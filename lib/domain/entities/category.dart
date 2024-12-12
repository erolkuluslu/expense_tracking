// domain/entities/category.dart
// Ensure this file is in the correct domain directory and is properly imported where needed.

import 'package:flutter/material.dart';

/// Domain model enumerating different categories of expenses.
enum Category {
  all,
  entertainment,
  food,
  grocery,
  work,
  traveling,
  other,
}

/// Extension on Category to provide a user-friendly name and associated icons.
extension CategoryExtension on Category {
  /// Returns a readable name for each category.
  String get toName {
    switch (this) {
      case Category.all:
        return 'All';
      case Category.entertainment:
        return 'Entertainment';
      case Category.food:
        return 'Food';
      case Category.grocery:
        return 'Grocery';
      case Category.work:
        return 'Work';
      case Category.traveling:
        return 'Traveling';
      case Category.other:
      default:
        return 'Other';
    }
  }

  /// Returns an icon representing each category.
  IconData get icon {
    switch (this) {
      case Category.all:
        return Icons.list;
      case Category.entertainment:
        return Icons.movie;
      case Category.food:
        return Icons.restaurant;
      case Category.grocery:
        return Icons.shopping_cart;
      case Category.work:
        return Icons.work;
      case Category.traveling:
        return Icons.flight;
      case Category.other:
      default:
        return Icons.more_horiz;
    }
  }
}
