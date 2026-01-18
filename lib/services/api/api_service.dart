abstract class ApiService {
  Future<List<Map<String, dynamic>>> getMarketData();
  Future<Map<String, dynamic>> getAnalyticsOverview();
  Future<Map<String, dynamic>> getAnalyticsTrends(String timeframe);
  Future<Map<String, dynamic>> getAnalyticsSentiment();
}
