import 'package:gems_revamp/eshop_module_new/product_detail/model/add_to_cart_model.dart';
import 'package:gems_revamp/eshop_module_new/product_detail/model/product_detail_model.dart';

abstract class ProductDetailsView {
  void productdeatilsResponse(List<ProductDetails> productDetails);
  void productaddWishListResponse(
      List<WishList> addWishlist, String productid, String quoteItemId);
  void addToCartResponse(List<AddToCartModel> addToCartModel, String productId);
  void recommendedProductResponse(List<YouMaLikeModel> youmaylike);
  void responseFailure(response);
  void onTimeout();
}
