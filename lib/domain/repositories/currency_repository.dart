/// Abstract repository for currency operations.
/// Returns a map of rates or an error map if something fails.
abstract class ICurrencyRepository {
  Future<Map<String, dynamic>> getConversionRates(String baseCurrency);
  Future<void> saveCurrencyPreference(String currency);
  String getCurrencyPreference();
}
