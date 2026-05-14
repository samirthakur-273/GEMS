import 'dart:async';

import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/product_detail/model/add_to_cart_model.dart';
import 'package:gems_revamp/eshop_module_new/product_detail/model/product_detail_model.dart';
import 'package:gems_revamp/eshop_module_new/product_detail/product_detail_view.dart';

class ProductDetailsPresenter {
  ProductDetailsView _productDetailsView;

  ProductDetailsPresenter(this._productDetailsView);
  void productdetails(String? productcode) {
    ApiConfig().productReview(productcode!).then((response) {
      _productDetailsView.productdeatilsResponse(
          productDetailsFromJson(response.body.toString()));
    }).catchError((onError, s) {
      if (onError is TimeoutException) {
        _productDetailsView.onTimeout();
      } else {
        _productDetailsView.responseFailure(onError);
      }
    });
  }

  recommendedProduct(String productcode) {
    ApiConfig().recommendedProduct(productcode).then((response) {
      _productDetailsView.recommendedProductResponse(
          youMaLikeModelFromJson(response.body.toString()));
    }).catchError((onError) {
      if (onError is TimeoutException) {
        _productDetailsView.onTimeout();
      } else {
        _productDetailsView.responseFailure(onError);
      }
    });
  }

  void addWishList(String productid, String customerid, String quoteItemId) {
    ApiConfig().addWishList(productid, customerid).then((response) {
      _productDetailsView.productaddWishListResponse(
          wishListFromJson(response.body.toString()), productid, quoteItemId);
    }).catchError((onError) {
      if (onError is TimeoutException) {
        _productDetailsView.onTimeout();
      } else {
        _productDetailsView.responseFailure(onError);
      }
    });
  }

  void addToCart(body, String? productId) {
    ApiConfig().addToCart(body).then((response) {

      _productDetailsView.addToCartResponse(
          addToCartModelFromJson(response.body.toString()), productId!);
    }).catchError((onError) {
      if (onError is TimeoutException) {
        _productDetailsView.onTimeout();
      } else {
        _productDetailsView.responseFailure(onError);
      }
    });
  }
}
