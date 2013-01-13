{Base}   = require './Base'
readline = require 'readline'

class Shell extends Base
  constructor: (@options = {}) ->
    @options.input  ?= process.stdin
    @options.output ?= process.stdout
    @stdin = process.stdin
    @stdout = process.stdout
    return @

  start: =>
    @rl =   readline.createInterface @options
    @rl.on 'line',   @onLine
    @rl.on 'SIGINT', @onSigint

  onLine: (d) =>
    @log 'Shell.onLine', d
    @emit 'line', d

  onSigint: =>
    @log 'Shell.onSigint'
    @emit 'SIGINT'

  exit: (code) =>
    @log 'Shell.exit:', code
    process.exit code

  send: (d) =>
    @log 'Shell.write', d
    console.log d

  close: =>
    @log 'Shell.close'

module.exports =
  Shell: Shell
