import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/model/cart_details_db_model.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class CartDetailsDBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const CARTDETAILSDATA = "cartdetailsdata";
  static const String TABLE = 'cartdetailstable';
  static const String DB_NAME = 'cartdetails.db';

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
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $CARTDETAILSDATA TEXT)");
  }

  Future<dynamic> save(CartDetailsDbModel cartdetails) async {
    var dbClient = await db;
    cartdetails.id = await dbClient!.insert(TABLE, cartdetails.toMap());
    return cartdetails;
  }

  Future truncateCartDetailsData() async {
    Database? dbClient = await db;
    await dbClient!.execute("DELETE from $TABLE");
  }

  Future<List<CartDetailsDbModel>> getCartDetailsData() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient!.query(TABLE, columns: [ID, CARTDETAILSDATA]);
    List<CartDetailsDbModel> cartdetails = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        cartdetails.add(CartDetailsDbModel.fromMap(maps[i]));
      }
    }
    return cartdetails;
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
