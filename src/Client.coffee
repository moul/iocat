#io = require 'socket.io-client'
#websocket = require 'websocket-stream'
{EventEmitter} = require 'events'
ws = require 'ws'

class Client extends EventEmitter
  constructor: (@url, @options = {}) ->
    return @

  #on: (event, fn) => console.log 'on', event

  start: =>
    console.log 'Client: url->', @url.format()

    href = @url.format()
    @ws = new ws @url.format()
    @ws.on 'open',    @onOpen
    @ws.on 'close',   @onClose
    @ws.on 'error',   @onError
    @ws.on 'message', @onMessage
    @ws.on 'connect', @onConnect
    return

  onConnect: =>
    console.log 'onConnect'

  onOpen: =>
    console.log 'onOpen'

  onClose: =>
    console.log 'onClose'

  onError: (err) =>
    console.log 'onError', err
    @emit 'error', err

  onMessage: =>
    console.log 'onMessage'

#    console.log 'test'
#    console.log @ws
#    @ws.on 'data', (buf) -> console.log 'test'
#    @ws.
    #@on = @ws.on
    #@io =   io.connect @url.format()

    #@io.on 'data', (buf) -> console.log buf

    #@on =   @io.on
    #@emit = @io.emit

module.exports =
  Client: Client
