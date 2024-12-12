import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracking/domain/usecases/calculate_cross_rate_use_case.dart';
import 'package:expense_tracking/domain/usecases/get_conversion_rates_use_case.dart';
import 'package:expense_tracking/domain/usecases/save_currency_preference_use_case.dart';

part 'currency_update_event.dart';
part 'currency_update_state.dart';

/// Bloc for managing currency updates and conversion rates.
class CurrencyUpdateBloc
    extends Bloc<CurrencyUpdateEvent, CurrencyUpdateState> {
  CurrencyUpdateBloc({
    required GetConversionRatesUseCase getConversionRatesUseCase,
    required SaveCurrencyPreferenceUseCase saveCurrencyPreferenceUseCase,
    required CalculateCrossRateUseCase calculateCrossRateUseCase,
    required String initialCurrencyPreference,
  })  : _getConversionRatesUseCase = getConversionRatesUseCase,
        _saveCurrencyPreferenceUseCase = saveCurrencyPreferenceUseCase,
        _calculateCrossRateUseCase = calculateCrossRateUseCase,
        super(CurrencyUpdateInitial(currency: initialCurrencyPreference)) {
    on<ChangeCurrencyEvent>(_onChangeCurrency);
    on<FetchConversionRateEvent>(_onFetchConversionRate);

    _currentBaseCurrency = initialCurrencyPreference;
    add(FetchConversionRateEvent(_currentBaseCurrency));
  }
  final GetConversionRatesUseCase _getConversionRatesUseCase;
  final SaveCurrencyPreferenceUseCase _saveCurrencyPreferenceUseCase;
  final CalculateCrossRateUseCase _calculateCrossRateUseCase;
  String _currentBaseCurrency = 'USD';

  Future<void> _onChangeCurrency(
    ChangeCurrencyEvent event,
    Emitter<CurrencyUpdateState> emit,
  ) async {
    if (state.currency == event.currency) {
      // No change needed if same currency selected.
      return;
    }

    emit(CurrencyUpdateLoading(currency: event.currency));

    final fromResponse =
        await _getConversionRatesUseCase.execute(_currentBaseCurrency);

    if (fromResponse['error'] != null) {
      emit(
        CurrencyUpdateError(
          errorMessage: fromResponse['error'] as String,
          currency: event.currency,
        ),
      );
      return;
    }

    final rates = fromResponse['rates'] as Map<String, dynamic>;
    final conversionRate = _calculateCrossRateUseCase.execute(
      rates,
      _currentBaseCurrency,
      event.currency,
    );

    _currentBaseCurrency = event.currency;

    await _saveCurrencyPreferenceUseCase.execute(event.currency);

    emit(
      CurrencyUpdated(
        currency: event.currency,
        conversionRate: conversionRate,
        previousCurrency: state.currency,
      ),
    );
  }

  Future<void> _onFetchConversionRate(
    FetchConversionRateEvent event,
    Emitter<CurrencyUpdateState> emit,
  ) async {
    final response =
        await _getConversionRatesUseCase.execute(event.baseCurrency);

    if (response['error'] != null) {
      emit(
        CurrencyUpdateError(
          errorMessage: response['error'] as String,
          currency: event.baseCurrency,
        ),
      );
      return;
    }

    final rates = response['rates'] as Map<String, dynamic>;
    final conversionRate = _calculateCrossRateUseCase.execute(
      rates,
      _currentBaseCurrency,
      event.baseCurrency,
    );

    emit(
      CurrencyUpdated(
        currency: event.baseCurrency,
        conversionRate: conversionRate,
        previousCurrency: state.currency,
      ),
    );
  }
}
