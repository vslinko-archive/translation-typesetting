request = require "superagent"
cruder = require "cruder"

convertContent = (content) ->
  data = []
  content.split(/\n/).forEach (paragraph) ->
    paragraph.split(/\.|\?|\!/).forEach (part) ->
      if part
        data.push
          content: part
          translation: part
    data.push "-"
  data

module.exports = (container, callback) ->
  connection = container.get "connection"
  calculate = container.get "calculate"
  mongoose = container.get "mongoose"
  app = container.get "app"

  TranslationSchema = new mongoose.Schema
    callbackUrl: type: String, required: true
    content: type: String, required: true
    translation: mongoose.Schema.Types.Mixed
    words: Number
    price: Number
    done: type: Boolean, default: false
    type: type: String, default: "text"
    receiveDate: type: Date, default: Date.now
    dueDate: type: Date
    customer:
      type: String
      required: true

  Translation = connection.model "translations", TranslationSchema

  app.get "/translations", cruder.list Translation.find()

  app.post "/translations", (req, res) ->
    params = req.body
    callbackUrl = params["callback-url"]
    language = params["language"]
    content = params["content"]
    type = params["type"]
    
    return res.send 500 unless language and content and callbackUrl

    from = language.from
    to = language.to

    return res.send 500 unless from and to

    translation = new Translation
      callbackUrl: callbackUrl
      content: content
      translation: if type == "html" then content else convertContent content
      words: calculate.words content, type
      price: calculate.price from, to, content, type
      dueDate: calculate.time()
      customer: req.user.username
      languageFrom: from
      languageTo: to
      type: type or "text"

    translation.save (err) ->
      return res.send 500 if err
  
      res.send
        "id": translation._id
        "price": translation.price
        "response-time": translation.dueDate

  app.get "/translations/:id", (req, res) ->
    Translation.findOne _id: req.params.id, (err, translation) ->
      return res.send 500 if err

      res.send translation

  app.post "/translations/:id", (req, res) ->
    Translation.findOne _id: req.params.id, (err, translation) ->
      return res.send 500 if err

      translation.translation = req.body.translation
      translation.done = req.body.done
      translation.save (err) ->
        return res.send 500 if err

        if translation.done
          data =
            id: translation._id
            price: translation.price
            language:
              from: translation.languageFrom
              to: translation.languageTo
            content:
              original: translation.content
              translation: translation.translation

          request
            .post(translation.callbackUrl)
            .type("json")
            .send(data)
            .end()

        res.send translation

  callback()
