import 'package:expense_tracking/data/idata_storage.dart';
import 'package:sqflite/sqflite.dart';
import '../models/expense.dart';

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
}
