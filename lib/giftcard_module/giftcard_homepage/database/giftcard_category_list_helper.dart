import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'package:gems_revamp/giftcard_module/giftcard_homepage/database/giftcard_category_list_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class GiftCardCategoryListDBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const GiftCategoryListData = "giftCategorylistdata";
  static const String TABLE = 'giftCategoryListtable';
  static const String DB_NAME = 'giftcardCategory.db';

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
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $GiftCategoryListData TEXT)");
  }

  Future<dynamic> save(GiftCardCategoryListDbModel giftcardListDbModel) async {
    var dbClient = await db;

    giftcardListDbModel.id = await dbClient!
        .insert(TABLE, giftcardListDbModel.toMap())
        .then((value) {})
        .catchError((onError) {
      //Print(onError);
    });

    return giftcardListDbModel;
  }

  Future truncateTable() async {
    Database? dbClient = await db;
    await dbClient?.execute("DELETE from $TABLE");
  }

  Future getGiftcardListData() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient!.query(TABLE, columns: [ID, GiftCategoryListData]);
    List giftCategoryList = [];

    if (maps.length > 0) {
      return jsonDecode(maps[0]["giftCategorylistdata"]);
    }
    return giftCategoryList;
  }

  Future close() async {
    var dbClient = await db;
    dbClient!.close();
  }
}
