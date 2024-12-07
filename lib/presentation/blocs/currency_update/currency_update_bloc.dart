/// Bloc for managing currency updates and conversion rates
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/repositories/currency_repository.dart';

part 'currency_update_event.dart';
part 'currency_update_state.dart';

/// [CurrencyUpdateBloc] handles currency conversion and updates
/// It manages fetching conversion rates and updating the currency preference
class CurrencyUpdateBloc extends Bloc<CurrencyUpdateEvent, CurrencyUpdateState> {
  final CurrencyRepository _repository;

  /// Creates a new instance of [CurrencyUpdateBloc]
  /// [repository] is used for currency operations and persistence
  CurrencyUpdateBloc({
    required CurrencyRepository repository,
  })  : _repository = repository,
        super(CurrencyUpdateInitial(
            currency: repository.getCurrencyPreference())) {
    on<ChangeCurrencyEvent>(_onChangeCurrency);
    on<FetchConversionRateEvent>(_onFetchConversionRate);

    // Fetch initial conversion rate and currency preference
    add(FetchConversionRateEvent(repository.getCurrencyPreference()));
  }

  /// Handles currency change events
  /// Fetches new conversion rates when currency changes
  void _onChangeCurrency(
      ChangeCurrencyEvent event, Emitter<CurrencyUpdateState> emit) async {
    if (state.currency == event.currency) {
      return;
    }

    emit(CurrencyUpdateLoading(currency: event.currency));

    // Fetch the new conversion rate
    await _fetchAndEmitConversionRate(event.currency, emit);
  }

  /// Handles conversion rate fetch events
  /// Used for initial loading and refreshing rates
  void _onFetchConversionRate(
      FetchConversionRateEvent event, Emitter<CurrencyUpdateState> emit) async {
    await _fetchAndEmitConversionRate(event.baseCurrency, emit);
  }

  /// Fetches conversion rates from the API and updates the state
  /// [targetCurrency] is the currency to convert to
  Future<void> _fetchAndEmitConversionRate(
      String targetCurrency, Emitter<CurrencyUpdateState> emit) async {
    final response = await _repository.getConversionRates();

    if (response.error != null) {
      emit(CurrencyUpdateError(
          errorMessage: 'Failed to fetch conversion rates',
          currency: targetCurrency));
      return;
    }

    final rates = response.data['rates'];
    final conversionRate = rates[targetCurrency] ?? 1.0;

    await _repository.saveCurrencyPreference(targetCurrency);

    emit(CurrencyUpdated(
      currency: targetCurrency,
      conversionRate: conversionRate,
    ));
  }
}
