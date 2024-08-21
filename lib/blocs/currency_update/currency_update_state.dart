part of 'currency_update_bloc.dart';

sealed class CurrencyUpdateState extends Equatable {
  final String currency;
  final double conversionRate;

  const CurrencyUpdateState({
    required this.currency,
    this.conversionRate = 1.0,
  });

  @override
  List<Object> get props => [currency, conversionRate];
}

final class CurrencyUpdateInitial extends CurrencyUpdateState {
  const CurrencyUpdateInitial(
      {required String currency, double conversionRate = 1.0})
      : super(currency: currency, conversionRate: conversionRate);
}

final class CurrencyUpdated extends CurrencyUpdateState {
  const CurrencyUpdated({
    required String currency,
    required double conversionRate,
  }) : super(currency: currency, conversionRate: conversionRate);
}

final class CurrencyUpdateError extends CurrencyUpdateState {
  final String errorMessage;

  const CurrencyUpdateError({
    required this.errorMessage,
    String currency = 'Unknown',
    double conversionRate = 1.0,
  }) : super(currency: currency, conversionRate: conversionRate);

  @override
  List<Object> get props => [currency, conversionRate, errorMessage];
}
