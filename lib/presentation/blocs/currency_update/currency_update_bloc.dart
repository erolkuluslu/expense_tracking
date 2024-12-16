import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_tracking/domain/usecases/calculate_cross_rate_use_case.dart';
import 'package:expense_tracking/domain/usecases/get_conversion_rates_use_case.dart';
import 'package:expense_tracking/domain/usecases/save_currency_preference_use_case.dart';
import 'package:expense_tracking/core/constants/app_constants.dart';

part 'currency_update_event.dart';
part 'currency_update_state.dart';

/// BLoC for managing currency updates and conversion rates.
///
/// PURPOSE OF THIS BLOC:
/// - It retrieves conversion rates for a given base currency.
/// - It changes the currently selected currency and calculates cross rates.
/// - It saves user currency preferences.
///
/// FLOW OVERVIEW:
/// STEP#1: Initialize with an initial currency preference.
/// STEP#2: Immediately fetch conversion rates for the initial currency.
/// STEP#3: When user requests a currency change (ChangeCurrencyEvent),
///          it fetches new rates and calculates the cross rate.
/// STEP#4: When user requests to just fetch rates (FetchConversionRateEvent),
///          it gets the data and updates the state.
/// STEP#5: Handle errors by emitting CurrencyUpdateError states.

class CurrencyUpdateBloc
    extends Bloc<CurrencyUpdateEvent, CurrencyUpdateState> {
  CurrencyUpdateBloc({
    required GetConversionRatesUseCase getConversionRatesUseCase,
    required SaveCurrencyPreferenceUseCase saveCurrencyPreferenceUseCase,
    required CalculateCrossRateUseCase calculateCrossRateUseCase,
  })  : _getConversionRatesUseCase = getConversionRatesUseCase,
        _saveCurrencyPreferenceUseCase = saveCurrencyPreferenceUseCase,
        _calculateCrossRateUseCase = calculateCrossRateUseCase,
        // Default to first currency if no preference is set
        super(CurrencyUpdateInitial(currency: AppConstants.currencies.first)) {
    // STEP#2: Register event handlers that define what happens when events are added.
    on<ChangeCurrencyEvent>(_onChangeCurrency);
    on<FetchConversionRateEvent>(_onFetchConversionRate);

    // STEP#3: Store the current base currency internally.
    _currentBaseCurrency = AppConstants.currencies.first;

    // STEP#4: Immediately fetch conversion rates for the initial currency
    //         so we start with updated info for the UI.
    add(FetchConversionRateEvent(_currentBaseCurrency));
  }

  final GetConversionRatesUseCase _getConversionRatesUseCase;
  final SaveCurrencyPreferenceUseCase _saveCurrencyPreferenceUseCase;
  final CalculateCrossRateUseCase _calculateCrossRateUseCase;

  late String _currentBaseCurrency;

  // HANDLER for ChangeCurrencyEvent:
  Future<void> _onChangeCurrency(
    ChangeCurrencyEvent event,
    Emitter<CurrencyUpdateState> emit,
  ) async {
    // STEP#1: If user tries to change to the same currency, do nothing.
    if (state.currency == event.currency) {
      return;
    }

    // STEP#2: Emit a loading state to show progress in UI.
    emit(CurrencyUpdateLoading(currency: event.currency));

    // STEP#3: Fetch conversion rates from the old base currency.
    final fromResponse =
        await _getConversionRatesUseCase.execute(_currentBaseCurrency);

    // STEP#4: Check if there was an error in response.
    if (fromResponse['error'] != null) {
      // STEP#5: Emit an error state if something went wrong.
      emit(
        CurrencyUpdateError(
          errorMessage: fromResponse['error'] as String,
          currency: event.currency,
        ),
      );
      return;
    }

    // STEP#6: Extract rates and ensure they are present.
    final rates = fromResponse['rates'];
    if (rates == null) {
      emit(
        CurrencyUpdateError(
          errorMessage: 'No rates available',
          currency: event.currency,
        ),
      );
      return;
    }

    // STEP#7: Calculate the cross rate from the old base to the new currency.
    final rateMap = rates as Map<String, dynamic>;
    final conversionRate = _calculateCrossRateUseCase.execute(
      rateMap,
      _currentBaseCurrency,
      event.currency,
    );

    // STEP#8: Update the internal current base currency.
    _currentBaseCurrency = event.currency;

    // STEP#9: Save the new preference.
    await _saveCurrencyPreferenceUseCase.execute(event.currency);

    // STEP#10: Emit a CurrencyUpdated state with the new currency and rate.
    emit(
      CurrencyUpdated(
        currency: event.currency,
        conversionRate: conversionRate,
        previousCurrency: state.currency,
      ),
    );
  }

  // HANDLER for FetchConversionRateEvent:
  Future<void> _onFetchConversionRate(
    FetchConversionRateEvent event,
    Emitter<CurrencyUpdateState> emit,
  ) async {
    // STEP#1: Get conversion rates for the requested base currency.
    final response =
        await _getConversionRatesUseCase.execute(event.baseCurrency);

    // STEP#2: Check for errors.
    if (response['error'] != null) {
      emit(
        CurrencyUpdateError(
          errorMessage: response['error'] as String,
          currency: event.baseCurrency,
        ),
      );
      return;
    }

    // STEP#3: Check rates availability.
    final rates = response['rates'];
    if (rates == null) {
      emit(
        CurrencyUpdateError(
          errorMessage: 'No rates available',
          currency: event.baseCurrency,
        ),
      );
      return;
    }

    // STEP#4: Calculate the rate from the current base to this currency.
    final rateMap = rates as Map<String, dynamic>;
    final conversionRate = _calculateCrossRateUseCase.execute(
      rateMap,
      _currentBaseCurrency,
      event.baseCurrency,
    );

    // STEP#5: Emit updated state with new conversion rate.
    emit(
      CurrencyUpdated(
        currency: event.baseCurrency,
        conversionRate: conversionRate,
        previousCurrency: state.currency,
      ),
    );
  }
}
