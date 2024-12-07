import 'package:equatable/equatable.dart';
import 'category.dart';

class Expense extends Equatable {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
  final String currency;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.currency = 'USD',
  }) : assert(amount >= 0, 'Amount must be non-negative');

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        date,
        category,
        currency,
      ];

  factory Expense.fromJson(Map<String, dynamic> json) {
    try {
      final amount = json['amount'];
      double parsedAmount;
      if (amount is String) {
        parsedAmount = double.tryParse(amount) ?? 0.0;
      } else if (amount is num) {
        parsedAmount = amount.toDouble();
      } else {
        parsedAmount = 0.0;
      }

      final date = json['date'];
      DateTime parsedDate;
      if (date is int) {
        parsedDate = DateTime.fromMillisecondsSinceEpoch(date);
      } else if (date is String) {
        parsedDate = DateTime.tryParse(date) ?? DateTime.now();
      } else {
        parsedDate = DateTime.now();
      }

      final category = json['category'];
      Category parsedCategory;
      if (category is String) {
        parsedCategory = Category.fromJson(category);
      } else if (category is Map<String, dynamic> && category['name'] is String) {
        parsedCategory = Category.fromJson(category['name'] as String);
      } else {
        parsedCategory = Category.other;
      }

      return Expense(
        id: json['id']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        amount: parsedAmount,
        date: parsedDate,
        category: parsedCategory,
        currency: json['currency']?.toString()?.toUpperCase() ?? 'USD',
      );
    } catch (e) {
      return Expense(
        id: '',
        title: 'Invalid Expense',
        amount: 0.0,
        date: DateTime.now(),
        category: Category.other,
        currency: 'USD',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount.toString(),
      'date': date.millisecondsSinceEpoch,
      'category': category.toJson(),
      'currency': currency.toUpperCase(),
    };
  }

  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    Category? category,
    String? currency,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      currency: currency?.toUpperCase() ?? this.currency,
    );
  }

  @override
  bool get stringify => true;
}
