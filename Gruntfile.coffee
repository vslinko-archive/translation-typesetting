module.exports = (grunt) ->
  grunt.initConfig
    coffeelint:
      index: "index.coffee"
      plugins: "plugins/**/*.coffee"
      test: "test/**/*.coffee"
      grunt: "Gruntfile.coffee"

  grunt.loadNpmTasks "grunt-coffeelint"

  grunt.registerTask "default", [
    "coffeelint"
  ]
