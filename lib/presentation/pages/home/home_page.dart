// ignore_for_file: library_private_types_in_public_api, prefer_int_literals

import 'package:expense_tracking/core/constants/app_constants.dart';
import 'package:expense_tracking/core/constants/ui_constants.dart';
import 'package:expense_tracking/core/extensions/extensions.dart';
import 'package:expense_tracking/presentation/blocs/auth/auth_bloc.dart';
import 'package:expense_tracking/presentation/blocs/currency_update/currency_update_bloc.dart';
import 'package:expense_tracking/presentation/pages/home/widgets/expense_filter_widget.dart';
import 'package:expense_tracking/presentation/pages/home/widgets/expenses_widget.dart';
import 'package:expense_tracking/presentation/pages/home/widgets/total_expenses_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = context.watch<AuthBloc>().state as AuthSuccess;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hello, ${authState.email}', 
          style: UIConstants.appBarTitleStyle
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: BlocBuilder<CurrencyUpdateBloc, CurrencyUpdateState>(
              builder: (context, state) {
                // Use the state's currency
                final selectedCurrency = state.currency;

                return DropdownButton<String>(
                  value: selectedCurrency,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: AppConstants.dropdownElevation,
                  style: UIConstants.dropdownTextStyle,
                  underline: Container(
                    height: 2,
                    color: Colors.white,
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      // Dispatch event to update currency through BLoC
                      context
                          .read<CurrencyUpdateBloc>()
                          .add(ChangeCurrencyEvent(newValue));
                    }
                  },
                  items: AppConstants.currencies
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TotalExpensesWidget(),
                SizedBox(height: 14),
                ExpenseFilterWidget(),
                SizedBox(height: 14),
                ExpensesWidget(),
              ],
            ),
          ),
          // Align the button at the bottom center
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  context.showAddExpenseSheet();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  elevation: AppConstants.buttonElevation,
                  shadowColor: UIConstants.shadowColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  splashFactory: InkRipple.splashFactory,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 30.0,
                  ),
                ),
                child: const Text(
                  'Add Expense',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
