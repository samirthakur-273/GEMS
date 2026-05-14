import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gems_revamp/point_conversion/airmiles_module/airtogems_module/model_airtogem.dart';
import 'package:gems_revamp/point_conversion/airmiles_module/gemtoair_module/model_gemtoair.dart';
import 'package:gems_revamp/utils/constants_files/apiconstants.dart';
import 'package:http/http.dart' as http;

import '../airmiles_gems_point_conversion/airmilegems_model.dart';

class AirMilesApiconfig {
  /* End point URL*/
  static const String gemstoairmilesUrl = 'mobile/user/gem_to_airmiles';
  static const String airmilestogemsUrl = 'mobile/user/airmiles_to_gems';
  static const String airmilesToGemsToAirmilesUrl =
      'mobile/user/airmiles_to_gems_to_airmiles';

  static var timeoutrespon = {"status": false, "message": "timeout"};

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
      return timeoutrespon;
    } on Error catch (e) {
     
    }
  }
  static Future<GemsToAirmiles> gemsToAirmilesApi(
      http.Client client, requestBody) async {
    var header = {
      'Content-Type': ApiConstanst.contentjson,
      "Authorization": ApiConstanst.apiAuthorizationToken,
      "TP_APPLICATION_KEY": "9d04cea4-af10-472b-80f0-7f2c4b9584ed",
    };

    var response = await post(
        ApiConstanst.clubClassBaseUrl + gemstoairmilesUrl, header, requestBody);

    return GemsToAirmiles.fromJson(response);
  }

  /* ********** AirMiles To Gems Api ********** */
  static Future<AirmilesToGems> airmilesToGemsApi(
      http.Client client, requestBody) async {
    var header = {
      'Content-Type': ApiConstanst.contentjson,
      "Authorization": ApiConstanst.apiAuthorizationToken,
      "TP_APPLICATION_KEY": "9d04cea4-af10-472b-80f0-7f2c4b9584ed",
    };

    var response = await post(
        ApiConstanst.clubClassBaseUrl + airmilestogemsUrl, header, requestBody);

    return AirmilesToGems.fromJson(response);
  }

  static Future<AirmilesGemsPointModel> airmilesToGemsToAirmilesApi(
      http.Client client) async {
    var header = {
      'Content-Type': ApiConstanst.contentjson,
      "Authorization": ApiConstanst.apiAuthorizationToken,
      "TP_APPLICATION_KEY": "9d04cea4-af10-472b-80f0-7f2c4b9584ed",
    };

    var response = await http.get(
      Uri.parse(ApiConstanst.clubClassBaseUrl + airmilesToGemsToAirmilesUrl),
      headers: header,
    );
    return AirmilesGemsPointModel.fromJson(json.decode(response.body));
  }
}
