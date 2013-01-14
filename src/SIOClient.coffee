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
    @io.on 'message', @onMessage
    @io.on 'connect', @onConnect


  # Methods
  send: (d) =>
    @log 'SIOClient.send', d
    @io.send d

  end: =>
    @log 'SIOClient.end'
    do @io.disconnect

  # Events
  onConnect: =>
    @log 'SIOClient.onConnect'
    @emit 'connect'

  onOpen: =>
    @log 'SIOClient.onOpen'
    @emit 'open'

  onClose: =>
    @log 'SIOClient.onClose'
    @emit 'close'

  onError: (err) =>
    @log 'SIOClient.onError', err
    @emit 'error', err

  onMessage: (msg) =>
    @log 'SIOClient.onMessage', msg
    @emit 'message', msg

module.exports =
  SIOClient: SIOClient
