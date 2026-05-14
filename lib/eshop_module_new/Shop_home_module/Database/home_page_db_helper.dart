import 'dart:async';
import 'dart:io' as io;
import 'package:gems_revamp/eshop_module_new/Shop_home_module/Model/home_page_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class HomePageDBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const HOMEPAGEDATA = "homepagedata";
  static const String TABLE = 'myhomepagetable';
  static const String DB_NAME = 'myhomepagedb.db';

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
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $HOMEPAGEDATA TEXT)");
  }

  Future<dynamic> save(HomePageDbModel homepage) async {
    var dbClient = await db;
    homepage.id = await dbClient.insert(TABLE, homepage.toMap());
    return homepage;
  }

  Future truncateHomePageData() async {
    Database dbClient = await db;
    await dbClient.execute("DELETE from $TABLE");
  }

  Future<List<HomePageDbModel>> getHomePageData() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.query(TABLE, columns: [ID, HOMEPAGEDATA]);
    List<HomePageDbModel> homepage = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        homepage.add(HomePageDbModel.fromMap(maps[i]));
      }
    }
    return homepage;
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
