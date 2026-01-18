abstract class AnalyticsService {
  Future<void> trackEvent(String name, {Map<String, dynamic>? properties});
  Future<void> trackScreenView(String screenName);
  Future<void> trackError(String message, {String? context});
}
