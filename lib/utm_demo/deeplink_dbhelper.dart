import 'dart:convert';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/auth_utils.dart';

class UtmManager {
  static const String _utmKey = 'utm_data';
  int numberOfDays = GemsGLobals.defaultUtmExpiryDays;

  Future<void> initializeNumberOfDays() async {
    numberOfDays = await AuthUtils.getIntValue(GemsGLobals.daysCountKey) ??
        GemsGLobals.defaultUtmExpiryDays;
  }

  Future<void> saveOrUpdateUtmData(
      String? source, String? medium, String? campaign) async {
    final prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    initializeNumberOfDays();

    DateFormat format = DateFormat(GemsGLobals.utmDateFormat);

    DateTime nextDays = now.add(Duration(days: numberOfDays));

    String nextDaysFormattedDate = format.format(nextDays);

     GemsGLobals.utmSource = source;
     GemsGLobals.utmMedium = medium;
     GemsGLobals.utmCampaign = campaign;
    

    final newData = {
      'utm_source': source,
      'utm_medium': medium,
      'utm_campaign': campaign,
      'timestamp': nextDaysFormattedDate,
    };
    await prefs.setString(_utmKey, jsonEncode(newData));
  }

  DateTime? parseTimestamp(String timestampString) {
    try {
      DateFormat format = DateFormat(GemsGLobals.utmDateFormat);
      return format.parse(timestampString);
    } catch (e) {
      DateTime? fallbackTimestamp = DateTime.tryParse(timestampString);

      return fallbackTimestamp;
    }
  }

  bool isCurrentAfterTimestamp(String timestampString) {
    try {
      DateTime? timestamp;

      timestamp = parseTimestamp(timestampString);

      if (timestamp == null) {
        return false;
      }

      DateTime now = DateTime.now();

      bool isAfter = now.isAfter(timestamp);

      return isAfter;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> fetchUtmData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString(_utmKey);

    if (storedData != null) {
      final data = jsonDecode(storedData) as Map<String, dynamic>;
      GemsGLobals.utmSource = data['utm_source'];
      GemsGLobals.utmMedium = data['utm_medium'];
      GemsGLobals.utmCampaign = data['utm_campaign'];

      String? timestampString = data['timestamp'];

      if (timestampString != null) {
        bool isExpired = isCurrentAfterTimestamp(timestampString);

        if (isExpired) {
          await prefs.remove(_utmKey);
          GemsGLobals.utmSource = null;
          GemsGLobals.utmMedium = null;
          GemsGLobals.utmCampaign = null;
          return null;
        } else {
          return data;
        }
      }
      return null;
    }
    return null;
  }

  Future<void> clearUtmData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_utmKey);
  }
}
