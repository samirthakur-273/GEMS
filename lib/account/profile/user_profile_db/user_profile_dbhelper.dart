import 'dart:async';
import 'dart:io' as io;
import 'package:gems_revamp/account/profile/user_profile_db/user_profile_db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class UserProfileDbHelper {
  static Database? _db;
  static const String id = 'id';
  static const userProfileData = 'userprofiledata';
  static const String userProfileDataTable = 'userprofiledatatable';
  static const String dataBaseName = 'userprofiledata.db';

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
        'CREATE TABLE $userProfileDataTable ($id  INTEGER PRIMARY KEY, $userProfileData TEXT)');
  }

  Future<dynamic> insertUserProfileData(
      UserProfileDbModel userProfileDbModel) async {
    var dbClient = await db;

    await dbClient.execute('DELETE from $userProfileDataTable');
    userProfileDbModel.id =
        await dbClient.insert(userProfileDataTable, userProfileDbModel.toMap());

    return userProfileDbModel.userprofiledata;
  }

  Future<List<UserProfileDbModel>> fetchUserProfileData() async {
    var dbClient = await db;
    List<Map<String, dynamic>> maps = await dbClient
        .query(userProfileDataTable, columns: [id, userProfileData]);
    List<UserProfileDbModel> getuserProfileData = [];
    if (maps.isNotEmpty) {
      getuserProfileData.add(UserProfileDbModel.fromMap(maps[0]));
    }

    return getuserProfileData;
  }

  Future truncateTable() async {
    Database dbClient = await db;
    await dbClient.execute('DELETE from $userProfileDataTable');
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
