import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "InfinityTreats.db";
  static final _databaseVersion = 1;

  // notification table

  static final table = 'NotificationList';
  static final columnId = '_id';
  static final columnNotiId = 'ID';
  static final columnTitle = 'title';
  static final columnMessage = 'message';
  static final columnServiceType = 'service_type';
  static final columnTripId = 'trip_id';
  static final columnCustId = 'customer_id';
  static final columnUserId = 'user_id';
  static final columnNotiTypeId = 'notification_type_id';
  static final columnCreatedDateTime = 'created_date_time';
  static final columnUpdatedDateTime = 'updated_date_time';
  static final columnIsRead = 'is_read';
  static final columnIsDelete = 'is_deleted';
  static final columnLastSyncedDeviceId = 'last_synced_device_id';

  /* flight recent search */
  // static final flightsRecentCitySearch = 'FlightsRecentCitySearch';
  // static final flightsRecentCityudateTrigger = 'FlightsRecentCityudateTrigger';
  // static final COLUMN_ID = 'id'; //tableName
  // static final FROM_AIRPORT_CODE = 'FROM_AIRPORT_CODE';
  // static final FROM_CITY_NAME = 'FROM_CITY_NAME';
  // static final TO_AIRPORT_CODE = 'TO_AIRPORT_CODE';
  // static final TO_CITY_NAME = 'TO_CITY_NAME';
  // static final DEPART_DATE = 'DEPART_DATE';
  // static final RETURN_DATE = 'RETURN_DATE';
  // static final PASSENGERS_ADULTS = 'PASSENGERS_ADULTS';
  // static final PASSENGERS_CHILD = 'PASSENGERS_CHILD';
  // static final PASSENGERS_INFANTS = 'PASSENGERS_INFANTS';
  // static final CABIN_CLASS = 'CABIN_CLASS';
  // static final CABIN_VALUE = 'CABIN_VALUE';
  // static final TRIP = 'TRIP';
  // static final TIMESTAMP = 'TIMESTAMP';
  // static final AIRPORTNAMETOCITY = 'AIRPORTNAMETOCITY';
  // static final AIRPORTNAMEFROMCITY = 'AIRPORTNAMEFROMCITY';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database ?? await _initDatabase();
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();

    return _database ?? await _initDatabase();
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(databasesPath, _databaseName);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE Flight_recent_search (
            _id INTEGER PRIMARY KEY,
            source TEXT NOT NULL,
            destination TEXT NOT NULL,
            source_code TEXT NOT NULL,
            destination_code TEXT NOT NULL,
            source_airport TEXT NOT NULL,
            destination_airport TEXT NOT NULL,
            triptype TEXT NOT NULL,
            startdate TEXT NOT NULL,
            enddate TEXT NOT NULL,
            cabinclass TEXT NOT NULL,
            guests TEXT NULL,
            child TEXT NULL,
            infant TEXT NULL,
            showNonStp TEXT NULL
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  // Future<int> insert(Map<String, dynamic> row) async {
  //   Database db = await instance.database;
  //   return await db.insert(table, row);
  // }

  Future<int> insertFlightRecentSearch(Map<String, dynamic> row) async {
    Database db = await instance.database;
    String source = row["source"];
    String destination = row["destination"];
    await db.execute("DELETE from Flight_recent_search where source='" +
        source +
        "' and destination='" +
        destination +
        "'");
    await db.execute(
        "DELETE FROM Flight_recent_search WHERE _id NOT IN ( SELECT _id FROM ( SELECT _id FROM Flight_recent_search ORDER BY _id DESC LIMIT 5) foo)");

    var data = await db.insert("Flight_recent_search", row);

    return data;
  }

  Future<List<Map<String, dynamic>>> getFlightRecentSearch() async {
    //
    Database db = await instance.database;
    // return await db.query(table);
    return await db
        .rawQuery("select * from Flight_recent_search ORDER by _id DESC");
  }

  Future<dynamic> deletecity(table) async {
    Database db = await instance.database;

    var query = await db.delete(table);

    return query;
  }

  Future truncateTable() async {
    Database dbClient = await instance.database;

    await dbClient.execute("DELETE from Flight_recent_search");
  }
}
