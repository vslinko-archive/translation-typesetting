module.exports = (grunt) ->
  grunt.initConfig
    simplemocha:
      acceptance: "test/acceptance/**/*.coffee"
      unit: "test/*.coffee"
      options: reporter: process.env.REPORTER or "spec"
    coffeelint:
      index: "index.coffee"
      plugins: "plugins/**/*.coffee"
      test: "test/**/*.coffee"
      grunt: "Gruntfile.coffee"

  grunt.loadNpmTasks "grunt-simple-mocha"
  grunt.loadNpmTasks "grunt-coffeelint"

  grunt.registerTask "default", [
    "simplemocha"
    "coffeelint"
  ]
