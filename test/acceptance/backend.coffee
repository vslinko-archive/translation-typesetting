suite = require "symfio-suite"


describe "translation-typesetting", ->
  wrapper = suite.http require "../../index"

  describe "GET /things", ->
    it "should respond with things", wrapper (callback) ->
      test = @http.get "/things"
      test.res (res) =>
        @expect(res).to.have.status 200
        @expect(res.body).to.have.length 1
        @expect(res.body[0].thing).to.equal "Hooray!"
        callback()
