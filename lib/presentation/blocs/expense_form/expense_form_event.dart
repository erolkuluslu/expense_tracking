part of 'expense_form_bloc.dart';

/// Base class for all expense form events
/// Uses [Equatable] for value comparison
abstract class ExpenseFormEvent extends Equatable {
  const ExpenseFormEvent();

  @override
  List<Object> get props => [];
}

/// Event emitted when the expense title is changed
class ExpenseTitleChanged extends ExpenseFormEvent {
  /// New title value
  final String title;

  const ExpenseTitleChanged(this.title);

  @override
  List<Object> get props => [title];
}

/// Event emitted when the expense amount is changed
class ExpenseAmountChanged extends ExpenseFormEvent {
  /// New amount value as string (will be parsed to double)
  final String amount;

  const ExpenseAmountChanged(this.amount);

  @override
  List<Object> get props => [amount];
}

/// Event emitted when the expense date is changed
class ExpenseDateChanged extends ExpenseFormEvent {
  /// New date value
  final DateTime date;

  const ExpenseDateChanged(this.date);

  @override
  List<Object> get props => [date];
}

/// Event emitted when the expense category is changed
class ExpenseCategoryChanged extends ExpenseFormEvent {
  /// New category value
  final Category category;

  const ExpenseCategoryChanged(this.category);

  @override
  List<Object> get props => [category];
}

/// Event emitted when the form is submitted
/// Triggers the expense creation/update process
class ExpenseSubmitted extends ExpenseFormEvent {
  const ExpenseSubmitted();
}
