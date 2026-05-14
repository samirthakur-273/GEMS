import 'package:gems_revamp/eshop_module_new/my_wishlist/model/my_wishlist_delete_model.dart';

abstract class MyWishlistDeleteView {
  void myWishlistDeleteResponse(
      List<MyWishlistDeleteModel> myWishlistDeleteModel, String productId);
  void myWishlistDeleteError(error);
}
