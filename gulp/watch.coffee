runSequence = require 'run-sequence'
watch = require 'gulp-watch'

module.exports = (gulp) ->
  gulp.task 'watch', (done) ->
    runSequence 'specs:startServer', ->
      gulp.watch [
        '+(src|spec)/**/*.+(coffee|js)'
      ], ['specs:onRunningServer']
      done()
