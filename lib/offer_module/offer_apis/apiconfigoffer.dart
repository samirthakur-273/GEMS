/* Author : Sanjana Shetty
 Date created : 14-April-2022
 Discription : Offer ApiConfig Page */

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gems_revamp/booking_slots/model/addwplticket_model.dart';
import 'package:gems_revamp/booking_slots/model/getwplticket_model.dart';
import 'package:gems_revamp/offer_module/offer_detail/model_offerdetail.dart';
import 'package:gems_revamp/offer_module/offer_favourite/model_offerfav.dart';
import 'package:gems_revamp/offer_module/offer_list/clinks/clinks_model.dart';
import 'package:gems_revamp/offer_module/offer_list/model_offerlist.dart';
import 'package:gems_revamp/offer_module/offer_pin/model_offerredeem.dart';
import 'package:gems_revamp/offer_module/offer_pin/new_offerredeem_model.dart';
import 'package:gems_revamp/offer_module/offer_receipt/model_offerfeedback.dart';
import 'package:gems_revamp/offer_module/offer_search/model_offersearch.dart';
import 'package:gems_revamp/utils/constants_files/apiconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;

class OfferApiconfig {
  /* End point URL*/
  static const String offerListUrl = 'offers/outletlist';
  static const String offersearchUrl = 'offers/offerSearch';
  static const String offerdetailsUrl = 'offers/outletdetail';
  static const String offerfeedbackUrl = 'offers/customerfeedback';
  static const String offerredeemUrl = 'offers/offerRedeem';
  static const String newOfferredeemUrl = 'offers/offerRedeemNew';
  static const String offerfavUrl = 'offers/addEditMyFav';
  static const String offerClink = 'offers/addClinkDetail';

  static var timeoutrespon = {"status": false, "message": "timeout"};

  static Future<dynamic> post(url, [header, params]) async {
    print(url);
    print(json.encode(params));
    print('Request:----');
    try {
      http.Response response = await http
          .post(
            Uri.parse(url),
            body: json.encode(params),
            headers: header,
          )
          .timeout(const Duration(minutes: 3));
      final responseBody = json.decode(response.body);
      print(responseBody);
      return responseBody;
    } on TimeoutException catch (e) {
      return timeoutrespon;
    } on SocketException catch (e) {
      return timeoutrespon;
    } on Error catch (e) {
    }
  }

  static var header = {
    'Content-Type': ApiConstanst.contentjson,
    'Authorization': ApiConstanst.apiAuthorizationToken,
    'TP_APPLICATION_KEY': ApiConstanst.tpppkey,
  };

// /* ********** Offer List Api ********** */

  static Future<OfferList> offerListApi(http.Client client, requestBody) async {
    var response = await post(
        ApiConstanst.simplikaBaseUrl + offerListUrl, header, requestBody);

    return OfferList.fromJson(response);
  }

  static Future<ClinksDetailModel> clinkApi(
      http.Client client, requestBody) async {
    var response = await post(
        ApiConstanst.simplikaBaseUrl + offerClink, header, requestBody);

    return ClinksDetailModel.fromJson(response);
  }

  static Future<GetWplModel> getWplTicket(http.Client client) async {
    http.Response response = await http
        .get(
          Uri.parse(ApiConstanst.mainBaseUrl +
              'GEMSCC/mobile/member/getWPLTicket?membership_no=${GemsGLobals.membershipNo}'),
          headers: header,
        )
        .timeout(const Duration(seconds: 20));
    GetWplModel data = GetWplModel.fromJson(json.decode(response.body));

    return data;
  }

  static Future<AddWplModel> addWplTicket(
    http.Client client,
    reqbody,
  ) async {

    http.Response response = await http
        .post(
            Uri.parse(ApiConstanst.mainBaseUrl +
                'GEMSCC/mobile/member/addWPLTicket'),
            headers: header,
            body: json.encode(reqbody))
        .timeout(const Duration(seconds: 20));
    print(jsonDecode(response.body));
    AddWplModel data = AddWplModel.fromJson(json.decode(response.body));

    return data;
  }

  /* ********** Offer Search Api ********** */

  static Future<OfferSearchModel> offerSearchApi(
      http.Client client, requestBody) async {
    var response = await post(
        ApiConstanst.simplikaBaseUrl + offersearchUrl, header, requestBody);

    return OfferSearchModel.fromJson(response);
  }

  /* ********** Offer Details Api ********** */

  static Future<OfferDetailModel> offerDetailsApi(
      http.Client client, requestBody) async {
    var response = await post(
        ApiConstanst.simplikaBaseUrl + offerdetailsUrl, header, requestBody);

    return OfferDetailModel.fromJson(response);
  }

  /* ********** Offer Favourite Api ********** */

  static Future<OfferFavouriteModel> offerFavApi(
      http.Client client, requestBody) async {
    var response = await post(
        ApiConstanst.simplikaBaseUrl + offerfavUrl, header, requestBody);

    return OfferFavouriteModel.fromJson(response);
  }

  /* ********** Offer Redeem Api ********** */

  static Future<OfferRedeemModel> offerRedeemApi(
      http.Client client, requestBody) async {
    var response = await post(
        ApiConstanst.simplikaBaseUrl + offerredeemUrl, header, requestBody);

    return OfferRedeemModel.fromJson(response);
  }

  static Future<NewOfferRedeemModel> newOfferRedeemApi(
      http.Client client, requestBody) async {
    var response = await post(
        ApiConstanst.simplikaBaseUrl + newOfferredeemUrl, header, requestBody);

    return NewOfferRedeemModel.fromJson(response);
  }
/* ******************Offer FeedBack Api******************** */

  static Future<OfferFeedBack> offerFeedbackApi(
      http.Client client, requestBody) async {
    var response = await post(
        ApiConstanst.simplikaBaseUrl + offerfeedbackUrl, header, requestBody);

    return OfferFeedBack.fromJson(response);
  }
}
