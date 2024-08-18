import 'package:expense_tracking/models/expense.dart';

abstract class ExpenseStorage {
  Future<void> saveExpense(Expense expense);
  Future<void> deleteExpense(String id);
  Stream<List<Expense?>> getExpenses();
}
