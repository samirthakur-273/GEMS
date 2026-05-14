import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:gems_revamp/eshop_module_new/Shop_home_module/Model/shop_home_model.dart';
import 'package:flutter/foundation.dart';
import 'package:gems_revamp/utils/constants_files/apiconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import 'package:gems_revamp/eshop_module_new/app_version_update_check/model/app_version_model.dart';
import 'package:gems_revamp/eshop_module_new/category_module/Database/category_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/category_module/Model/category_db_model.dart';
import 'package:gems_revamp/eshop_module_new/category_module/Model/category_list_model.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/eshop_module_new/forgot_password/model/forgot_password_model.dart';

import 'package:gems_revamp/eshop_module_new/my_profile_module/Database/my_profile_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/details_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/my_profile_db_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/my_profile_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/my_account_module/update_acc_modal.dart';
import 'package:gems_revamp/eshop_module_new/my_returns_module/Model/my_return_model.dart';
import 'package:gems_revamp/eshop_module_new/order_return_module/Model/order_return_model.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Database/product_filter_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_filter_db_model.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_filter_model.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_list_model.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/Database/cart_details_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/Database/shipping_method_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/model/cart_details_db_model.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/model/cart_details_model.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/model/apply_coupon_model.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/model/payment_card_model.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/Database/my_wishlist_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/model/my_wishlist_db_model.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/model/my_wishlist_model.dart';
import 'package:gems_revamp/eshop_module_new/payment_gateway/token_model.dart';
import 'package:gems_revamp/eshop_module_new/review_page/review_page_model.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_dialog/model/dialog_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Shop_home_module/Database/home_page_db_helper.dart';
import 'Shop_home_module/Model/home_page_db_model.dart';

class ApiConfig {
  static var dbHelper = ProductFilterDBHelper();
  static var dbprofileHelper = MyProfileDBHelper();
  static var dbcatHelper = CategoryPageDBHelper();
  static var dbwishListHelper = MyWishListDBHelper();
  static var dbCartDetailsHelper = CartDetailsDBHelper();

  Future<dynamic> categoryList() async {
    var body = {
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode
    };

    return postData(
      "categorylist/${ApiConstanst.eshopCategtoyId}",
      body,
    );
  }

  Future<dynamic> signInUp(
      String email, String password, String guestId) async {
    var body = {
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode,
      "username": email,
      "password": password,
      "maskedId": guestId
    };
    return postData(
      "customerlogin",
      body,
    );
  }

  Future<dynamic> signUp(
    String firstname,
    String lastname,
    String issubscribed,
    String email,
    String password,
  ) async {
    var body = {
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode,
      "firstname": firstname,
      "lastname": lastname,
      "is_subscribed": issubscribed,
      "email": email,
      "password": password
    };
    return postData(
      "customercreate",
      body,
    );
  }

  Future<dynamic> productReview(String productcode) async {
    var body = {
      "brandcode": "1",
      "country_code": "main_website_store",
      "lang_code": "1"
    };
    return postData(
      "productview/$productcode",
      body,
    );
  }

  Future<dynamic> policyContent(String indentifier) async {
    var body = {
      "brandcode": "1",
      "country_code": "main_website_store",
      "lang_code": "1",
      "identifire": indentifier
    };
    return postData(
      "cmspagecontent",
      body,
    );
  }

  Future<dynamic> recommendedProduct(String productcode) async {
    var body = {
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode,
      "sku": productcode,
      "customerid": Constants.customerId
    };
    return postData(
      "recommended",
      body,
    );
  }

  Future<dynamic> addWishList(String productid, String customerid) async {
    var body = {
      "email": GemsGLobals.useremail,
      "shopuserid": GemsGLobals.custEncryptedId,
      "firstname": GemsGLobals.userFirstName,
      "lastname": GemsGLobals.userLastName,
      "productid": productid
    };
    return postData(
      "addtowhishlist/",
      body,
    );
  }

  Future<dynamic> autosuggest(String searchItem) async {
    var body = {
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode,
      "searchterms": searchItem
    };
    
    return postData(
      "autosuggestdata",
      body,
    );
  }

/* Shipping Details API/DB */
  Future<List<ShippingMethodDbModel>> getShippingDataFromDb() {
    var data = ShippingDetailsDBHelper().getShippingDetailsData();
    return data;
  }

