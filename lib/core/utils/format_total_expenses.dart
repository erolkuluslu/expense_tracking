import 'package:intl/intl.dart';

String formatTotalExpenses(double totalExpenses, String currency) {
  String symbol;
  switch (currency) {
    case 'EUR':
      symbol = '€';
    case 'TRY':
      symbol = '₺';
    case 'USD':
    default:
      symbol = r'$';
      break;
  }

  final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
  final formattedValue = formatter.format(totalExpenses.abs());
  return totalExpenses < 0 ? '-$formattedValue' : formattedValue;
}
