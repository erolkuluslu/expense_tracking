import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracking/repositories/expense_repository.dart';

part 'currency_update_event.dart';
part 'currency_update_state.dart';

class CurrencyUpdateBloc
    extends Bloc<CurrencyUpdateEvent, CurrencyUpdateState> {
  final ExpenseRepository _repository;

  CurrencyUpdateBloc({required ExpenseRepository repository})
      : _repository = repository,
        super(CurrencyUpdateInitial(
            currency: repository.getCurrencyPreference())) {
    on<ChangeCurrencyEvent>((event, emit) async {
      if (state.currency == event.currency) {
        return; // No need to change the state if the currency is the same
      }

      try {
        double conversionRate =
            _getConversionRate(state.currency, event.currency);
        await _repository.saveCurrencyPreference(event.currency);
        emit(CurrencyUpdated(
          currency: event.currency,
          conversionRate: conversionRate,
        ));
      } on Exception catch (e) {
        emit(CurrencyUpdateError(errorMessage: e.toString()));
      }
    });

    // Calculate initial conversion rate and total expenses
    final savedCurrency = _repository.getCurrencyPreference();
    final conversionRate = _getConversionRate(
        'USD', savedCurrency); // Assume stored expenses are in USD
    emit(CurrencyUpdated(
        currency: savedCurrency, conversionRate: conversionRate));
  }

  double _getConversionRate(String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) {
      return 1.0;
    }

    if (fromCurrency == 'EUR' && toCurrency == 'USD') {
      return 1.10;
    } else if (fromCurrency == 'EUR' && toCurrency == 'TRY') {
      return 29.62;
    } else if (fromCurrency == 'USD' && toCurrency == 'EUR') {
      return 1 / 1.10;
    } else if (fromCurrency == 'USD' && toCurrency == 'TRY') {
      return 26.95;
    }

    // Default fallback conversion rate
    return 1.0;
  }
}
