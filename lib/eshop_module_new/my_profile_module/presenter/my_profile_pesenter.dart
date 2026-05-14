import 'dart:async';
import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/my_profile_model.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';

abstract class MyProfileViewContract {
  void onMyProfileViewSuccess(MyProfileModel response);
  void onMyProfileViewError(var error);
  void onProfileTimeout();
}

class MyProfilePresenter {
  MyProfileViewContract _view;
  MyProfilePresenter(this._view);

  getMyProfileData() {
    var request = {
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode,
      "shopuserid": GemsGLobals.custEncryptedId
    };
    ApiConfig()
        .fetchMyProfileData(request)
        .then((c) => _view.onMyProfileViewSuccess(c))
        .catchError((onError) {
      if (onError is TimeoutException) _view.onProfileTimeout();
      _view.onMyProfileViewError(onError);
    });
  }
}
