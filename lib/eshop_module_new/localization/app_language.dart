import 'package:flutter/material.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = Locale('en');

  Locale get appLocal => _appLocale;
  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('language_code') == null) {
      _appLocale = Locale('en');
      Constants.langCode = "1";
      return Null;
    }
    if (prefs.getString('language_code') == 'en') {
      Constants.langCode = "1";
    }
    _appLocale = Locale(prefs.getString('language_code') ?? "");
    if (prefs.getString('language_code') == 'ar') {
      Constants.langCode = "2";
    }
    return Null;
  }

  void changeLanguage(Locale type) async {
    var prefs = await SharedPreferences.getInstance();
    if (_appLocale == type) {
      return;
    }

    if (type == Locale("ar")) {
      _appLocale = Locale("ar");
      await prefs.setString('language_code', 'ar');
      await prefs.setString('countryCode', '');
    } else {
      _appLocale = Locale("en");
      await prefs.setString('language_code', 'en');
      await prefs.setString('countryCode', 'US');
    }
    notifyListeners();
  }
}
