import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:gems_revamp/point_conversion/smiles_module/login_smiles/model_smilesid.dart';
import 'package:gems_revamp/utils/constants_files/apiconstants.dart';
import 'package:http/http.dart' as http;

class ApiconfigSmiles {
  static var timeoutrespon = {"status": false, "message": "timeout"};

  /* End point URL*/
  static const String smilesloginUrl =
      'mobile/partner/linkConversionProgramAccount';

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

  static Future<dynamic> postData(http.Client client, urlPath, params) async {
    var header = {
      'Content-Type': ApiConstanst.contentjson,
      "Authorization": ApiConstanst.apiAuthorizationToken,
      "TP_APPLICATION_KEY": ApiConstanst.tpppkey,
    };
  

    try {
      final response = await client
          .post(Uri.parse(ApiConstanst.clubClassBaseUrl + urlPath),
              body: params, headers: header)
          .timeout(const Duration(milliseconds: 20000));
    
      return jsonDecode(response.body);
    } on TimeoutException catch (e) {
      return timeoutrespon;
    } on Error catch (e) {}
  }

  /* Etisalat Linking Api */
  static Future<SmilesLoginModel> smilesLoginApi(
      http.Client client, requestBody) async {
    var header = {
      'Content-Type': ApiConstanst.contentjson,
      "Authorization": ApiConstanst.apiAuthorizationToken,
      "TP_APPLICATION_KEY": ApiConstanst.tpppkey,
    };

    var response = await post(
        ApiConstanst.clubClassBaseUrl + smilesloginUrl, header, requestBody);

    return SmilesLoginModel.fromJson(response);
  }

  /* Etisalat linking otp verification */
  static Future<dynamic> linkOtpVerify(http.Client client, data) async {
    return postData(client, "mobile/partner/stampOTPHashVerify", data);
  }

  /* Etisalat getallmembership data */
  static Future<dynamic> getAllMembershipsData(http.Client client, data) async {
    return postData(client, "mobile/partner/getAllMembershipsData", data);
  }

   /* checkUserAccount for grocery */
  static Future<dynamic> checkUserAccount(http.Client client, data) async {
    return postData(client, "mobile/partner/checkUserAccount", data);
  }


  /* Etisalat PostTransaction api */
  static Future<dynamic> postTransactionToBlockchain(
      http.Client client, data) async {
    return postData(client, "mobile/partner/postTransactionToBlockchain", data);
  }

  /* Etisalat post Transactionverify api */
  static Future<dynamic> verifypostTransaction(http.Client client, data) async {
    return postData(client, "mobile/partner/verifyPostTransactionOTP", data);
  }

  /* Etisalat Delink api */
  static Future<dynamic> delinkProgramAccount(http.Client client, data) async {
    return postData(client, "mobile/partner/delinkProgramAccount", data);
  }

  /* Etisalat Refresh Smiles Balance api */
  static Future<dynamic> refreshgetlatestpoints(
      http.Client client, data) async {
    return postData(client, "mobile/partner/getLatestPartnerPoints", data);
  }
}
