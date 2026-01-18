import 'package:flutter_test/flutter_test.dart';
import 'package:pulsenow_flutter/models/market_data_model.dart';

void main() {
  test('MarketData.fromJson parses required fields', () {
    final data = {
      'symbol': 'BTC/USD',
      'description': 'Bitcoin',
      'price': 42000.5,
      'change24h': 1.2,
      'changePercent24h': 1.2,
      'volume': 1200000000,
      'high24h': 43000,
      'low24h': 41000,
      'marketCap': 850000000000,
      'lastUpdated': '2024-01-01T12:00:00.000Z',
    };

    final model = MarketData.fromJson(data);

    expect(model.symbol, 'BTC/USD');
    expect(model.price, 42000.5);
    expect(model.changePercent24h, 1.2);
    expect(model.volume, 1200000000);
    expect(model.marketCap, 850000000000);
    expect(model.lastUpdated.year, 2024);
  });
}
