import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/model/my_wishlist_db_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class MyWishListDBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const MYWISHLISTDATA = "mywishlistdata";
  static const String TABLE = 'mywishlisttable';
  static const String DB_NAME = 'rbdatabase.db';

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
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $MYWISHLISTDATA TEXT)");
  }

  Future<dynamic> save(MyWishListDbModel wishlist) async {
    var dbClient = await db;
    wishlist.id = await dbClient.insert(TABLE, wishlist.toMap());
    return wishlist;
  }

  Future truncateWishlistData() async {
    Database dbClient = await db;
    await dbClient.execute("DELETE from $TABLE");
  }

  Future<List<MyWishListDbModel>> getMyWishListData() async {
    var dbClient = await db;
    List<Map<String,dynamic>> maps = await dbClient.query(TABLE, columns: [ID, MYWISHLISTDATA]);
    List<MyWishListDbModel> mywishlist = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        mywishlist.add(MyWishListDbModel.fromMap(maps[i]));
      }
    }
    return mywishlist;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
