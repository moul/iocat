readline = require 'readline'

class Shell
  constructor: (@options = {}) ->
    @options.input  ?= process.stdin
    @options.output ?= process.stdout
    return @

  start: ->
    @rl = readline.createInterface @options

module.exports =
  Shell: Shell
