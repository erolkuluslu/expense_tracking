/// Use case: Calculate cross conversion rate given a rates map and two currencies.
class CalculateCrossRateUseCase {
  double execute(
    Map<String, dynamic> rates,
    String fromCurrency,
    String toCurrency,
  ) {
    final normalizedFrom = fromCurrency.toUpperCase();
    final normalizedTo = toCurrency.toUpperCase();

    if (normalizedFrom == normalizedTo) return 1;

    final fromRate = rates[normalizedFrom] as num?;
    final toRate = rates[normalizedTo] as num?;

    if (fromRate == null || toRate == null || fromRate == 0) {
      // If we can't properly convert, return 1.0 as a fallback.
      return 1;
    }

    return toRate / fromRate;
  }
}
