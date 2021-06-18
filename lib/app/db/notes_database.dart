import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/note.dart';

class NotesDatabase {
  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  NotesDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('notes.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final textType = 'TEXT NOT NULL';
    await db.execute('''
      CREATE TABLE $tableNotes(
        ${TableNotesFields.id} $idType,
        ${TableNotesFields.isImportant} $boolType,
        ${TableNotesFields.number} $integerType,
        ${TableNotesFields.title} $textType,
        ${TableNotesFields.description} $textType,
        ${TableNotesFields.time} $textType,
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
