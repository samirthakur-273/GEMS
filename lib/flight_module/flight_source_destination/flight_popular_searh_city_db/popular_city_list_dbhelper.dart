import 'dart:async';
import 'dart:io' as io;
import 'package:gems_revamp/flight_module/flight_source_destination/flight_popular_searh_city_db/popular_city_list_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class FltPopularCityListDBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const FLTPOPULARDATA = "fltpopulardata";
  static const String TABLE = 'Flight_popularcity';
  static const String DB_NAME = 'Popularlist.db';

  Future<Database> get db async => _db ?? await initDb();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $FLTPOPULARDATA TEXT)");
  }

  Future<dynamic> save(PopularCityListDbModel flightListDbModel) async {
    var dbClient = await db;

    flightListDbModel.cityId = await dbClient
        .insert(TABLE, flightListDbModel.toMap())
        .catchError((onError) {
      return 0;
    });
  }

  Future truncateTable() async {
    Database dbClient = await db;
    await dbClient.execute("DELETE from $TABLE");
  }

  Future<List<PopularCityListDbModel>> getFltPopularCityListData() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.query(TABLE, columns: [ID, FLTPOPULARDATA]);
    List<PopularCityListDbModel> fltList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        fltList.add(PopularCityListDbModel.fromMap(maps[i]));
      }
    }

    return fltList;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
