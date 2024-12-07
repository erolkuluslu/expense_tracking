part of 'currency_update_bloc.dart';

/// Base class for all currency update events
/// Uses [Equatable] for value comparison
sealed class CurrencyUpdateEvent extends Equatable {
  const CurrencyUpdateEvent();

  @override
  List<Object> get props => [];
}

/// Event emitted when the user changes the currency
/// Triggers fetching new conversion rates
final class ChangeCurrencyEvent extends CurrencyUpdateEvent {
  /// The new currency code (e.g., 'USD', 'EUR')
  final String currency;

  const ChangeCurrencyEvent(this.currency);

  @override
  List<Object> get props => [currency];
}

/// Event for fetching conversion rates from the API
/// Used for initial load and manual refresh
final class FetchConversionRateEvent extends CurrencyUpdateEvent {
  /// The base currency to fetch rates for
  final String baseCurrency;

  const FetchConversionRateEvent(this.baseCurrency);

  @override
  List<Object> get props => [baseCurrency];
}
