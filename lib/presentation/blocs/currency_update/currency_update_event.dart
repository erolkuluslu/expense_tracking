part of 'currency_update_bloc.dart';

abstract class CurrencyUpdateEvent extends Equatable {
  const CurrencyUpdateEvent();

  @override
  List<Object?> get props => [];
}

class ChangeCurrencyEvent extends CurrencyUpdateEvent {
  const ChangeCurrencyEvent(this.currency);
  final String currency;

  @override
  List<Object?> get props => [currency];
}

class FetchConversionRateEvent extends CurrencyUpdateEvent {
  const FetchConversionRateEvent(this.baseCurrency);
  final String baseCurrency;

  @override
  List<Object?> get props => [baseCurrency];
}
