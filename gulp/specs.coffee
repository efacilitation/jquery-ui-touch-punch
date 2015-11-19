mocha = require 'gulp-mocha'
webpackStream = require 'webpack-stream'
runSequence = require 'run-sequence'
karma = require 'gulp-karma'

require 'coffee-loader'

module.exports = (gulp) ->

  gulp.task 'specs', (next) ->
    runSequence 'specs:build', 'specs:run', next


  gulp.task 'specs:build', ->
    webpackConfig = require('./webpack_config').getDefaultConfiguration()
    webpackConfig.output =
      filename: 'specs.js'

    gulp.src [
      'src/spec_setup.coffee'
      'src/**/*.coffee'
    ]
    .pipe webpackStream webpackConfig
    .pipe gulp.dest 'dist/specs'


  gulp.task 'specs:run', ->
    gulp.src 'dist/specs/specs.js'
    .pipe karma
      configFile: 'karma.conf.coffee'
      action: 'start'
