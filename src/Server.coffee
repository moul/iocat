{Base} = require './Base'
ws =     require 'ws'

class Server extends Base
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
    @log 'send', d
    @ws.send d

  end: =>
    @log 'end'
    do @ws.close

  # Server Events
  onServerListening: =>
    @log  'onServerListening'
    @emit 'listening'

  onServerConnection: (ws) =>
    @log  'onServerConnection'
    @emit 'connection'
    @ws = ws
    @ws.on 'open',       @onClientOpen
    @ws.on 'close',      @onClientClose
    @ws.on 'error',      @onClientError
    @ws.on 'message',    @onClientMessage
    @ws.on 'connect',    @onClientConnect

  onServerError: (err) =>
    @log  'onServerError', err
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
  Server: Server
