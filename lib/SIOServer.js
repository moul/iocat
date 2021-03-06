// Generated by CoffeeScript 1.10.0
(function() {
  var Base, SIOServer, io,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  Base = require('./Base').Base;

  io = require('socket.io');

  SIOServer = (function(superClass) {
    extend(SIOServer, superClass);

    function SIOServer(options) {
      var base;
      this.options = options != null ? options : {};
      this.onClientMessage = bind(this.onClientMessage, this);
      this.onClientError = bind(this.onClientError, this);
      this.onClientClose = bind(this.onClientClose, this);
      this.onClientOpen = bind(this.onClientOpen, this);
      this.onClientDisonnect = bind(this.onClientDisonnect, this);
      this.onClientConnect = bind(this.onClientConnect, this);
      this.onSIOServerError = bind(this.onSIOServerError, this);
      this.onSIOServerConnection = bind(this.onSIOServerConnection, this);
      this.onSIOServerSocketConnection = bind(this.onSIOServerSocketConnection, this);
      this.onSIOServerDisconnect = bind(this.onSIOServerDisconnect, this);
      this.onSIOServerListening = bind(this.onSIOServerListening, this);
      this.isActive = bind(this.isActive, this);
      this.end = bind(this.end, this);
      this.send = bind(this.send, this);
      this._enqueue = bind(this._enqueue, this);
      this.start = bind(this.start, this);
      if ((base = this.options).port == null) {
        base.port = this.options.localPort;
      }
      this.options.log = !!this.options.verbose;
      this.log('constructor');
      this._queue = [];
      return this;
    }

    SIOServer.prototype.start = function(fn) {
      if (fn == null) {
        fn = null;
      }
      this.log('start');
      this.sio = io.listen(this.options.port, this.options);
      this.sio.on('listening', this.onSIOServerListening);
      this.sio.on('connection', this.onSIOServerSocketConnection);
      this.sio.on('error', this.onSIOServerError);
      this.sio.sockets.on('disconnect', this.onSIOServerDisconnect);
      this.sio.sockets.on('connection', this.onSIOServerConnection);
      this.sio.sockets.on('error', this.onSIOServerError);
      if (fn) {
        return fn();
      }
    };

    SIOServer.prototype._enqueue = function(data) {
      return this._queue.push(data);
    };

    SIOServer.prototype.send = function(data, fn) {
      if (fn == null) {
        fn = null;
      }
      if (!this.isActive()) {
        return this._enqueue(data);
      } else {
        this.log('send', data);
        this.ioc.emit(this.options.emitKey, data);
        if (fn) {
          return fn();
        }
      }
    };

    SIOServer.prototype.end = function(fn) {
      if (fn == null) {
        fn = null;
      }
      this.log('end');
      if (this.isActive()) {
        this.ioc.disconnect();
      }
      this.ioc = null;
      this.ready = false;
      if (fn) {
        return fn();
      }
    };

    SIOServer.prototype.isActive = function() {
      return (this.ioc != null) && this.ready;
    };

    SIOServer.prototype.onSIOServerListening = function() {
      this.log('onSIOServerListening');
      return this.emit('listening');
    };

    SIOServer.prototype.onSIOServerDisconnect = function() {
      this.log('onSIOServerDisconnect');
      return this.emit('disconnect');
    };

    SIOServer.prototype.onSIOServerSocketConnection = function(socket) {
      return this.log("onSIOServerSocketConnection");
    };

    SIOServer.prototype.onSIOServerConnection = function(socket) {
      var data, i, len, ref;
      this.log('onSIOServerConnection');
      this.emit('connection', socket);
      this.ioc = socket;
      this.ioc.on('open', this.onClientOpen);
      this.ioc.on('close', this.onClientClose);
      this.ioc.on('error', this.onClientError);
      this.ioc.on(this.options.emitKey, this.onClientMessage);
      this.ioc.on('connect', this.onClientConnect);
      this.ioc.on('disconnect', this.onClientDisonnect);
      this.ready = true;
      ref = this._queue;
      for (i = 0, len = ref.length; i < len; i++) {
        data = ref[i];
        this.send(data);
      }
      return this.emit('ready');
    };

    SIOServer.prototype.onSIOServerError = function(err) {
      this.log('onSIOServerError', err);
      return this.emit('error', err);
    };

    SIOServer.prototype.onClientConnect = function() {
      this.log('onClientConnect');
      return this.emit('connect');
    };

    SIOServer.prototype.onClientDisonnect = function() {
      this.log('onClientDisonnect');
      return this.emit('disconnect');
    };

    SIOServer.prototype.onClientOpen = function() {
      this.log('onClientOpen');
      return this.emit('open');
    };

    SIOServer.prototype.onClientClose = function() {
      this.log('onClientClose');
      return this.emit('close');
    };

    SIOServer.prototype.onClientError = function(err) {
      this.log('onClientError', err);
      return this.emit('error', err);
    };

    SIOServer.prototype.onClientMessage = function(msg) {
      this.log('onClientMessage', msg);
      return this.emit(this.options.emitKey, msg);
    };

    return SIOServer;

  })(Base);

  module.exports = {
    SIOServer: SIOServer
  };

}).call(this);
