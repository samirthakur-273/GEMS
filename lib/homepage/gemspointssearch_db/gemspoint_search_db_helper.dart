import 'dart:async';
import 'dart:io' as io;
import 'package:gems_revamp/homepage/gemspointssearch_db/gemspoint_search_history_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class GemsPointListDBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const String PRODUCTNAMES = 'productNames';
  static const String AFFILIATEID = 'affiliateId';
  static const String TABLE = 'gemspointsearchhistory';
  static const String DB_NAME = 'gemspointhistorydb.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY,  $PRODUCTNAMES TEXT, $AFFILIATEID TEXT)");
  }

  Future<GemsPointSearchHistory> save(
      GemsPointSearchHistory searchHistory) async {
    var dbClient = await db;
    searchHistory.id = await dbClient.insert(TABLE, searchHistory.toMap());
    return searchHistory;
  }

  Future truncategemspointSearchHistory() async {
    Database dbClient = await db;
    await dbClient.execute("DELETE from $TABLE");
  }

  Future<List<GemsPointSearchHistory>> getGemsPointSearchHistory() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(TABLE,
        columns: [ID, PRODUCTNAMES, AFFILIATEID],
        distinct: true,
        limit: 4,
        groupBy: PRODUCTNAMES,
        orderBy: "id desc");
    List<GemsPointSearchHistory> searchhistory = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        searchhistory.add(GemsPointSearchHistory.fromMap(maps[i]));
      }
    }
    return searchhistory;
  }

  Future<int> delete(String id) async {
    var dbClient = await db;
    return await dbClient
        .delete(TABLE, where: '$PRODUCTNAMES = ?', whereArgs: [id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
