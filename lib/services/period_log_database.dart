import 'package:menstrual_tracking_app/model/period_log.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PeriodLogDatabase {
  static final PeriodLogDatabase instance = PeriodLogDatabase._init();
  static Database? _database;

  PeriodLogDatabase._init();

  // Initialize the data base
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('period_log.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE period_logs (
        id TEXT PRIMARY KEY,
        logDate TEXT NOT NULL,
        startDate TEXT NOT NULL,
        endDate TEXT NOT NULL,
        cycleLength INTEGER NOT NULL
      )
    ''');
  }

  Future<void> insertPeriodLog(PeriodLog log) async {
    final db = await instance.database;

    await db.insert(
      'period_logs',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PeriodLog>> getAllPeriodLogs() async {
    final db = await instance.database;

    final result = await db.query('period_logs', orderBy: 'startDate DESC');
    return result.map((map) => PeriodLog.fromMap(map)).toList();
  }

  Future<PeriodLog?> getPeriodLogById(String id) async {
    final db = await instance.database;

    final result = await db.query(
      'period_logs',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return PeriodLog.fromMap(result.first);
    }
    return null;
  }

  Future<int> updatePeriodLog(PeriodLog log) async {
    final db = await instance.database;
    return db.update(
      'period_logs',
      log.toMap(),
      where: 'id = ?',
      whereArgs: [log.id],
    );
  }

  Future<int> deletePeriodLog(String id) async {
    final db = await instance.database;

    return db.delete('period_logs', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllPeriodLogs() async {
    final db = await instance.database;
    return db.delete('period_logs');
  }
}
