part of 'currency_update_bloc.dart';

/// Events represent user or system actions that will affect the currency state.
/// For instance, changing currency or requesting fresh conversion rates.

abstract class CurrencyUpdateEvent extends Equatable {
  const CurrencyUpdateEvent();

  @override
  List<Object?> get props => [];
}

// STEP: Triggered when the user chooses a different currency from a dropdown or menu.
class ChangeCurrencyEvent extends CurrencyUpdateEvent {
  const ChangeCurrencyEvent(this.currency);
  final String currency;

  @override
  List<Object?> get props => [currency];
}

// STEP: Triggered when the app needs to fetch the latest conversion rates for a given base currency.
class FetchConversionRateEvent extends CurrencyUpdateEvent {
  const FetchConversionRateEvent(this.baseCurrency);
  final String baseCurrency;

  @override
  List<Object?> get props => [baseCurrency];
}
