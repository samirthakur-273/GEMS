import 'dart:async';
import 'dart:io' as io;
import 'package:gems_revamp/my_purchase/flight_purchase/flt_db/flt_list_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class FLTPurchaseListDBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const FLTPURCHASEDATA = "fltPurchasetdata";
  static const String TABLE = 'Flight_mypurchase';
  static const String DB_NAME = 'Purchaseflight.db';

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
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $FLTPURCHASEDATA TEXT)");
  }

  Future<dynamic> save(FLTPurchaseListDbModel flightListDbModel) async {
    var dbClient = await db;

    flightListDbModel.purchaseId = await dbClient
        .insert(TABLE, flightListDbModel.toMap())
        .then((value) {})
        .catchError((onError) {});
  }

  Future truncateTable() async {
    Database dbClient = await db;
    await dbClient.execute("DELETE from $TABLE");
  }

  Future<List<FLTPurchaseListDbModel>> getFLTPurchaseListData() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.query(TABLE, columns: [ID, FLTPURCHASEDATA]);
    List<FLTPurchaseListDbModel> fltList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        fltList.add(FLTPurchaseListDbModel.fromMap(maps[i]));
      }
    }

    return fltList;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
