// ignore_for_file: sort_constructors_first

import 'package:expense_tracking/domain/entities/expense.dart';

import 'package:expense_tracking/domain/repositories/expense_repository.dart';

/// Use case: Get all expenses as a stream.
class GetAllExpensesUseCase {
  final IExpenseRepository repository;

  GetAllExpensesUseCase(this.repository);

  Stream<List<Expense?>> execute() {
    return repository.getAllExpenses();
  }
}
