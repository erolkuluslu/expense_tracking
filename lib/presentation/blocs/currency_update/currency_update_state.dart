part of 'currency_update_bloc.dart';

/// States represent the current UI data. They tell the UI what to show.
/// For example: initial state, loading state, success with updated rate, or error.

abstract class CurrencyUpdateState extends Equatable {
  const CurrencyUpdateState({required this.currency});
  final String currency;

  @override
  List<Object?> get props => [currency];
}

// STEP: Initial state before any conversions happen. Just knows the initial currency.
class CurrencyUpdateInitial extends CurrencyUpdateState {
  const CurrencyUpdateInitial({required super.currency});
}

// STEP: Loading state shown when fetching data or changing currencies.
class CurrencyUpdateLoading extends CurrencyUpdateState {
  const CurrencyUpdateLoading({required super.currency});
}

// STEP: Successful update with a newly calculated conversion rate.
class CurrencyUpdated extends CurrencyUpdateState {
  const CurrencyUpdated({
    required String currency,
    required this.conversionRate,
    this.previousCurrency,
  }) : super(currency: currency);

  final double conversionRate;
  final String? previousCurrency;

  @override
  List<Object?> get props => [currency, conversionRate, previousCurrency];
}

// STEP: Error state if fetching or calculating rates fails.
class CurrencyUpdateError extends CurrencyUpdateState {
  const CurrencyUpdateError({
    required String currency,
    required this.errorMessage,
  }) : super(currency: currency);

  final String errorMessage;

  @override
  List<Object?> get props => [currency, errorMessage];
}
