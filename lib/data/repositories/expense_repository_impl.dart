import 'package:expense_tracking/data/datasources/local/local_storage_source.dart';
import 'package:expense_tracking/domain/entities/expense.dart';
import 'package:expense_tracking/domain/repositories/expense_repository.dart';

/// Concrete implementation of IExpenseRepository using local storage.
class ExpenseRepositoryImpl implements IExpenseRepository {
  ExpenseRepositoryImpl(this._storage);
  final LocalStorageSource _storage;

  @override
  Future<void> createExpense(Expense expense) {
    // Saves the expense to local storage
    return _storage.saveExpense(expense);
  }

  @override
  Future<void> deleteExpense(String id) {
    // Deletes the expense from local storage by ID
    return _storage.deleteExpense(id);
  }

  @override
  Stream<List<Expense?>> getAllExpenses() {
    // Returns a stream of expenses from local storage
    return _storage.getExpenses();
  }
}
