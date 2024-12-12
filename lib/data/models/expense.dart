// data/models/expense_model.dart
import 'package:expense_tracking/domain/entities/category.dart';
import 'package:expense_tracking/domain/entities/expense.dart';

class ExpenseModel extends Expense {
  ExpenseModel({
    required super.id,
    required super.title,
    required super.amount,
    required super.date,
    required super.currency,
    required super.category,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      currency: json['currency'] as String,
      category: Category.values.firstWhere(
        (c) => c.toString() == json['category'] as String,
        orElse: () => Category.other,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'currency': currency,
      'category': category.toString(),
    };
  }
}
