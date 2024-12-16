import 'package:equatable/equatable.dart';
import 'package:expense_tracking/domain/entities/category.dart';
import 'package:expense_tracking/domain/entities/expense.dart';

/// Events for managing expense list:
/// - Subscribing to the list
/// - Deleting an expense
/// - Changing the category filter

abstract class ExpenseListEvent extends Equatable {
  const ExpenseListEvent();

  @override
  List<Object?> get props => [];
}

// Triggered when UI starts and wants to listen for expense updates.
class ExpenseListSubscriptionRequested extends ExpenseListEvent {}

// Triggered when user deletes a specific expense.
class ExpenseListExpenseDeleted extends ExpenseListEvent {
  const ExpenseListExpenseDeleted({required this.expense});
  final Expense expense;

  @override
  List<Object?> get props => [expense];
}

// Triggered when user wants to filter expenses by a certain category.
class ExpenseListCategoryFilterChanged extends ExpenseListEvent {
  const ExpenseListCategoryFilterChanged(this.filter);
  final Category filter;

  @override
  List<Object?> get props => [filter];
}