  Future<dynamic> getshippingmethods() async {
    var request = {
      "email": GemsGLobals.useremail,
      "shopuserid": GemsGLobals.custEncryptedId
    };
    // {
    //   "brandcode": Constants.brandCode,
    //   "country_code": Constants.countryCode,
    //   "lang_code": Constants.langCode,
    //   "customerid": Constants?.customerId ?? jsonDecode(Constants.guestId)
    // };
    var updateResponse;
    updateApiResponseTime('shippingapiresponsetime').then((value) async {
      updateResponse = await value;
    });
    final shippingdetailsDataDb = getShippingDataFromDb().then((value) async {
      if (value.length > 0 && updateResponse == false) {
        /* if data available in db */
        return ShippingMethodModel.fromJson(
            json.decode(value.last.shippingMethoddata));
      } else {
        /* else call api */
        var response = await postData('getshippingmethods/', request);
        var responseBody =
            ShippingMethodModel.fromJson(json.decode(response.body)[0]);
        /* update updateresponse value in model*/
        responseBody.updateResponse = true;
        return responseBody;
      }
    });
    return shippingdetailsDataDb;
  }

  /* Forgot Password API */
  Future<ForgotPasswordModel> forgotPassword(request) async {
    var response = await postData('forgotpassword', request);
    ForgotPasswordModel list =
        ForgotPasswordModel.fromJson(json.decode(response.body)[0]);
    return list;
  }

  Future<CreateReturnSuccess> sendOrderReturnData(body) async {
    var response = await postData('returnoperations', body);
    CreateReturnSuccess list =
        CreateReturnSuccess.fromJson(json.decode(response.body)[0]);
    return list;
  }

  Future<DialogModel> dialogSaveMoney(body) async {
    var response = await postData('newsletter', body);
    DialogModel list = DialogModel.fromJson(json.decode(response.body)[0]);
    return list;
  }

  Future<AddToWishListModel> addToWishList(body) async {
    var response = await postData('addtowhishlist/', body);
    AddToWishListModel list =
        AddToWishListModel.fromJson(json.decode(response.body)[0]);
    return list;
  }

  Future<AddToWishListModel> deleteFromWishList(body) async {
    var response = await postData('deletewhishlist/', body);
    AddToWishListModel list =
        AddToWishListModel.fromJson(json.decode(response.body)[0]);
    return list;
  }

/* My Wishlist API/DB */
  Future<List<MyWishListDbModel>> getWishListDataFromDb() {
    var data = dbwishListHelper.getMyWishListData();
    return data;
  }

  Future<dynamic> fetchMyWishListData(request) async {
    var updateResponse;
    updateApiResponseTime('wishlistapiresponsetime').then((value) async {
      updateResponse = await value;
    });
    final wishlistDataDb = getWishListDataFromDb().then((value) async {
      if (value.length > 0 && updateResponse == false) {
        /* if data available in db */
        return MyWishlistModel.fromJson(json.decode(value.last.mywishlistdata));
      } else {
        /* else call api */
        var response = await postData('viewwhishlist/', request);
        var responseBody =
            MyWishlistModel.fromJson(json.decode(response.body)[0]);
        /* update updateresponse value in model*/
        responseBody.updateResponse = true;
        return responseBody;
      }
    });
    return wishlistDataDb;
  }

  Future<dynamic> myWishlistDelete(body) async {
    var response = await postData('deletewhishlist/', body);
    return response;
  }

  Future<dynamic> addToCart(body) async {
    return postData(
      "addtocart/",
      body,
    );
  }

  Future<dynamic> dialogContentDisplay(body) async {
    return postData(
      "newsletter",
      body,
    );
  }

  Future<dynamic> orderTrack(body) async {
    return postData(
      "ordertracking",
      body,
    );
  }

  Future<dynamic> checkout(body) async {
    return postData(
      "placeorder/",
      body,
    );
  }

  Future<dynamic> orderstatusupdate(body) async {
    return postData("orderstatusupdate/", body);
  }

  Future<dynamic> getpaymentMethods(body) async {
    return postData(
      "getpaymentmethods/",
      body,
    );
  }

