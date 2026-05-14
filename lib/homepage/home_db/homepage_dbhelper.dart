import 'dart:async';
import 'dart:io' as io;
import 'package:gems_revamp/homepage/home_db/homepage_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class HomePageListDBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const HomePageData = 'homepagedata';
  static const String TABLE = 'homepagetable';
  static const String DB_NAME = 'homepageList.db';

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
        'CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $HomePageData TEXT)');
  }

  Future<dynamic> save(HomePageDbModel homePageDbModel) async {
    var dbClient = await db;
    homePageDbModel.id = await dbClient.insert(TABLE, homePageDbModel.toMap());
    return homePageDbModel;
  }

  Future truncateTable() async {
    Database dbClient = await db;
    await dbClient.execute('DELETE from $TABLE');
  }

  Future<List<HomePageDbModel>> getHomepageListData() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.query(TABLE, columns: [ID, HomePageData]);
    List<HomePageDbModel> homedatalist = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        homedatalist.add(HomePageDbModel.fromMap(maps[i]));
      }
    }
    return homedatalist;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
