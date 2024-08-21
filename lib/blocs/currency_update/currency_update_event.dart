part of 'currency_update_bloc.dart';

sealed class CurrencyUpdateEvent extends Equatable {
  const CurrencyUpdateEvent();

  @override
  List<Object> get props => [];
}

final class ChangeCurrencyEvent extends CurrencyUpdateEvent {
  final String currency;

  const ChangeCurrencyEvent(this.currency);

  @override
  List<Object> get props => [currency];
}