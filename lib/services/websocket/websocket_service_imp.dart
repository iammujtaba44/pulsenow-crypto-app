import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:pulsenow_flutter/services/websocket/websocket_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../models/market_data_model.dart';
import '../../utils/constants.dart';

class WebSocketServiceImpl implements WebSocketService {
  WebSocketChannel? _channel;
  StreamController<MarketDataUpdate>? _controller;
  Timer? _reconnectTimer;
  bool _shouldReconnect = false;
  int _reconnectAttempts = 0;

  @override
  Stream<MarketDataUpdate> get stream {
    _controller ??= StreamController<MarketDataUpdate>.broadcast(
      onCancel: disconnect,
    );
    return _controller!.stream;
  }

  @override
  void connect() {
    if (_channel != null) return;
    _shouldReconnect = true;
    _openConnection();
  }

  void _openConnection() {
    _reconnectTimer?.cancel();
    _controller ??= StreamController<MarketDataUpdate>.broadcast(
      onCancel: disconnect,
    );

    _channel = WebSocketChannel.connect(Uri.parse(AppConstants.wsUrl));
    _channel!.stream.listen(
      (message) {
        _reconnectAttempts = 0;
        final decoded = json.decode(message.toString());
        if (decoded is! Map<String, dynamic>) return;
        if (decoded['type'] != 'market_update') return;
        final data = decoded['data'];
        if (data is! Map<String, dynamic>) return;

        final update = MarketDataUpdate.fromJson(data);
        _controller?.add(update);
      },
      onError: (error) {
        _controller?.addError(error);
        _scheduleReconnect();
      },
      onDone: _scheduleReconnect,
    );
  }

  void _scheduleReconnect() {
    if (!_shouldReconnect) return;
    _channel?.sink.close();
    _channel = null;

    // Exponential backoff with a capped delay to avoid aggressive retries.
    final seconds = min(30, 2 << _reconnectAttempts);
    _reconnectAttempts = min(_reconnectAttempts + 1, 6);
    _reconnectTimer = Timer(Duration(seconds: seconds), () {
      if (_shouldReconnect) {
        _openConnection();
      }
    });
  }

  @override
  void disconnect() {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _controller?.close();
    _channel = null;
    _controller = null;
  }
}
