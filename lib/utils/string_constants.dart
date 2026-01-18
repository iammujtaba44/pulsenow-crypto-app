class AppStrings {
  static const String appTitle = 'PulseNow';
  static const String screenMarketData = 'MarketData';
  static const String searchHint = 'Search symbols or descriptions';
  static const String sortAscending = 'Ascending';
  static const String sortDescending = 'Descending';
  static const String offlineDataUpdatedPrefix = 'Offline data • Updated ';
  static const String tooltipToggleSortDirection = 'Toggle sort direction';
  static const String tooltipSwitchToDark = 'Switch to dark mode';
  static const String tooltipSwitchToLight = 'Switch to light mode';
  static const String retry = 'Retry';
  static const String noMarketDataAvailable = 'No market data available';
  static const String price = 'Price';
  static const String change24h = '24h Change';
  static const String volume = 'Volume';
  static const String marketCap = 'Market Cap';
  static const String symbol = 'Symbol';
  static const String heroTagSymbolPrefix = 'symbol_';

  static const String errorFailedLoadMarketData = 'Failed to load market data.';
  static const String errorInvalidMarketDataResponse = 'Invalid market data response.';
  static const String errorMarketDataPayloadMissing = 'Market data payload missing.';
  static const String errorMarketDataRequestFailed = 'Market data request failed.';
  static const String errorFailedLoadAnalyticsOverview = 'Failed to load analytics overview.';
  static const String errorFailedLoadAnalyticsTrends = 'Failed to load analytics trends.';
  static const String errorFailedLoadAnalyticsSentiment = 'Failed to load analytics sentiment.';
  static const String errorInvalidAnalyticsResponse = 'Invalid analytics response.';
  static const String errorAnalyticsPayloadMissing = 'Analytics payload missing.';
  static const String errorMarketStreamDisconnected = 'Market stream disconnected.';
  static const String errorUnableLoadMarketData = 'Unable to load market data.';

  static const String warningShowingCachedData = 'Showing cached data. Connect to refresh.';

  static const String eventMarketDataLoaded = 'market_data_loaded';
  static const String eventMarketDataRefresh = 'market_data_refresh';
  static const String eventMarketSearchCleared = 'market_search_cleared';
  static const String eventMarketSortField = 'market_sort_field';
  static const String eventMarketSortDirection = 'market_sort_direction';
  static const String eventMarketDetailOpened = 'market_detail_opened';
  static const String eventMarketSearch = 'market_search';

  static const String analyticsSourceKey = 'source';
  static const String analyticsSourceCache = 'cache';
  static const String analyticsSourceNetwork = 'network';
  static const String analyticsLastUpdatedKey = 'lastUpdated';
  static const String analyticsContextLoadMarketData = 'loadMarketData';
  static const String analyticsFieldKey = 'field';
  static const String analyticsDirectionKey = 'direction';
  static const String analyticsSymbolKey = 'symbol';
  static const String analyticsQueryKey = 'query';
  static const String high24h = 'High 24h';
  static const String low24h = 'Low 24h';
  static const String lastUpdated = 'Last Updated';
  static const String overview = 'Overview';
  static const String statistics = 'Statistics';
}
