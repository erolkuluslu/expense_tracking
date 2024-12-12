import 'package:expense_tracking/domain/repositories/currency_repository.dart';

/// Use case: Get conversion rates for a given base currency.
class GetConversionRatesUseCase {
  GetConversionRatesUseCase(this.repository);
  final ICurrencyRepository repository;

  Future<Map<String, dynamic>> execute(String baseCurrency) {
    return repository.getConversionRates(baseCurrency);
  }
}
