// Generated by CoffeeScript 1.4.0
(function() {
  var Base, SIOClient, io,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Base = require('./Base').Base;

  io = require('socket.io-client');

  SIOClient = (function(_super) {

    __extends(SIOClient, _super);

    function SIOClient(url, options) {
      this.url = url;
      this.options = options != null ? options : {};
      this.onMessage = __bind(this.onMessage, this);

      this.onError = __bind(this.onError, this);

      this.onClose = __bind(this.onClose, this);

      this.onOpen = __bind(this.onOpen, this);

      this.onConnect = __bind(this.onConnect, this);

      this.end = __bind(this.end, this);

      this.send = __bind(this.send, this);

      this.start = __bind(this.start, this);

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
      this.io.on('message', this.onMessage);
      return this.io.on('connect', this.onConnect);
    };

    SIOClient.prototype.send = function(d) {
      this.log('send', d);
      return this.io.send(d);
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

    SIOClient.prototype.onMessage = function(msg) {
      this.log('onMessage', msg);
      return this.emit('message', msg);
    };

    return SIOClient;

  })(Base);

  module.exports = {
    SIOClient: SIOClient
  };

}).call(this);