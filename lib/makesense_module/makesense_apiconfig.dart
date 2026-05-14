import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:gems_revamp/Login_module/login_types/model_registerdevice.dart';
import 'package:gems_revamp/account/profile/edit_profile/visitor_update/visitor_model.dart';
import 'package:gems_revamp/makesense_module/maintenancemodel.dart';
import 'package:gems_revamp/makesense_module/makesenese_event_model.dart';
import 'package:gems_revamp/makesense_module/notification_count_module/notification_count_model.dart';
import 'package:gems_revamp/makesense_module/notification_module/notification_list_model.dart';
import 'package:gems_revamp/utils/apiconfig.dart';
import 'package:gems_revamp/utils/constants_files/apiconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;

class MakesenseApiConfig {
  static const String redisterdeviceUrl = 'device/register';
  static const String updatefbtoken = 'visitor/updateFirebaseToken';
  static const String logoutfirebaseurl = "visitor/logout";
  static const String visitorUpdateurl = "visitor/update";

  static Map<String, String> _header = {
    "Content-Type": ApiConstanst.contentjson,
    "APP_KEY": ApiConstanst.makesenseNewAppKey,
    "API_KEY": ApiConstanst.makesenseNewApiKey,
    "DEVICE_ID": GemsGLobals.makesenseDeviceID,
    "CHANNEL_CODE": "app",
    'Authorization': ApiConstanst.apiAuthorizationToken,
  };

  /* sendPostRequest */
  static Future<dynamic> postMethod(url, params, hdrs) async {
    try {
      http.Response response = await http
          .post(
            Uri.parse(url),
            headers: hdrs,
            body: params != null ? json.encode(params) : null,
          )
          .timeout(const Duration(seconds: 20));

      final responseBody = json.decode(response.body);

      return responseBody;
    } on TimeoutException catch (e) {
      return Apiconfig.timeoutrespon;
    } on SocketException catch (e) {
      return Apiconfig.timeoutrespon;
    } on Error catch (e) {}
  }

  static Future<dynamic> getMethod1(url, header) async {
    try {
      http.Response response = await http
          .get(Uri.parse(url), headers: header)
          .timeout(const Duration(seconds: 20));

      final responseBody = json.decode(response.body);

      return responseBody;
    } on TimeoutException catch (e) {
      return Apiconfig.timeoutrespon;
    } on SocketException catch (e) {
      return Apiconfig.timeoutrespon;
    } on Error catch (e) {}
  }

  static Future<MaintenceModel> maintenanceApi(appversion, context) async {
    var formatrespon = {"status": false, "message": "format exception"};
    Map<String, String> _headers = {
      "Content-Type": "application/json",
      "APP_KEY":
          ApiConstanst.makesenseNewAppKey,
      "DEVICE_ID":
          "${GemsGLobals.makesenseDeviceID}",
      "API_KEY":
          ApiConstanst.makesenseNewApiKey,
      "CHANNEL_CODE": "app"
    };
    final response = await getMethod1(
            ApiConstanst.makesenseBaseUrlCCRoute +
                'maintenance/version?version=$appversion',
            _headers)
        .timeout(Duration(seconds: 20))
        .onError((error, stackTrace) {
      return formatrespon;
    });
    //

    if (response.runtimeType.toString() == 'String') {
      MaintenceModel data = MaintenceModel.fromJson(formatrespon);
      //

      return data;
    } else {
      MaintenceModel data = MaintenceModel.fromJson(response);
      //

      return data;
    }
  }

  static Future<RegisterDeviceModel> registerdeviceApi(
      http.Client client, requestBody) async {
    Map<String, String> _regheader = {
      "Content-Type": ApiConstanst.contentjson,
      "APP_KEY": ApiConstanst.makesenseNewAppKey,
      "API_KEY": ApiConstanst.makesenseNewApiKey,
      "CHANNEL_CODE": "app",
      'Authorization': ApiConstanst.apiAuthorizationToken,
      "app_version": GemsGLobals.appVersion,
    };

    var response = await postMethod(
      ApiConstanst.makesenseBaseUrlCCRoute + redisterdeviceUrl,
      requestBody,
      _regheader,
    );

    return RegisterDeviceModel.fromJson(response);
  }

  //  Notification List Api
  static Future<NotificationListModel> notificationApiCall(
      http.Client client) async {
    var response = await getMethod1(
        ApiConstanst.makesenseBaseUrl +
            'notification/list?membership_no=${GemsGLobals.membershipNo}&queryType=list',
        _header);
    return NotificationListModel.fromJson(response);
  }

  static Future<NotificationCountModel> notificationCountsApi(
      http.Client client) async {
    var response = await getMethod1(
        ApiConstanst.makesenseBaseUrl +
            'notification/list?membership_no=${GemsGLobals.membershipNo}&queryType=count',
        _header);
    return NotificationCountModel.fromJson(response);
  }
  

  // Read Notification List Api
  static Future<NotificationListModel> readnotificationApi(
      http.Client client, notificationid) async {
    final response = await getMethod1(
        ApiConstanst.makesenseBaseUrl +
            "notification/read?membership_no=${GemsGLobals.membershipNo}&notification_id=$notificationid",
        _header);
    print(ApiConstanst.makesenseBaseUrl +
        "notification/read?membership_no=${GemsGLobals.membershipNo}&notification_id=$notificationid");
    return NotificationListModel.fromJson(response);
  }

  //delete notification api
  static Future<dynamic> deletenotificationAp(
      http.Client client, request) async {
    final response = await postMethod(
            ApiConstanst.makesenseBaseUrl + "notification/delete",
            request,
            _header)
        .timeout(const Duration(seconds: 20));

    return response;
  }

