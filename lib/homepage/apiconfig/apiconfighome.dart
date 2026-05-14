import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gems_revamp/homepage/home_db/homepage_db_model.dart';
import 'package:gems_revamp/homepage/home_db/homepage_dbhelper.dart';
import 'package:gems_revamp/homepage/homesearch/common_search_model.dart';
import 'package:gems_revamp/homepage/homesearch/homesearch_model.dart';
import 'package:gems_revamp/homepage/pointbalance/model_pointbalance.dart';
import 'package:gems_revamp/utils/constants_files/apiconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;

class HomeApiconfig {
  /* End Point Urls */
  static const pointbalanceUrl = 'mobile/user/get_point_balance?membership_no=';
  static const homesearchUrl = 'users/partnerList';

  static var key = utf8.encode(
      'eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Ik1vc2ggSGFtZWRhbmkiLCJhZG1pbiI6xihGTS');
  static var timeoutrespon = {"status": false, "message": "timeout"};

  static var header1 = {
    'Content-Type': ApiConstanst.contentjson,
    'Authorization': ApiConstanst.apiAuthorizationToken,
    'TP_APPLICATION_KEY': '9d04cea4-af10-472b-80f0-7f2c4b9584ed',
  };

  static Future<dynamic> getDataMethod(http.Client client, urlPath) async {
    try {
      final response = await client
          .get(Uri.parse(urlPath), headers: header1)
          .timeout(const Duration(milliseconds: 20000));
      return jsonDecode(response.body);
    } on TimeoutException catch (e) {
      return timeoutrespon;
    } on Error catch (e) {}
  }

  static Future<dynamic> affilatePartner(http.Client client, reqBody) {
    return post(ApiConstanst.simplikaBaseUrl + ApiConstanst.affiliateUrl, header,
        reqBody);
  }

  static Future<dynamic> elevateTripApi(http.Client client, reqBody) {
    return post(ApiConstanst.simplikaBaseUrl + ApiConstanst.elevategetUrl,
        header, reqBody);
  }

  static Future<dynamic> elevateBookingApi(http.Client client, reqBody) {
    return post(
        ApiConstanst.simplikaBaseUrl + ApiConstanst.elevateBookingDetails,
        header,
        reqBody);
  }

  static Future<dynamic> post(url, [header, params]) async {
    try {
      http.Response response = await http
          .post(
            Uri.parse(url),
            body: json.encode(params),
            headers: header,
          )
          .timeout(const Duration(minutes: 3));

      final responseBody = json.decode(response.body);

      return responseBody;
    } on TimeoutException catch (e) {
      return timeoutrespon;
    } on SocketException catch (e) {
      //print('socketeee: $e');
      return timeoutrespon;
    } on Error catch (e) {}
  }

  static var header = {
    'Content-Type': 'application/json',
    'Authorization': ApiConstanst.apiAuthorizationToken,
  };

  Future<List<HomePageDbModel>> gethomeListDataFromDb() {
    var data = HomePageListDBHelper().getHomepageListData();

    return data;
  }

  Future<dynamic> homesection(http.Client client, homesectionReq) async {
    final homedata = gethomeListDataFromDb().then((getHomeData) async {
      if (getHomeData.length <= 0 || GemsGLobals.userType == "guest") {
        final response = await post(
            ApiConstanst.simplikaBaseUrl + ApiConstanst.homesectionUrl,
            header,
            homesectionReq);
        if (GemsGLobals.userType != "guest") {
          HomePageListDBHelper()
              .save(HomePageDbModel(null, json.encode(response)));
        }
        return response;
      } else {
        return json.decode(getHomeData.last.homepagedata);
      }
    });

    return homedata;
  }

  /* **************** My Points Balance *********************** */
  static Future<MyPointsModel> myPointsApiCall(http.Client client) async {
    // if (GemsGLobals.membershipNo == null) {
    //   GemsGLobals.membershipNo = "";
    // }

    var response = await getDataMethod(
        client,
        ApiConstanst.clubClassBaseUrl +
            pointbalanceUrl +
            GemsGLobals.membershipNo.toString());

    return MyPointsModel.fromJson(response);
  }

  /* **************** Home Search *********************** */
  static Future<HomeSearchModel> homesearchApiCall(
      http.Client client, controllertext) async {
    var response;
    if (controllertext.length > 0) {
      response = await getDataMethod(
          client,
          ApiConstanst.simplikaBaseUrl +
              homesearchUrl +
              "?affiliate_name=" +
              controllertext);
    } else {
      response = await getDataMethod(
          client, ApiConstanst.simplikaBaseUrl + homesearchUrl);
    }

    return HomeSearchModel.fromJson(response);
  }

  static Future <CommonSearchModel> commonSearchApiCall(http.Client client, req) async {
   final response =  await post(
        ApiConstanst.simplikaBaseUrl + 'users/common_search',
        header, req);        
        CommonSearchModel data = CommonSearchModel.fromJson(response);
        
       
        return data;
  }


  static Future<dynamic> postforceupdate(url, [header, params]) async {
    try {
      http.Response response = await http
          .post(
            Uri.parse(url),
            body: json.encode(params),
            headers: header,
          )
          .timeout(const Duration(minutes: 3));

      final responseBody = json.decode(response.body);

      return responseBody;
    } on TimeoutException catch (e) {
      return timeoutrespon;
    } on SocketException catch (e) {
      return timeoutrespon;
    } on Error catch (e) {}
  }

  static Future<dynamic> forceUpdateApi(http.Client client, appVersion) async {
    final response = await postforceupdate(
        ApiConstanst.simplikaBaseUrl + 'users/checkForceUpdate',
        header,
        appVersion);

    return response;
  }
}
