import 'package:pulsenow_flutter/models/market_data_model.dart';

abstract class WebSocketService {
  void connect();
  void disconnect();
  Stream<MarketDataUpdate> get stream;
}
