

import 'package:gems_revamp/offer_module/offer_list/databasefiles/outlet_db_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class OutletDBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const outletListData = 'outletlistdata';
  static const String TABLE = 'outletlisttable';
  static const String DB_NAME = 'outletlistdata.db';

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
        'CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $outletListData TEXT)');
  }

  Future<dynamic> save(OutletDBModel outletDbModel) async {
    var dbClient = await db;
    outletDbModel.id = await dbClient.insert(TABLE, outletDbModel.toMap());
    return outletDbModel;
  }

  Future truncateTable() async {
    Database dbClient = await db;
    await dbClient.execute('DELETE from $TABLE');
  }

  Future<List<OutletDBModel>> getOutletListData() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps =
        await dbClient.query(TABLE, columns: [ID, outletListData]);
    List<OutletDBModel> outletList = [];
    if (maps.isNotEmpty) {
      for (int i = 0; i < maps.length; i++) {
        outletList.add(OutletDBModel.fromMap(maps[i]));
      }
    }
    return outletList;
  }
}
