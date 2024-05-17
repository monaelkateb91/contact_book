
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:contact_book/model/contact.dart';
class MyDatabase {
  static final MyDatabase _myDatabase = MyDatabase._privateConstructor();

  // private constructor
  MyDatabase._privateConstructor();


  static late Database _database;
  //
  factory MyDatabase() {
    return _myDatabase;
  }
  // variables
  final String tableName = 'contacts';

  final String columnId = 'id';
  final String columnName = 'name';
  final String columnPhone = 'phone';
  final String columnEmail = 'email';

  //
  // init database
  initializeDatabase() async {
    // Get path where to store database
    Directory directory = await getApplicationDocumentsDirectory();
    // path
    String path = '${directory.path}contact.db';
    // create Database
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        //
        await db.execute(
            'CREATE TABLE $tableName ($columnId INTEGER PRIMARY KEY, $columnName TEXT, $columnPhone TEXT, $columnEmail TEXT)');
        //
      },
    );
  }

  // CRUD
  // Read
  Future<List<Map<String, Object?>>> getContactList() async {


    List<Map<String, Object?>> result =
    await _database.query(tableName, orderBy: columnName);
    return result;
    //
  }

  // Insert
  Future<int> insertContact(Contact contact) async {
    //
    int rowsInserted = await _database.insert(tableName, contact.toMap());
    return rowsInserted;
    //
  }

  // Update
  Future<int> updateContact(Contact contact) async {
    //
    int rowsUpdated = await _database.update(tableName, contact.toMap(),
        where: '$columnId= ?', whereArgs: [contact.id]);
    return rowsUpdated;
    //
  }

  // Delete
  Future<int> deleteContact(Contact contact) async {
    //
    int rowsDeleted = await _database
        .delete(tableName, where: '$columnId= ?', whereArgs: [contact.id]);
    return rowsDeleted;
    //
  }

  // Count
  Future<int> countContact() async {
    //
    List<Map<String, Object?>> result =
    await _database.rawQuery('SELECT COUNT(*) FROM $tableName');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count;
    //
  }
//

}