  Future<dynamic> applystorecredit(body) async {
    return postData(
      "storecredit/",
      body,
    );
  }

  Future<dynamic> loggedincustomeraddresses(body) async {
    return postData(
      "viewaddressinfo/",
      body,
    );
  }

  Future<dynamic> myOrderDetail(body) async {
    return postData(
      "orderinfodetails",
      body,
    );
  }

  Future<dynamic> myOrderCancel(body) async {
    return postData(
      "orderoperations",
      body,
    );
  }

  Future<dynamic> cityResp(body) async {
    return postData(
      "fetchcheckoutfileds",
      body,
    );
  }

  Future<dynamic> editaddress(body) async {
    return postData("editaddress/", body);
  }

  Future<dynamic> deleteaddress(body) async {
    return postData("deleteaddress/", body);
  }

  Future<dynamic> addAddress(body) async {
    return postData("adddeliveryaddress/", body);
  }

/* CartDetails API/DB */
  Future<List<CartDetailsDbModel>> getCartDataFromDb() {
    var data = dbCartDetailsHelper.getCartDetailsData();
    return data;
  }

  Future<dynamic> fetchCartDetails(request) async {
    var updateResponse;
    updateApiResponseTime('cartapiresponsetime').then((value) async {
      updateResponse = await value;
    });

    final cartdetailsDataDb = getCartDataFromDb().then((value) async {
      if (value.length > 0 && updateResponse == false) {
        /* if data available in db */
        return CartDetailsModel.fromJson(
            json.decode(value.last.cartdetailsdata));
      } else {
        /* else call api */
        var response = await postData('cartdetails/', request);
        var responseBody =
            CartDetailsModel.fromJson(json.decode(response.body)[0]);
        /* update updateresponse value in model*/
        responseBody.updateResponse = true;
        return responseBody;
      }
    });
    return cartdetailsDataDb;
  }

  Future<dynamic> editCart(body) {
    return postData("editproduct/", body);
  }

  Future<dynamic> deleteCart(body) {
    return postData("removeproduct/", body);
  }

  static var timeoutrespon = {"status": false, "message": "timeout"};

  static Future<dynamic> postData(urlPath, [body]) async {
    Map<String, String> userheader = {
      "Authorization": ApiConstanst.authorizationEshopKey,
      "Content-Type": "application/json"
    };

    try {
      final response = await http.Client().post(
          Uri.parse(ApiConstanst.eShopBaseUrl + urlPath),
          body: body == null ? json.encode({}) : json.encode(body),
          headers: userheader);
      print(json.encode(body));

      if (kDebugMode) print(response.body + 'post-----------body');
     

      // if (kDebugMode)
       return response;
    } on TimeoutException catch (e) {
      if (kDebugMode) //print('Timeout');
        rethrow;
      //return timeoutrespon;
    } on Error catch (e) {
      if (kDebugMode) {}
    }
  }

  /* Apply Coupon API */
  Future<ApplyCouponModel> applyCouponData(request) async {
    var response = await postData('applycoupon', request);
    ApplyCouponModel list =
        ApplyCouponModel.fromJson(json.decode(response.body)[0]);
    return list;
  }

  /* Product Sort List API */
  Future<ProductListModel> fetchSortedProductList(request) async {
    var response = await postData('sortingcollection/', request);
    ProductListModel list =
        ProductListModel.fromJson(json.decode(response.body)[0]);
    return list;
  }

  Future<List<HomePageDbModel>> getHomePageDataFromDb() {
    var data = HomePageDBHelper().getHomePageData();
    return data;
  }

  getWishlistData(responseBody) {
    final getWishListData = getWishListDataFromDb().then((value) async {
      if (value.length > 0) {
        MyWishlistModel mylist;
        mylist =
            MyWishlistModel.fromJson(json.decode(value.last.mywishlistdata));
        responseBody.bestseller.items.asMap().forEach((index, product) {
          mylist.viewWishlist?.forEach((element) {
            if (product.sku == element.sku) {
              responseBody.bestseller.items[index].dbIsWishList = true;
            }
          });
        });
      }
      return responseBody;
    });
    return getWishListData;
  }

