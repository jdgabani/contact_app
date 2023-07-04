import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? database;
  static List<Map<String, dynamic>>? data;

  static Future<void> createDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'contact.db');

    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Test (id INTEGER PRIMARY KEY,name TEXT,value TEXT)');
    });
  }

  static Future<void> insertData(String name, String userId) async {
    await database!.insert('Test', {
      "name" : name,
      "value" :userId,
    });
  }

  static Future<void> getData() async {
    data = await database!.query('Test');
    print('$data');
  }

  static Future<void> deleteData() async {
    await database!
        .delete('Test', where: 'name=?', whereArgs: ['jaydeep Gabani']);
  }
}
