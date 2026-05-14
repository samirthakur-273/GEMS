import 'dart:async';
import 'dart:io' as io;
import 'package:gems_revamp/family_and_friends/master_list_db/master_list_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class MasterListDbHelper {
  static Database? _db;
  static const String id = 'id';
  static const masterlistdata = 'masterlistdata';
  static const String masterlistdatatable = 'masterlistdatatable';
  static const String dataBaseName = 'masterlistdata.db';

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
        'CREATE TABLE $masterlistdatatable ($id  INTEGER PRIMARY KEY, $masterlistdata TEXT)');
  }

  Future<dynamic> insertMasterListData(
      MasterListDBModel masterListDBModel) async {
    var dbClient = await db;

    await dbClient.execute('DELETE from $masterlistdatatable');
    masterListDBModel.id =
        await dbClient.insert(masterlistdatatable, masterListDBModel.toMap());
    return masterListDBModel.masterlistdata;
  }

  Future<List<MasterListDBModel>> fetchMasterListData() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient
        .query(masterlistdatatable, columns: [id, masterlistdata]);
    List<MasterListDBModel> getMasterListData = [];
    if (maps.isNotEmpty) {
      getMasterListData.add(MasterListDBModel.fromMap(maps[0]));
    }

    return getMasterListData;
  }

  Future truncateTable() async {
    Database dbClient = await db;
    await dbClient.execute('DELETE from $masterlistdatatable');
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
