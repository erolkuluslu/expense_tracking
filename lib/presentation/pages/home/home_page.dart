import 'package:expense_tracking/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/currency_update/currency_update_bloc.dart';
import 'widgets/expense_filter_widget.dart';
import 'widgets/expenses_widget.dart';
import 'widgets/total_expenses_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _selectedCurrency;
  final List<String> _currencies = ['USD', 'EUR', 'TRY'];

  // Add customizable color and effect properties
  double buttonElevation = 4.0;
  Color splashColor = Colors.white.withOpacity(0.5);
  Color shadowColor = Colors.black12;

  @override
  void initState() {
    super.initState();
    // Load the saved currency preference when the HomePage is initialized
    _selectedCurrency = context.read<CurrencyUpdateBloc>().state.currency;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = context.watch<AuthBloc>().state as AuthSuccess;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, ${authState.email}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: DropdownButton<String>(
              value: _selectedCurrency,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.white),
              underline: Container(
                height: 2,
                color: Colors.white,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCurrency = newValue!;
                  context
                      .read<CurrencyUpdateBloc>()
                      .add(ChangeCurrencyEvent(_selectedCurrency));
                });
              },
              items: _currencies.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
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
                  backgroundColor: colorScheme
                      .primary, // Using colorScheme's primary color for the button
                  elevation: buttonElevation, // Elevation effect
                  shadowColor: shadowColor, // Shadow color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  splashFactory: InkRipple.splashFactory, // Ripple effect
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
