import 'dart:async';

import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_filter_model.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_list_model.dart';
import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';

abstract class ProductListViewContract {
  void onProductListViewSuccess(ProductListModel response);
  void onProductListViewError(var error);
  void onProductSearchViewSuccess(ProductListModel response);
  void onAddToWishListSuccess(AddToWishListModel response, index);
  void onAddToWishListError(var error);
  void onDeleteToWishListSuccess(AddToWishListModel response, index);
  void onFilterDataViewSuccess(ProductFilterModel response);
  void onFilterDataViewError(var error);
  void onListViewChangeSuccess(var listType);
  void onTimeout();
}

class ProductListPresenter {
  ProductListViewContract _view;
  ProductListPresenter(this._view);

  getProductListData(catId, request) {
    ApiConfig()
        .fetchProductListData(catId, request)
        .then((c) => _view.onProductListViewSuccess(c))
        .catchError((onError) {
      _view.onProductListViewError(onError);
      if (onError is TimeoutException) _view.onTimeout();
    });
  }

  changeListType(listType) {
    _view.onListViewChangeSuccess(listType);
  }

  getProductSearchData(request, search) {
    ApiConfig()
        .fetchProductSearchData(request, search)
        .then((c) => _view.onProductSearchViewSuccess(c))
        .catchError((onError) {
      _view.onProductListViewError(onError);
      if (onError is TimeoutException) _view.onTimeout();
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
      _view.onAddToWishListError(onError);
      if (onError is TimeoutException) _view.onTimeout();
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
      _view.onAddToWishListError(onError);
      if (onError is TimeoutException) _view.onTimeout();
    });
  }

  sortProductList(limit, pageno, catId, sortMethod) {
    var body = {
      "category_id": catId,
      "sortfilter": sortMethod,
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode,
      "limit": limit,
      "pageno": pageno,
      "email": GemsGLobals.useremail,
      "shopuserid": GemsGLobals.custEncryptedId ?? "",
      // "customerid": GemsGLobals.custEncryptedId,
    };
    ApiConfig()
        .fetchSortedProductList(body)
        .then((c) => _view.onProductListViewSuccess(c))
        .catchError((onError) {
      _view.onProductListViewError(onError);
      if (onError is TimeoutException) _view.onTimeout();
    });
  }

  sendFilterData(body, catId) {
    ApiConfig()
        .sendproductFilterData(body)
        .then((c) => _view.onProductListViewSuccess(c))
        .catchError((onError) {
      _view.onProductListViewError(onError);
      if (onError is TimeoutException) _view.onTimeout();
    });
  }

  getFilterData(catId) {
    var body = {
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode,
      "limit": "10",
      "pageno": "1",
      "category_id": catId
    };
    ApiConfig()
        .fetchproductFilterData(body, catId)
        .then((c) => _view.onFilterDataViewSuccess(c))
        .catchError((onError) {
      _view.onFilterDataViewError(onError);
      if (onError is TimeoutException) _view.onTimeout();
    });
  }
}
