import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static final NumberFormat _priceFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
  static final NumberFormat _percentFormatter = NumberFormat.decimalPattern()
    ..minimumFractionDigits = 2
    ..maximumFractionDigits = 2;
  static final NumberFormat _compactFormatter = NumberFormat.compactCurrency(symbol: '\$');
  static final DateFormat _timestampFormatter = DateFormat('MMM d, HH:mm');

  static String formatPrice(double value) => _priceFormatter.format(value);

  static String formatPercent(double value) {
    final sign = value >= 0 ? '+' : '';
    return '$sign${_percentFormatter.format(value)}%';
  }

  static String formatCompact(double value) => _compactFormatter.format(value);

  static String formatTimestamp(DateTime value) => _timestampFormatter.format(value);
}
