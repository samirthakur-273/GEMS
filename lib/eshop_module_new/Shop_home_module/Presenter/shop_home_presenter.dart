import 'dart:async';

import 'package:gems_revamp/eshop_module_new/Shop_home_module/Model/shop_home_model.dart';
import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_list_model.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';

abstract class ShopHomeViewContract {
  void onShopHomeViewSuccess(ShopHomeModel response);
  void onShopHomeViewError(var error);
  void onAddToWishListSuccess(AddToWishListModel response, index);
  void onAddToWishListError(var error);
  void onDeleteToWishListSuccess(AddToWishListModel response, index);
  void onTimeout();
}

class ShopHomeViewPresenter {
  ShopHomeViewContract _view;
  ShopHomeViewPresenter(this._view);

  getShopHomeData() {
    ApiConfig().fetchShopHomeData().then((c) {
      _view.onShopHomeViewSuccess(c);
    }).catchError((onError, s) {
      if (onError is TimeoutException) _view.onTimeout();
      _view.onShopHomeViewError(s);
    });
  }

  addToWishList(productId, index) {
    var body = {
      "email": GemsGLobals.useremail,
      "shopuserid": GemsGLobals.custEncryptedId,
      "firstname": GemsGLobals.userFirstName,
      "lastname": GemsGLobals.userLastName,
      "productid": productId
    };
    ApiConfig()
        .addToWishList(body)
        .then((c) => _view.onAddToWishListSuccess(c, index))
        .catchError((onError) {
      if (onError is TimeoutException) _view.onTimeout();
      _view.onAddToWishListError(onError);
    });
  }

  deleteFromWishList(productId, index) {
    var body = {
      "productId": productId,
      "email": GemsGLobals.useremail,
      "shopuserid": GemsGLobals.custEncryptedId,
    };

    ApiConfig()
        .deleteFromWishList(body)
        .then((c) => _view.onDeleteToWishListSuccess(c, index))
        .catchError((onError) {
      if (onError is TimeoutException) _view.onTimeout();
      _view.onAddToWishListError(onError);
    });
  }
}
