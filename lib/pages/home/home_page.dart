import 'package:expense_tracking/blocs/auth/auth_bloc.dart';
import 'package:expense_tracking/blocs/currency_update/currency_update_bloc.dart';
import 'package:expense_tracking/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  @override
  void initState() {
    super.initState();
    // Load the saved currency preference when the HomePage is initialized
    _selectedCurrency = context.read<CurrencyUpdateBloc>().state.currency;
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state as AuthSuccess;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, ${authState.email}!'),
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
      body: const SingleChildScrollView(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.showAddExpenseSheet();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
