do($ = jQuery) ->

  $.support.touch = 'ontouchend' of document

  if not $.support.touch
    return

  mouseProto = $.ui.mouse::
  _mouseInit = mouseProto._mouseInit
  _mouseDestroy = mouseProto._mouseDestroy
  touchIsHandled = undefined

  simulateMouseEvent = (event, simulatedType) ->
    isMultiTouchEvent = event.originalEvent.touches.length > 1
    if isMultiTouchEvent
      return

    touch = event.originalEvent.changedTouches[0]
    simulatedEvent = document.createEvent 'MouseEvents'

    if $(touch.target).is ':input, [contenteditable]'
      event.stopPropagation()
    else
      # TODO: Why is the propagation/bubbling here not stopped?
      event.preventDefault()

    simulatedEvent.initMouseEvent(
      simulatedType,    # type
      true,             # bubbles
      true,             # cancelable
      window,           # view
      1,                # detail
      touch.screenX,    # screenX
      touch.screenY,    # screenY
      touch.clientX,    # clientX
      touch.clientY,    # clientY
      false,            # ctrlKey
      false,            # altKey
      false,            # shiftKey
      false,            # metaKey
      0,                # button
      null              # relatedTarget
    )
    event.target.dispatchEvent simulatedEvent


  mouseProto._touchStart = (event) ->
    # Ignore the event if another widget is already being handled
    if touchIsHandled or !(@_mouseCapture event.originalEvent.changedTouches[0])
      return

    touchIsHandled = true

    @_touchStartCoords = @_getTouchCoords event
    @_touchMoved = false

    simulateMouseEvent event, 'mouseover'
    simulateMouseEvent event, 'mousemove'
    simulateMouseEvent event, 'mousedown'

    return


  mouseProto._touchMove = (event) ->
    if not touchIsHandled
      return

    # Interaction was not a click
    touchMoveCoords = @_getTouchCoords event
    if @_touchStartCoords and ((@_touchStartCoords.x isnt touchMoveCoords.x) or (@_touchStartCoords.y isnt touchMoveCoords.y))
      @_touchMoved = true

    simulateMouseEvent event, 'mousemove'

    return


  mouseProto._getTouchCoords = (event) ->
    return {
      x: event.originalEvent.changedTouches[0].pageX
      y: event.originalEvent.changedTouches[0].pageY
    }


  mouseProto._touchEnd = (event) ->
    if not touchIsHandled
      return

    simulateMouseEvent event, 'mouseup'
    simulateMouseEvent event, 'mouseout'
    if not @_touchMoved
      simulateMouseEvent event, 'click'

    touchIsHandled = false
    return


  mouseProto._mouseInit = ->
    @element.bind
      touchstart: $.proxy @, '_touchStart'
      touchmove: $.proxy @, '_touchMove'
      touchend: $.proxy @, '_touchEnd'
    _mouseInit.call this


  mouseProto._mouseDestroy = ->
    @element.unbind
      touchstart: $.proxy @, '_touchStart'
      touchmove: $.proxy @, '_touchMove'
      touchend: $.proxy @, '_touchEnd'

    _mouseDestroy.call @
