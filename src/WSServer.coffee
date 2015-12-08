{Base} = require './Base'
ws =     require 'ws'

class WSServer extends Base
  constructor: (@options = {}) ->
    @log 'constructor'
    @_queue = []
    @options.port ?= @options.localPort
    return @

  start: =>
    @log 'start'
    @wss = new ws.Server  @options

    @wss.on 'listening',  @onWSServerListening
    @wss.on 'connection', @onWSServerConnection
    @wss.on 'error',      @onWSServerError

  isActive: =>
    @wss? and @ws? and @ready

  _enqueue: (data) =>
    @_queue.push data

  # Methods
  send: (data) =>
    unless do @isActive
      @_enqueue data
    else
      @log 'send', data
      @ws.send data

  end: (fn = null) =>
    @log 'end'
    do @ws.close if do @isActive
    @wss = null
    @ws = null
    @ready = false
    do fn if fn

  # WSServer Events
  onWSServerListening: =>
    @log  'onWSServerListening'
    @emit 'listening'

  onWSServerConnection: (socket) =>
    #console.dir socket
    @log  'onWSServerConnection'
    @emit 'connection'
    @ws = socket
    @ws.on 'open',       @onClientOpen
    @ws.on 'close',      @onClientClose
    @ws.on 'error',      @onClientError
    @ws.on @options.emitKey,     @onClientMessage
    @ws.on 'connect',    @onClientConnect
    @ready = true
    for data in @_queue
      @send data

  onWSServerError: (err) =>
    @log  'onWSServerError', err
    @emit 'error', err

  # Client Events
  onClientConnect: =>
    @log  'onClientConnect'
    @emit 'connect'

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
  WSServer: WSServer
