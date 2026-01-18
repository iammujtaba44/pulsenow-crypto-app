import 'package:either_dart/either.dart';
import 'package:pulsenow_flutter/core/errors/app_exceptions.dart';

import '../../models/market_data_model.dart';

class MarketDataFetchResult {
  const MarketDataFetchResult({
    required this.items,
    required this.isFromCache,
    required this.lastUpdated,
  });
  final List<MarketData> items;
  final bool isFromCache;
  final DateTime? lastUpdated;
}

abstract class MarketDataRepository {
  Future<Either<AppException, MarketDataFetchResult>> fetchMarketData({bool forceRefresh = false});
  Stream<MarketDataUpdate> streamMarketUpdates();
}
