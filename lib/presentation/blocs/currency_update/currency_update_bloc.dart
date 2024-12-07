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
  String _currentBaseCurrency = 'USD';

  /// Creates a new instance of [CurrencyUpdateBloc]
  /// [repository] is used for currency operations and persistence
  CurrencyUpdateBloc({
    required CurrencyRepository repository,
  })  : _repository = repository,
        super(CurrencyUpdateInitial(
            currency: repository.getCurrencyPreference())) {
    on<ChangeCurrencyEvent>(_onChangeCurrency);
    on<FetchConversionRateEvent>(_onFetchConversionRate);

    // Initialize with stored preference
    _currentBaseCurrency = repository.getCurrencyPreference();
    
    // Fetch initial conversion rate and currency preference
    add(FetchConversionRateEvent(_currentBaseCurrency));
  }

  /// Handles currency change events
  /// Fetches new conversion rates when currency changes
  void _onChangeCurrency(
      ChangeCurrencyEvent event, Emitter<CurrencyUpdateState> emit) async {
    if (state.currency == event.currency) {
      return;
    }

    emit(CurrencyUpdateLoading(currency: event.currency));

    // Fetch conversion rates for both current and target currencies
    final fromResponse = await _repository.getConversionRates(_currentBaseCurrency);
    
    if (fromResponse.error != null) {
      emit(CurrencyUpdateError(
          errorMessage: 'Failed to fetch conversion rates',
          currency: event.currency));
      return;
    }

    final rates = fromResponse.data['rates'] as Map<String, dynamic>;
    final conversionRate = _repository.calculateCrossRate(
      rates,
      _currentBaseCurrency,
      event.currency
    );

    // Update current base currency
    _currentBaseCurrency = event.currency;
    
    // Save the new preference
    await _repository.saveCurrencyPreference(event.currency);

    emit(CurrencyUpdated(
      currency: event.currency,
      conversionRate: conversionRate,
      previousCurrency: state.currency,
    ));
  }

  /// Handles conversion rate fetch events
  /// Used for initial loading and refreshing rates
  void _onFetchConversionRate(
      FetchConversionRateEvent event, Emitter<CurrencyUpdateState> emit) async {
    final response = await _repository.getConversionRates(event.baseCurrency);

    if (response.error != null) {
      emit(CurrencyUpdateError(
          errorMessage: 'Failed to fetch conversion rates',
          currency: event.baseCurrency));
      return;
    }

    final rates = response.data['rates'] as Map<String, dynamic>;
    final conversionRate = _repository.calculateCrossRate(
      rates,
      _currentBaseCurrency,
      event.baseCurrency
    );

    emit(CurrencyUpdated(
      currency: event.baseCurrency,
      conversionRate: conversionRate,
      previousCurrency: state.currency,
    ));
  }
}
