cruder = require "cruder"

module.exports = (container, callback) ->
  app = container.get "app"

  calculateWords = (content) ->
    count = 0
    content.split(/\s+/).forEach (item) ->
      count++ if item.length > 0
    count

  calculateTime = ->
    return new Date() + 1000*25*60*60

  calculatePrice = (from, to, content) ->
    calculateWords(content) * 0.1

  container.set "calculate",
    words: calculateWords
    price: calculatePrice
    time: calculateTime

  app.post "/calculations", (req, res) ->
    res.send 401 unless req.user

    params = req.body
    language = params.language
    content = params.content
    
    res.send 500 unless language and content

    from = language.from
    to = language.to

    res.send 500 unless from and to

    res.send
      "price": calculatePrice from, to, content
      "response-time": calculateTime from, to, content

  callback()
