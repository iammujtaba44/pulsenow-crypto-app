import 'package:either_dart/either.dart';
import 'package:pulsenow_flutter/core/errors/app_exceptions.dart';
import 'package:pulsenow_flutter/utils/string_constants.dart';

import '../../domain/repositories/market_data_repository.dart';
import '../../models/market_data_model.dart';
import '../../services/websocket/websocket_service.dart';
import '../datasources/market_data_local_data_source.dart';
import '../datasources/market_data_remote_data_source.dart';

class MarketDataRepositoryImpl implements MarketDataRepository {
  const MarketDataRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._webSocketService,
  );

  final MarketDataRemoteDataSource _remoteDataSource;
  final MarketDataLocalDataSource _localDataSource;
  final WebSocketService _webSocketService;

  @override
  Future<Either<AppException, MarketDataFetchResult>> fetchMarketData({
    bool forceRefresh = false,
  }) async {
    // Prefer fresh cache to keep the UI responsive when offline.
    final cached = await _localDataSource.getCachedMarketData();
    if (!forceRefresh && cached != null && cached.isFresh(DateTime.now())) {
      return Right(MarketDataFetchResult(
        items: cached.items,
        isFromCache: true,
        lastUpdated: cached.cachedAt,
      ));
    }

    try {
      final fresh = await _remoteDataSource.fetchMarketData();
      await _localDataSource.saveMarketData(fresh);
      return Right(MarketDataFetchResult(
        items: fresh,
        isFromCache: false,
        lastUpdated: DateTime.now(),
      ));
    } catch (error) {
      if (cached != null) {
        return Right(MarketDataFetchResult(
          items: cached.items,
          isFromCache: true,
          lastUpdated: cached.cachedAt,
        ));
      }
      return const Left(AppException(AppStrings.errorUnableLoadMarketData));
    }
  }

  @override
  Stream<MarketDataUpdate> streamMarketUpdates() {
    _webSocketService.connect();
    return _webSocketService.stream;
  }
}
