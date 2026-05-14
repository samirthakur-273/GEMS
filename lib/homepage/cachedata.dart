import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
class cachedata {
  savetopBanners(List<dynamic> data, String cat) async {
    final prefs = await SharedPreferences.getInstance();
    int? lasttime = prefs.getInt("hodedatatimetop");
    if (lasttime == null) {
      prefs.setInt(
          "hodedatatimetop", new DateTime.now().millisecondsSinceEpoch);
    }
    prefs.setString("topbanners" + cat, jsonEncode(data));
  }

  savehome(List<dynamic> data, String cat) async {
    final prefs = await SharedPreferences.getInstance();
    int? lasttime = prefs.getInt("hodedatatime");
    if (lasttime == null) {
      prefs.setInt("hodedatatime", new DateTime.now().millisecondsSinceEpoch);
    }

    prefs.setString("homedata" + cat, jsonEncode(data));
  }

  Future<dynamic> gethome(String cat) async {
    final prefs = await SharedPreferences.getInstance();
    int? lasttime = prefs.getInt("hodedatatime");

    int mins = new DateTime.now()
        .difference(new DateTime.fromMicrosecondsSinceEpoch(lasttime! * 1000))
        .inMinutes;

    if (mins < (1 * 60)) {
      return prefs.get("homedata" + cat);
    } else {
      prefs.setInt("hodedatatime", 0);
      prefs.setString("homedatamain", "");
      prefs.setString("homedatasave", "");
      prefs.setString("homedataearn", "");
      prefs.setString("topbannersmain", "");
      prefs.setString("topbannerssave", "");
      prefs.setString("topbannersearn", "");
      return null;
    }
  }
  Future<Object?> gettopBanners(String cat) async {
    final prefs = await SharedPreferences.getInstance();
    int? lasttime = prefs.getInt("hodedatatimetop");

    int minss = new DateTime.now()
        .difference(new DateTime.fromMicrosecondsSinceEpoch(lasttime! * 1000))
        .inMinutes;
    if (minss < (1 * 60)) {
      return prefs.get("topbanners" + cat);
    } else {
      prefs.setInt("hodedatatimetop", 0);

      return null;
    }
  }



 
}
