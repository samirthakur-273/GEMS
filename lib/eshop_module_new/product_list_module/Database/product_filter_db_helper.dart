import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_filter_db_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ProductFilterDBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const String FILTERDATA = 'filterdata';
  static const String TABLE = 'productfilterdata';
  static const String DB_NAME = 'productfilterdata.db';

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
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY,  $FILTERDATA TEXT)");
  }

  Future<ProductFilterDataModel> save(ProductFilterDataModel filterData) async {
    var dbClient = await db;
    filterData.id = await dbClient.insert(TABLE, filterData.toMap());
    return filterData;
  }

  Future truncatefilterData() async {
    Database dbClient = await db;
    await dbClient.execute("DELETE from $TABLE");
  }

  Future<List<ProductFilterDataModel>> getFilterData() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient.query(TABLE,
        columns: [ID, FILTERDATA],
        distinct: true,
        limit: 4,
        groupBy: FILTERDATA,
        orderBy: "id desc");
    List<ProductFilterDataModel> filterData = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        filterData.add(ProductFilterDataModel.fromMap(maps[i]));
      }
    }
    return filterData;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
