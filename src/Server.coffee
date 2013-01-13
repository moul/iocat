{EventEmitter} = require 'events'
ws = require 'ws'

class Server extends EventEmitter
  constructor: (@options = {}) ->
    @options.port ?= @options.localPort
    return @

  start: =>
    @wss = new ws.Server  @options

    @wss.on 'listening',  @onServerListening
    @wss.on 'connection', @onServerConnection
    @wss.on 'error',      @onServerError

  # Methods
  send: (d) =>
    console.log 'Server.send', d
    @ws.send d

  end: =>
    console.log 'Server.end'
    do @ws.close

  # Server Events
  onServerListening: =>
    console.log 'onListening'
    @emit 'listening'

  onServerConnection: (ws) =>
    console.log 'onConnection'
    @emit 'connection'
    @ws = ws
    @ws.on 'open',       @onClientOpen
    @ws.on 'close',      @onClientClose
    @ws.on 'error',      @onClientError
    @ws.on 'message',    @onClientMessage
    @ws.on 'connect',    @onClientConnect

  onServerError: (err) =>
    console.log 'onError', err
    @emit 'error', err

  # Client Events
  onClientConnect: =>
    console.log 'onConnect'
    @emit 'connect'

  onClientOpen: =>
    console.log 'onOpen'
    @emit 'open'

  onClientClose: =>
    console.log 'onClose'
    @emit 'close'

  onClientError: (err) =>
    console.log 'onError', err
    @emit 'error', err

  onClientMessage: (msg) =>
    console.log 'onMessage', msg
    @emit 'message', msg

module.exports =
  Server: Server
