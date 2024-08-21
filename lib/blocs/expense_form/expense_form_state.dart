part of 'expense_form_bloc.dart';

enum ExpenseFormStatus { initial, loading, success, failure }

extension ExpenseFormStatusX on ExpenseFormStatus {
  bool get isLoading => [
        ExpenseFormStatus.loading,
        ExpenseFormStatus.success,
      ].contains(this);
}

class ExpenseFormState extends Equatable {
  final String? title;
  final double? amount;
  final DateTime date;
  final Category category;
  final String currency; // New currency field
  final ExpenseFormStatus status;
  final Expense? initialExpense;

  const ExpenseFormState({
    this.title,
    this.amount,
    required this.date,
    this.category = Category.other,
    this.currency = 'USD', // Default currency
    this.status = ExpenseFormStatus.initial,
    this.initialExpense,
  });

  ExpenseFormState copyWith({
    String? title,
    double? amount,
    DateTime? date,
    Category? category,
    String? currency, // Support copying with a new currency
    ExpenseFormStatus? status,
    Expense? initialExpense,
  }) {
    return ExpenseFormState(
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      currency: currency ?? this.currency, // Apply new currency
      status: status ?? this.status,
      initialExpense: initialExpense ?? this.initialExpense,
    );
  }

  @override
  List<Object?> get props => [
        title,
        amount,
        date,
        category,
        currency, // Include currency in equality checks
        status,
        initialExpense,
      ];

  bool get isFormValid => title != null && amount != null;
}
