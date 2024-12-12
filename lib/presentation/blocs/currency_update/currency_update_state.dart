part of 'currency_update_bloc.dart';

abstract class CurrencyUpdateState extends Equatable {
  const CurrencyUpdateState({required this.currency});
  final String currency;

  @override
  List<Object?> get props => [currency];
}

class CurrencyUpdateInitial extends CurrencyUpdateState {
  const CurrencyUpdateInitial({required super.currency});
}

class CurrencyUpdateLoading extends CurrencyUpdateState {
  const CurrencyUpdateLoading({required super.currency});
}

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

class CurrencyUpdateError extends CurrencyUpdateState {
  const CurrencyUpdateError({
    required String currency,
    required this.errorMessage,
  }) : super(currency: currency);
  final String errorMessage;

  @override
  List<Object?> get props => [currency, errorMessage];
}
