import 'dart:async';
import 'dart:io' as io;
import 'package:gems_revamp/my_purchase/hotel_purchase/hlt_db/hlt_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class HotelPurchaseListDBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const HOTELPURCHASEDATA = "hotelPurchasetdata";
  static const String TABLE = 'hotel_mypurchase';
  static const String DB_NAME = 'Purchasehlt.db';

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
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $HOTELPURCHASEDATA TEXT)");
  }

  Future<dynamic> save(HotelPurchaseListDbModel hotelListDbModel) async {
    var dbClient = await db;

    hotelListDbModel.purchaseId = await dbClient
        .insert(TABLE, hotelListDbModel.toMap())
        .then((value) {})
        .catchError((onError) {
    });
  }

  Future truncateTable() async {
    Database dbClient = await db;
    await dbClient.execute("DELETE from $TABLE");
  }

  Future<List<HotelPurchaseListDbModel>> getHLTPurchaseListData() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.query(TABLE, columns: [ID, HOTELPURCHASEDATA]);
    List<HotelPurchaseListDbModel> hotelCardList = [];
    if (maps.length > 0) {

      for (int i = 0; i < maps.length; i++) {
        hotelCardList.add(HotelPurchaseListDbModel.fromMap(maps[i]));
      }
    }

    return hotelCardList;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
