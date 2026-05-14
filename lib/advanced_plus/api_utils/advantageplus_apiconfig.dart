import 'dart:async';
import 'dart:convert';

import 'package:gems_revamp/utils/constants_files/apiconstants.dart';
import 'package:http/http.dart' as http;

class AdvantageplusApiConfig {
  static var timeoutrespon = {"status": false, "message": "timeout"};

  //postData() method
  static Future<dynamic> postData(http.Client client, urlPath, params) async {
    var header = 'application/json';
    Map<String, String> userheader = {
      'Content-Type': header,
      'TP_APPLICATION_KEY': '6ad6ce68-0816-4ca5-9b89-5177e2bd9185',
      'Authorization': ApiConstanst.apiAuthorizationToken
    };

    try {
      final response = await client
          .post(Uri.parse(ApiConstanst.advantagePlusBaseUrl + urlPath),
              body: params, headers: userheader)
          .timeout(const Duration(milliseconds: 20000));

      return jsonDecode(response.body);
    } on TimeoutException catch (e) {
      return timeoutrespon;
    } on Error catch (e) {}
  }

  //getData() method
  static Future<dynamic> getData(http.Client client, urlPath) async {
    try {
      var header = 'application/json';
      Map<String, String> userheader = {
        'Content-Type': header,
        'Authorization': ApiConstanst.apiAuthorizationToken
      };

      final response = await client
          .get(
              Uri.parse(urlPath,
              ),
              headers: userheader)
          .timeout(const Duration(milliseconds: 20000));

      return jsonDecode(response.body);
    } on TimeoutException catch (e) {
      return timeoutrespon;
    } on Error catch (e) {}
  }

  static Future<dynamic> advantagePlusRegistrationApi(
      http.Client client, advantagePlusRegistrationReq) {
    return postData(client, "users/getAdvantagePlusurl",
        jsonEncode(advantagePlusRegistrationReq));
  }

  //AdvantagePlusDetilsData
  static Future<dynamic> advantagePlusDetailsDataApi(
      http.Client client, req) async {
    return getData(client,ApiConstanst.advantagePlusApiBaseUrl+"server/development/advplus/rest/V1/"
        "users/getAdvantagePlusMemberDetail/$req");
 }
}
