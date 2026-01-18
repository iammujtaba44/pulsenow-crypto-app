import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/market_data_model.dart';
import '../../utils/constants.dart';

class MarketDataCacheEntry {
  const MarketDataCacheEntry({
    required this.items,
    required this.cachedAt,
  });

  final List<MarketData> items;
  final DateTime cachedAt;

  bool isFresh(DateTime now) => now.difference(cachedAt) <= AppConstants.marketDataCacheTtl;
}

class MarketDataLocalDataSource {
  MarketDataLocalDataSource({DateTime Function()? now}) : _now = now ?? DateTime.now;

  static const String _cacheKey = 'market_data_cache';
  static const String _cacheTimestampKey = 'market_data_cache_timestamp';

  final DateTime Function() _now;
  SharedPreferences? _preferences;

  Future<SharedPreferences> _getPreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  Future<MarketDataCacheEntry?> getCachedMarketData() async {
    final preferences = await _getPreferences();
    final cachedJson = preferences.getString(_cacheKey);
    final cachedTimestamp = preferences.getString(_cacheTimestampKey);
    if (cachedJson == null || cachedTimestamp == null) return null;

    try {
      final decoded = jsonDecode(cachedJson);
      if (decoded is! List) return null;

      final cachedAt = DateTime.tryParse(cachedTimestamp);
      if (cachedAt == null) return null;

      final items = decoded.map((item) => MarketData.fromJson(Map<String, dynamic>.from(item))).toList(growable: false);

      return MarketDataCacheEntry(items: items, cachedAt: cachedAt);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveMarketData(List<MarketData> items) async {
    final preferences = await _getPreferences();
    final payload = jsonEncode(items.map((item) => item.toJson()).toList());
    await preferences.setString(_cacheKey, payload);
    await preferences.setString(_cacheTimestampKey, _now().toIso8601String());
  }

  Future<void> clearCache() async {
    final preferences = await _getPreferences();
    await preferences.remove(_cacheKey);
    await preferences.remove(_cacheTimestampKey);
  }
}
