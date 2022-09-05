import 'dart:io';

import 'package:contacts_app/models/call_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  final String tableName = 'calls';
  final String field1 = 'callNumber';
  final String field2 = 'callerName';
  final String field3 = 'callType';
  final String field4 = 'time';
  final String field5 = 'period';
  final String field6 = 'isHD';
  final String field7 = 'simNumber';
  final String field8 = 'records';
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'calls.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName($field1 TEXT, $field2 TEXT, $field3 TEXT,$field4 TEXT,$field5 TEXT,$field6 INTEGER,$field7 TEXT,$field8 TEXT)
      ''');
  }

  Future<List<CallModel>> getCalls() async {
    Database db = await instance.database;
    var calls = await db.query(tableName);
    List<CallModel> callList = calls.isNotEmpty
        ? calls.map((c) => CallModel.fromJson(c)).toList()
        : [];
    return callList;
  }

  Future<int> add(CallModel call) async {
    Database db = await instance.database;
    return await db.insert(tableName, call.toJson());
  }

  Future<int> remove(int callNumber) async {
    Database db = await instance.database;
    return await db
        .delete(tableName, where: '$field1 = ?', whereArgs: [callNumber]);
  }

  Future<int> update(CallModel call) async {
    Database db = await instance.database;
    return await db.update(tableName, call.toJson(),
        where: "$field1 = ?", whereArgs: [call.callNumber]);
  }
}
