import 'package:expense_tracking/data/idata_storage.dart';
import 'package:expense_tracking/data/models/expense.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:rxdart/rxdart.dart';

class SQLiteExpenseStorage implements ExpenseStorage {
  final Database _database;
  final _expensesController = BehaviorSubject<List<Expense?>>();
  static const String _tableName = 'expenses';
  static const String _currencyPrefsTable = 'currency_preferences';

  SQLiteExpenseStorage._({required Database database}) : _database = database {
    _initialize();
  }

  static Future<SQLiteExpenseStorage> create() async {
    final dbPath = await getDatabasesPath();
    final database = await openDatabase(
      path.join(dbPath, 'expenses.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            amount TEXT NOT NULL,
            date INTEGER NOT NULL,
            category TEXT NOT NULL,
            currency TEXT NOT NULL
          )
        ''');
        
        await db.execute('''
          CREATE TABLE $_currencyPrefsTable (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
          )
        ''');
      },
    );

    return SQLiteExpenseStorage._(database: database);
  }

  Future<void> _initialize() async {
    final expenses = await _loadExpenses();
    _expensesController.add(expenses);
  }

  Future<List<Expense>> _loadExpenses() async {
    final maps = await _database.query(_tableName);
    return maps.map((map) => Expense.fromJson(map)).toList();
  }

  @override
  Future<void> saveExpense(Expense expense) async {
    await _database.insert(
      _tableName,
      expense.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    final expenses = await _loadExpenses();
    _expensesController.add(expenses);
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _database.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    final expenses = await _loadExpenses();
    _expensesController.add(expenses);
  }

  @override
  Stream<List<Expense?>> getExpenses() {
    return _expensesController.asBroadcastStream();
  }

  @override
  Future<void> saveCurrencyPreference(String currency) async {
    await _database.insert(
      _currencyPrefsTable,
      {'key': 'currency', 'value': currency},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  String getCurrencyPreference() {
    return 'USD'; // Default value, will be updated in next implementation
  }

  Future<void> close() async {
    await _database.close();
    await _expensesController.close();
  }
}