  static Future<dynamic> updateFirebaseToken(
      http.Client client, request) async {
    var header = {
      "Content-Type": ApiConstanst.contentjson,
      "TP_APPLICATION_KEY": ApiConstanst.tpApplicationKey,
      "CC_TOKEN": ApiConstanst.cctoken,
      'Authorization': ApiConstanst.apiAuthorizationToken,
    };
    final response = await postMethod(
        ApiConstanst.clubClassBaseUrl + "mobile/member/updateUserStatus",
        request,
        header);

    return response;
  }

  static Future<dynamic> logoutMaksenseApi(http.Client client, request) async {
    final response = await postMethod(
        ApiConstanst.makesenseBaseUrlCCRoute + logoutfirebaseurl,
        request,
        _header);

    return response;
  }
}

//delete notification api

class MakesenseApiClass {
  static Future<dynamic> postMethod(url, params, hdrs) async {
    print(url);
    print(params);
    try {
      http.Response response = await http
          .post(
            Uri.parse(url),
            headers: hdrs,
            body: params != null ? params : null,
          )
          .timeout(const Duration(seconds: 20));

      final responseBody = json.decode(response.body);

      return responseBody;
    } on TimeoutException catch (e) {
      return Apiconfig.timeoutrespon;
    } on SocketException catch (e) {
      return Apiconfig.timeoutrespon;
    } on Error catch (e) {}
  }

  static Future<dynamic> getMethod(url, header) async {
    try {
      http.Response response = await http
          .get(Uri.parse(url), headers: header)
          .timeout(const Duration(seconds: 20));

      final responseBody = json.decode(response.body);

      return responseBody;
    } on TimeoutException catch (e) {
      return Apiconfig.timeoutrespon;
    } on SocketException catch (e) {
      return Apiconfig.timeoutrespon;
    } on Error catch (e) {}
  }


  static Future<VisitorUpdateModal> visitorUpdateApi(
      http.Client client, segmentreq) async {
    Map<String, String> _headers = {
      "Content-Type": ApiConstanst.contentjson,
      "APP_KEY": ApiConstanst.makesenseNewAppKey,
      "DEVICE_ID": "${GemsGLobals.makesenseDeviceID}",
      "API_KEY": ApiConstanst.makesenseNewApiKey,
      'Authorization': ApiConstanst.apiAuthorizationToken,
      "app_version": GemsGLobals.appVersion,
      "CHANNEL_CODE": GemsGLobals.channelCode
    };

    final response = await MakesenseApiClass.postMethod(
        ApiConstanst.makesenseBaseUrlCCRoute + MakesenseApiConfig.visitorUpdateurl,
        jsonEncode(segmentreq),
        _headers);
    VisitorUpdateModal data = VisitorUpdateModal.fromJson(response);
    return data;
  }

  static Future<MakesenseEventModel> makesenseEventsApi(
      http.Client client, segmentreq, keyName) async {
    Map<String, String> _headers = {
      "Content-Type": "application/json",
      "APP_KEY": ApiConstanst.makesenseNewAppKey,
      "DEVICE_ID": "${GemsGLobals.makesenseDeviceID}",
      "API_KEY": ApiConstanst.makesenseNewApiKey,
      'Authorization': ApiConstanst.apiAuthorizationToken,
      "app_version": GemsGLobals.appVersion,
      "CHANNEL_CODE": "app",
    };

    var request = {
      "events": [
        {
          "key": "$keyName".trim(),
          "count": 1,
          "membership_no": GemsGLobals.membershipNo ?? null,
          "timestamp": DateTime.now().millisecondsSinceEpoch,
          "segmentation": {
            ...?segmentreq,
            "school": GemsGLobals.school,
            "nationality": GemsGLobals.nationality,
            "member_type": GemsGLobals.userType == GemsGLobals.guest
                ? GemsGLobals.unidentifiedUser
                : GemsGLobals.userType,
            "membership_no": GemsGLobals.membershipNo ?? "",
            "emirates": GemsGLobals.emirate,
            "corporate_name": GemsGLobals.partnerName,
            "os": GemsGLobals.osType,
            "utm_source": GemsGLobals.utmSource,
            "utm_medium": GemsGLobals.utmMedium,
            "utm_campaign": GemsGLobals.utmCampaign,
            
          },
          "extra_data": {
            "device_version": GemsGLobals.deviceversion,
            'channel': 'app',
            'device_id': GemsGLobals.makesenseDeviceID,
            'device_model': GemsGLobals.devicemodel,
            "os": GemsGLobals.osType,
            "membership_no": GemsGLobals.membershipNo ?? null,
            "member_type": GemsGLobals.userType == GemsGLobals.guest
                ? GemsGLobals.unidentifiedUser
                : GemsGLobals.userType,
            "mobile_no": GemsGLobals.mobilenumber ?? null,
            "email_id": GemsGLobals.useremail,
            "logged_in": GemsGLobals.membershipNo != null ? true : false,
            "manufacturer": GemsGLobals.deviceName ?? null,
            "school": GemsGLobals.school,
            "nationality": GemsGLobals.nationality,
            "emirate": GemsGLobals.emirate,
            "corporate": GemsGLobals.partnerName,
          }
        }
      ],
      "timestamp": DateTime.now().millisecondsSinceEpoch
    };

    final response = await MakesenseApiClass.postMethod(
        ApiConstanst.makesenseBaseUrlCCRoute + "event",
        jsonEncode(request),
        _headers);
    MakesenseEventModel data = MakesenseEventModel.fromMap(response);
    return data;
  }
}
