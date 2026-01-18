import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pulsenow_flutter/services/analytics/analytics_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsServiceImpl implements AnalyticsService {
  static const String _eventsKey = 'analytics_events';
  static const int _maxStoredEvents = 50;

  SharedPreferences? _preferences;

  Future<SharedPreferences> _getPreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  @override
  Future<void> trackEvent(
    String name, {
    Map<String, dynamic>? properties,
  }) async {
    final payload = <String, dynamic>{
      'name': name,
      'timestamp': DateTime.now().toIso8601String(),
      if (properties != null && properties.isNotEmpty) 'properties': properties,
    };

    debugPrint('Analytics event: ${jsonEncode(payload)}');
    await _storeEvent(payload);
  }

  @override
  Future<void> trackScreenView(String screenName) {
    return trackEvent('screen_view', properties: {'screen': screenName});
  }

  @override
  Future<void> trackError(String message, {String? context}) {
    return trackEvent('error', properties: {
      'message': message,
      if (context != null) 'context': context,
    });
  }

  Future<void> _storeEvent(Map<String, dynamic> payload) async {
    final preferences = await _getPreferences();
    final existing = preferences.getStringList(_eventsKey) ?? [];
    final updated = [...existing, jsonEncode(payload)];
    final trimmed = updated.length > _maxStoredEvents ? updated.sublist(updated.length - _maxStoredEvents) : updated;
    await preferences.setStringList(_eventsKey, trimmed);
  }
}
