import 'package:expense_tracking/data/sqlite_data_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'data/shared_pref_storage.dart';
import 'repositories/expense_repository.dart';
import 'package:flutter/material.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = SharedPrefStorage(
    preferences: await SharedPreferences.getInstance(),
  );

  /*
  final database = await openDatabase(
    'expenses.db',
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE expenses(id TEXT PRIMARY KEY, title TEXT, amount REAL, date TEXT, category TEXT)',
      );
    },
    version: 1,
  );

  final storage = SQLiteExpenseStorage(database: database);
  */

  final expenseRepository = ExpenseRepository(storage: storage);

  runApp(App(expenseRepository: expenseRepository));
}
