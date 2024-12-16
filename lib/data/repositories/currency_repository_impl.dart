import 'package:expense_tracking/data/datasources/services/iservice_manager.dart';
import 'package:expense_tracking/data/datasources/local/local_storage_source.dart';
import 'package:expense_tracking/domain/repositories/currency_repository.dart';

/// Concrete implementation of ICurrencyRepository using an API and local storage.
class CurrencyRepositoryImpl implements ICurrencyRepository {
  CurrencyRepositoryImpl({
    required LocalStorageSource storage,
    required IserviceManager serviceManager,
  })  : _storage = storage,
        _serviceManager = serviceManager;
  final LocalStorageSource _storage;
  final IserviceManager _serviceManager;

  static const String _baseUrlFormat =
      'https://api.exchangerate-api.com/v4/latest/{currency}';

  static const _supportedCurrencies = {'USD', 'EUR', 'GBP', 'TRY'};

  @override
  Future<void> saveCurrencyPreference(String currency) async {
    final normalizedCurrency = currency.toUpperCase();
    if (!_supportedCurrencies.contains(normalizedCurrency)) {
      throw ArgumentError('Unsupported currency: $currency');
    }
    await _storage.saveCurrencyPreference(normalizedCurrency);
  }

  @override
  String getCurrencyPreference() {
    final currency = _storage.getCurrencyPreference();
    return _supportedCurrencies.contains(currency.toUpperCase())
        ? currency
        : 'USD';
  }

  @override
  Future<Map<String, dynamic>> getConversionRates(String baseCurrency) async {
    final normalizedCurrency = baseCurrency.toUpperCase();
    if (!_supportedCurrencies.contains(normalizedCurrency)) {
      return {'error': 'Unsupported currency: $baseCurrency'};
    }

    final url = _baseUrlFormat.replaceAll('{currency}', normalizedCurrency);
    final response = await _serviceManager.get(url);

    if (response.error != null) {
      // Return a map with an error key to indicate failure.
      return {'error': response.error};
    }

    final data = response.data;
    if (data == null || data['rates'] == null) {
      return {'error': 'Invalid response format'};
    }

    // Return the rates directly.
    return {'rates': data['rates']};
  }
}
