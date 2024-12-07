import '../idata_storage.dart';
import '../datasources/iservice_manager.dart';
import '../datasources/base_response_model.dart';

/// Repository responsible for managing currency-related operations
class CurrencyRepository {
  final ExpenseStorage _storage;
  final IserviceManager _serviceManager;
  static const String _baseUrl = 'https://api.exchangerate-api.com/v4/latest/USD';

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

  /// Fetches the latest conversion rates from the API
  /// Returns a map of currency codes to conversion rates
  Future<BaseResponseModel> getConversionRates() async {
    return await _serviceManager.get(_baseUrl);
  }
}
