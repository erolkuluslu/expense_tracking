part of 'expense_form_bloc.dart';

/// The form can be in various states:
/// initial, loading (while saving), success (saved successfully), failure (validation or save error)
enum ExpenseFormStatus { initial, loading, success, failure }

class ExpenseFormState extends Equatable {
  const ExpenseFormState({
    required this.date,
    this.initialExpense,
    this.title,
    this.amount,
    this.category = Category.other,
    this.status = ExpenseFormStatus.initial,
    this.currency = 'USD',
    this.errorMessage,
  });

  final Expense? initialExpense;
  final String? title;
  final double? amount;
  final DateTime date;
  final Category category;
  final ExpenseFormStatus status;
  final String currency;
  final String? errorMessage;

  // Allows us to create new states from old ones, changing only what’s needed.
  ExpenseFormState copyWith({
    Expense? initialExpense,
    String? title,
    double? amount,
    DateTime? date,
    Category? category,
    ExpenseFormStatus? status,
    String? currency,
    String? errorMessage,
  }) {
    return ExpenseFormState(
      initialExpense: initialExpense ?? this.initialExpense,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      status: status ?? this.status,
      currency: currency ?? this.currency,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // A quick helper to check if the form is currently valid.
  bool get isFormValid {
    final hasTitle = title != null && title!.trim().isNotEmpty;
    final hasValidAmount = amount != null && amount! > 0;
    return hasTitle && hasValidAmount;
  }

  @override
  List<Object?> get props => [
        initialExpense,
        title,
        amount,
        date,
        category,
        status,
        currency,
        errorMessage
      ];
}
