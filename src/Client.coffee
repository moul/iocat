io = require 'socket.io-client'

class Client
  constructor: (@url, @options = {}) ->
    return @

  start: =>
    console.log 'Client: url->', @url.format()
    @io =   io.connect @url.format()

    @on =   @io.on
    @emit = @io.emit

module.exports =
  Client: Client
