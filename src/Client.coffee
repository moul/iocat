class Client
  constructor: (@url, @options = {}) ->
    #console.log @url
    #console.log @options

module.exports =
  Client: Client
