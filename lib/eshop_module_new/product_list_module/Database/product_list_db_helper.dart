import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_search_history_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ProductListDBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const String PRODUCTNAME = 'productName';
  static const String TABLE = 'productsearchhistory';
  static const String DB_NAME = 'productsearchhistorydb.db';

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
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY,  $PRODUCTNAME TEXT)");
  }

  Future<ProductSearchHistory> save(ProductSearchHistory searchHistory) async {
    var dbClient = await db;
    searchHistory.id = await dbClient.insert(TABLE, searchHistory.toMap());
    return searchHistory;
  }

  Future truncateSearchHistory() async {
    Database dbClient = await db;
    await dbClient.execute("DELETE from $TABLE");
  }

  Future<List<ProductSearchHistory>> getSearchHistory() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(TABLE,
        columns: [ID, PRODUCTNAME],
        distinct: true,
        limit: 4,
        groupBy: PRODUCTNAME,
        orderBy: "id desc");
    List<ProductSearchHistory> searchhistory = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        searchhistory.add(ProductSearchHistory.fromMap(maps[i]));
      }
    }
    return searchhistory;
  }

  Future<int> delete(String id) async {
    var dbClient = await db;
    return await dbClient
        .delete(TABLE, where: '$PRODUCTNAME = ?', whereArgs: [id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
