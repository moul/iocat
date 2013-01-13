{EventEmitter} = require 'events'
readline = require 'readline'

class Shell extends EventEmitter
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
    console.log 'Shell.onLine', d
    @emit 'line', d

  onSigint: =>
    console.log 'Shell.onSigint'
    @emit 'SIGINT'

  exit: (code) =>
    console.log 'Shell.exit:', code
    process.exit code

  write: (str) =>
    console.log 'Shell.write', str

  close: =>
    console.log 'Shell.close'

module.exports =
  Shell: Shell
