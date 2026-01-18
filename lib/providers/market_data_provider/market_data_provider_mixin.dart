part of 'market_data_provider.dart';

mixin MarketDataProviderMixin<T extends ChangeNotifier> {
  StreamSubscription<MarketDataUpdate>? _subscription;
  List<MarketData> _marketData = [];
  MarketDataState _state = MarketDataState.loading;
  String? _error;
  String? _warning;
  bool _isFromCache = false;
  DateTime? _lastUpdated;
  String _query = '';
  MarketSortField _sortField = MarketSortField.price;
  MarketSortDirection _sortDirection = MarketSortDirection.descending;
  DateTime? _lastSearchTrackedAt;
  String? get error => _error;
  String? get warning => _warning;
  bool get isFromCache => _isFromCache;
  DateTime? get lastUpdated => _lastUpdated;
  String get query => _query;
  MarketSortField get sortField => _sortField;
  MarketSortDirection get sortDirection => _sortDirection;
  MarketDataState get state => _state;

  /// Returns the filtered and sorted market data based on the current query and sort field.
  List<MarketData> get marketData {
    final lowerQuery = _query.toLowerCase();
    final filtered = _query.isEmpty
        ? List<MarketData>.of(_marketData)
        : _marketData.where((item) {
            return item.symbol.toLowerCase().contains(lowerQuery) ||
                item.description.toLowerCase().contains(lowerQuery);
          }).toList();

    final int Function(MarketData, MarketData) baseComparator = switch (_sortField) {
      MarketSortField.price => (a, b) => a.price.compareTo(b.price),
      MarketSortField.change => (a, b) => a.changePercent24h.compareTo(b.changePercent24h),
      MarketSortField.volume => (a, b) => a.volume.compareTo(b.volume),
      MarketSortField.marketCap => (a, b) => a.marketCap.compareTo(b.marketCap),
      MarketSortField.symbol => (a, b) => a.symbol.compareTo(b.symbol),
    };

    final comparator = _sortDirection == MarketSortDirection.descending
        ? (MarketData a, MarketData b) => baseComparator(b, a)
        : baseComparator;

    filtered.sort(comparator);
    return filtered;
  }
}
