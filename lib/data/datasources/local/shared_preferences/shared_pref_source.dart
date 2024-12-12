import 'dart:convert';
import 'package:expense_tracking/data/datasources/local/local_storage_source.dart';
import 'package:expense_tracking/data/models/expense.dart';
import 'package:expense_tracking/domain/entities/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSource implements LocalStorageSource {
  SharedPreferencesSource(this._prefs);
  static const String _expensesKey = 'expenses';
  static const String _currencyKey = 'currency';
  final SharedPreferences _prefs;

  @override
  Future<void> saveExpense(Expense expense) async {
    final expenses = await _getExpensesList();
    // Convert domain Expense to ExpenseModel before saving
    final expenseModel = ExpenseModel(
      id: expense.id,
      title: expense.title,
      amount: expense.amount,
      date: expense.date,
      currency: expense.currency,
      category: expense.category,
    );
    expenses.add(expenseModel);
    await _saveExpensesList(expenses);
  }

  @override
  Future<void> deleteExpense(String id) async {
    final expenses = await _getExpensesList();
    expenses.removeWhere((expense) => expense.id == id);
    await _saveExpensesList(expenses);
  }

  @override
  Stream<List<Expense>> getExpenses() async* {
    final expenses = await _getExpensesList();
    yield expenses;
  }

  Future<List<ExpenseModel>> _getExpensesList() async {
    final expensesJson = _prefs.getStringList(_expensesKey) ?? [];
    return expensesJson
        .map(
          (jsonString) => ExpenseModel.fromJson(
            jsonDecode(jsonString) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  Future<void> _saveExpensesList(List<ExpenseModel> expenses) async {
    final expensesJson =
        expenses.map((expense) => jsonEncode(expense.toJson())).toList();
    await _prefs.setStringList(_expensesKey, expensesJson);
  }

  @override
  Future<void> saveCurrencyPreference(String currency) async {
    await _prefs.setString(_currencyKey, currency);
  }

  @override
  String getCurrencyPreference() {
    return _prefs.getString(_currencyKey) ?? 'USD';
  }
}