  /* Shop Home API */
  Future<ShopHomeModel> fetchShopHomeData() async {
    var updateResponse;
    updateApiResponseTime('homeapiresponsetime').then((value) async {
      updateResponse = await value;
    });
    final homepageDataDb = await getHomePageDataFromDb().then((value) async {
      if (value.length > 0 && updateResponse == false) {
        /* if data available in db */
        var responseBody =
            ShopHomeModel.fromJson(json.decode(value.last.homepagedata));
        return getWishlistData(responseBody);
      } else {
        /* else call api */
        var response = await postData(
            'homescreen/${ApiConstanst.eshopCategtoyId}', null);

        var responseBody =
            ShopHomeModel.fromJson(json.decode(response.body)[0]);
        /* update updateresponse value in model*/
        responseBody.updateResponse = true;

        return getWishlistData(responseBody);
      }
    });

    return homepageDataDb;
  }

  Future<List<ProductFilterDataModel>> getFilterDataFromDb() {
    var data = dbHelper.getFilterData();
    return data;
  }

  /* Product Filter Databse/API */
  Future<dynamic> fetchproductFilterData(request, catId) async {
    final filterDataDb = getFilterDataFromDb().then((value) async {
      if (value.length > 0) {
        /* in case of different category id truncate table and call api*/
        if (catId !=
            ProductFilterModel.fromJson(json.decode(value.last.filterdata))
                .catId) {
          dbHelper.truncatefilterData();
          var response = await postData('filterlistinfo/', request);
          return ProductFilterModel.fromJson(json.decode(response.body)[0]);
        } else {
          /* if data available in db with the same category id*/
          return ProductFilterModel.fromJson(
              json.decode(value.last.filterdata));
        }
      } else {
        /* else call api */
        var response = await postData('filterlistinfo/', request);
        return ProductFilterModel.fromJson(json.decode(response.body)[0]);
      }
    });

    return filterDataDb;
  }

  /*  Filter result API */
  Future<ProductListModel> sendproductFilterData(request) async {
    var response = await postData('filtercollectiondata/', request);
    ProductListModel list =
        ProductListModel.fromJson(json.decode(response.body)[0]);
    return list;
  }

  /* Product List API */
  Future<ProductListModel> fetchProductListData(catId, request) async {
    MyWishlistModel mylist;
    var response = await postData('productlist/' + catId, request);
    var responseBody = ProductListModel.fromJson(json.decode(response.body)[0]);
    final getProductListData = getWishListDataFromDb().then((value) async {
      if (value.length > 0) {
        mylist =
            MyWishlistModel.fromJson(json.decode(value.last.mywishlistdata));
        responseBody.items!.asMap().forEach((index, product) {
          mylist.viewWishlist?.forEach((element) {
            if (product.sku == element.sku) {
              responseBody.items?[index].dbIsWishList = true;
            }
          });
        });
      }
      return responseBody;
    });

    return getProductListData;
  }

  /* Product Search API */
  Future<ProductListModel> fetchProductSearchData(request, search) async {
    var response = await postData('productsearch/' + search, request);
    ProductListModel list =
        ProductListModel.fromJson(json.decode(response.body)[0]);
    return list;
  }

  Future<TokenModel> createToken(body) async {
    var jsonBody = jsonEncode(body);

    var head = {
      HttpHeaders.authorizationHeader: Constants.PGPublicKey,
      HttpHeaders.contentTypeHeader: "application/json"
    };
    final response = await http.post(Uri.parse(Constants.PGApiUrl + "tokens"),
        headers: head, body: jsonBody);

    if (response.statusCode == 201) {
      final String responseString = response.body;

      return tokenModelFromJson(responseString);
    } else {
      return tokenModelFromJson(null.toString());
    }
  }

  Future<PaymentCardModel> paymentByCard(body) async {
    var jsonBody = jsonEncode(body);

    Map<String, String> userheader = {
      "Authorization": ApiConstanst.authorizationEshopKey,
      "Cko-Authorization": Constants.PGPublicKey,
      "Content-Type": "application/json"
    };
    final response = await http.post(Uri.parse(Constants.PGApiUrlPayment),
        headers: userheader, body: jsonBody);

    if (response.statusCode == 201) {
      final String responseString = response.body;

      return paymentCardModelFromJson(responseString);
    } else {
      final String responseString = response.body;

      return paymentCardModelFromJson(responseString);
    }
  }

