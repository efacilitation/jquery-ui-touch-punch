describe 'jquery-ui-touch-punch', ->
  $bodyElement = null

  createTouchEvent = (type, target) ->
    touchEvent = document.createEvent 'MouseEvents'

    event =
      screenX: 0
      screenY: 0
      clientX: 0
      clientY: 0
      pageX: 0
      pageY: 0

    touchEvent.initMouseEvent type, true, true, window, 1,
      event.screenX, event.screenY,
      event.clientX, event.clientY,
      event.pageX, event.pageY,
      false, false, false, false, 0, null

    touchEvent.changedTouches = touchEvent.touches = [ {
      identifier: Date.now() + Math.random()
      target: target
      clientX: event.clientX
      clientY: event.clientY
      pageX: event.pageX
      pageY: event.pageY
      screenX: event.screenX
      screenY: event.screenY
    } ]

    sandbox.spy touchEvent, 'stopPropagation'
    sandbox.spy touchEvent, 'preventDefault'

    return touchEvent


  beforeEach ->
    $bodyElement = $ 'body'


  afterEach ->
    $draggableElement = $bodyElement.find '.draggable'
    touchEvent = createTouchEvent 'touchend', $draggableElement[0]
    $draggableElement.get(0).dispatchEvent touchEvent
    $draggableElement.remove()


  describe 'triggering a touchstart event', ->

    describe 'given the target is not a input or a contenteditable draggable element', ->

      touchEvent = null
      $draggableElement = null

      beforeEach ->
        $draggableElement = $ '<div class="draggable"></div>'
        $draggableElement.draggable()

        $bodyElement.append $draggableElement
        touchEvent = createTouchEvent 'touchstart', $draggableElement[0]


      it 'should not stop the propagation of the event', ->
        expectTouchStartEvent = (event) ->
          expect(event.type).to.be.equal 'touchstart'
          $bodyElement.off 'touchstart', expectTouchStartEvent
        $bodyElement.on 'touchstart', expectTouchStartEvent
        $draggableElement[0].dispatchEvent touchEvent
        expect(touchEvent.stopPropagation).to.not.have.been.called


      it 'should prevent the default action of the event', ->
        $draggableElement[0].dispatchEvent touchEvent
        expect(touchEvent.preventDefault).to.have.been.called


    describe 'given the target is a :input draggable element', ->

      touchEvent = null

      beforeEach ->
        $draggableElement = $ '<input class="draggable"></input>'
        $draggableElement.draggable()
        $bodyElement.append $draggableElement
        touchEvent = createTouchEvent 'touchstart', $draggableElement.get 0
        $draggableElement.get(0).dispatchEvent touchEvent


      it 'should stop the propagation of the event ', ->
        expect(touchEvent.stopPropagation).to.have.been.calledThrice


      it 'should not prevent the default action of the event', ->
        expect(touchEvent.preventDefault).not.to.have.been.called


    describe 'given the target is a contenteditable draggable element', ->

      touchEvent = null

      beforeEach ->
        $draggableElement = $('<div class="draggable" contenteditable></div>')
        $draggableElement.draggable()
        $bodyElement.append $draggableElement
        touchEvent = createTouchEvent 'touchstart', $draggableElement.get 0
        $draggableElement[0].dispatchEvent touchEvent


      it 'should stop the propagation of the event ', ->
        expect(touchEvent.stopPropagation).to.have.been.calledThrice


      it 'should not prevent the default action of the event', ->
        expect(touchEvent.preventDefault).not.to.have.been.called