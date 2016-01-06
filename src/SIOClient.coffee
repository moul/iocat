{Base} = require './Base'
io =     require 'socket.io-client'

class SIOClient extends Base
  constructor: (@url, @options = {}) ->
    return @

  start: =>
    @log 'SIOClient: url->', @url.format()

    href = @url.format()
    @io = io.connect @url.format()
    @io.on 'open',    @onOpen
    @io.on 'close',   @onClose
    @io.on 'error',   @onError
    @io.on @options.emitKey, @onMessage
    @io.on 'connect', @onConnect

  # Methods
  send: (d) =>
    @log 'send', d
    @io.emit @options.emitKey, d

  end: =>
    @log 'end'
    do @io.disconnect

  # Events
  onConnect: =>
    @log 'onConnect'
    @emit 'connect'

  onOpen: =>
    @log 'onOpen'
    @emit 'open'

  onClose: =>
    @log 'onClose'
    @emit 'close'

  onError: (err) =>
    @log 'onError', err
    @emit 'error', err

  onMessage: (msg...) =>
    @log 'onMessage', msg
    @emit @options.emitKey, msg

module.exports =
  SIOClient: SIOClient
