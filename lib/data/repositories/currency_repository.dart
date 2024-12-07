import '../idata_storage.dart';
import '../datasources/iservice_manager.dart';
import '../datasources/base_response_model.dart';

/// Repository responsible for managing currency-related operations
class CurrencyRepository {
  final ExpenseStorage _storage;
  final IserviceManager _serviceManager;
  static const String _baseUrlFormat = 'https://api.exchangerate-api.com/v4/latest/{currency}';
  
  static const _supportedCurrencies = {'USD', 'EUR', 'GBP', 'TRY'};

  const CurrencyRepository({
    required ExpenseStorage storage,
    required IserviceManager serviceManager,
  })  : _storage = storage,
        _serviceManager = serviceManager;

  /// Saves the user's currency preference
  Future<void> saveCurrencyPreference(String currency) async {
    final normalizedCurrency = currency.toUpperCase();
    if (!_supportedCurrencies.contains(normalizedCurrency)) {
      throw ArgumentError('Unsupported currency: $currency');
    }
    await _storage.saveCurrencyPreference(normalizedCurrency);
  }

  /// Gets the user's stored currency preference
  String getCurrencyPreference() {
    final currency = _storage.getCurrencyPreference();
    return _supportedCurrencies.contains(currency.toUpperCase()) 
        ? currency 
        : 'USD';
  }

  /// Fetches the latest conversion rates from the API for a specific base currency
  /// Returns a map of currency codes to conversion rates
  Future<BaseResponseModel> getConversionRates(String baseCurrency) async {
    final normalizedCurrency = baseCurrency.toUpperCase();
    if (!_supportedCurrencies.contains(normalizedCurrency)) {
      return BaseResponseModel(
        error: 'Unsupported currency: $baseCurrency',
      );
    }

    final url = _baseUrlFormat.replaceAll('{currency}', normalizedCurrency);
    final response = await _serviceManager.get(url);
    
    if (response.error != null) {
      return response;
    }

    // Validate response data
    final data = response.data;
    if (data == null || data['rates'] == null) {
      return BaseResponseModel(
        error: 'Invalid response format',
      );
    }

    return response;
  }

  /// Calculates the conversion rate between two currencies
  /// If the currencies are the same, returns 1.0
  /// If either currency is not found in rates, returns 1.0 and logs error
  double calculateCrossRate(Map<String, dynamic> rates, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return 1.0;
    
    final normalizedFrom = fromCurrency.toUpperCase();
    final normalizedTo = toCurrency.toUpperCase();
    
    if (!_supportedCurrencies.contains(normalizedFrom) || 
        !_supportedCurrencies.contains(normalizedTo)) {
      print('Warning: Unsupported currency conversion $fromCurrency -> $toCurrency');
      return 1.0;
    }
    
    final toRate = rates[normalizedTo] as num?;
    final fromRate = rates[normalizedFrom] as num?;
    
    if (toRate == null || fromRate == null) {
      print('Warning: Missing rate for conversion $fromCurrency -> $toCurrency');
      return 1.0;
    }
    
    if (fromRate == 0) {
      print('Warning: Invalid rate (0) for $fromCurrency');
      return 1.0;
    }
    
    return toRate / fromRate;
  }
}
