{Base} = require './Base'
ws =     require 'ws'

class WSClient extends Base
  constructor: (@url, @options = {}) ->
    return @

  start: =>
    @log 'WSClient: url->', @url.format()

    href = @url.format()
    @ws = new ws @url.format()
    @ws.on 'open',    @onOpen
    @ws.on 'close',   @onClose
    @ws.on 'error',   @onError
    @ws.on 'message', @onMessage
    @ws.on 'connect', @onConnect


  # Methods
  send: (d) =>
    @log 'WSClient.send', d
    @ws.send d

  end: =>
    @log 'WSClient.end'
    do @ws.close

  # Events
  onConnect: =>
    @log 'WSClient.onConnect'
    @emit 'connect'

  onOpen: =>
    @log 'WSClient.onOpen'
    @emit 'open'

  onClose: =>
    @log 'WSClient.onClose'
    @emit 'close'

  onError: (err) =>
    @log 'WSClient.onError', err
    @emit 'error', err

  onMessage: (msg) =>
    @log 'WSClient.onMessage', msg
    @emit 'message', msg

module.exports =
  WSClient: WSClient
