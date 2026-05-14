import 'dart:async';
import 'dart:io' as io;
import 'package:gems_revamp/my_purchase/gift_purchase/gc_db/gc_list_db_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class GiftCardPurchaseListDBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const GIFTPURCHASEDATA = "giftPurchasetdata";
  static const String TABLE = 'giftPurchasetable';
  static const String DB_NAME = 'Purchasegift.db';

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
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $GIFTPURCHASEDATA TEXT)");
  }

  Future<dynamic> save(GiftCardPurchaseListDbModel giftcardListDbModel) async {
    var dbClient = await db;

    giftcardListDbModel.purchaseId = await dbClient
        .insert(TABLE, giftcardListDbModel.toMap())
        .then((value) {})
        .catchError((onError) {
    });
  }

  Future truncateTable() async {
    Database dbClient = await db;
    await dbClient.execute("DELETE from $TABLE");
  }

  Future<List<GiftCardPurchaseListDbModel>>
      getGiftcardPurchaseListData() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.query(TABLE, columns: [ID, GIFTPURCHASEDATA]);
    List<GiftCardPurchaseListDbModel> giftCardList = [];
    if (maps.length > 0) {

      for (int i = 0; i < maps.length; i++) {
        giftCardList.add(GiftCardPurchaseListDbModel.fromMap(maps[i]));
      }
    }
    return giftCardList;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
