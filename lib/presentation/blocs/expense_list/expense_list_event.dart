import 'package:equatable/equatable.dart';
import 'package:expense_tracking/domain/entities/category.dart';
import 'package:expense_tracking/domain/entities/expense.dart';

abstract class ExpenseListEvent extends Equatable {
  const ExpenseListEvent();

  @override
  List<Object?> get props => [];
}

class ExpenseListSubscriptionRequested extends ExpenseListEvent {}

class ExpenseListExpenseDeleted extends ExpenseListEvent {
  const ExpenseListExpenseDeleted({required this.expense});

  /// Updated the constructor to accept a named parameter.
  final Expense expense;

  @override
  List<Object?> get props => [expense];
}

class ExpenseListCategoryFilterChanged extends ExpenseListEvent {
  const ExpenseListCategoryFilterChanged(this.filter);
  final Category filter;

  @override
  List<Object?> get props => [filter];
}
