{Base}   = require './Base'
readline = require 'readline'

class Shell extends Base
  constructor: (@options = {}) ->
    @options.input  ?= process.stdin
    @options.output ?= process.stdout
    @stdin =  process.stdin
    @stdout = process.stdout
    return @

  start: =>
    @rl =   readline.createInterface @options
    @rl.on 'line',   @onLine
    @rl.on 'SIGINT', @onSigint # ^C
    #@rl.on 'SIGTSTP',          # ^Z
    #@rl.on 'SIGCONT',          # fg after ^Z
    #@rl.on 'close',
    #@rl.on 'pause',
    #@rl.on 'resume',
    do @rl.prompt

  onLine: (d) =>
    @log 'onLine', d
    @emit 'line', d
    do @rl.prompt

  onSigint: =>
    @log 'onSigint'
    @emit 'SIGINT'

  exit: (code) =>
    @log 'exit:', code
    process.exit code

  send: (d) =>
    @log 'write', d
    console.log d

  close: =>
    @log 'close'

module.exports =
  Shell: Shell
