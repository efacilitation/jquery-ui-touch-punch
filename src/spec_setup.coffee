require('es6-promise').polyfill()

root = if window? then window else global

if !root._spec_setup
  root.sinon = require 'sinon'
  root.chai = require 'chai'
  root.expect = chai.expect
  root.sandbox = sinon.sandbox.create()
  root.jQuery = require 'jquery'
  root.$ = root.jQuery
  require 'jquery-ui'
  require './jquery.ui.touch-punch'


  sinonChai = require 'sinon-chai'
  isSinonChaiIncludedAsBrowserPackage = typeof sinonChai is 'function'
  if isSinonChaiIncludedAsBrowserPackage
    chai.use sinonChai
  root._spec_setup = true


afterEach ->
  sandbox.restore()
