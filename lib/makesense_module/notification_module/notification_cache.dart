import 'package:shared_preferences/shared_preferences.dart';

class NotificationCache {
  notificationSaveCache(data, var _name) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("notificationData", (data));
  }

  Future<dynamic> getNotificationCacheData(var _name) async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.get("notificationData");
  }
}
