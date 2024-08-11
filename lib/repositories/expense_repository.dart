import 'package:expense_tracking/data/local_data_storage.dart';
import 'package:expense_tracking/models/expense.dart';

class ExpenseRepository {
  final LocalDataStorage _storage;

  const ExpenseRepository({
    required LocalDataStorage storage,
  }) : _storage = storage;

  Future<void> createExpense(Expense expense) => _storage.saveExpense(expense);

  Future<void> deleteExpense(String id) => _storage.deleteExpense(id);

  Stream<List<Expense?>> getAllExpenses() => _storage.getExpenses();
}
