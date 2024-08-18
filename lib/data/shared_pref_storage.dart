import 'dart:convert';
import 'package:expense_tracking/data/idata_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class SharedPrefStorage implements ExpenseStorage {
  final SharedPreferences _preferences;
  static const expensesCollectionKey = 'expenses_collection_key';
  //A constant key used to store and retrieve the expenses list from SharedPreferences.
  final _controller = BehaviorSubject<List<Expense?>>.seeded(const []);
  //BehaviorSubject from rxdart that stores the current list of expenses and allows other parts of the app to listen for changes.

  SharedPrefStorage({
    required SharedPreferences preferences,
  }) : _preferences = preferences {
    _initialize();
  }

  void _initialize() {
    final expensesJson = _preferences.getString(expensesCollectionKey);

    if (expensesJson != null) {
      //If the string exists, it's decoded into a list of Expense objects.
      final expenseList = List<dynamic>.from(jsonDecode(expensesJson) as List);
      final expenses =
          expenseList.map((expense) => Expense.fromJson(expense)).toList();
      _controller.add(expenses);
      //The decoded list is then added to _controller, making it available to any listeners.
    } else {
      _controller.add(const []);
      //If there's no data, an empty list is added to _controller.
    }
  }

  Stream<List<Expense?>> getExpenses() => _controller.asBroadcastStream();
//Converts the BehaviorSubject into a broadcast stream so multiple listeners can subscribe to updates.

  @override
  Future<void> saveExpense(Expense expense) async {
    final expenses = [..._controller.value];
    final expenseIndex = expenses.indexWhere(
      (currentExpense) => currentExpense?.id == expense.id,
    );

    if (expenseIndex >= 0) {
      expenses[expenseIndex] = expense;
    } else {
      expenses.add(expense);
    }

    _controller.add(expenses);
    await _preferences.setString(expensesCollectionKey, jsonEncode(expenses));
    return;
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
      _preferences.setString(expensesCollectionKey, jsonEncode(expenses));
      return;
    }
  }
}
