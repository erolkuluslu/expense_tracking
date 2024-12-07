part of 'currency_update_bloc.dart';

/// Base state for currency updates
abstract class CurrencyUpdateState extends Equatable {
  final String currency;
  
  const CurrencyUpdateState({
    required this.currency,
  });

  @override
  List<Object?> get props => [currency];
}

/// Initial state when the bloc is created
class CurrencyUpdateInitial extends CurrencyUpdateState {
  const CurrencyUpdateInitial({required String currency})
      : super(currency: currency);
}

/// Loading state while fetching conversion rates
class CurrencyUpdateLoading extends CurrencyUpdateState {
  const CurrencyUpdateLoading({required String currency})
      : super(currency: currency);
}

/// Error state when conversion rate fetch fails
class CurrencyUpdateError extends CurrencyUpdateState {
  final String errorMessage;

  const CurrencyUpdateError({
    required this.errorMessage,
    required String currency,
  }) : super(currency: currency);

  @override
  List<Object?> get props => [currency, errorMessage];
}

/// Success state with updated conversion rate
class CurrencyUpdated extends CurrencyUpdateState {
  final double conversionRate;
  final String previousCurrency;

  const CurrencyUpdated({
    required String currency,
    required this.conversionRate,
    required this.previousCurrency,
  }) : super(currency: currency);

  @override
  List<Object?> get props => [currency, conversionRate, previousCurrency];
}
