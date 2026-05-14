import 'dart:async';
import 'dart:io' as io;
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/hotel_popular_searh_city_db/popularcitydb_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class HotelPopularCityListDBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const PopularCityData = "popularcitydata";
  static const String TABLE = 'popularcitytable';
  static const String DB_NAME = 'popularCityList.db';

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
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $PopularCityData TEXT)");
  }

  Future<dynamic> save(PopularCityListDbModel popularCityListDbModel) async {
    var dbClient = await db;
    popularCityListDbModel.id =
        await dbClient.insert(TABLE, popularCityListDbModel.toMap());
    return popularCityListDbModel;
  }

  Future truncateTable() async {
    Database dbClient = await db;
    await dbClient.execute("DELETE from $TABLE");
  }

  Future<List<PopularCityListDbModel>> getpopularCityListData() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.query(TABLE, columns: [ID, PopularCityData]);
    List<PopularCityListDbModel> popularlist = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        popularlist.add(PopularCityListDbModel.fromMap(maps[i]));
      }
    }
    return popularlist;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
