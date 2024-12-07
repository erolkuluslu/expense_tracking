import 'package:expense_tracking/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/expense.dart';
import '../../../../data/models/category.dart';
import '../../../blocs/currency_update/currency_update_bloc.dart';
import '../../../blocs/expense_list/expense_list_bloc.dart';

class ExpenseTileWidget extends StatelessWidget {
  const ExpenseTileWidget({super.key, required this.expense});
  final Expense expense;

  String _formatAmount(double amount, CurrencyUpdateState currencyState) {
    if (currencyState is! CurrencyUpdated) {
      return NumberFormat.currency(
        symbol: _getCurrencySymbol(expense.currency),
        decimalDigits: 2,
      ).format(amount);
    }

    double convertedAmount = amount;
    if (expense.currency != currencyState.currency) {
      if (expense.currency == currencyState.previousCurrency) {
        convertedAmount = amount * currencyState.conversionRate;
      } else {
        convertedAmount = amount * currencyState.conversionRate;
      }
    }

    return NumberFormat.currency(
      symbol: _getCurrencySymbol(currencyState.currency),
      decimalDigits: 2,
    ).format(convertedAmount);
  }

  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'TRY':
        return '₺';
      case 'GBP':
        return '£';
      default:
        return currencyCode;
    }
  }

  IconData _getCategoryIcon(Category category) {
    switch (category) {
      case Category.all:
        return Icons.list;
      case Category.entertainment:
        return Icons.movie;
      case Category.food:
        return Icons.restaurant;
      case Category.grocery:
        return Icons.shopping_cart;
      case Category.work:
        return Icons.work;
      case Category.traveling:
        return Icons.flight;
      case Category.other:
        return Icons.more_horiz;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return BlocBuilder<CurrencyUpdateBloc, CurrencyUpdateState>(
      builder: (context, currencyState) {
        final formattedAmount = _formatAmount(expense.amount, currencyState);
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
            leading: Icon(
              _getCategoryIcon(expense.category),
              color: colorScheme.surfaceTint,
            ),
            title: Text(expense.title, style: textTheme.titleMedium),
            subtitle: Text(formattedDate),
            trailing: Text(
              formattedAmount,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}
