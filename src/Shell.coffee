readline = require 'readline'

class Shell
  constructor: (@options = {}) ->
    @options.input  ?= process.stdin
    @options.output ?= process.stdout
    return @

  start: =>
    @rl =   readline.createInterface @options
    @on =   @rl.on
    @emit = @rl.emit

  exit: (code) =>
    console.log 'Shell.exit:', code
    process.exit code

module.exports =
  Shell: Shell
