import 'package:equatable/equatable.dart';

import 'category.dart';

class Expense extends Equatable {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;
  final String currency; // Add a currency field

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.currency = 'USD', // Default to USD if not specified
  });

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        date,
        category,
        currency, // Include currency in equality checks
      ];

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      title: json['title'],
      amount: double.tryParse(json['amount']) ?? 0.0,
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      category: Category.fromJson(json['category']),
      currency: json['currency'] ?? 'USD', // Handle currency field in JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount.toString(),
      'date': date.millisecondsSinceEpoch,
      'category': category.toJson(),
      'currency': currency, // Include currency in serialization
    };
  }

  Expense copyWith({
    String? title,
    double? amount,
    DateTime? date,
    Category? category,
    String? currency, // Support currency changes
  }) {
    return Expense(
      id: id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      currency: currency ?? this.currency, // Apply currency changes
    );
  }

  @override
  bool get stringify => true;
}
