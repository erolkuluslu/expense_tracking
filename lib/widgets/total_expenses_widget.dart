import 'package:expense_tracking/blocs/expense_list/expense_list_bloc.dart';
import '/utils/format_total_expenses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/currency_update/currency_update_bloc.dart';

class TotalExpensesWidget extends StatelessWidget {
  const TotalExpensesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final expenseState = context.watch<ExpenseListBloc>().state;
    final currencyState = context.watch<CurrencyUpdateBloc>().state;

    // Recalculate total expenses based on the selected currency's conversion rate
    final convertedExpenses =
        expenseState.totalExpenses * currencyState.conversionRate;

    // Format the total expenses with the correct currency symbol
    final totalExpenses =
        formatTotalExpenses(convertedExpenses, currencyState.currency);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Expenses',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
          Text(totalExpenses, style: textTheme.displaySmall),
        ],
      ),
    );
  }
}
