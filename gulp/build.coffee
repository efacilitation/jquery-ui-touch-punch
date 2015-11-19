runSequence = require 'run-sequence'
webpack = require 'webpack-stream'

module.exports = (gulp) ->

  gulp.task 'build', (next) ->
    runSequence 'build:release', next


  gulp.task 'build:release', ->
    webpackConfig = require('./webpack_config').getDefaultConfiguration()
    webpackConfig.output =
      libraryTarget: 'umd'
      library: 'jquery-ui-touch-punch'
      filename: 'jquery.ui.touch-punch.js'

    gulp.src ['src/jquery.ui.touch-punch.js']
    .pipe webpack webpackConfig
    .pipe gulp.dest 'dist/release'
