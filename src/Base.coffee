{EventEmitter} = require 'events'

class Base extends EventEmitter
  log: (args...) =>
    return false unless @options.verbose
    name = @?.constructor?.toString?().match(/function\s*(\w+)/)?[1] || 'ApiBase'
    console.log "#{name}>", args...

module.exports =
  Base: Base
