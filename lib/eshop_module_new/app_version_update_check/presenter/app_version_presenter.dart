import 'dart:async';
import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/app_version_update_check/view/app_version_view.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';

class AppVersionPresenter {
  AppVersionView _appVersionView;

  AppVersionPresenter(this._appVersionView);

  void loadAppVersion() {
    var body = {
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode,
    };
    ApiConfig()
        .checkAppVersion(body)
        .then((c) => _appVersionView.appVersionResponse(c))
        .catchError((onError) {
      _appVersionView.appVersionError(onError);
      if (onError is TimeoutException) _appVersionView.onTimeout();
    });
  }
}