  /* My Returns API */
  Future<MyReturnsModel> fetchMyReturnListData(request) async {
    var response = await postData('returnoperations', request);
    MyReturnsModel list =
        MyReturnsModel.fromJson(json.decode(response.body)[0]);

    return list;
  }

  /* App Version API */
  Future<AppVersionModel> checkAppVersion(request) async {
    var response = await postData('appversion', request);

    AppVersionModel list =
        AppVersionModel.fromJson(json.decode(response.body)[0]);
    return list;
  }

  /* My Profile API/DB */
  Future<List<MyProfileDataModel>> getProfileDataFromDb() {
    var data = dbprofileHelper.getMyProfileData();
    return data;
  }

  Future<dynamic> fetchMyProfileData(request) async {
    var updateResponse;
    updateApiResponseTime('profileapiresponsetime').then((value) async {
      updateResponse = await value;
    });
    final profileDataDb = getProfileDataFromDb().then((value) async {
      if (value.length > 0 && updateResponse == false) {
        /* if data available in db */
        return MyProfileModel.fromJson(json.decode(value.last.profiledata));
      } else {
        /* else call api */
        var response = await postData('customer/dashboard', request);
        var responseBody =
            MyProfileModel.fromJson(json.decode(response.body)[0]);
        /* update updateresponse value in model*/
        responseBody.updateResponse = true;
        return responseBody;
      }
    });

    return profileDataDb;
  }

  /* My Details API */
  Future<DetailsModel> fetchMyDetailsData() async {
    var request = {
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode,
      "shopuserid": GemsGLobals.custEncryptedId ?? "0",
      "masked_id": ""
    };

    var response = await postData('header_footer', request);
    DetailsModel list = DetailsModel.fromJson(json.decode(response.body)[0]);
    return list;
  }

  static Future<dynamic> deleteAddress(http.Client client, body) async {
    var jsonBody = jsonEncode(body);

    Map<String, String> userheader = {
      "Authorization": "Bearer 7spvcpr3t4s4ufxhblugrazg8gxs2yjl",
      "Content-Type": "application/json"
    };
    final response = await http.post(
        Uri.parse(ApiConstanst.eShopBaseUrl + "customeradressoperation"),
        headers: userheader,
        body: jsonBody);
    if (response.statusCode == 200) {
      return "true";
    } else {
      return "false";
    }
  }

  /* Category List API/DB */
  Future<List<CategoryDbModel>> getCategoryDataFromDb() {
    var data = dbcatHelper.getCategoryData();
    return data;
  }

  Future<dynamic> fetchCategoryListData() async {
    var request = {
      "brandcode": "1",
      "country_code": "main_website_store",
      "lang_code": "1"
    };
    var updateResponse;
    updateApiResponseTime('catapiresponsetime').then((value) async {
      updateResponse = await value;
    });
    final categoryData = getCategoryDataFromDb().then((value) async {
      if (value.length > 0 && updateResponse == false) {
        return CategoryListModel.fromJson(json.decode(value.last.categorydata));
      } else {
        var response = await postData(
            'categorylist/${ApiConstanst.eshopCategtoyId}', request);
        var responseBody =
            CategoryListModel.fromJson(json.decode(response.body)[0]);
        responseBody.updateResponse = true;
        return responseBody;
      }
    });

    return categoryData;
  }
  //
  // Future<List<HomePageDbModel>> getHomePageDataFromDb() {
  //   var data = dbhomeHelper.getHomePageData();
  //   return data;
  // }

  updateApiResponseTime(apiresponsetime) async {
    var prefs = await SharedPreferences.getInstance();
    var time = prefs.getString(apiresponsetime);
    var timeDiff = time != null
        ? DateTime.now().difference(DateTime.parse(time)).inMinutes
        : 0;
    if (timeDiff >= Constants.responseUpdatetime) {
      return true;
    }
    return false;
  }

// update user info APi
  Future<UpdateDataModal> profileUpdate(request) async {
    var response = await postData('customer/profile_update', request);
    UpdateDataModal list =
        UpdateDataModal.fromMap(json.decode(response.body)[0]);
    return list;
  }
}
