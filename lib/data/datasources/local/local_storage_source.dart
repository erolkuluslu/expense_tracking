import 'package:expense_tracking/domain/entities/expense.dart';

abstract class LocalStorageSource {
  Future<void> saveExpense(Expense expense);
  Future<void> deleteExpense(String id);
  Future<void> saveCurrencyPreference(String currency);
  String getCurrencyPreference();
  Stream<List<Expense>> getExpenses();
}
