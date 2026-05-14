import 'dart:async';
import 'dart:io' as io;
import 'package:gems_revamp/giftcard_module/giftcard_homepage/database/giftcard_list_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class GiftCardListDBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const GiftCardListData = "giftlistdata";
  static const String TABLE = 'giftcardListtable';
  static const String DB_NAME = 'giftcardList.db';

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
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $GiftCardListData TEXT)");
  }

  Future<dynamic> save(GiftCardListDbModel giftcardListDbModel) async {
    var dbClient = await db;
    giftcardListDbModel.id =
        await dbClient!.insert(TABLE, giftcardListDbModel.toMap());
    return giftcardListDbModel;
  }

  Future truncateTable() async {
    Database? dbClient = await db;
    await dbClient!.execute("DELETE from $TABLE");
  }

  Future<List<GiftCardListDbModel>> getGiftcardListData() async {
    var dbClient = await db;
    List<dynamic> maps =
        await dbClient!.query(TABLE, columns: [ID, GiftCardListData]);
    List<GiftCardListDbModel> giftCardList = [];
    if (maps.length > 0) {

      for (int i = 0; i < maps.length; i++) {
        giftCardList.add(GiftCardListDbModel.fromMap(maps[i]));
      }
    }
    return giftCardList;
  }

  Future close() async {
    var dbClient = await db;
    dbClient!.close();
  }
}
