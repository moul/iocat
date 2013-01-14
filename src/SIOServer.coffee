{Base} = require './Base'
io =     require 'socket.io'

class SIOServer extends Base
  constructor: (@options = {}) ->
    @options.port ?= @options.localPort
    @options.log   = !!@options.verbose
    @log 'SIOServer.constructor'
    return @

  start: =>
    @log 'start'
    @sio = io.listen @options.port, @options

    @sio.set    'log', false
    @sio.enable 'browser client mignification'
    @sio.enable 'browser client etag'
    @sio.enable 'browser client gzip'

    #@sio.sockets.on 'listening',  @onSIOServerListening
    #@sio.sockets.on 'disconnect', @onSIOServerDisconnect
    @sio.sockets.on 'connection', @onSIOServerConnection
    @sio.sockets.on 'error',      @onSIOServerError

  # Methods
  send: (d) =>
    @log 'send', d
    @ioc.send d

  end: =>
    @log 'end'
    do @ioc.disconnect

  # SIOServer Events
  onSIOServerListening: =>
    @log  'onSIOServerListening'
    @emit 'listening'

  onSIOServerDisconnect: =>
    @log  'onSIOServerDisconnect'
    @emit 'disconnect'

  onSIOServerConnection: (ws) =>
    @log  'onSIOServerConnection'
    @emit 'connection'
    @ioc = ws
    @ioc.on 'open',       @onClientOpen
    @ioc.on 'close',      @onClientClose
    @ioc.on 'error',      @onClientError
    @ioc.on 'message',    @onClientMessage
    @ioc.on 'connect',    @onClientConnect
    @ioc.on 'disconnect', @onClientDisonnect

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
    @emit 'message', msg

module.exports =
  SIOServer: SIOServer
