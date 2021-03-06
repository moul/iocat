// Generated by CoffeeScript 1.10.0
(function() {
  var Base, SIOClient, io,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty,
    slice = [].slice;

  Base = require('./Base').Base;

  io = require('socket.io-client');

  SIOClient = (function(superClass) {
    extend(SIOClient, superClass);

    function SIOClient(url, options) {
      this.url = url;
      this.options = options != null ? options : {};
      this.onMessage = bind(this.onMessage, this);
      this.onError = bind(this.onError, this);
      this.onClose = bind(this.onClose, this);
      this.onOpen = bind(this.onOpen, this);
      this.onConnect = bind(this.onConnect, this);
      this.end = bind(this.end, this);
      this.send = bind(this.send, this);
      this.start = bind(this.start, this);
      return this;
    }

    SIOClient.prototype.start = function() {
      var href;
      this.log('SIOClient: url->', this.url.format());
      href = this.url.format();
      this.io = io.connect(this.url.format());
      this.io.on('open', this.onOpen);
      this.io.on('close', this.onClose);
      this.io.on('error', this.onError);
      this.io.on(this.options.emitKey, this.onMessage);
      return this.io.on('connect', this.onConnect);
    };

    SIOClient.prototype.send = function(d) {
      this.log('send', d);
      return this.io.emit(this.options.emitKey, d);
    };

    SIOClient.prototype.end = function() {
      this.log('end');
      return this.io.disconnect();
    };

    SIOClient.prototype.onConnect = function() {
      this.log('onConnect');
      return this.emit('connect');
    };

    SIOClient.prototype.onOpen = function() {
      this.log('onOpen');
      return this.emit('open');
    };

    SIOClient.prototype.onClose = function() {
      this.log('onClose');
      return this.emit('close');
    };

    SIOClient.prototype.onError = function(err) {
      this.log('onError', err);
      return this.emit('error', err);
    };

    SIOClient.prototype.onMessage = function() {
      var msg;
      msg = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      this.log('onMessage', msg);
      return this.emit(this.options.emitKey, msg);
    };

    return SIOClient;

  })(Base);

  module.exports = {
    SIOClient: SIOClient
  };

}).call(this);
