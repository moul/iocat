fs =         require 'fs'
program =    require 'commander'
{Url} =      require './Url'

class Program
  constructor: (@options = {}) ->
    @options.name ?= 'iocat'
    do @initCommander
    return @

  initCommander: ->
    program.name = @options.name
    program
      .version(do Program.getVersion)
      .usage('[options] URL')
      .option('-v, --verbose',                             'verbose')
      .option('-l, --listen',                              'Start in listen mode, creating a server')
      .option('-p, --local-port <port>',                   'Specify local port for remote connections',                 parseInt)
      .option('--socketio',                                'Use socket.io')
      .option('-k, --keep-listen',                         'Keep inbound sockets open for multiple connects')
      .option('-e, --emit-key <key>',                      'Emit-key, default is "message"',                          "message")
      #.option('-U, --use-unix-domain-socket',              'Use UNIX domain socket')
      #.option('-X, --proxy-protocol {socks[45],connect}',  'proxy protocol')
      #.option('-b, --bind-interface <if>',                 'Bind socket to interface')                                #checkInterface
      #.option('-c, --send-crlf',                           'Send CRLF as line-ending')
      #.option('-d, --detach-stdin',                        'Detach from stdin')
      #.option('-i, --interval <secs>',                     'Delay interval for lines sent, ports scanned',            parseFloat)
      #.option('-m, --text-mode {text,binary,auto}',        'Specify the message transmit mode (default: auto)')
      #.option('-n, --new-lines',                           'Separate each received message with a newline')
      #.option('-n, --no-name-resolution',                  'Suppress name/port resolutions')
      #.option('-q, --quit-on-eof <secs>',                  'Quit after EOF on stdin and delay of secs (0 allowed)',   parseFloat)
      #.option('-r, --randomize-local-port',                'Randomize local port')
      #.option('-s, --local-source-address <addr>',         'Local source address')
      #.option('-u, --udp',                                 'UDP mode')
      #.option('-w, --wait <secs>',                         'Timeout for connects and final net reads',                parseFloat)
      #.option('-x, --proxy <addr[:port]>',                 'Proxy address and port')                                  # parseAddr
      #.option('-z, --zero-io-mode',                        'Zero-I/O mode [used for scanning]')

  @getVersion: -> JSON.parse(fs.readFileSync "#{__dirname}/../package.json", 'utf8').version

  parseOptions: =>
    program.parse(process.argv)
    @options extends program

  initShell: =>
    {Shell} = require './Shell'
    @shell = new Shell
    do @shell.start

  initWSClient: (destString) =>
    {WSClient} = require './WSClient'
    dest = new Url destString
    @client = new WSClient dest, @options
    do @client.start

  initSIOClient: (destString) =>
    {SIOClient} = require './SIOClient'
    dest = new Url destString
    @client = new SIOClient dest, @options
    do @client.start

  initWSServer: =>
    {WSServer} = require './WSServer'
    @server = new WSServer @options
    do @server.start

  initSIOServer: =>
    {SIOServer} = require './SIOServer'
    @server = new SIOServer @options
    do @server.start

  runClient: (destString) =>
    do @initShell
    if @options.socketio then @initSIOClient destString else @initWSClient destString

    @shell.on 'line', (d) =>
      @client.send d

    @client.on 'error', (err) =>
      console.log 'client.on error'
      @shell.exit 0

    @client.on 'data', (d) =>
      do @shell.stdin.pause
      @shell.send d
      do @shell.stdin.resume

    @client.on @options.emitKey, (d) =>
      @shell.send d

    @client.on 'close', =>
      console.log 'client.on close'
      do @shell.stdin.pause
      @shell.send "\nconnection closed by foreign host."
      do @shell.close
      @shell.exit 0

    @client.on 'open', =>
      @shell.send "Connection to #{destString} succeeded!"

    @shell.on 'SIGINT', =>
      console.log 'shell.on SIGINT'
      do @shell.stdin.pause
      @shell.send "\nending session"
      do @shell.close
      do @client.end
      @shell.exit 0

  runServer: =>
    do @initShell
    if @options.socketio then do @initSIOServer else do @initWSServer

    @shell.on 'line', (d) =>
      @server.send d

    @server.on 'error', (err) =>
      console.log 'server.on error'
      @shell.exit 0

    @server.on @options.emitKey, (d) =>
      @shell.send d

    @server.on 'connection', =>
      console.log 'New connection'

    @server.on 'close', =>
      do @shell.stdin.pause
      @shell.send "\nconnection closed by foreign host."
      unless @options.keepListen
        do @shell.close
        @shell.exit 0

    @shell.on 'SIGINT', =>
      console.log 'shell.on SIGINT'
      do @shell.stdin.pause
      @shell.send "\nending session"
      do @shell.close
      do @server.end
      @shell.exit 0

  run: =>
    do @parseOptions

    if @options.args?.length is 1
      @runClient @options.args[0]
    else if @options.listen
      do @runServer
    else
      do program.help

  @create: (options = {}) ->
    new Program options

  @run: ->
    prog = do Program.create
    prog.run()

module.exports =
  Program: Program
  create:  Program.create
  run:     Program.run
