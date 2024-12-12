import 'package:expense_tracking/domain/entities/expense.dart';

/// Abstract repository for expenses, defines what methods are needed
/// without detailing how they're implemented.
abstract class IExpenseRepository {
  Stream<List<Expense?>> getAllExpenses();
  Future<void> deleteExpense(String id);
  Future<void> createExpense(Expense expense);
}
