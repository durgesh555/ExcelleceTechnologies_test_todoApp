import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:app_todo/model.dart';


class DatabaseHelper{

  static DatabaseHelper _databaseHelper;      //singleton databaseHelper//
  static Database _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colDate = 'date';
     
  DatabaseHelper._createInstance();          //named constructor to create instance of database.

  factory DatabaseHelper(){
   if(_databaseHelper == null){
   _databaseHelper = DatabaseHelper._createInstance();    //this is executed only once , singleton object.
   }
    return _databaseHelper;
  }

  Future<Database> get database async{
    if(_database == null){
    _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    
   var noteDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
   return noteDatabase;
  }

  void _createDb(Database db, int newVersion) async {
   await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT,'
   '$colDate TEXT)');
  }

  //fetch data from databse..//
  Future<List<Map<String, dynamic>>> getNoteMapList() async{
    Database db = await this.database;

    var result = await db.query(noteTable);
    return result; 
  }

  //insert data into database..//
  Future<int> insertNote(Note note) async{
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }
 
  //update tha data into database..//
  Future<int> updateNote(Note note) async{
    var db = await this.database;
    var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }
 
 //get number of Note Objects in database.//
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x =await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
 }

 //get the mapList [List<map>] and convert it to NoteList [List<Note>].//
 Future<List<Note>> getNoteList() async{
   var noteMapList = await getNoteMapList();
   int count = noteMapList.length;

   // ignore: deprecated_member_use
   List<Note> noteList = List<Note>();

   for(int i=0; i<count; i++){
     noteList.add(Note.fromMapObject(noteMapList[i]));
   }
  return noteList;
 }
 
}
