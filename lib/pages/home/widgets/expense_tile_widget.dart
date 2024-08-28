import 'package:expense_tracking/blocs/currency_update/currency_update_bloc.dart';
import 'package:expense_tracking/blocs/expense_list/expense_list_bloc.dart';
import 'package:expense_tracking/extensions/extensions.dart';
import 'package:expense_tracking/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ExpenseTileWidget extends StatelessWidget {
  const ExpenseTileWidget({super.key, required this.expense});
  final Expense expense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final currencyState = context.watch<CurrencyUpdateBloc>().state;

    // Convert the expense amount based on the current currency's conversion rate
    final convertedAmount = expense.amount * currencyState.conversionRate;

    // Format the price with the correct currency symbol
    final currencyFormatter = NumberFormat.currency(
      symbol: _getCurrencySymbol(currencyState.currency),
      decimalDigits: 0,
    );
    final price = currencyFormatter.format(convertedAmount);

    final formattedDate = DateFormat('dd/MM/yyyy').format(expense.date);

    return Dismissible(
      key: ValueKey(expense.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(16),
        color: colorScheme.error,
        child: Icon(Icons.delete, color: colorScheme.onError),
      ),
      onDismissed: (direction) {
        context
            .read<ExpenseListBloc>()
            .add(ExpenseListExpenseDeleted(expense: expense));
      },
      child: ListTile(
        onTap: () => context.showAddExpenseSheet(expense: expense),
        leading: Icon(Icons.car_repair, color: colorScheme.surfaceTint),
        title: Text(expense.title, style: textTheme.titleMedium),
        subtitle: Text(
          formattedDate,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onBackground.withOpacity(0.5),
          ),
        ),
        trailing: Text('-$price', style: textTheme.titleLarge),
      ),
    );
  }

  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'EUR':
        return '€';
      case 'TRY':
        return '₺';
      case 'USD':
      default:
        return '\$';
    }
  }
}
