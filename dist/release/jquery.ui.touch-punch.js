(function webpackUniversalModuleDefinition(root, factory) {
	if(typeof exports === 'object' && typeof module === 'object')
		module.exports = factory();
	else if(typeof define === 'function' && define.amd)
		define([], factory);
	else if(typeof exports === 'object')
		exports["jquery-ui-touch-punch"] = factory();
	else
		root["jquery-ui-touch-punch"] = factory();
})(this, function() {
return /******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports) {

	(function($) {
	  var _mouseDestroy, _mouseInit, mouseProto, simulateMouseEvent, touchIsHandled;
	  $.support.touch = 'ontouchend' in document;
	  if (!$.support.touch) {
	    return;
	  }
	  mouseProto = $.ui.mouse.prototype;
	  _mouseInit = mouseProto._mouseInit;
	  _mouseDestroy = mouseProto._mouseDestroy;
	  touchIsHandled = void 0;
	  simulateMouseEvent = function(event, simulatedType) {
	    var isMultiTouchEvent, simulatedEvent, touch;
	    isMultiTouchEvent = event.originalEvent.touches.length > 1;
	    if (isMultiTouchEvent) {
	      return;
	    }
	    touch = event.originalEvent.changedTouches[0];
	    simulatedEvent = document.createEvent('MouseEvents');
	    if ($(touch.target).is(':input, [contenteditable]')) {
	      event.stopPropagation();
	    } else {
	      event.preventDefault();
	    }
	    simulatedEvent.initMouseEvent(simulatedType, true, true, window, 1, touch.screenX, touch.screenY, touch.clientX, touch.clientY, false, false, false, false, 0, null);
	    return event.target.dispatchEvent(simulatedEvent);
	  };
	  mouseProto._touchStart = function(event) {
	    if (touchIsHandled || !(this._mouseCapture(event.originalEvent.changedTouches[0]))) {
	      return;
	    }
	    touchIsHandled = true;
	    this._touchStartCoords = this._getTouchCoords(event);
	    this._touchMoved = false;
	    simulateMouseEvent(event, 'mouseover');
	    simulateMouseEvent(event, 'mousemove');
	    simulateMouseEvent(event, 'mousedown');
	  };
	  mouseProto._touchMove = function(event) {
	    var touchMoveCoords;
	    if (!touchIsHandled) {
	      return;
	    }
	    touchMoveCoords = this._getTouchCoords(event);
	    if (this._touchStartCoords && ((this._touchStartCoords.x !== touchMoveCoords.x) || (this._touchStartCoords.y !== touchMoveCoords.y))) {
	      this._touchMoved = true;
	    }
	    simulateMouseEvent(event, 'mousemove');
	  };
	  mouseProto._getTouchCoords = function(event) {
	    return {
	      x: event.originalEvent.changedTouches[0].pageX,
	      y: event.originalEvent.changedTouches[0].pageY
	    };
	  };
	  mouseProto._touchEnd = function(event) {
	    if (!touchIsHandled) {
	      return;
	    }
	    simulateMouseEvent(event, 'mouseup');
	    simulateMouseEvent(event, 'mouseout');
	    if (!this._touchMoved) {
	      simulateMouseEvent(event, 'click');
	    }
	    touchIsHandled = false;
	  };
	  mouseProto._mouseInit = function() {
	    this.element.bind({
	      touchstart: $.proxy(this, '_touchStart'),
	      touchmove: $.proxy(this, '_touchMove'),
	      touchend: $.proxy(this, '_touchEnd')
	    });
	    return _mouseInit.call(this);
	  };
	  return mouseProto._mouseDestroy = function() {
	    this.element.unbind({
	      touchstart: $.proxy(this, '_touchStart'),
	      touchmove: $.proxy(this, '_touchMove'),
	      touchend: $.proxy(this, '_touchEnd')
	    });
	    return _mouseDestroy.call(this);
	  };
	})(jQuery);


/***/ }
/******/ ])
});
;