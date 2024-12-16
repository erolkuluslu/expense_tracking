// lib/domain/usecases/save_currency_preference_use_case.dart
// ignore_for_file: avoid_print

import 'package:expense_tracking/core/utils/logging_mixin.dart';
import 'package:expense_tracking/domain/repositories/currency_repository.dart';

class SaveCurrencyPreferenceUseCase with LoggingMixin {
  final ICurrencyRepository _repository;

  SaveCurrencyPreferenceUseCase(this._repository);

  Future<void> execute(String currency) async {
    try {
      // Log before storing
      logDataStorage('currency_preference', currency,
          source: 'CurrencyUpdateBloc');

      // Save the currency preference
      await _repository.saveCurrencyPreference(currency);

      // Optional: Log after successful storage
      print('Currency preference saved successfully: $currency');
    } catch (e) {
      // Log any errors
      print('Error saving currency preference: $e');
    }
  }
}
