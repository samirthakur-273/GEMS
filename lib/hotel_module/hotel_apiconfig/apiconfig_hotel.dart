import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:gems_revamp/hotel_module/hotel_detail/hotel_detail_model.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/hotel_desti_model.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/hotel_popular_searh_city_db/popularcity_helper.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/hotel_popular_searh_city_db/popularcitydb_model.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/popular_city_model.dart';
import 'package:gems_revamp/hotel_module/hotel_list/hotel_sort_filter/hotel_filter_model.dart';
import 'package:gems_revamp/hotel_module/hotel_review/model_hotelreview.dart';
import 'package:gems_revamp/hotel_module/send_email_mvp/share_email_model.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hlt_db/hlt_db_model.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hlt_db/hlt_dbhelper.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_details/purchaseOrder_model.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_list/hotel_purchase_list_model.dart';
import 'package:gems_revamp/hotel_module/hotel_list/hotel_list_data/hotel_list_model.dart';
import 'package:gems_revamp/utils/apiconfig.dart';
import 'package:gems_revamp/utils/constants_files/apiconstants.dart';
import 'package:http/http.dart' as http;

class HotelApiconfig {
  static var hotel_tp_appkey = "6ad6ce68-0816-4ca5-9b89-5177e2bd9185";

  static Future<dynamic> post(url, [params]) async {
    try {
      http.Response response = await http
          .post(
            Uri.parse(ApiConstanst.hotelBaseURL + url),
            headers: {
              "Content-Type": ApiConstanst.contentjson,
              "TP_APPLICATION_KEY": hotel_tp_appkey,
              'Authorization': ApiConstanst.apiAuthorizationToken
            },
            body: params != null ? json.encode(params) : null,
          )
          .timeout(const Duration(seconds: 120));

      final responseBody = json.decode(response.body);
      final statusCode = response.statusCode;
      if (statusCode != 200 || responseBody == null) {}
      return responseBody;
    } on TimeoutException catch (e) {
      return Apiconfig.timeoutrespon;
    } on SocketException catch (e) {
      return Apiconfig.timeoutrespon;
    } on Error catch (e) {
      
    }
  }

  static var header = {
    "Content-Type": ApiConstanst.contentjson,
    "TP_APPLICATION_KEY": hotel_tp_appkey,
    "Authorization": ApiConstanst.apiAuthorizationToken
  };

/* Function for GET Method*/
  static Future<dynamic> getMethod(url, [params]) async {
    try {
      http.Response response = await http
          .get(
            Uri.parse(ApiConstanst.hotelBaseURL + url),
            headers: header,
          )
          .timeout(const Duration(seconds: 120));


      final responseBody = json.decode(response.body);
      final statusCode = response.statusCode;
      if (statusCode != 200 || responseBody == null) {
        throw new TimeoutException(
            "An error ocurred : [Status Code : $statusCode]");
      }
      return responseBody;
    } on TimeoutException catch (e) {
      return Apiconfig.timeoutrespon;
    } on SocketException catch (e) {
      return Apiconfig.timeoutrespon;
    } on Error catch (e) {

    }
  }



  Future<List<PopularCityListDbModel>> getHTLPopularListData() {
    var data = HotelPopularCityListDBHelper().getpopularCityListData();

    return data;
  }

  Future<PopularCityHotelModel> popularCityHotel(http.Client client) async {
    final htlPopularListDBData = getHTLPopularListData().then((value) async {
      if (value.length > 0) {
        /* if data available in db */
        return PopularCityHotelModel.fromJson(
            json.decode(value.last.popularcitydata));
      } else {
        final response = await getMethod("get_popular_city");

        return PopularCityHotelModel.fromJson(response);
      }
    });
    return htlPopularListDBData;
  }

  static Future<AutoSuggestHotelModel> autoSuggestHotelsApi(
      http.Client client, searchText) async {
    final response = await getMethod("autosuggest?keyword=$searchText");
    AutoSuggestHotelModel data = AutoSuggestHotelModel.fromJson(response);
    return data;
  }

  /*Hotel list api*/
  static Future<HotelListModel> hotelListing(
      http.Client client, request) async {
    final response =
        await post("search", request).timeout(Duration(seconds: 60));

    HotelListModel data = HotelListModel.fromJson(response);

    return data;
  }

  /*Hotel detail api*/
  static Future<HoteldetailModel> hotelDetailApi(
      http.Client client, reqbody) async {
    final response =
        await post("hotel_details", reqbody).timeout(Duration(seconds: 40));
    HoteldetailModel data = HoteldetailModel.fromJson(response);
    return data;
  }

