/// Domain model for currency information if needed.
library;
// ignore_for_file: sort_constructors_first

class CurrencyInfo {
  final String currencyCode;
  final double conversionRate;

  CurrencyInfo({
    required this.currencyCode,
    required this.conversionRate,
  });
}
