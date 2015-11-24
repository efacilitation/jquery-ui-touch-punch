describe 'jquery-ui-touch-punch', ->
  stopPropagationSpy = null

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

    return touchEvent


  beforeEach ->
    stopPropagationSpy = sandbox.spy Event::, 'stopPropagation'


  afterEach ->
    $draggableElement = $('body').find '.draggable'
    touchEvent = createTouchEvent 'touchend', $draggableElement[0]
    $draggableElement[0].dispatchEvent touchEvent
    $draggableElement.remove()


  it 'should propagate the touch start event given it is not a input or not a contenteditable draggable element', ->
    $draggableElement = $('<div class="draggable"></div>')
    $draggableElement.draggable()

    $('body').append $draggableElement

    expectTouchStartEvent = (event) ->
      expect(event.type).to.be.equal 'touchstart'

    $('body').on 'touchstart', expectTouchStartEvent

    touchEvent = createTouchEvent 'touchstart', $draggableElement[0]
    $draggableElement[0].dispatchEvent touchEvent
    expect(stopPropagationSpy).to.not.have.been.called

    $('body').off 'touchstart', expectTouchStartEvent


  it 'should not propagate the touch start event given it is a :input draggable element', ->
    $draggableElement = $('<input class="draggable"></input>')
    $draggableElement.draggable()

    $('body').append $draggableElement

    touchEvent = createTouchEvent 'touchstart', $draggableElement[0]
    $draggableElement[0].dispatchEvent touchEvent
    expect(stopPropagationSpy).to.have.been.calledThrice


  it 'should not propagate the touch start event given it is a contenteditable draggable element', ->
    $draggableElement = $('<div class="draggable" contenteditable></div>')
    $draggableElement.draggable()

    $('body').append $draggableElement

    touchEvent = createTouchEvent 'touchstart', $draggableElement[0]
    $draggableElement[0].dispatchEvent touchEvent
    expect(stopPropagationSpy).to.have.been.calledThrice
