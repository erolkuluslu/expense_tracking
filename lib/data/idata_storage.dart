import 'package:expense_tracking/data/models/expense.dart';

abstract class ExpenseStorage {
  Future<void> saveExpense(Expense expense);
  Future<void> deleteExpense(String id);
  Future<void> saveCurrencyPreference(String currency);
  String getCurrencyPreference();

  Stream<List<Expense?>> getExpenses();
}
