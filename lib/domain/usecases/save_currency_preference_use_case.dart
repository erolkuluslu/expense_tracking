import 'package:expense_tracking/domain/repositories/currency_repository.dart';

/// Use case: Save the user's preferred currency.
class SaveCurrencyPreferenceUseCase {
  SaveCurrencyPreferenceUseCase(this.repository);
  final ICurrencyRepository repository;

  Future<void> execute(String currencyCode) {
    return repository.saveCurrencyPreference(currencyCode);
  }
}
