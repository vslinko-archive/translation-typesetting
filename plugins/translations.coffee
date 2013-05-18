cruder = require "cruder"

module.exports = (container, callback) ->
  connection = container.get "connection"
  calculate = container.get "calculate"
  mongoose = container.get "mongoose"
  app = container.get "app"

  TranslationSchema = new mongoose.Schema
    callbackUrl: String
    content: String
    words: Number
    price: Number
    receiveDate: type: Date, default: Date.now
    dueDate: type: Date
    customer:
      type: String
      required: true

  Translation = connection.model "translations", TranslationSchema

  app.post "/translations", (req, res) ->
    res.send 401 unless req.user

    params = req.body
    callbackUrl = params["callback-url"]
    language = params["language"]
    content = params["content"]
    
    res.send 500 unless language and content and callbackUrl

    from = language.from
    to = language.to

    res.send 500 unless from and to

    translation = new Translation
      callbackUrl: callbackUrl
      content: content
      words: calculate.words content
      price: calculate.price from, to, content
      dueDate: calculate.time()
      customer: req.user.username

    translation.save (err) ->
      return res.send 500 if err
  
      res.send
        "id": translation._id
        "price": translation.price
        "response-time": translation.dueDate

  callback()
