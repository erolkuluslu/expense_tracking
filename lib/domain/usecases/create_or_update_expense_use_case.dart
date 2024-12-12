import 'package:expense_tracking/domain/entities/expense.dart';
import 'package:expense_tracking/domain/repositories/expense_repository.dart';

/// Use case: Create or update an expense.
/// We assume the repository's createExpense can handle both or just create new expenses.
class CreateOrUpdateExpenseUseCase {
  CreateOrUpdateExpenseUseCase(this.repository);
  final IExpenseRepository repository;

  Future<void> execute(Expense expense) {
    return repository.createExpense(expense);
  }
}
