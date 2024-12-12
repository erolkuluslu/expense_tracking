import 'package:expense_tracking/domain/repositories/expense_repository.dart';

/// Use case: Delete an expense by ID.
class DeleteExpenseUseCase {
  DeleteExpenseUseCase(this.repository);
  final IExpenseRepository repository;

  Future<void> execute(String id) {
    return repository.deleteExpense(id);
  }
}
