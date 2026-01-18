import 'package:flutter_test/flutter_test.dart';
import 'package:pulsenow_flutter/services/websocket/websocket_service_imp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pulsenow_flutter/data/datasources/market_data_local_data_source.dart';
import 'package:pulsenow_flutter/data/datasources/market_data_remote_data_source.dart';
import 'package:pulsenow_flutter/data/repositories/market_data_repository_impl.dart';
import 'package:pulsenow_flutter/models/market_data_model.dart';

class FakeRemoteDataSource implements MarketDataRemoteDataSource {
  FakeRemoteDataSource({required this.items, this.shouldThrow = false});

  final List<MarketData> items;
  final bool shouldThrow;

  @override
  Future<List<MarketData>> fetchMarketData() async {
    if (shouldThrow) {
      throw Exception('network error');
    }
    return items;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MarketData buildMarketData(String symbol) {
    return MarketData(
      symbol: symbol,
      description: 'Test $symbol',
      price: 123.45,
      change24h: 1.23,
      changePercent24h: 0.45,
      volume: 1000,
      high24h: 130,
      low24h: 110,
      marketCap: 100000,
      lastUpdated: DateTime.now(),
    );
  }

  test('returns cached data when network fails', () async {
    SharedPreferences.setMockInitialValues({});
    final localDataSource = MarketDataLocalDataSource();
    final cachedItems = [buildMarketData('BTC/USD')];
    await localDataSource.saveMarketData(cachedItems);

    final repository = MarketDataRepositoryImpl(
      FakeRemoteDataSource(items: const <MarketData>[], shouldThrow: true),
      localDataSource,
      WebSocketServiceImpl(),
    );

    final result = await repository.fetchMarketData();
    result.fold(
      (exception) => fail('Expected success, but got error: ${exception.message}'),
      (result) {
        expect(result.isFromCache, true);
        expect(result.items.length, 1);
        expect(result.lastUpdated, isNotNull);
      },
    );
  });

  test('writes cache after successful network fetch', () async {
    SharedPreferences.setMockInitialValues({});
    final localDataSource = MarketDataLocalDataSource();
    final freshItems = [buildMarketData('ETH/USD'), buildMarketData('SOL/USD')];

    final repository = MarketDataRepositoryImpl(
      FakeRemoteDataSource(items: freshItems),
      localDataSource,
      WebSocketServiceImpl(),
    );

    final result = await repository.fetchMarketData();
    final cached = await localDataSource.getCachedMarketData();

    result.fold(
      (exception) => fail('Expected success, but got error: ${exception.message}'),
      (result) {
        expect(result.isFromCache, false);
        expect(cached, isNotNull);
        expect(cached!.items.length, freshItems.length);
      },
    );
    expect(cached, isNotNull);
    expect(cached!.items.length, freshItems.length);
  });
}
