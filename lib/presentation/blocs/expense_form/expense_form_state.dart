part of 'expense_form_bloc.dart';

/// Status of the expense form
/// [initial] - Form is ready for input
/// [loading] - Form is processing
/// [success] - Form submission succeeded
/// [failure] - Form submission failed
enum ExpenseFormStatus { initial, loading, success, failure }

/// Extension on [ExpenseFormStatus] to provide helper methods
extension ExpenseFormStatusX on ExpenseFormStatus {
  /// Returns true if the form is in a loading state
  bool get isLoading => [
        ExpenseFormStatus.loading,
        ExpenseFormStatus.success,
      ].contains(this);
}

/// State class for the expense form
/// Contains all form fields and the current form status
class ExpenseFormState extends Equatable {
  /// Title of the expense
  final String? title;
  /// Amount of the expense
  final double? amount;
  /// Date when the expense occurred
  final DateTime date;
  /// Category of the expense
  final Category category;
  /// Currency of the expense
  final String currency; 
  /// Current status of the form
  final ExpenseFormStatus status;
  /// Original expense when editing an existing expense
  final Expense? initialExpense;

  /// Creates a new [ExpenseFormState]
  /// All fields except [date] are optional
  const ExpenseFormState({
    this.title,
    this.amount,
    required this.date,
    this.category = Category.other,
    this.currency = 'USD', // Default currency
    this.status = ExpenseFormStatus.initial,
    this.initialExpense,
  });

  /// Creates a copy of the current state with optional field updates
  ExpenseFormState copyWith({
    String? title,
    double? amount,
    DateTime? date,
    Category? category,
    String? currency, 
    ExpenseFormStatus? status,
    Expense? initialExpense,
  }) {
    return ExpenseFormState(
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      currency: currency ?? this.currency, 
      status: status ?? this.status,
      initialExpense: initialExpense ?? this.initialExpense,
    );
  }

  @override
  /// List of properties to check for equality
  List<Object?> get props => [
        title,
        amount,
        date,
        category,
        currency, 
        status,
        initialExpense,
      ];

  /// Returns true if the form is valid (title and amount are not null)
  bool get isFormValid => title != null && amount != null;
}
