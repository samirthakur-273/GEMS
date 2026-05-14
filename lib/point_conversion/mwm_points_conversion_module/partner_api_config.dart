import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../utils/apiconfig.dart';
import '../../utils/constants_files/api_end_points.dart';
import '../../utils/constants_files/apiconstants.dart';
import '../../utils/constants_files/text_constants.dart';
import 'convert_points/submit_transaction/submit_transaction_model.dart';
import 'convert_points/submit_transaction/submit_transaction_request_model.dart';
import 'delink/delink_model.dart';
import 'delink/delink_request_model.dart';
import 'get_membership_list/get_membership_list_model.dart';
import 'partner_details/partner_details_model.dart';
import 'partner_list/partner_list_model.dart';
import 'transaction_capping/transaction_capping_model.dart';
import 'transaction_capping/transaction_capping_request_model.dart';
import 'verify_member/resend_otp/resend_otp_model.dart';
import 'verify_member/validate_otp/validate_otp_model.dart';
import 'verify_member/verify_member_model.dart';

class PartnerApiConfig {
  static const String partnerList =
      '${ApiConstanst.partnerBaseUrl}${ApiEndPoints.partnerList}';
  static const String partnerDetails =
      '${ApiConstanst.partnerBaseUrl}${ApiEndPoints.partnerDetails}';
  static const String verifyMember =
      '${ApiConstanst.partnerBaseUrl}${ApiEndPoints.verifyMember}';
  static const String getMembershipList =
      '${ApiConstanst.partnerBaseUrl}${ApiEndPoints.getMembershipList}';
  static const String validateOtp =
      '${ApiConstanst.partnerBaseUrl}${ApiEndPoints.validateOtp}';
  static const String resendOtp =
      '${ApiConstanst.partnerBaseUrl}${ApiEndPoints.resendOtp}';
  static Map<String, String> header = {
    'Content-Type': ApiConstanst.contentjson,
    'api-key': ApiConstanst.partnerApiKey,
    'Authorization': ApiConstanst.partnerAuthorizationKey,
  };
  static const String delink =
      '${ApiConstanst.partnerBaseUrl}${ApiEndPoints.delink}';

  static String submitTransaction =
      '${ApiConstanst.partnerBaseUrl}${ApiEndPoints.submitTransaction}';
  static String transactionCapping =
      '${ApiConstanst.partnerBaseUrl}${ApiEndPoints.transactionCapping}';

  static Future<dynamic> postMethod(url, params) async {
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: header,
            body: params != null ? json.encode(params) : null,
          )
          .timeout(
            const Duration(
              seconds: AppTexts.timeoutDuration,
            ),
          );

      final responseBody = json.decode(response.body);

      return responseBody;
    } on TimeoutException catch (e) {
      return Apiconfig.timeoutrespon;
    } on SocketException catch (e) {
      return Apiconfig.timeoutrespon;
    }
  }

  static Future<dynamic> getMethod(url) async {
    try {
      final response = await http
          .get(Uri.parse(url), headers: header)
          .timeout(const Duration(seconds: 30));

      final responseBody = json.decode(response.body);

      return responseBody;
    } on TimeoutException catch (e) {
      return Apiconfig.timeoutrespon;
    } on SocketException catch (e) {
      return Apiconfig.timeoutrespon;
    }
  }

  static Future<PartnerListModel> partnerListApi(http.Client client) async {
    final response =
        await getMethod('${partnerList}?published=${ApiConstanst.mwmTestKey}');
    final partnerListModel = PartnerListModel.fromJson(response);

    return partnerListModel;
  }

  static Future<PartnerDetailsModel> partnerDetailsApi(
      http.Client client, String? partnerCurrencyCode) async {
    final response = await getMethod(
        '${partnerDetails + partnerCurrencyCode!}&published=${ApiConstanst.mwmTestKey}');
    final partnerDetailsModel = PartnerDetailsModel.fromJson(response);

    return partnerDetailsModel;
  }

  static Future<VerifyPartnerModel> verifyPartnerApi(
      http.Client client, Map<String, dynamic> params) async {
    final response = await postMethod(verifyMember, params);
    final verifyPartnerModel = VerifyPartnerModel.fromJson(response);

    return verifyPartnerModel;
  }

  static Future<GetMembershipListModel> getMembershipApi(
      http.Client client, Map<String, dynamic> params) async {
    final response = await postMethod(getMembershipList, params);
    final getMembershipListModel = GetMembershipListModel.fromJson(response);

    return getMembershipListModel;
  }

  static Future<DelinkModel> delinkApi(DelinkRequestModel requestBody) async {
    final response = await postMethod(delink, requestBody.toJson());
    final delinkModel = DelinkModel.fromJson(response);
    return delinkModel;
  }

  static Future<SubmitTransactionModel> submitTransactionApi(
      SubmitTransactionRequestModel requestBody) async {
    final response = await postMethod(submitTransaction, requestBody.toJson());
    final transactionResponse = SubmitTransactionModel.fromJson(response);
    return transactionResponse;
  }

  static Future<ValidateOtp> validateOtpApi(
      http.Client client, Map<String, dynamic> params) async {
    final response = await postMethod(validateOtp, params);
    final validateOtpModel = ValidateOtp.fromJson(response);

    return validateOtpModel;
  }

  static Future<TransactionCappingModel> transactionCappingLimitApi(
      TransactionCappingRequestModel requestBody) async {
    final response = await postMethod(transactionCapping, requestBody.toJson());
    final transactionCappingResponse =
        TransactionCappingModel.fromJson(response);
    return transactionCappingResponse;
  }

  static Future<ResendOtpModal> resendOtpApi(
      http.Client client, Map<String, dynamic> params) async {
    final response = await postMethod(resendOtp, params);
    final resendOtpModel = ResendOtpModal.fromJson(response);

    return resendOtpModel;
  }
}
