part of 'expense_form_bloc.dart';

/// Events represent user actions on the expense form:
/// - Changing title, amount, date, category
/// - Submitting the form

abstract class ExpenseFormEvent extends Equatable {
  const ExpenseFormEvent();

  @override
  List<Object?> get props => [];
}

// Fired when user updates the expense title in UI.
class ExpenseTitleChanged extends ExpenseFormEvent {
  const ExpenseTitleChanged(this.title);
  final String title;

  @override
  List<Object?> get props => [title];
}

// Fired when user updates the expense amount input.
class ExpenseAmountChanged extends ExpenseFormEvent {
  const ExpenseAmountChanged(this.amount);
  final String amount;

  @override
  List<Object?> get props => [amount];
}

// Fired when user selects a new date for the expense.
class ExpenseDateChanged extends ExpenseFormEvent {
  const ExpenseDateChanged(this.date);
  final DateTime date;

  @override
  List<Object?> get props => [date];
}

// Fired when user selects a new category (like "food", "entertainment").
class ExpenseCategoryChanged extends ExpenseFormEvent {
  const ExpenseCategoryChanged(this.category);
  final Category category;

  @override
  List<Object?> get props => [category];
}

// Fired when user presses the submit button to save the expense.
class ExpenseSubmitted extends ExpenseFormEvent {}
