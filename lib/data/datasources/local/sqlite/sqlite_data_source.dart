import 'package:expense_tracking/data/models/expense.dart';
import 'package:expense_tracking/data/datasources/local/local_storage_source.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteDataSource implements LocalStorageSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expenses.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses (
        id TEXT PRIMARY KEY,
        amount REAL,
        description TEXT,
        date TEXT,
        category TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE preferences (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }

  @override
  Future<void> saveExpense(Expense expense) async {
    final db = await database;
    await db.insert(
      'expenses',
      expense.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteExpense(String id) async {
    final db = await database;
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Stream<List<Expense>> getExpenses() async* {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('expenses');
    yield maps.map((map) => Expense.fromJson(map)).toList();
  }

  @override
  Future<void> saveCurrencyPreference(String currency) async {
    final db = await database;
    await db.insert(
      'preferences',
      {'key': 'currency', 'value': currency},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  String getCurrencyPreference() {
    // Default currency if not set
    return 'USD';
  }
}
