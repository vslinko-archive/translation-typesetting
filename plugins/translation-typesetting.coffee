cruder = require "cruder"


module.exports = (container, callback) ->
  connection = container.get "connection"
  mongoose = container.get "mongoose"
  app = container.get "app"

  ThingSchema = new mongoose.Schema
    thing: type: String, require: true

  Thing = connection.model "things", ThingSchema

  app.get "/things", cruder.list Thing.find()

  callback()
