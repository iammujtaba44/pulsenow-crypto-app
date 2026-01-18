import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pulsenow_flutter/domain/repositories/market_data_repository.dart';
import 'package:pulsenow_flutter/services/analytics/analytics_service.dart';

import '../../domain/usecases/get_market_data.dart';
import '../../domain/usecases/stream_market_updates.dart';
import '../../models/market_data_model.dart';
import '../../utils/string_constants.dart';

part 'market_data_provider_mixin.dart';
part 'enum/market_data_provider_enum.dart';

class MarketDataProvider with ChangeNotifier, MarketDataProviderMixin {
  MarketDataProvider(
    this._getMarketData,
    this._streamUpdates,
    this._analytics,
  );
  final GetMarketDataUseCase _getMarketData;
  final StreamMarketUpdatesUseCase _streamUpdates;
  final AnalyticsService _analytics;

  /// Sets the state of the market data provider and updates the listeners.
  void _setState(MarketDataState state, {String? error}) {
    _state = state;
    if (error case String? error when error != null && error.isNotEmpty) {
      _error = error;
      _isFromCache = false;
    }
    notifyListeners();
  }

  /// Initializes the market data provider by subscribing to the market data updates and loading the market data.
  void init() {
    _subscription ??= _streamUpdates().listen(
      _applyUpdate,
      onError: (error) => _analytics.trackError(AppStrings.errorMarketStreamDisconnected, context: error.toString()),
    );
    if (_marketData.isEmpty) loadMarketData();
  }

  /// Loads the market data from the repository and updates the state accordingly.
  Future<void> loadMarketData({bool forceRefresh = false}) async {
    _error = null;
    _warning = null;
    _setState(MarketDataState.loading);

    final result = await _getMarketData(forceRefresh: forceRefresh);

    result.fold(
      (exception) async {
        _setState(MarketDataState.error, error: exception.message);
        await _analytics.trackError(exception.message);
      },
      (result) => _updateMarketData(result),
    );
  }

  Future<void> refresh() async {
    await _analytics.trackEvent(AppStrings.eventMarketDataRefresh);
    return loadMarketData(forceRefresh: true);
  }

  void updateQuery(String value) {
    _query = value.trim();
    _trackSearchIfNeeded(_query);
    notifyListeners();
  }

  void clearQuery() {
    if (_query.isEmpty) return;
    _query = '';
    _analytics.trackEvent(AppStrings.eventMarketSearchCleared);
    notifyListeners();
  }

  void updateSortField(MarketSortField field) {
    _sortField = field;
    _analytics.trackEvent(
      AppStrings.eventMarketSortField,
      properties: {AppStrings.analyticsFieldKey: field.name},
    );
    notifyListeners();
  }

  void toggleSortDirection() {
    _sortDirection = _sortDirection == MarketSortDirection.ascending
        ? MarketSortDirection.descending
        : MarketSortDirection.ascending;
    _analytics.trackEvent(
      AppStrings.eventMarketSortDirection,
      properties: {AppStrings.analyticsDirectionKey: _sortDirection.name},
    );
    notifyListeners();
  }

  void trackDetailOpened(MarketData item) {
    _analytics.trackEvent(
      AppStrings.eventMarketDetailOpened,
      properties: {AppStrings.analyticsSymbolKey: item.symbol},
    );
  }

  void _applyUpdate(MarketDataUpdate update) {
    final index = _marketData.indexWhere((item) => item.symbol == update.symbol);
    if (index == -1) return;
    final current = _marketData[index];
    _marketData[index] = current.copyWith(
      price: update.price,
      change24h: update.change24h,
      changePercent24h: update.change24h,
      volume: update.volume,
      lastUpdated: update.timestamp,
    );
    _setState(MarketDataState.success);
  }

  void _trackSearchIfNeeded(String query) {
    if (query.isEmpty) return;
    final now = DateTime.now();
    // Avoid spamming analytics while the user types.
    if (_lastSearchTrackedAt != null && now.difference(_lastSearchTrackedAt!) < const Duration(seconds: 2)) {
      return;
    }
    _lastSearchTrackedAt = now;
    _analytics.trackEvent(
      AppStrings.eventMarketSearch,
      properties: {AppStrings.analyticsQueryKey: query},
    );
  }

  void _updateMarketData(MarketDataFetchResult result) async {
    _marketData = result.items;
    _isFromCache = result.isFromCache;
    _lastUpdated = result.lastUpdated;
    if (_isFromCache) {
      _warning = AppStrings.warningShowingCachedData;
    }
    await _analytics.trackEvent(
      AppStrings.eventMarketDataLoaded,
      properties: {
        AppStrings.analyticsSourceKey:
            result.isFromCache ? AppStrings.analyticsSourceCache : AppStrings.analyticsSourceNetwork,
        if (result.lastUpdated != null) AppStrings.analyticsLastUpdatedKey: result.lastUpdated!.toIso8601String(),
      },
    );
    _setState(_marketData.isEmpty ? MarketDataState.empty : MarketDataState.success);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
