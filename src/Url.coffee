url = require 'url'

class Url
  constructor: (@inputString = '') ->
    @obj =    Url.parse  @inputString
    @string = Url.format @obj
    return @

  format: => Url.format @obj

  @parse: (string) ->
    noprotocol = string.indexOf('://') is -1
    string = "ws://#{string}" if noprotocol
    obj = url.parse string
    if not obj.port
      obj.port = switch obj.protocol
        when 'https:', 'wss:' then 443
        when 'http:',  'ws:'  then 80
    obj.protocol = 'wss:' if noprotocol and obj.port is 443
    obj

  @format: (obj) -> url.format obj

module.exports =
  Url:     Url
  parse:   Url::parse
  format:  Url::format
