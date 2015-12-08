{Base} = require './Base'
io =     require 'socket.io'

class SIOServer extends Base
  constructor: (@options = {}) ->
    @options.port ?= @options.localPort
    @options.log   = !!@options.verbose
    @log 'constructor'
    @_queue = []
    return @

  start: (fn = null) =>
    @log 'start'
    @sio = io.listen @options.port, @options

    #@sio.set    'log', false
    #@sio.enable 'browser client mignification'
    #@sio.enable 'browser client etag'
    #@sio.enable 'browser client gzip'

    @sio.on 'listening', @onSIOServerListening
    #@sio.server.on 'request',
    @sio.on 'connection', @onSIOServerSocketConnection
    #@sio.server.on 'close',
    #@sio.server.on 'checkContinue',
    #@sio.server.on 'connect',
    #@sio.server.on 'upgrade',
    #@sio.server.on 'clientError',
    @sio.on 'error',              @onSIOServerError
    @sio.sockets.on 'disconnect', @onSIOServerDisconnect
    @sio.sockets.on 'connection', @onSIOServerConnection
    @sio.sockets.on 'error',      @onSIOServerError
    do fn if fn

  _enqueue: (data) =>
    @_queue.push data

  # Methods
  send: (data, fn = null) =>
    unless do @isActive
      @_enqueue data
    else
      @log 'send', data
      @ioc.emit @options.emitKey, data
      do fn if fn

  end: (fn = null) =>
    @log 'end'
    do @ioc.disconnect if do @isActive
    @ioc = null
    @ready = false
    do fn if fn

  isActive: =>
    @ioc? and @ready

  # SIOServer Events
  onSIOServerListening: =>
    @log  'onSIOServerListening'
    @emit 'listening'

  onSIOServerDisconnect: =>
    @log  'onSIOServerDisconnect'
    @emit 'disconnect'

  onSIOServerSocketConnection: (socket) => # socket connection without socket.io handshake
    @log "onSIOServerSocketConnection"

  onSIOServerConnection: (socket) =>
    @log  'onSIOServerConnection'
    @emit 'connection', socket
    @ioc = socket
    @ioc.on 'open',       @onClientOpen
    @ioc.on 'close',      @onClientClose
    @ioc.on 'error',      @onClientError
    @ioc.on @options.emitKey,     @onClientMessage
    @ioc.on 'connect',    @onClientConnect
    @ioc.on 'disconnect', @onClientDisonnect
    @ready = true
    for data in @_queue
      @send data
    @emit 'ready'

  onSIOServerError: (err) =>
    @log  'onSIOServerError', err
    @emit 'error', err

  # Client Events
  onClientConnect: =>
    @log  'onClientConnect'
    @emit 'connect'

  onClientDisonnect: =>
    @log  'onClientDisonnect'
    @emit 'disconnect'

  onClientOpen: =>
    @log  'onClientOpen'
    @emit 'open'

  onClientClose: =>
    @log  'onClientClose'
    @emit 'close'

  onClientError: (err) =>
    @log  'onClientError', err
    @emit 'error', err

  onClientMessage: (msg) =>
    @log  'onClientMessage', msg
    @emit @options.emitKey, msg

module.exports =
  SIOServer: SIOServer
