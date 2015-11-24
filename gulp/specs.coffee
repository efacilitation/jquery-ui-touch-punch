webpackStream = require 'webpack-stream'
runSequence = require 'run-sequence'
karmaWrapper = require 'node-karma-wrapper'

module.exports = (gulp) ->

  karmaServer = null
  createKarmaServer = ->
    karmaServer = karmaWrapper configFile: 'karma.conf.coffee'


  gulp.task 'specs', (done) ->
    runSequence 'specs:build', 'specs:run', done


  gulp.task 'specs:onRunningServer', (done) ->
    runSequence 'specs:build', 'specs:run:onRunningServer', done


  gulp.task 'specs:build', ->
    webpackConfig = require('./webpack_config').getDefaultConfiguration()
    webpackConfig.output =
      filename: 'specs.js'

    gulp.src [
      'src/spec_setup.coffee'
      'src/**/*.+(coffee|js)'
    ]
    .pipe webpackStream webpackConfig
    .pipe gulp.dest 'dist/specs'


  gulp.task 'specs:startServer', (done) ->
    createKarmaServer()
    karmaServer.inBackground done


  gulp.task 'specs:run:onRunningServer', (done) ->
    karmaServer.run done


  gulp.task 'specs:run', (done) ->
    createKarmaServer()
    karmaServer.simpleRun done
