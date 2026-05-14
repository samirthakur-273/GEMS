import 'package:gems_revamp/eshop_module_new/my_wishlist/model/my_wishlist_model.dart';

abstract class MyWishlistView {
  void myWishlistResponse(MyWishlistModel myWishlistModel);
  void myWishlistError(error);
  void onTimeout();
}
