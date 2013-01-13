{Base} = require './Base'
ws =     require 'ws'

class Client extends Base
  constructor: (@url, @options = {}) ->
    return @

  start: =>
    @log 'Client: url->', @url.format()

    href = @url.format()
    @ws = new ws @url.format()
    @ws.on 'open',    @onOpen
    @ws.on 'close',   @onClose
    @ws.on 'error',   @onError
    @ws.on 'message', @onMessage
    @ws.on 'connect', @onConnect


  # Methods
  send: (d) =>
    @log 'Client.send', d
    @ws.send d

  end: =>
    @log 'Client.end'
    do @ws.close

  # Events
  onConnect: =>
    @log 'Client.onConnect'
    @emit 'connect'

  onOpen: =>
    @log 'Client.onOpen'
    @emit 'open'

  onClose: =>
    @log 'Client.onClose'
    @emit 'close'

  onError: (err) =>
    @log 'Client.onError', err
    @emit 'error', err

  onMessage: (msg) =>
    @log 'Client.onMessage', msg
    @emit 'message', msg

module.exports =
  Client: Client
