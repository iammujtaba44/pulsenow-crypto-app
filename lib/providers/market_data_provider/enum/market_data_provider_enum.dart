part of '../market_data_provider.dart';

enum MarketDataState { initial, loading, empty, error, success }

enum MarketSortField {
  symbol(AppStrings.symbol),
  price(AppStrings.price),
  change(AppStrings.change24h),
  volume(AppStrings.volume),
  marketCap(AppStrings.marketCap);

  const MarketSortField(this.label);
  final String label;
}

enum MarketSortDirection { ascending, descending }
