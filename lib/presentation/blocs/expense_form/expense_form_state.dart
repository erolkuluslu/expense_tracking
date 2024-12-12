// presentation/blocs/expense_form/expense_form_state.dart

part of 'expense_form_bloc.dart';

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
  });
  final Expense? initialExpense;
  final String? title;
  final double? amount;
  final DateTime date;
  final Category category;
  final ExpenseFormStatus status;
  final String currency;

  ExpenseFormState copyWith({
    Expense? initialExpense,
    String? title,
    double? amount,
    DateTime? date,
    Category? category,
    ExpenseFormStatus? status,
    String? currency,
  }) {
    return ExpenseFormState(
      initialExpense: initialExpense ?? this.initialExpense,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      status: status ?? this.status,
      currency: currency ?? this.currency,
    );
  }

  /// Define form validation logic:
  /// Form is valid if title is non-empty and amount > 0.
  bool get isFormValid {
    final hasTitle = title != null && title!.trim().isNotEmpty;
    final hasValidAmount = amount != null && amount! > 0;
    // date and category are always set in this code, so we don't check them strictly.
    return hasTitle && hasValidAmount;
  }

  @override
  List<Object?> get props =>
      [initialExpense, title, amount, date, category, status, currency];
}
