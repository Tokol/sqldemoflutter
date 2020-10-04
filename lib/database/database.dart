
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlpractise/model/task.dart';

 class DB{


  static Database _db;

  static int get _version => 1;


  static Future<void> init() async{

    if(_db!=null){
      return;
    }


      try {
        String _path = await getDatabasesPath() + 'task';
        _db = await openDatabase(_path, version: _version, onCreate: onCreate);
      }
      catch(ex) {
        print(ex);
      }



  }

  static void onCreate(Database db, int version) async {
    db.execute("CREATE TABLE Task ("
        "id INTEGER PRIMARY KEY,"
        "taskName TEXT,"
        "isComplete TEXT"
        ")");
  }


  static Future<int> insert(Task task ) async {

        print(_db.path);

    var table = await _db.rawQuery("SELECT MAX(id)+1 as id FROM Task");

    int id = table.first["id"];

    print(id);

        var raw = await _db.rawInsert(
            "INSERT Into Task (id,taskName,isComplete)"
                " VALUES (?,?,?)",
            [id, task.taskName, task.complete]);
        return raw;


  }


  static Future<List<Map<String, dynamic>>> query(String table) async {
   var res =  await  _db.query("Task");

   res.isNotEmpty?print(res) :print('no task added');

  }


  static Future<int> update (String table, Task task) async{
    await  _db.update(table, task.toMap(), where: 'id = ?', whereArgs: [task.id] );

  }


  static Future<int> delete (String table, Task task) async{
  await   _db.delete(table, where:'id = ?', whereArgs:[task.id]);

  }

}