import 'package:intl/intl.dart';

String formatTotalExpenses(double totalExpenses, String currency) {
  String symbol;
  switch (currency) {
    case 'EUR':
      symbol = '€';
      break;
    case 'TRY':
      symbol = '₺';
      break;
    case 'USD':
    default:
      symbol = '\$';
      break;
  }

  final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
  final formattedValue = formatter.format(totalExpenses.abs());
  return totalExpenses < 0 ? "-$formattedValue" : formattedValue;
}
