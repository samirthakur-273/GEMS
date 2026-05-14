import 'package:gems_revamp/eshop_module_new/cart_details/model/cart_details_model.dart';
import 'package:gems_revamp/eshop_module_new/review_page/review_page_model.dart';

abstract class CartDetailsView {
  void cartDetailResponse(CartDetailsModel addToCartModel);
  void editCartResponse(List<EditProductModel> editProductModel);
  void deleteCartResponse(List<RemoveProductModel> removeProductModel);
  void getshippingmethodresponse(ShippingMethodModel shippingmodel) {}
  void responseFailure(response);
  void onTimeout();
}
