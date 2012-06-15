extend = (obj, args...) ->
  for arg in args
    obj[prop] = val for prop, val of arg
  obj

class EventEmitter
  constructor: ->
    @event_handlers = {}

  on: (event_name, handler) ->
    @handlers(event_name).push handler

  removeEventListeners: (event_name) =>
    @handlers(event_name).length = 0
    
  removeListener: (event_name, handler) =>
    handlers = @handlers(event_name)
    for h, i in handlers
      if h is handler
        handlers.splice i, 1
        return

  # protected
  emit: (event_name, args...) =>
    # create copy so handlers can remove themselves
    handlers_list = extend [], @handlers(event_name)
    handler(args...) for handler in handlers_list

  # private
  handlers: (event_name) -> @event_handlers[event_name] ?= []

Key =
  _1: 49
  _2: 50
  _3: 51
  A: 65
  D: 68
  E: 69
  O: 79
  R: 82
  S: 83
  W: 87
  Comma: 188

Mouse =
  Left: 0
  Middle: 1
  Right: 2

class Indexable
  @id_count = 0

  constructor: ->
    @id = Indexable.id_count++

class Batch
  constructor: ->
    # indexed by zorder
    @sprites = []
  add: (sprite) ->
    (@sprites[sprite.zorder] ?= {})[sprite.id] = sprite
  remove: (sprite) ->
    delete @sprites[sprite.zorder][sprite.id]

class Sprite extends Indexable
  constructor: (animation_name, params) ->
    super
    o =
      pos: new Vec2d(0, 0)
      batch: null
      zorder: 0
    extend o, params

    @pos = o.pos
    @zorder = o.zorder

    @batch = o.batch
    @batch.add this

  delete: ->
    @batch.remove(this)

class Engine extends EventEmitter
  target_fps = 60
  min_fps = 20
  target_spf = 1 / target_fps

  schedule = (sec, cb) -> setInterval(cb, sec * 1000)
  unschedule = clearInterval

  @Key = Key
  @Mouse = Mouse
  @Sprite = Sprite
  @Batch = Batch

  constructor: (@canvas) ->
    super
    @context = @canvas.getContext("2d")
    @size = new Vec2d(@canvas.width, @canvas.height)

  setSize: (@size) ->
    @canvas.width = @size.x
    @canvas.height = @size.y

  start: ->
    @loadAssets()
    @attachListeners()
    @startMainLoop()

  stop: ->
    @stopMainLoop()
    @removeListeners()

  keyState: (key_code) -> !!@key_states[key_code]

  mousePos: -> @mouse_pos

  # private
  startMainLoop: ->
    previous_update = new Date()
    max_frame_skips = target_fps - min_fps
    fps_time_passed = 0
    fps_refresh_rate = 1
    fps_count = 0
    @interval = schedule target_spf, =>
      now = new Date()
      delta = (now - previous_update) / 1000
      previous_update = now

      fps_time_passed += delta

      skip_count = 0
      while delta > target_spf and skip_count < max_frame_skips
        @callUpdate target_spf, 1
        skip_count += 1
        delta -= target_spf

      multiplier = delta / target_spf
      @callUpdate delta, multiplier
      @emit 'draw', @context
      fps_count += 1

      if fps_time_passed >= fps_refresh_rate
        fps_time_passed = 0
        @fps = fps_count / fps_refresh_rate
        fps_count = 0

  drawBatch: (batch) ->
    for sprites in batch.sprites
      for id, sprite of sprites
        frame = sprite.frames[0]
        @context.drawImage @spritesheet, frame.pos.x, frame.pos.y, frame.size.x, frame.size.y, sprite.pos.x, sprite.pos.y, frame.size.x, frame.size.y

  callUpdate: (dt, dx) ->
    @emit 'update', dt, dx
    @key_just_pressed = {}

  loadAssets: ->
    @spritesheet = new Image()
    @spritesheet.src = "spritesheet.png"
    # TODO: get the animations.json file somehow.

  attachListeners: ->
    # mouse input
    @mouse_pos = new Vec2d(0, 0)
    handleMouseEvent = (event_name) =>
      @canvas.addEventListener event_name, (event) =>
        @mouse_pos = new Vec2d(event.offsetX, event.offsetY)
        @emit event_name, @mouse_pos
    handleMouseEvent x for x in ['mousemove', 'mousedown', 'mouseup']

    # keyboard input
    @canvas.addEventListener 'keydown', (event) => @emit 'keydown', event.keyCode
    @canvas.addEventListener 'keyup', (event) => @emit 'keyup', event.keyCode

    @key_states = {}
    @key_just_pressed = {}
    window.addEventListener 'keydown', (event) =>
      @key_states[event.keyCode] = true
      @key_just_pressed[event.keyCode] = true

    window.addEventListener 'keyup', (event) =>
      @key_states[event.keyCode] = false


  removeListeners: ->
    # TODO

  stopMainLoop: ->
    unschedule @interval

  createBatch: -> new Batch(this)
  createOrderedGroup: -> new OrderedGroup(this)