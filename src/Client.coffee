#io = require 'socket.io-client'
#websocket = require 'websocket-stream'
{EventEmitter} = require 'events'
ws = require 'ws'

class Client extends EventEmitter
  constructor: (@url, @options = {}) ->
    return @

  start: =>
    console.log 'Client: url->', @url.format()

    href = @url.format()
    @ws = new ws @url.format()
    @ws.on 'open',    @onOpen
    @ws.on 'close',   @onClose
    @ws.on 'error',   @onError
    @ws.on 'message', @onMessage
    @ws.on 'connect', @onConnect

  # Methods
  send: (d) =>
    console.log 'Client.send', d
    @ws.send d

  end: =>
    console.log 'Client.end'
    do @ws.close

  # Events
  onConnect: =>
    console.log 'Client.onConnect'
    @emit 'connect'

  onOpen: =>
    console.log 'Client.onOpen'
    @emit 'open'

  onClose: =>
    console.log 'Client.onClose'
    @emit 'close'

  onError: (err) =>
    console.log 'Client.onError', err
    @emit 'error', err

  onMessage: (msg) =>
    console.log 'Client.onMessage', msg
    @emit 'message', msg

module.exports =
  Client: Client
