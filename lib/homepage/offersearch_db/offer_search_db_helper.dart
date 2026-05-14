import 'dart:async';
import 'dart:io' as io;
import 'package:gems_revamp/homepage/offersearch_db/offer_search_history_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class OfferSearchListDBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const String PRODUCTNAMEE = 'productNamee';
  static const OFFERSEARCHDATA = "offersearchdata";
  static const String TABLE = 'offersearchhistory';
  static const String DB_NAME = 'offerhistorydb.db';

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
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY,  $PRODUCTNAMEE TEXT, $OFFERSEARCHDATA TEXT)");
  }

  Future<OfferSearchHistory> save(OfferSearchHistory searchHistory) async {
    var dbClient = await db;
    searchHistory.id = await dbClient.insert(TABLE, searchHistory.toMap());
    return searchHistory;
  }

  Future truncateofferSearchHistory() async {
    Database dbClient = await db;
    await dbClient.execute("DELETE from $TABLE");
  }

  Future<List<OfferSearchHistory>> getofferSearchHistory() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(TABLE,
        columns: [ID, PRODUCTNAMEE, OFFERSEARCHDATA],
        distinct: true,
        limit: 4,
        groupBy: PRODUCTNAMEE,
        orderBy: "id desc");
    List<OfferSearchHistory> searchhistory = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        searchhistory.add(OfferSearchHistory.fromMap(maps[i]));
      }
    }
    return searchhistory;
  }

  Future<int> delete(String id) async {
    var dbClient = await db;
    //print("opopo");
    return await dbClient
        .delete(TABLE, where: '$PRODUCTNAMEE = ?', whereArgs: [id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
