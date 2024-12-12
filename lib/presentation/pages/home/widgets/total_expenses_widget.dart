import 'package:expense_tracking/core/utils/format_total_expenses.dart';
import 'package:expense_tracking/domain/entities/expense.dart';
import 'package:expense_tracking/presentation/blocs/currency_update/currency_update_bloc.dart';
import 'package:expense_tracking/presentation/blocs/expense_list/expense_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalExpensesWidget extends StatelessWidget {
  const TotalExpensesWidget({super.key});

  double _calculateTotalExpenses(
    List<Expense?> expenses,
    CurrencyUpdateState currencyState,
  ) {
    var total = 0.0;
    for (final expense in expenses) {
      if (expense == null) continue;

      if (currencyState is CurrencyUpdated) {
        if (expense.currency == currencyState.currency) {
          total += expense.amount;
        } else if (expense.currency == currencyState.previousCurrency) {
          total += expense.amount * currencyState.conversionRate;
        } else {
          // For other currencies, use the base conversion rate
          total += expense.amount * currencyState.conversionRate;
        }
      } else {
        total += expense
            .amount; // Fallback to original amount if no conversion available
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return BlocBuilder<ExpenseListBloc, ExpenseListState>(
      builder: (context, expenseState) {
        return BlocBuilder<CurrencyUpdateBloc, CurrencyUpdateState>(
          builder: (context, currencyState) {
            final totalExpenses = _calculateTotalExpenses(
              expenseState.expenses,
              currencyState,
            );

            final formattedTotal = formatTotalExpenses(
              totalExpenses,
              currencyState.currency,
            );

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
                  Text(formattedTotal, style: textTheme.displaySmall),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
