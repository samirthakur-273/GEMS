import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AdvPlusCache {
  Future<void> saveAdvantagePlusMemberDetailsData(
      Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(
        "memberDataStoreTime", new DateTime.now().millisecondsSinceEpoch);
    prefs.setString("memberDataDetails", jsonEncode(data));
  }

  Future<dynamic> fetchAdvantagePlusMemberDetailsData() async {
    final prefs = await SharedPreferences.getInstance();
    int lasttime = prefs.getInt("memberDataStoreTime") ?? 0;

    int minss = new DateTime.now()
        .difference(new DateTime.fromMicrosecondsSinceEpoch(lasttime * 1000))
        .inMinutes;

    if (minss < (1 * 60)) {
      return prefs.get("memberDataDetails");
    } else {
      prefs.remove("memberDataStoreTime");

      return null;
    }
  }
}
