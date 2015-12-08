{Base} = require './Base'
ws =     require 'ws'

class WSClient extends Base
  constructor: (@url, @options = {}) ->
    @log "constructor"
    return @

  start: =>
    @log 'WSClient: url->', @url.format()

    href = @url.format()
    @ws = new ws @url.format()
    @ws.on 'open',    @onOpen
    @ws.on 'close',   @onClose
    @ws.on 'error',   @onError
    @ws.on @options.emitKey,  @onMessage
    @ws.on 'connect', @onConnect

  # Methods
  send: (d) =>
    @log 'send', d
    @ws.send d

  end: =>
    @log 'end'
    do @ws.close

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

  onMessage: (msg) =>
    @log 'onMessage', msg
    @emit @options.emitKey, msg

module.exports =
  WSClient: WSClient
