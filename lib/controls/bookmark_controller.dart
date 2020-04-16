import 'package:parkapp/models/carpark.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class BookmarkController {
  static BookmarkController _bookmarkController;
  static Database _database;

  String carparkTable = 'carparkTable';
  String colAddress = 'address';
  String colID = 'ID';
  String colLat = 'lat';
  String colLng = 'lng';

  BookmarkController._createInstance();

  factory BookmarkController() {
    if (_bookmarkController == null) {
      _bookmarkController = BookmarkController._createInstance();
    }
    return _bookmarkController;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = p.join(directory.toString(), 'bookmarks.db');

    // Open/create the database at a given path
    var bookmarksDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return bookmarksDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $carparkTable($colID TEXT PRIMARY KEY,'
        '$colAddress TEXT, $colLat DOUBLE, $colLng DOUBLE)');
  }

  Future<List<Map<String, dynamic>>> getCarparkMapList() async {
    Database db = await this.database;

    var result = await db.query(carparkTable, orderBy: '$colID ASC');
    return result;
  }

  Future<int> insertCarpark(Carpark carPark) async {
    Database db = await this.database;
    var result = await db.insert(carparkTable, carPark.toMap());
    return result;
  }

  Future<int> updateCarpark(Carpark carPark) async {
    var db = await this.database;
    var result = await db.update(carparkTable, carPark.toMap(),
        where: '$colID = ?', whereArgs: [carPark.number]);
    return result;
  }

  Future<int> deleteCarpark(String ID) async {
    var db = await this.database;
    int result = await db
        .rawDelete("DELETE FROM $carparkTable WHERE ID = '$ID'");
    return result;
  }

  Future<bool> checkExist(String ID) async {
    var db = await this.database;
    List<Map<String, dynamic>> queryResult = await db
        .rawQuery("SELECT * FROM $carparkTable WHERE ID = '$ID'");
    bool result = queryResult.isNotEmpty ? true : false;
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
    await db.rawQuery('SELECT COUNT (*) from $carparkTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Carpark>> getCarparkList() async {
    var carparkMapList = await getCarparkMapList();
    int count = carparkMapList.length;

    List<Carpark> noteList = List<Carpark>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Carpark.fromMapObject(carparkMapList[i]));
    }

    return noteList;
  }
}
