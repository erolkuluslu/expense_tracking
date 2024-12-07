import 'package:sqflite/sqflite.dart';
/*

class SQLiteExpenseStorage implements ExpenseStorage {
  final Database _database;

  SQLiteExpenseStorage({required Database database}) : _database = database;

  @override
  Future<void> saveExpense(Expense expense) async {
    await _database.insert(
      'expenses',
      expense.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _database.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Stream<List<Expense?>> getExpenses() async* {
    final List<Map<String, dynamic>> maps = await _database.query('expenses');
    yield List.generate(maps.length, (i) {
      return Expense.fromJson(maps[i]);
    });
  }

  @override
  Future<void> saveCurrencyPreference(String currency) {
    // TODO: implement saveCurrencyPreference
    throw UnimplementedError();
  }

  @override
  String getCurrencyPreference() {
    // TODO: implement getCurrencyPreference
    throw UnimplementedError();
  }
}

class Database {
}


*/