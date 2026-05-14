import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:gems_revamp/giftcard_module/giftcard_detailspage/giftcard_deatails_model.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/database/giftcard_list_category_helper.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/database/giftcard_list_db_model.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/giftcard_category/giftcardcategory_modal.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/giftcard_voucherlist/giftcard_voucherlist_modal.dart';
import 'package:gems_revamp/giftcard_module/giftcard_thankupage/gfitcard_confirm_model.dart';
import 'package:gems_revamp/giftcard_module/pg_module/pg_modal.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gc_db/gc_list_db_model.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gc_db/gc_list_dbhelper.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gift_purchase_list/gift_purchase_list_model.dart';
import 'package:gems_revamp/utils/constants_files/apiconstants.dart';
import 'package:http/http.dart' as http;

class GiftApiconfig {
  static final header = {"Content-Type": "application/json"};
  static var timeoutrespon = {"status": false, "message": "timeout"};

  static const String API_KEY = //BounzConstants.TP_APPLICATION_KEY;
      'e57c65e7-e64b-4c7a-bb51-1299ba9c9312';
  // static String initpuchase =
  //     "https://apitypuatgems22.clubclass.io/app/api/giftcard/initpurchase/";

  static const String gc_trxn_list = 'transaction/myBookings?';

/* GET Method Funcion*/
  static Future<dynamic> getData(url) async {
    try {
      var header = 'application/json';
      Map<String, String> userheader = {
        'Content-Type': header,
        'API_KEY': API_KEY,
        'Authorization': ApiConstanst.apiAuthorizationToken
      };

      http.Response response = await http
          .get(Uri.parse(url), headers: userheader)
          .timeout(const Duration(seconds: 1000));
      final responseBody = json.decode(response.body);
      final statusCode = response.statusCode;
      if (statusCode != 200 || responseBody == null) {
        throw new TimeoutException(
            "An error ocurred : [Status Code : $statusCode]");
      }

      return responseBody;
    } on TimeoutException catch (e) {
      return timeoutrespon;
    } on SocketException catch (e) {
      return timeoutrespon;
    } on Error catch (e) {
    }
  }

  static Future<dynamic> postDataa(http.Client client, urlPath, params) async {
    var header = 'application/json';
    Map<String, String> userheader = {
      'Content-Type': header,
      'API_KEY': API_KEY,
      'Authorization': ApiConstanst.apiAuthorizationToken
    };
    final response = await client
        .post(Uri.parse(ApiConstanst.giftCardBaseUrl + urlPath),
            body: jsonEncode(params), headers: userheader)
        .catchError((onError) {});

    return jsonDecode(response.body.toString());
  }

  static Future<GiftCategoryModal> getcategoryList(
    http.Client client,
  ) async {
    var response = await getData(
        ApiConstanst.giftCardBaseUrl + "category/list?channel=mobile");

    GiftCategoryModal data = GiftCategoryModal.fromJson(response);

    return data;
  }

  Future<List<GiftCardListDbModel>> getvocherListDataFromDb() {
    var data = GiftCardListDBHelper().getGiftcardListData();
    return data;
  }

  Future<GiftVoucherModal> getVoucherList(
      http.Client client,
      String catName,
      String brandName,
      String search,
      String sort,
      currency,
      country,
      callapi) async {
        final response = await getData(ApiConstanst.giftCardBaseUrl +
            'giftvoucher/list?search=$search&sort=$sort&channel=mobile&brands=$brandName&categories=$catName&currency=$currency&country=$country');
        GiftVoucherModal data = GiftVoucherModal.fromJson(response);
        return data;
  }


  static Future<GiftcardDetailsModal> getDetailsList(
      http.Client client, int brandId, String supplierCode) async {
    final response = await getData(ApiConstanst.giftCardBaseUrl +
        "giftvoucher/details?channel=mobile&giftcard_id=$brandId&supplier_code=$supplierCode");

    GiftcardDetailsModal data = GiftcardDetailsModal.fromJson(response);

    return data;
  }

  // PG init Api
  static Future<GiftPgModal> pgInit(http.Client client, request) async {
    final response =
        await postDataa(client, "transaction/initGVTransaction", request);

    GiftPgModal data = GiftPgModal.fromJson(response);

    return data;
  }

  
  static Future<GiftConfrmModal> pgUpdate(http.Client client, request) async {
    final response =
        // await postDataa(client, "transaction/updatePgTransaction", request);
        await postDataa(client, "transaction/updatePgTransaction", request);

   
    GiftConfrmModal data = GiftConfrmModal.fromJson(response);
    return data;
  }

  /* giftPurchaseListApiCall */

  static Future<List<GiftCardPurchaseListDbModel>>
      getgiftCardPurchaseDataFromDb() {
    var data = GiftCardPurchaseListDBHelper().getGiftcardPurchaseListData();
    return data;
  }

  static Future<GiftCardPurchaseListModel> giftPurchaseListApiCall(
      http.Client client, membershipId, limit) async {
    final giftTransactionDbData =
        getgiftCardPurchaseDataFromDb().then((value) async {
      if (value.length > 0) {
        /* if data available in db */
        return GiftCardPurchaseListModel.fromJson(
            json.decode(value.last.giftcardpurchaselistdata));
      } else {
        final response = await getData(ApiConstanst.giftCardBaseUrl +
            gc_trxn_list +
            'limit=$limit&customer_id=' +
            '$membershipId');

        return GiftCardPurchaseListModel.fromJson(response);
      }
    });
    return giftTransactionDbData;
  }
}
