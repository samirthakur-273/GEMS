import 'dart:async';

import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/view/my_wishlist_view.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';

class MyWishlistPresenter {
  MyWishlistView _myWishlistView;
  MyWishlistPresenter(this._myWishlistView);

  void loadMyWishlistData() {
    var body = {
      "email": GemsGLobals.useremail,
      "shopuserid": GemsGLobals.custEncryptedId,
    };
    ApiConfig()
        .fetchMyWishListData(body)
        .then((c) => _myWishlistView.myWishlistResponse(c))
        .catchError((onError) {
      _myWishlistView.myWishlistError(onError);
      if (onError is TimeoutException) _myWishlistView.onTimeout();
    });
  }
}
