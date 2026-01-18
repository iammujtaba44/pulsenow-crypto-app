double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}

class MarketData {
  final String symbol;
  final String description;
  final double price;
  final double change24h;
  final double changePercent24h;
  final double volume;
  final double high24h;
  final double low24h;
  final double marketCap;
  final DateTime lastUpdated;

  const MarketData({
    required this.symbol,
    required this.description,
    required this.price,
    required this.change24h,
    required this.changePercent24h,
    required this.volume,
    required this.high24h,
    required this.low24h,
    required this.marketCap,
    required this.lastUpdated,
  });

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      symbol: (json['symbol'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      price: _toDouble(json['price']),
      change24h: _toDouble(json['change24h']),
      changePercent24h: _toDouble(json['changePercent24h']),
      volume: _toDouble(json['volume']),
      high24h: _toDouble(json['high24h']),
      low24h: _toDouble(json['low24h']),
      marketCap: _toDouble(json['marketCap']),
      lastUpdated: DateTime.tryParse(json['lastUpdated']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'description': description,
      'price': price,
      'change24h': change24h,
      'changePercent24h': changePercent24h,
      'volume': volume,
      'high24h': high24h,
      'low24h': low24h,
      'marketCap': marketCap,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  MarketData copyWith({
    double? price,
    double? change24h,
    double? changePercent24h,
    double? volume,
    DateTime? lastUpdated,
  }) {
    return MarketData(
      symbol: symbol,
      description: description,
      price: price ?? this.price,
      change24h: change24h ?? this.change24h,
      changePercent24h: changePercent24h ?? this.changePercent24h,
      volume: volume ?? this.volume,
      high24h: high24h,
      low24h: low24h,
      marketCap: marketCap,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class MarketDataUpdate {
  final String symbol;
  final double price;
  final double change24h;
  final double volume;
  final DateTime timestamp;

  const MarketDataUpdate({
    required this.symbol,
    required this.price,
    required this.change24h,
    required this.volume,
    required this.timestamp,
  });

  factory MarketDataUpdate.fromJson(Map<String, dynamic> json) {
    return MarketDataUpdate(
      symbol: (json['symbol'] ?? '').toString(),
      price: _toDouble(json['price']),
      change24h: _toDouble(json['change24h']),
      volume: _toDouble(json['volume']),
      timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? '') ?? DateTime.now(),
    );
  }
}
