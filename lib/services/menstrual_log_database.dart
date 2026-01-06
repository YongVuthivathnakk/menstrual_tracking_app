import 'package:menstrual_tracking_app/model/mood_log.dart';
import 'package:menstrual_tracking_app/model/note_log.dart';
import 'package:menstrual_tracking_app/model/period_log.dart';
import 'package:menstrual_tracking_app/model/symptom_log.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MenstrualLogDatabase {
  static final MenstrualLogDatabase instance = MenstrualLogDatabase._init();
  static Database? _database;

  MenstrualLogDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('menstrual.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return openDatabase(path, version: 2, onCreate: _createDB);
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

    await db.execute('''
      CREATE TABLE symptom_logs (
        id TEXT PRIMARY KEY,
        logDate TEXT NOT NULL,
        symptoms TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE mood_logs (
        id TEXT PRIMARY KEY,
        logDate TEXT NOT NULL,
        moods TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE note_logs (
        id TEXT PRIMARY KEY,
        logDate TEXT NOT NULL,
        heading TEXT NOT NULL,
        note TEXT NOT NULL
      )
    ''');
  }

  // ================= PERIOD =================

  Future<void> insertPeriodLog(PeriodLog log) async {
    final db = await database;
    await db.insert(
      'period_logs',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PeriodLog>> getAllPeriodLogs() async {
    final db = await database;
    final result = await db.query('period_logs', orderBy: 'startDate DESC');
    return result.map(PeriodLog.fromMap).toList();
  }

  Future<int> deleteAllPeriodLogs() async {
    final db = await database;
    return db.delete('period_logs');
  }

  // ================= SYMPTOM =================

  Future<void> insertSymptomLog(SymptomLog log) async {
    final db = await database;
    await db.insert(
      'symptom_logs',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SymptomLog>> getSymptomLogs() async {
    final db = await database;
    final result = await db.query('symptom_logs', orderBy: 'logDate DESC');
    return result.map(SymptomLog.fromMap).toList();
  }

  // ================= MOOD =================

  Future<void> insertMoodLog(MoodLog log) async {
    final db = await database;
    await db.insert(
      'mood_logs',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MoodLog>> getMoodLogs() async {
    final db = await database;
    final result = await db.query('mood_logs', orderBy: 'logDate DESC');
    return result.map(MoodLog.fromMap).toList();
  }

  // ================= NOTE =================

  Future<void> insertNoteLog(NoteLog log) async {
    final db = await database;
    await db.insert(
      'note_logs',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<NoteLog>> getNoteLogs() async {
    final db = await database;
    final result = await db.query('note_logs', orderBy: 'logDate DESC');
    return result.map(NoteLog.fromMap).toList();
  }
}
