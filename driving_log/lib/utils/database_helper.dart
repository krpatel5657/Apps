import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:driving_log/models/note.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTime = 'time';
  String colDate = 'date';
  String colRoad = 'road';
  String colWeather = 'weather';
  String colDayOrNight = 'dayOrNight';
  String colNotes = 'notes';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future <Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }

    return _database;
  }



  Future <Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    var notesDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTime TEXT, $colDate TEXT, $colDayOrNight TEXT, $colRoad TEXT, $colWeather TEXT, $colNotes TEXT');

  }
  Future <List<Map<dynamic, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

    //var result = await db.rawQuery('SELECT * FROM $noteTable order by $colId ASC');
    var result = await db.query(noteTable, orderBy:'$colId DESC');
    return result;

  }
  Future <int> insertNote (Note n) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, n.toMap());
    return result;
  }

  Future <int> updateNote (Note n) async {
    var db = await this.database;
    var result = await db.update(noteTable, n.toMap(), where: '$colId = ?', whereArgs: [n.id]);
    return result;
  }
  Future <int> deleteNote (int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future <List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = List <Note>();
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }
    return noteList;

  }


}