import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const dbName = "myNotes.db";
  static const dbVersion = 1;
  static const dbTable = "User_Notes";
  static const notesId = "id";
  static const notesTitle = "title";
  static const notesBody = "body";
  static const notesDueDate = "dueDate";
  static const notesDueTime = "dueTime";

  // Constructor
  static final DatabaseHelper dbHelper = DatabaseHelper();

  // Initializing database
  static Database? _database;

  // Initializing _database
  Future<Database?> get database async {
    _database ??= await initDB();

    return _database;
  }

  initDB() async {
    //This gets location
    Directory directory = await getApplicationDocumentsDirectory();
    //This basically joins our directory and the database thus creating a complete path
    String path = join(directory.path, dbName);
    //This is a method Provided by Sqflite to open the datbase
    return await openDatabase(path, version: dbVersion, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    await db.execute(
        // "CREATE TABLE $dbTable($notesId INTEGER PRIMARY KEY AUTO INCREMENT, $notesTitle TEXT, $notesBody TEXT NOT NULL)");
        '''
CREATE TABLE $dbTable(
  $notesId INTEGER PRIMARY KEY,
  $notesTitle TEXT,
  $notesBody TEXT NOT NULL,
  $notesDueDate TEXT,
  $notesDueTime TEXT 
)
''');
  }

  // Insert Method
  insertRecord(Map<String, dynamic> row) async {
    Database? db = await dbHelper.database;
    return await db!.insert(dbTable, row);
  }

  // Read Method
  Future<List<Map<String, dynamic>>> readRecord() async {
    Database? db = await dbHelper.database;
    return await db!.query(dbTable);
  }

  // Update Method
  Future<int> updateRecord(Map<String, dynamic> row) async {
    Database? db = await dbHelper.database;
    int id = row[notesId];
    return await db!.update(dbTable, row, where: '$notesId=?', whereArgs: [id]);
  }

  //DeleteMethod
  Future<int> deleteRecord(int id) async {
    Database? db = await dbHelper.database;
    return await db!.delete(dbTable, where: '$notesId = ?', whereArgs: [id]);
  }
}
