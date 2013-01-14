{Base} = require './Base'
io =     require 'socket.io'

class SIOServer extends Base
  constructor: (@options = {}) ->
    @options.port ?= @options.localPort
    return @

  start: =>
    @io = io.listen @options.port

    @io.sockets.on 'listening',  @onSIOServerListening
    @io.sockets.on 'connection', @onSIOServerConnection
    @io.sockets.on 'error',      @onSIOServerError

  # Methods
  send: (d) =>
    @log 'send', d
    @ws.send d

  end: =>
    @log 'end'
    do @ws.close

  # SIOServer Events
  onSIOServerListening: =>
    @log  'onSIOServerListening'
    @emit 'listening'

  onSIOServerConnection: (ws) =>
    @log  'onSIOServerConnection'
    @emit 'connection'
    @ws = ws
    @ws.on 'open',       @onClientOpen
    @ws.on 'close',      @onClientClose
    @ws.on 'error',      @onClientError
    @ws.on 'message',    @onClientMessage
    @ws.on 'connect',    @onClientConnect

  onSIOServerError: (err) =>
    @log  'onSIOServerError', err
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
  SIOServer: SIOServer
