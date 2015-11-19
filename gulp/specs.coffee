webpackStream = require 'webpack-stream'
runSequence = require 'run-sequence'
karmaWrapper = require 'node-karma-wrapper'

module.exports = (gulp) ->

  karmaServer = null
  createKarmaServer = ->
    karmaServer = karmaWrapper configFile: 'karma.conf.coffee'


  gulp.task 'specs', (done) ->
    runSequence 'specs:build', 'specs:run', done


  gulp.task 'specs:watch', (done) ->
    runSequence 'specs:build', 'specs:run:server', done


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


  gulp.task 'specs:run:server', (done) ->
    if not karmaServer
      createKarmaServer()

    karmaServer.start ->
      console.log 'start'
      done()


  gulp.task 'specs:run', (done) ->
    createKarmaServer()
    karmaServer.simpleRun done
