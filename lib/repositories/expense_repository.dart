import 'package:expense_tracking/data/idata_storage.dart';

import '../models/expense.dart';

class ExpenseRepository {
  final ExpenseStorage _storage;

  const ExpenseRepository({required ExpenseStorage storage})
      : _storage = storage;

  Future<void> createExpense(Expense expense) => _storage.saveExpense(expense);

  Future<void> deleteExpense(String id) => _storage.deleteExpense(id);

  Future<void> saveCurrencyPreference(String currency) =>
      _storage.saveCurrencyPreference(currency);

  String getCurrencyPreference() => _storage.getCurrencyPreference();

  Stream<List<Expense?>> getAllExpenses() => _storage.getExpenses();
}
