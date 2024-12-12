import 'package:expense_tracking/domain/entities/category.dart';

/// Domain entity representing an Expense.
class Expense {
  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.currency,
    required this.category,
  });
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String currency;
  final Category category;

  Expense copyWith({
    String? title,
    double? amount,
    DateTime? date,
    String? currency,
    Category? category,
  }) {
    return Expense(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      currency: currency ?? this.currency,
      category: category ?? this.category,
    );
  }
}
