import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:gems_revamp/Login_module/alumni_login/alumni_register/alumni_register_model.dart';
import 'package:gems_revamp/Login_module/friend&family_login/fnf_login/referral_model.dart';
import 'package:gems_revamp/Login_module/parent_login/check_member/login_types_model.dart';
import 'package:gems_revamp/Login_module/parent_login/getOTP/generateOtp_model.dart';
import 'package:gems_revamp/Login_module/parent_login/login_password/parent_password_model.dart';
import 'package:gems_revamp/Login_module/parent_login/resend_otp/resend_parent_model.dart';
import 'package:gems_revamp/Login_module/parent_login/verifyOTP/verifyotp_modal.dart';
import 'package:gems_revamp/account/profile/edit_profile/edit_profile_model.dart';
import 'package:gems_revamp/account/profile/emirate/emirate_model.dart';
import 'package:gems_revamp/account/profile/profile_utils/user_apiconfig.dart';
import 'package:gems_revamp/utils/constants_files/apiconstants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class LoginApiconfig {
  /* End point URL*/

  static var key = utf8.encode(
      'eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Ik1vc2ggSGFtZWRhbmkiLCJhZG1pbiI6xihGTS');
  static var timeoutrespon = {"status": false, "message": "timeout"};
  static const String verifyOtp = "mobile/user/verify_otp";
  static const String parentLogin = "mobile/user/parent_login";
  static const String resendOtp = "mobile/user/resend_otp";
  static const String checkMember = "mobile/member/checkMemberValidation";
  static const updateRegisterProfile = 'mobile/user/corporate_registration';
  static const String getEmirateData = 'tp/getEmirateData';

  static var header = {
    "Content-Type": ApiConstanst.contentjson,
    "TP_APPLICATION_KEY": ApiConstanst.tpApplicationKey,
    "CC_TOKEN": ApiConstanst.cctoken,
    'Authorization': ApiConstanst.apiAuthorizationToken,
  };

  static Future<GenerateOtpModal> generateOtpApi(
    http.Client client,
    reqbody,
  ) async {
    var urlpath = "mobile/user/generate_otp";
    http.Response response = await http
        .post(Uri.parse(ApiConstanst.clubClassBaseUrl + urlpath),
            headers: header, body: json.encode(reqbody))
        .timeout(const Duration(seconds: 20));

    GenerateOtpModal data =
        GenerateOtpModal.fromJson(json.decode(response.body));

    return data;
  }

  static Future<VerifyOtpModal> verifyOtpApi(
    http.Client client,
    reqbody,
  ) async {
    http.Response response = await http
        .post(Uri.parse(ApiConstanst.clubClassBaseUrl + verifyOtp),
            headers: header, body: json.encode(reqbody))
        .timeout(const Duration(seconds: 20));

    VerifyOtpModal data = VerifyOtpModal.fromJson(json.decode(response.body));
    return data;
  }

  static Future<ParentPasswordModel> parentPasswordLogin(
    http.Client client,
    reqbody,
  ) async {
    http.Response response = await http
        .post(Uri.parse(ApiConstanst.clubClassBaseUrl + parentLogin),
            headers: header, body: json.encode(reqbody))
        .timeout(const Duration(seconds: 20));
    ParentPasswordModel data =
        ParentPasswordModel.fromJson(json.decode(response.body));
    return data;
  }

  static Future<UpdateRegistrationModal> updateRegisterProfileApiCall(
    http.Client client,
    reqbody,
  ) async {
    http.Response response = await http
        .post(Uri.parse(ApiConstanst.clubClassBaseUrl + updateRegisterProfile),
            headers: header, body: json.encode(reqbody))
        .timeout(const Duration(seconds: 20));
    UpdateRegistrationModal data =
        UpdateRegistrationModal.fromJson(json.decode(response.body));
    return data;
  }

  static Future<EmirateModal> emirateApiCall(
    http.Client client,
  ) async {
    http.Response response = await http
        .get(
          Uri.parse(ApiConstanst.clubClassBaseUrl + getEmirateData),
          headers: header,
        )
        .timeout(const Duration(seconds: 20));

    EmirateModal data = EmirateModal.fromJson(json.decode(response.body));
    return data;
  }

  static Future<ResendParentOtpModel> parentResendOtp(
    http.Client client,
    reqbody,
  ) async {
    http.Response response = await http
        .post(Uri.parse(ApiConstanst.clubClassBaseUrl + resendOtp),
            headers: header, body: json.encode(reqbody))
        .timeout(const Duration(seconds: 20));

    ResendParentOtpModel data =
        ResendParentOtpModel.fromJson(json.decode(response.body));
    return data;
  }

  static Future<CheckMemberModel> checkMemberApi(
    http.Client client,
    reqbody,
  ) async {
    http.Response response = await http
        .post(
            Uri.parse(ApiConstanst.clubClassBaseUrl +
                "mobile/member/checkMemberValidation"),
            headers: header,
            body: json.encode(reqbody))
        .timeout(const Duration(seconds: 20));
    CheckMemberModel data =
        CheckMemberModel.fromJson(json.decode(response.body));
    return data;
  }

  // referral Api's
  static Future<ReferralModel> referralApi(
    http.Client client,
    reqbody,
  ) async {
    http.Response response = await http
        .post(
            Uri.parse(
                ApiConstanst.clubClassBaseUrl + 'mobile/user/referral_login'),
            headers: header,
            body: json.encode(reqbody))
        .timeout(const Duration(seconds: 20));

    ReferralModel data = ReferralModel.fromJson(json.decode(response.body));
    return data;
  }

  // alumni Api's
  static Future<ReferralModel> alumniLoginApi(
    http.Client client,
    reqbody,
  ) async {
    http.Response response = await http
        .post(
            Uri.parse(
                ApiConstanst.mainBaseUrl + 'GEMSCC/mobile/user/alumni_login'),
            headers: header,
            body: json.encode(reqbody))
        .timeout(const Duration(seconds: 20));
    // https://gemsapisimuat.clubclass.io/target/GEMSCC/mobile/user/alumni_login

    ReferralModel data = ReferralModel.fromJson(json.decode(response.body));
    return data;
  }

  static Future<AlumniRegisterModel> alumniRegisterApi(
    http.Client client,
    reqbody,
  ) async {
    http.Response response = await http
        .post(
            Uri.parse(ApiConstanst.mainBaseUrl +
                'GEMSCC/mobile/users/alumni_registration'),
            headers: header,
            body: json.encode(reqbody))
        .timeout(const Duration(seconds: 20));
    AlumniRegisterModel data =
        AlumniRegisterModel.fromJson(json.decode(response.body));

    return data;
  }

  static Future<dynamic> postdata(url, [header, params]) async {
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

/* ********** Register Device Api ********** */
}
