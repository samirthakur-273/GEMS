import 'dart:async';

import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/eshop_module_new/my_returns_module/Model/my_return_model.dart';
import 'package:gems_revamp/eshop_module_new/api_config.dart';

abstract class MyReturnsViewContract {
  void onMyReturnsViewSuccess(MyReturnsModel response);
  void onMyReturnsViewError(var error);
  void onTimeout();
}

class MyReturnsPresenter {
  MyReturnsViewContract _view;
  MyReturnsPresenter(this._view);

  getMyReturnData() {
    var request = {
      "action": "view",
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode,
      "customer_id": Constants.customerId
    };
    ApiConfig()
        .fetchMyReturnListData(request)
        .then((c) => _view.onMyReturnsViewSuccess(c))
        .catchError((onError) {
      //print(onError);
      _view.onMyReturnsViewError(onError);
      if (onError is TimeoutException) _view.onTimeout();
    });
  }
}
