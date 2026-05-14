import 'dart:async';

import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/cart_details_view.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/model/cart_details_model.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';

class CartDetailsPresenter {
  CartDetailsView _cartDetailsView;

  CartDetailsPresenter(this._cartDetailsView);

  void cartDetails() {
    var body = {
      "brandcode": Constants.brandCode,
      "country_code": "main_website_store",
      "lang_code": Constants.langCode,
      "email": GemsGLobals.useremail,
      "shopuserid": GemsGLobals.custEncryptedId,
    };
    // {
    //   "brandcode": Constants.brandCode,
    //   "country_code": Constants.countryCode,
    //   "lang_code": Constants.langCode,
    //   "customerid": Constants.customerId ?? jsonDecode(Constants.guestId),
    // };
    ApiConfig()
        .fetchCartDetails(body)
        .then((c) => _cartDetailsView.cartDetailResponse(c))
        .catchError((onError) {
      //print(onError);
      _cartDetailsView.responseFailure(onError);
      if (onError is TimeoutException) {}
      _cartDetailsView.onTimeout();
    });
  }

  void shippingmethod() {
    ApiConfig()
        .getshippingmethods()
        .then((c) => _cartDetailsView.getshippingmethodresponse(c))
        .catchError((onError) {
      if (onError is TimeoutException) _cartDetailsView.onTimeout();
      _cartDetailsView.responseFailure(onError);
    });
  }

  void editProductCart(body) {
    ApiConfig()
        .editCart(body)
        .then((c) => _cartDetailsView
            .editCartResponse(editProductModelFromJson(c.body.toString())))
        .catchError((onError) {
      _cartDetailsView.responseFailure(onError);
      if (onError is TimeoutException) _cartDetailsView.onTimeout();
    });
  }

  void removeProductCart(body) {
    ApiConfig()
        .deleteCart(body)
        .then((c) => _cartDetailsView
            .deleteCartResponse(removeProductModelFromJson(c.body.toString())))
        .catchError((onError) {
      _cartDetailsView.responseFailure(onError);
      if (onError is TimeoutException) _cartDetailsView.onTimeout();
    });
  }
}
