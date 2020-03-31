import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:parkapp/models/bookmark.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String bookmarkTable = 'bookmarkTable';
  String colName = 'LocationName';
  String colID = 'LocationID';
  String colX = 'cX';
  String colY = 'cY';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'bookmarks.db';

    // Open/create the database at a given path
    var bookmarksDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return bookmarksDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $bookmarkTable($colID TEXT PRIMARY KEY,'
            '$colName TEXT, $colX DOUBLE, $colY DOUBLE)');
  }

  Future<List<Map<String, dynamic>>> getBookmarkMapList() async {
    Database db = await this.database;

    var result = await db.query(bookmarkTable, orderBy: '$colName ASC');
    return result;
  }

  Future<int> insertBookmark(Bookmark bookmark) async {
    Database db = await this.database;
    var result = await db.insert(bookmarkTable, bookmark.toMap());
    return result;
  }

  Future<int> updateBookmark(Bookmark bookmark) async {
    var db = await this.database;
    var result = await db.update(bookmarkTable, bookmark.toMap(),
        where: '$colID = ?', whereArgs: [bookmark.LocationID]);
    return result;
  }

  Future<int> deleteBookmark(String ID) async {
    var db = await this.database;
    int result =
        await db.rawDelete("DELETE FROM $bookmarkTable WHERE LocationID = '$ID'");
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $bookmarkTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Bookmark>> getBookmarkList() async {
    var bookmarkMapList = await getBookmarkMapList();
    int count =
        bookmarkMapList.length;

    List<Bookmark> noteList = List<Bookmark>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Bookmark.fromMapObject(bookmarkMapList[i]));
    }

    return noteList;
  }
}
