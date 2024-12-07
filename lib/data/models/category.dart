import 'package:expense_tracking/data/models/expense.dart';
import 'package:flutter/material.dart';

enum Category {
  all,
  grocery,
  food,
  work,
  entertainment,
  traveling,
  other;

  String toJson() => name;
  static Category fromJson(String json) => values.byName(json);
}

extension CategoryX on Category {
  String get toName => switch (this) {
        Category.all => 'All',
        Category.entertainment => 'Entertainment',
        Category.food => 'Food',
        Category.grocery => 'Grocery',
        Category.work => 'Work',
        Category.traveling => 'Traveling',
        Category.other => 'Other',
      };

  IconData get icon => switch (this) {
        Category.all => Icons.list,
        Category.entertainment => Icons.movie,
        Category.food => Icons.restaurant,
        Category.grocery => Icons.shopping_cart,
        Category.work => Icons.work,
        Category.traveling => Icons.flight,
        Category.other => Icons.more_horiz,
      };

  bool apply(Expense? expense) => switch (this) {
        Category.all => true,
        Category.entertainment => expense?.category == Category.entertainment,
        Category.food => expense?.category == Category.food,
        Category.grocery => expense?.category == Category.grocery,
        Category.work => expense?.category == Category.work,
        Category.traveling => expense?.category == Category.traveling,
        Category.other => expense?.category == Category.other,
      };

  Iterable<Expense?> applyAll(Iterable<Expense?> expenses) {
    return expenses.where(apply);
  }
}
