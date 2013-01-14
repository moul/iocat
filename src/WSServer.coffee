{Base} = require './Base'
ws =     require 'ws'

class WSServer extends Base
  constructor: (@options = {}) ->
    @log 'constructor'
    @options.port ?= @options.localPort
    return @

  start: =>
    @log 'start'
    @wss = new ws.Server  @options

    @wss.on 'listening',  @onWSServerListening
    @wss.on 'connection', @onWSServerConnection
    @wss.on 'error',      @onWSServerError

  # Methods
  send: (d) =>
    @log 'send', d
    @ws.send d

  end: =>
    @log 'end'
    do @ws.close

  # WSServer Events
  onWSServerListening: =>
    @log  'onWSServerListening'
    @emit 'listening'

  onWSServerConnection: (ws) =>
    @log  'onWSServerConnection'
    @emit 'connection'
    @ws = ws
    @ws.on 'open',       @onClientOpen
    @ws.on 'close',      @onClientClose
    @ws.on 'error',      @onClientError
    @ws.on 'message',    @onClientMessage
    @ws.on 'connect',    @onClientConnect

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
    @emit 'message', msg

module.exports =
  WSServer: WSServer