  // Hotel Filter Count api
  static Future<FilterCount> getfilterDataApi(
      http.Client client, reqbody) async {
    final response =
        await post("getFilterData", reqbody).timeout(Duration(seconds: 40));
    FilterCount data = FilterCount.fromMap(response);
    return data;
  }

  // Hotel sort filter api
  static Future<HotelListModel> updateFilterApi(
      http.Client client, reqbody) async {
    final response =
        await post("updateFilters", reqbody).timeout(Duration(seconds: 40));
   
    HotelListModel data = HotelListModel.fromJson(response);
    return data;
  }

  /* hotelPurchaseListApiCall */

  static Future<List<HotelPurchaseListDbModel>> getHLTPurchaseListDataFromDb() {
    var data = HotelPurchaseListDBHelper().getHLTPurchaseListData();
    return data;
  }

  static Future<HotelPurchaseListModel> hotelPurchaseListApiCall(
      http.Client client, memberId) async {
    final hltTransactionDbData =
        getHLTPurchaseListDataFromDb().then((value) async {
      if (value.length > 0) {
        /* if data available in db */
        return HotelPurchaseListModel.fromJson(
            json.decode(value.last.hotelspurchaselistdata));
      } else {
        /* else call api */
        final response = await getMethod('customer_trxn_list?ccod=$memberId');

        return HotelPurchaseListModel.fromJson(response);
      }
    });
    return hltTransactionDbData;
  }

  static var timeoutrespon = {"status": false, "message": "timeout"};
  static Future<dynamic> postData(http.Client client, urlPath, params) async {
    
    try {
      final responsee = await client.post(
          Uri.parse(ApiConstanst.hotelBaseURL + urlPath),
          body: params,
          headers: {
            "Content-Type": "application/json",
            "TP_APPLICATION_KEY": '6ad6ce68-0816-4ca5-9b89-5177e2bd9185',
            'Authorization': ApiConstanst.apiAuthorizationToken
          }).timeout(const Duration(seconds: 45));
     
      return jsonDecode(responsee.body);
    } on TimeoutException catch (e) {
      
      return timeoutrespon;
    } on Error catch (e) {
    }
  }

  /*share via email Api */
  static Future<ShareViaEmailModel> shareviaemail(
      http.Client client, bookingNo, type) async {
    http.Response response = await http.get(
      Uri.parse(ApiConstanst.hotelBaseURL +
          "share_via_email?booking_ref_no=$bookingNo"),
      headers: {
        "Content-Type": ApiConstanst.contentjson,
        "TP_APPLICATION_KEY": ApiConstanst.tpppkey,
        'Authorization': ApiConstanst.apiAuthorizationToken
      },
    ).timeout(const Duration(seconds: 120));

    final responseBody = json.decode(response.body);
    final statusCode = response.statusCode;
    if (statusCode != 200 || responseBody == null) {
      throw new TimeoutException(
          "An error ocurred : [Status Code : $statusCode]");
    }

    ShareViaEmailModel data = ShareViaEmailModel.fromMap(responseBody);
    return data;
  }

  static Future<ReviewDetail> createorder(http.Client client, request) async {
    final response =
        await postData(http.Client(), "create_order", jsonEncode(request));

    ReviewDetail data = ReviewDetail.fromJson(response);

    return data;
  }

  static Future<dynamic> postHotelpurchaseorde(url, [header, params]) async {
    try {
     
      http.Response response = await http
          .post(
            Uri.parse(url),
            body: json.encode(params),
            headers: header,
          )
          .timeout(const Duration(seconds: 40));

      final responseBody = json.decode(response.body);

      return responseBody;
    } on TimeoutException catch (e) {
      return timeoutrespon;
    } on SocketException catch (e) {
      return timeoutrespon;
    } on Error catch (e) {

    }
  }

  static Future<PurchaseOrderModal> purchaseOrders(
      http.Client client, request) async {
    var header = {
      "Content-Type": ApiConstanst.contentjson,
      "TP_APPLICATION_KEY": ApiConstanst.tpppkey,
      'Authorization': ApiConstanst.apiAuthorizationToken
    };
  
    final response = await postHotelpurchaseorde(
        "${ApiConstanst.hotelBaseURL}purchase_order", header, request);



    PurchaseOrderModal data = PurchaseOrderModal.fromJson(response);
    return data;
  }

  static Future<PurchaseOrderModal> getHotelpurchaseDetails(brfNo) async {
    var header = {
      "Content-Type": ApiConstanst.contentjson,
      "TP_APPLICATION_KEY": ApiConstanst.tpppkey,
      'Authorization': ApiConstanst.apiAuthorizationToken
    };

    var response =
        await getMethod("customer_trxn_details?cp_brf_no=$brfNo", header);



    return PurchaseOrderModal.fromJson(response);
  }
}
