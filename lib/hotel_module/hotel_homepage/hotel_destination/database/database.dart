import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "hotelrecentsearch.db";
  static final _databaseVersion = 1;

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();


  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database ?? await _initDatabase();
    _database = await _initDatabase();

    return _database ?? await _initDatabase();
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(databasesPath, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {

    await db.execute('''
          CREATE TABLE Hotel_recent_search (
            _id INTEGER PRIMARY KEY,
            city TEXT NOT NULL,
            destination_id TEXT NOT NULL,
            destinationType TEXT NOT NULL,
            searchType TEXT NOT NULL,
            searchText TEXT NOT NULL,
            searchId TEXT NOT NULL,
            checkindate TEXT NOT NULL,
            checkoutdate TEXT NOT NULL,
            image TEXT NULL,
            guests TEXT NULL,
            rooms TEXT NULL,
            adult TEXT NULL,
            child TEXT NULL,
            uniqueid TEXT NULL,
            hotelid TEXT NULL,
            mop TEXT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE Hotel_PopularCity (
            _id INTEGER PRIMARY KEY, 
            destination_id TEXT NOT NULL,
            search_type TEXT NOT NULL,
            search_text TEXT NOT NULL,
            dest_type TEXT NOT NULL,
            count TEXT NOT NULL
            )
          ''');
  }
  

  Future<int> insertHotelRecentSearch(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String cityname = row["city"];
    await db.execute(
        "DELETE from Hotel_recent_search where city='" + cityname + "'");
    await db.execute(
        "DELETE FROM Hotel_recent_search WHERE _id NOT IN ( SELECT _id FROM ( SELECT _id FROM Hotel_recent_search ORDER BY _id DESC LIMIT 5) foo)");
    return await db.insert("Hotel_recent_search", row);
  }

  Future<int> insertHotelPopularCity(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String destinationId = row["destination_id"];
    await db.execute("DELETE from Hotel_PopularCity where destination_id='" +
        destinationId +
        "'");
    await db.execute(
        "DELETE FROM Hotel_PopularCity WHERE _id NOT IN ( SELECT _id FROM ( SELECT _id FROM Hotel_PopularCity ORDER BY _id DESC LIMIT 5) foo)");
    return await db.insert("Hotel_PopularCity", row);
  }

  Future<List<Map<String, dynamic>>> getHotelRecentSearch() async {
    Database db = await instance.database;
    // return await db.query(table);
    return await db
        .rawQuery("select * from Hotel_recent_search ORDER by _id DESC");
  }

  Future<List<Map<String, dynamic>>> getHotelPopularCity() async {
    Database db = await instance.database;
    // return await db.query(table);
    return await db
        .rawQuery("select * from Hotel_PopularCity ORDER by _id DESC");
  }

  Future<List<Map<String, Object?>>> deleteHotelRecentSearch() async {
    Database db = await instance.database;
    // return await db.query(table);
    return await db.rawQuery("DELETE FROM Hotel_recent_search");
  }

  Future<List<Map<String, Object?>>> deleteHotelPopularCity() async {
    Database db = await instance.database;
    // return await db.query(table);
    return await db.rawQuery("DELETE FROM Hotel_PopularCity");
  }
}
