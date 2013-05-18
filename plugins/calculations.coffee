cruder = require "cruder"

calculateTime = ->
  return new Date() + 1000*25*60*60

calculatePrice = (from, to, content) ->
  count = 0
  content.split(/\s+/).forEach (item) ->
    count++ if item.length > 0
  count * 0.1

module.exports = (container, callback) ->
  app = container.get "app"

  app.post "/calculations", (req, res) ->
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
