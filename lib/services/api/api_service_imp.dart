import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pulsenow_flutter/services/api/api_service.dart';
import '../../core/errors/app_exceptions.dart';
import '../../utils/constants.dart';
import '../../utils/string_constants.dart';

class ApiServiceImpl implements ApiService {
  static const String baseUrl = AppConstants.baseUrl;
  static const int _maxRetries = 2;
  static const Duration _timeout = Duration(seconds: 10);

  @override
  Future<List<Map<String, dynamic>>> getMarketData() async {
    final uri = Uri.parse(
      '$baseUrl${AppConstants.marketDataEndpoint}',
    );
    return _executeWithRetry(() async {
      final response = await http.get(uri).timeout(_timeout);
      if (response.statusCode != 200) {
        throw ApiException(
          AppStrings.errorFailedLoadMarketData,
          statusCode: response.statusCode,
        );
      }

      final decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const ApiException(AppStrings.errorInvalidMarketDataResponse);
      }

      final data = decoded['data'];
      if (data is! List) {
        throw const ApiException(AppStrings.errorMarketDataPayloadMissing);
      }

      return data.map((item) => Map<String, dynamic>.from(item)).toList();
    }, failureMessage: AppStrings.errorMarketDataRequestFailed);
  }

  @override
  Future<Map<String, dynamic>> getAnalyticsOverview() {
    final uri = Uri.parse('$baseUrl${AppConstants.analyticsEndpoint}/overview');
    return _getAnalyticsPayload(
      uri,
      failureMessage: AppStrings.errorFailedLoadAnalyticsOverview,
    );
  }

  @override
  Future<Map<String, dynamic>> getAnalyticsTrends(String timeframe) {
    final uri = Uri.parse(
      '$baseUrl${AppConstants.analyticsEndpoint}/trends?timeframe=$timeframe',
    );
    return _getAnalyticsPayload(
      uri,
      failureMessage: AppStrings.errorFailedLoadAnalyticsTrends,
    );
  }

  @override
  Future<Map<String, dynamic>> getAnalyticsSentiment() {
    final uri = Uri.parse('$baseUrl${AppConstants.analyticsEndpoint}/sentiment');
    return _getAnalyticsPayload(
      uri,
      failureMessage: AppStrings.errorFailedLoadAnalyticsSentiment,
    );
  }

  Future<Map<String, dynamic>> _getAnalyticsPayload(
    Uri uri, {
    required String failureMessage,
  }) {
    return _executeWithRetry(() async {
      final response = await http.get(uri).timeout(_timeout);
      if (response.statusCode != 200) {
        throw ApiException(
          failureMessage,
          statusCode: response.statusCode,
        );
      }

      final decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const ApiException(AppStrings.errorInvalidAnalyticsResponse);
      }

      final data = decoded['data'];
      if (data is! Map<String, dynamic>) {
        throw const ApiException(AppStrings.errorAnalyticsPayloadMissing);
      }

      return Map<String, dynamic>.from(data);
    }, failureMessage: failureMessage);
  }

  Future<T> _executeWithRetry<T>(
    Future<T> Function() action, {
    required String failureMessage,
  }) async {
    var attempt = 0;
    var delay = const Duration(milliseconds: 400);

    while (true) {
      try {
        return await action();
      } on ApiException {
        rethrow;
      } catch (error) {
        if (attempt >= _maxRetries) {
          throw NetworkException(
            failureMessage,
            details: error.toString(),
          );
        }
        await Future.delayed(delay);
        delay *= 2;
        attempt += 1;
      }
    }
  }
}
