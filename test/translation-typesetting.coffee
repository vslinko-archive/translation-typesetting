symfio = require "symfio"
plugin = require "../plugins/translation-typesetting"
suite = require "symfio-suite"


describe "translation-typesetting()", ->
  wrapper = suite.sandbox symfio, ->
    @connection = model: @sandbox.stub()
    @mongoose = Schema: @sandbox.stub()
    @model = find: @sandbox.stub()
    @app = get: @sandbox.stub()

    @connection.model.returns @model

    @container.set "connection", @connection
    @container.set "mongoose", @mongoose
    @container.set "app", @app

  it "should define things model", wrapper ->
    plugin @container, ->

    @expect(@connection.model).to.have.been.calledOnce
    @expect(@connection.model).to.have.been.calledWith "things"
