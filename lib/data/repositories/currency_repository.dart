import '../idata_storage.dart';
import '../datasources/iservice_manager.dart';
import '../datasources/base_response_model.dart';

/// Repository responsible for managing currency-related operations
class CurrencyRepository {
  final ExpenseStorage _storage;
  final IserviceManager _serviceManager;
  static const String _baseUrlFormat = 'https://api.exchangerate-api.com/v4/latest/{currency}';

  const CurrencyRepository({
    required ExpenseStorage storage,
    required IserviceManager serviceManager,
  })  : _storage = storage,
        _serviceManager = serviceManager;

  /// Saves the user's currency preference
  Future<void> saveCurrencyPreference(String currency) =>
      _storage.saveCurrencyPreference(currency);

  /// Gets the user's stored currency preference
  String getCurrencyPreference() => _storage.getCurrencyPreference();

  /// Fetches the latest conversion rates from the API for a specific base currency
  /// Returns a map of currency codes to conversion rates
  Future<BaseResponseModel> getConversionRates(String baseCurrency) async {
    final url = _baseUrlFormat.replaceAll('{currency}', baseCurrency);
    return await _serviceManager.get(url);
  }

  /// Calculates the conversion rate between two currencies
  /// If the currencies are the same, returns 1.0
  double calculateCrossRate(Map<String, dynamic> rates, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return 1.0;
    
    final toRate = rates[toCurrency];
    final fromRate = rates[fromCurrency];
    
    if (toRate == null || fromRate == null) return 1.0;
    
    return toRate / fromRate;
  }
}
