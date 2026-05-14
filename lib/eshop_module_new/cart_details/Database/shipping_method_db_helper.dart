import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/model/cart_details_db_model.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class ShippingDetailsDBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const SHIPPINGDETAILSDATA = "shippingMethoddata";
  static const String TABLE = 'shippingMethoddatatable';
  static const String DB_NAME = 'shippingMethod.db';

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
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $SHIPPINGDETAILSDATA TEXT)");
  }

  Future<dynamic> save(ShippingMethodDbModel shippingdetails) async {
    var dbClient = await db;
    shippingdetails.id = await dbClient!.insert(TABLE, shippingdetails.toMap());
    return shippingdetails;
  }

  Future truncateShippingDetailsData() async {
    Database? dbClient = await db;
    await dbClient!.execute("DELETE from $TABLE");
  }

  Future<List<ShippingMethodDbModel>> getShippingDetailsData() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient!.query(TABLE, columns: [ID, SHIPPINGDETAILSDATA]);
    List<ShippingMethodDbModel> shippingdetails = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        shippingdetails.add(ShippingMethodDbModel.fromMap(maps[i]));
      }
    }
    return shippingdetails;
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
