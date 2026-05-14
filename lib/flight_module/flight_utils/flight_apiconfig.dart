import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gems_revamp/flight_module/flightBookingConfirmation/flight_booking_confimr_model.dart';
import 'package:gems_revamp/flight_module/flightBookingConfirmation/send_email_mvp/share_email_model.dart';
import 'package:gems_revamp/flight_module/flight_details/details_modal.dart';
import 'package:gems_revamp/flight_module/flight_details/return_jr_details_modal.dart';
import 'package:gems_revamp/flight_module/flight_review_iternery/create_ord_modal.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/return_srch_modal.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/search_list_model.dart';
import 'package:gems_revamp/flight_module/flight_source_destination/flight_popular_searh_city_db/popular_city_list_db_model.dart';
import 'package:gems_revamp/flight_module/flight_source_destination/flight_popular_searh_city_db/popular_city_list_dbhelper.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flight_purchase_list/flight_purchase_list_model.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flt_db/flt_list_db_model.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flt_db/flt_list_dbhelper.dart';
import 'package:gems_revamp/utils/constants_files/apiconstants.dart';
import 'package:http/http.dart' as http;

import 'package:gems_revamp/flight_module/flight_source_destination/flight_search_city_model.dart';
import 'package:gems_revamp/utils/apiconfig.dart';

class FlightApiConfig {
  static const String poupularCityList = 'get_popular_city';
  static const String flightPurchaseList = 'customer_trxn_list?ccod=';
  static const String flightPurchaseDetails = 'customer_trxn_data?cp_brf_no=';

  static final _header = {
    "Content-Type": "application/json",
    "TP_APPLICATION_KEY": '6ad6ce68-0816-4ca5-9b89-5177e2bd9185',
    'Authorization': ApiConstanst.apiAuthorizationToken
  };

  static Future<dynamic> post(url, [params]) async {
    try {
      http.Response response = await http
          .post(
            Uri.parse(ApiConstanst.flightBaseUrl + url),
            headers: _header,
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

/* Function for GET Method*/
  static Future<dynamic> getMethod(url, [params]) async {
    try {
      http.Response response = await http.get(
        Uri.parse(url),
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

      return responseBody;
    } on TimeoutException catch (e) {
      return Apiconfig.timeoutrespon;
    } on SocketException catch (e) {
      return Apiconfig.timeoutrespon;
    } on Error catch (e) {}
  }

  /* source destination auto suggest API*/

  static Future<FlightSearchCityModel> autoSuggest(
      http.Client client, searchText) async {
    final response = await getMethod(
        ApiConstanst.flightBaseUrl + "autosuggest?keyword=$searchText");
    FlightSearchCityModel data = FlightSearchCityModel.fromJson(response);
    return data;
  }

  Future<List<PopularCityListDbModel>> getFLTPopularListData() {
    var data = FltPopularCityListDBHelper().getFltPopularCityListData();

    return data;
  }

/* Popular city list UAT */
  Future<FlightSearchCityModel> popularCityApi(http.Client client) async {
    final fltPopularListDBData = getFLTPopularListData().then((value) async {
      if (value.length > 0) {
        /* if data available in db */
        return FlightSearchCityModel.fromJson(
            json.decode(value.last.fltpopularlistdata));
      } else {
        final response =
            await getMethod(ApiConstanst.flightBaseUrl + poupularCityList);

        return FlightSearchCityModel.fromJson(response);
      }
    });
    return fltPopularListDBData;
  }

  static Future<FlightSearchListModel> searchResultApi(
      http.Client client, request) async {
    final response =
        await post("search", request).timeout(Duration(seconds: 40));

    FlightSearchListModel data = FlightSearchListModel.fromJson(response);

    return data;
  }

  static Future<ReturnSearchListModal> retsearchResultApi(
      http.Client client, request) async {
    final response =
        await post("search", request).timeout(Duration(seconds: 40));

    ReturnSearchListModal data = ReturnSearchListModal.fromJson(response);
    return data;
  }

  static Future<FlightSearchListModel> filterApi(
      http.Client client, request) async {
    final response =
        await post("filters", request).timeout(Duration(seconds: 40));

    FlightSearchListModel data = FlightSearchListModel.fromJson(response);
    return data;
  }

  static Future<ReturnSearchListModal> filterRetrnApi(
      http.Client client, request) async {
    final response =
        await post("filters", request).timeout(Duration(seconds: 40));

    ReturnSearchListModal data = ReturnSearchListModal.fromJson(response);
    return data;
  }

  static Future<DetailsFlightModel> flightdetailsApi(
      http.Client client, request) async {
    final response =
        await post("flight_details", request).timeout(Duration(seconds: 120));
     DetailsFlightModel data = DetailsFlightModel.fromJson(response);
    return data;
  }

/* Api for return Journey */
  static Future<ReturnJrnyDetailsFlightModel> returnFlightDetailsApi(
      http.Client client, request) async {
    final response =
        await post("flight_details", request).timeout(Duration(seconds: 120));
   ReturnJrnyDetailsFlightModel data =
        ReturnJrnyDetailsFlightModel.fromJson(response);
    return data;
  }

  /* */

  static Future<List<FLTPurchaseListDbModel>> getFLTPurchaseListDataFromDb() {
    var data = FLTPurchaseListDBHelper().getFLTPurchaseListData();
    return data;
  }

  static Future<FlightPurchaseListModel> fltPurchaseListApiCall(
      http.Client client, membershipId) async {
    final fltTransactionDbData =
        getFLTPurchaseListDataFromDb().then((value) async {
      if (value.length > 0) {
        /* if data available in db */
        return FlightPurchaseListModel.fromJson(
            json.decode(value.last.fltpurchaselistdata));
      } else {
        /* else call api */

        final response = await getMethod(
            ApiConstanst.flightBaseUrl + flightPurchaseList + '$membershipId ');

        return FlightPurchaseListModel.fromJson(response);
      }
    });
    return fltTransactionDbData;
    /* Api for Single Journey */
  }

  /* Api for create order */
  static Future<FlightCreateOrderModal> createOrder(
      http.Client client, request) async {
   final response =
        await post("create_order", request).timeout(Duration(seconds: 120));

    FlightCreateOrderModal data = FlightCreateOrderModal.fromJson(response);
    return data;
  }

  static Future<FlightPurchaseOrderModel> purchaseOrder(
      http.Client client, request) async {
   final response =
        await post("purchase_order", request).timeout(Duration(seconds: 120));

    FlightPurchaseOrderModel data = FlightPurchaseOrderModel.fromJson(response);
    return data;
  }

  /* Purchase Order Details Api */

  static Future<FlightPurchaseOrderModel> flightPurchaseDetailsApi(
      http.Client client, brfNo) async {
    final response = await getMethod(
        ApiConstanst.flightBaseUrl + flightPurchaseDetails + '$brfNo');

    FlightPurchaseOrderModel data = FlightPurchaseOrderModel.fromJson(response);

    return data;
  }

  /*share via email Api */
  static Future<ShareViaEmailModel> shareviaemail(
      http.Client client, bookingNo, type, tmpCode) async {
    final response = await getMethod(ApiConstanst.flightBaseUrl +
        "share_via_email?booking_ref_no=$bookingNo");

    ShareViaEmailModel data = ShareViaEmailModel.fromJson(response);
    return data;
  }
}
