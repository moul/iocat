# iocat

**Socket.IO** and **WebSocket** **netcat-like** utility.

![](https://raw.githubusercontent.com/moul/iocat/master/assets/iocat.jpg)

## Usage

```command
$ iocat --help

  Usage: iocat [options] URL

  Options:

    -h, --help               output usage information
    -V, --version            output the version number
    -v, --verbose            verbose
    -l, --listen             Start in listen mode, creating a server
    -p, --local-port <port>  Specify local port for remote conntects
    --socketio               Use socket.io
    -k, --keep-listen        Keep inbound sockets open for multiple connects
    -e, --emit-key <key>     Emit-key, default is "message"
```

## Examples

WebSocket Server
```bash
$ iocat -l -p 3050
> Hello !
< Hi !
```

WebSocket Client
```bash
$ iocat ws://127.0.0.1:3050
< Hello !
> Hi !
```

Socket.IO Server
```bash
$ iocat --socketio -l -p 3050
> Hello !
< Hi !
```

Socket.IO Client
```bash
$ iocat --socketio ws://127.0.0.1:3050
< Hello !
> Hi !
```

## Install

```bash
npm install iocat -g
```

## Alternatives

The **WebSocket** part is an alternative to the built-in `wscat` binary, packaged with [ws](http://einaros.github.com/ws/).

## License

MIT
