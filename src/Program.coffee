fs =         require 'fs'
program =    require 'commander'
{Url} =      require './Url'

class Program
  constructor: (@options = {}) ->
    @options.name ?= 'wscat'
    do @initCommander
    return @

  initCommander: ->
    program.name = @options.name
    program
      .version(do Program.getVersion)
      .usage('[options] URL')
      .option('-v, --verbose',                             'verbose')
      .option('-l, --listen',                              'Start in listen mode, creating a server')
      #.option('-U, --use-unix-domain-socket',              'Use UNIX domain socket')
      #.option('-X, --proxy-protocol {socks[45],connect}',  'proxy protocol')
      #.option('-b, --bind-interface <if>',                 'Bind socket to interface')                                #checkInterface
      #.option('-c, --send-crlf',                           'Send CRLF as line-ending')
      #.option('-d, --detach-stdin',                        'Detach from stdin')
      #.option('-i, --interval <secs>',                     'Delay interval for lines sent, ports scanned',            parseFloat)
      #.option('-k, --keep-listen',                         'Keep inbound sockets open for multiple connects')
      #.option('-m, --text-mode {text,binary,auto}',        'Specify the message transmit mode (default: auto)')
      #.option('-n, --new-lines',                           'Separate each received message with a newline')
      #.option('-n, --no-name-resolution',                  'Suppress name/port resolutions')
      #.option('-p, --local-port <port>',                   'Specify local port for remote conntects',                 parseInt)
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

  initClient: (destString) =>
    {Client} = require './Client'
    dest = new Url destString
    @client = new Client dest
    do @client.start

  initServer: =>
    {Server} = require './Server'
    @server = new Server

  runClient: (destString) =>
    do @initShell
    @initClient destString
    @shell.on 'line', (d) =>
      @client.write "#{d}\n"
    @client.on 'data', (d) =>
      do @client.stdin.pause
      @client.stdout.srite d
      do @client.stdin.resume
    @client.on 'close', =>
      console.log 'client.on close'
      do @client.stdin.pause
      @shell.write "\nconnection closed by foreign host."
      do @shell.close
      @shell.exit 0
    @shell.on 'SIGINT', =>
      console.log 'shell.on SIGINT'
      do @shell.stdin.pause
      @shell.write "\nending session"
      do @shell.close
      do @client.end
      @shell.exit 0

  runServer: =>
    do @initShell
    do @initServer

  run: =>
    do @parseOptions

    if @options.args?.length is 1
      @runClient @options.args[0]
    else if @options.listen
      @runServer
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
