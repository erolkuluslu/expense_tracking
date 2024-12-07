import 'dart:convert';
import 'package:expense_tracking/data/idata_storage.dart';
import 'package:expense_tracking/data/models/expense.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefStorage implements ExpenseStorage {
  final SharedPreferences _preferences;
  static const expensesCollectionKey = 'expenses_collection_key';
  static const currencyPreferenceKey = 'currency_preference_key';
  final _controller = BehaviorSubject<List<Expense?>>.seeded(const []);

  SharedPrefStorage({required SharedPreferences preferences})
      : _preferences = preferences {
    _initialize();
  }

  void _initialize() {
    final expensesJson = _preferences.getString(expensesCollectionKey);

    if (expensesJson != null) {
      final expenseList = (jsonDecode(expensesJson) as List)
          .whereType<Map<String, dynamic>>()
          .toList();
      final expenses =
          expenseList.map((expense) => Expense.fromJson(expense)).toList();
      _controller.add(expenses);
    } else {
      _controller.add(const []);
    }
  }

  @override
  String getCurrencyPreference() {
    return _preferences.getString(currencyPreferenceKey) ?? 'USD';
  }

  @override
  Future<void> saveCurrencyPreference(String currency) async {
    await _preferences.setString(currencyPreferenceKey, currency);
  }

  @override
  Stream<List<Expense?>> getExpenses() => _controller.stream;

  @override
  Future<void> saveExpense(Expense expense) async {
    final expenses = [..._controller.value];
    final expenseIndex = expenses
        .indexWhere((currentExpense) => currentExpense?.id == expense.id);

    if (expenseIndex >= 0) {
      expenses[expenseIndex] = expense;
    } else {
      expenses.add(expense);
    }

    _controller.add(expenses);
    final jsonList = expenses.map((e) => e?.toJson()).toList();
    await _preferences.setString(expensesCollectionKey, jsonEncode(jsonList));
  }

  @override
  Future<void> deleteExpense(String id) async {
    final expenses = [..._controller.value];
    final expenseIndex =
        expenses.indexWhere((currentExpense) => currentExpense?.id == id);

    if (expenseIndex == -1) {
      throw Exception('No expense found');
    } else {
      expenses.removeAt(expenseIndex);
      _controller.add(expenses);
      final jsonList = expenses.map((e) => e?.toJson()).toList();
      await _preferences.setString(expensesCollectionKey, jsonEncode(jsonList));
    }
  }
}
