import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracking/network_services/iservice_manager.dart';
import 'package:expense_tracking/repositories/expense_repository.dart';

part 'currency_update_event.dart';
part 'currency_update_state.dart';

class CurrencyUpdateBloc
    extends Bloc<CurrencyUpdateEvent, CurrencyUpdateState> {
  final ExpenseRepository _repository;
  final IserviceManager _serviceManager;

  CurrencyUpdateBloc({
    required ExpenseRepository repository,
    required IserviceManager serviceManager,
  })  : _repository = repository,
        _serviceManager = serviceManager,
        super(CurrencyUpdateInitial(
            currency: repository.getCurrencyPreference())) {
    on<ChangeCurrencyEvent>(_onChangeCurrency);
    on<FetchConversionRateEvent>(_onFetchConversionRate);

    // Fetch initial conversion rate and currency preference
    add(FetchConversionRateEvent(repository.getCurrencyPreference()));
  }

  void _onChangeCurrency(
      ChangeCurrencyEvent event, Emitter<CurrencyUpdateState> emit) async {
    if (state.currency == event.currency) {
      return;
    }

    emit(CurrencyUpdateLoading(currency: event.currency));

    // Fetch the new conversion rate
    await _fetchAndEmitConversionRate(event.currency, emit);
  }

  void _onFetchConversionRate(
      FetchConversionRateEvent event, Emitter<CurrencyUpdateState> emit) async {
    // No need to emit loading state here if it's only an initial fetch
    await _fetchAndEmitConversionRate(event.baseCurrency, emit);
  }

  Future<void> _fetchAndEmitConversionRate(
      String targetCurrency, Emitter<CurrencyUpdateState> emit) async {
    final response = await _serviceManager.get(
        'https://api.exchangerate-api.com/v4/latest/USD'); // Assuming base currency is USD

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
