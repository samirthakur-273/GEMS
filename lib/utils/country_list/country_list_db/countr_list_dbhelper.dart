import 'dart:async';
import 'dart:io' as io;

import 'package:gems_revamp/utils/country_list/country_list_db/country_list_db_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class CountryListDbHelper {
  static Database? _db;
  static const String id = 'id';
  static const countrylistdata = 'countrylistdata';
  static const String countrylistdatatable = 'countrylistdatatable';
  static const String dataBaseName = 'countrylistdata.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dataBaseName);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $countrylistdatatable ($id  INTEGER PRIMARY KEY, $countrylistdata TEXT)');
  }

  Future<dynamic> insertMasterListData(
      CountryListDbModel countryListDbModel) async {
    var dbClient = await db;

    await dbClient.execute('DELETE from $countrylistdatatable');
    countryListDbModel.id =
        await dbClient.insert(countrylistdatatable, countryListDbModel.toMap());
    return countryListDbModel.countrylistdata;
  }

  Future<List<CountryListDbModel>> fetchMasterListData() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient
        .query(countrylistdatatable, columns: [id, countrylistdata]);
    List<CountryListDbModel> getcountryListData = [];
    if (maps.isNotEmpty) {
      getcountryListData.add(CountryListDbModel.fromMap(maps[0]));
    }

    return getcountryListData;
  }

  Future truncateTable() async {
    Database dbClient = await db;
    await dbClient.execute('DELETE from $countrylistdatatable');
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
