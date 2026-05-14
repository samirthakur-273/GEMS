import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/model/my_wishlist_delete_model.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/view/my_wishlist_delete_view.dart';

class MyWishlistDeletePresenter {
  MyWishlistDeleteView _myWishlistDeleteView;
  MyWishlistDeletePresenter(this._myWishlistDeleteView);

  void deleteMyWishlistData(body, String? productID) {
    ApiConfig().myWishlistDelete(body).then((onValue) {
      _myWishlistDeleteView.myWishlistDeleteResponse(
          wishlistDeleteFromJson(onValue.body.toString()), productID!);
    }).catchError((onError, s) {
      _myWishlistDeleteView.myWishlistDeleteError(onError);
    });
  }
}
