import 'package:expense_tracking/data/datasources/local/local_storage_source.dart';

import '../models/expense.dart';

/// Repository responsible for managing expense-related operations
class ExpenseRepository {
  final LocalStorageSource _storage;

  const ExpenseRepository({required LocalStorageSource storage})
      : _storage = storage;

  /// Creates a new expense
  Future<void> createExpense(Expense expense) => _storage.saveExpense(expense);

  /// Deletes an expense by its ID
  Future<void> deleteExpense(String id) => _storage.deleteExpense(id);

  /// Gets a stream of all expenses
  Stream<List<Expense?>> getAllExpenses() => _storage.getExpenses();
}
