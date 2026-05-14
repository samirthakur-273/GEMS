import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:gems_revamp/eshop_module_new/category_module/Model/category_db_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class CategoryPageDBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const CATEGORYDATA = "categorydata";
  static const String TABLE = 'categorytable';
  static const String DB_NAME = 'categorydb.db';

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $CATEGORYDATA TEXT)");
  }

  Future<dynamic> save(CategoryDbModel category) async {
    var dbClient = await db;
    category.id = await dbClient!.insert(TABLE, category.toMap());
    return category;
  }

  Future truncateCategoryData() async {
    Database? dbClient = await db;
    await dbClient!.execute("DELETE from $TABLE");
  }

  Future<List<CategoryDbModel>> getCategoryData() async {
    var dbClient = await db;
    List<Map> maps = await dbClient!.query(TABLE, columns: [ID, CATEGORYDATA]);
    List<CategoryDbModel> category = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        category.add(CategoryDbModel.fromMap(maps[i]));
      }
    }
    return category;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient!.close();
  }
}
