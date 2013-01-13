wscat
=====

A WebSocket netcat-like utility.

An alternative to the built-in `wscat` binary, packaged with [ws](http://einaros.github.com/ws/).

Usage
-----

```
  Usage: wscat [options] URL

  Options:

    -h, --help               output usage information
    -V, --version            output the version number
    -v, --verbose            verbose
    -l, --listen             Start in listen mode, creating a server
    -p, --local-port <port>  Specify local port for remote conntects
```

Example
-------

Server
```bash
# wscat -l -p 3050
> Hello !
< Hi !
```

Client
```bash
# wscat ws://127.0.0.1:3050
< Hello !
> Hi !
```
