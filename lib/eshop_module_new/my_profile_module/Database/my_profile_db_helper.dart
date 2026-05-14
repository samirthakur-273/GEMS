import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/my_profile_db_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class MyProfileDBHelper {
  static Database? _db;
  static const String ID = 'id';
  static const PROFILEDATA = "profiledata";
  static const String TABLE = 'myprofiletable';
  static const String DB_NAME = 'myprofiledb.db';

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
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $PROFILEDATA TEXT)");
  }

  Future<dynamic> save(MyProfileDataModel myProfile) async {
    var dbClient = await db;
    myProfile.id = await dbClient!.insert(TABLE, myProfile.toMap());
    return myProfile;
  }

  Future truncateMyProfileData() async {
    Database? dbClient = await db;
    await dbClient!.execute("DELETE from $TABLE");
  }

  Future<List<MyProfileDataModel>> getMyProfileData() async {
    var dbClient = await db;
    List<Map> maps = await dbClient!.query(TABLE, columns: [ID, PROFILEDATA]);
    List<MyProfileDataModel> myProfile = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        myProfile.add(MyProfileDataModel.fromMap(maps[i]));
      }
    }
    return myProfile;
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
