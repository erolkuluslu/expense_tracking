import 'package:expense_tracking/domain/entities/category.dart';
import 'package:flutter/material.dart';

extension CategoryExtension on Category {
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
}
