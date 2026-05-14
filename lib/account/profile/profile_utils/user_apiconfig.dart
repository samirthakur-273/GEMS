import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:gems_revamp/account/favourites/my_favourites_model.dart';
import 'package:gems_revamp/account/mypoints/model_mypoints.dart';
import 'package:gems_revamp/account/mysaving/my_savings_model.dart';
import 'package:gems_revamp/account/profile/user_intrest_list/user_intrest_model.dart';
import 'package:gems_revamp/account/profile/user_profile_model.dart';
import 'package:gems_revamp/family_and_friends/family_friends_list/family_friends_list_model.dart';
import 'package:gems_revamp/family_and_friends/family_friends_master_list/master_list_model.dart';
import 'package:gems_revamp/utils/constants_files/apiconstants.dart';
import 'package:gems_revamp/utils/country_list/country_list_model.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;

class UserApiConfig {
  static var key = utf8.encode(
      'eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Ik1vc2ggSGFtZWRhbmkiLCJhZG1pbiI6xihGTS');

  static var timeoutrespon = {"status": false, "message": "timeout"};

  /* header key values */
  static var contentjson = 'application/json';

  static var tpApplicationKey = '9d04cea4-af10-472b-80f0-7f2c4b9584ed';
  static var ccToken = '59f07010-eb63-11e9-be54-579a069e8abb';

  /* End Point Urls */
  static const userprofile = 'mobile/users/get_customer_info?';
  static const userIntrestList = 'listing/interestList';
  static const userUpdateIntrestList = 'mobile/member/update_user_interest';
  static const familyFriendsRefList =
      'mobile/users/get_referral_list?membership_no=';
  static const deleteReferal = 'mobile/users/delete_referral';
  static const masterList = 'mobile/listing/get_master_list';
  static const addRefrral = 'mobile/users/add_referral';
  static const memberSavingBal = 'users/member_saving?customer_id=';
  static const String deleteaccounturl = 'users/delete_account';

  /* Common  Header */
  static var header1 = {
    'Content-Type': contentjson,
    'Authorization': ApiConstanst.apiAuthorizationToken,
    'TP_APPLICATION_KEY': tpApplicationKey,
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

  /* User Profile Api  */
  static Future<UserProfileModel> userProfileApiCall(
      http.Client client, membershipId) async {
    var response = await getDataMethod(
        client,
        ApiConstanst.clubClassBaseUrl +
            userprofile +
            'membership_no=$membershipId' +
            '&type=${GemsGLobals.userType}');
    return UserProfileModel.fromJson(response);
  }

  /* My Favourite Api  */
  static Future<MyFavouriteModel> myFavouriteApiCall(
      http.Client client, myFavouriteReq) async {
    var header = {
      'Content-Type': contentjson,
      'Authorization': ApiConstanst.apiAuthorizationToken,
      'TP_APPLICATION_KEY': tpApplicationKey,
    };

    var response = await post(
        ApiConstanst.simplikaBaseUrl + ApiConstanst.wishlistUrl,
        header,
        myFavouriteReq);

    return MyFavouriteModel.fromJson(response);
  }

  /* My Saving Api  */
  static Future<MySavingsModel> mySavingsApiCall(
      http.Client client, mySavingReq) async {
    var header = {
      'Content-Type': 'application/json',
      'Authorization': ApiConstanst.apiAuthorizationToken,
      'TP_APPLICATION_KEY': tpApplicationKey,
    };
    var response = await post(
        ApiConstanst.simplikaBaseUrl + ApiConstanst.savingsUrl,
        header,
        mySavingReq);

    return MySavingsModel.fromJson(response);
  }

  /* Interest Api  */
  static Future<UserIntrestModel> intrestListApiCall(http.Client client) async {
    var response = await getDataMethod(
        client, ApiConstanst.clubClassBaseUrl + userIntrestList);

    return UserIntrestModel.fromJson(response);
  }

  /* update intrest Api */

  Future<dynamic> updateIntrestApiCall(
      http.Client client, updateIntrestReq) async {
    var header = {
      'Content-Type': 'application/json',
      'Authorization': ApiConstanst.apiAuthorizationToken,
      'TP_APPLICATION_KEY': tpApplicationKey,
      'CC_TOKEN': ccToken
    };

    final response = await post(
        ApiConstanst.clubClassBaseUrl + userUpdateIntrestList,
        header,
        updateIntrestReq);

    return response;
  }

  /* familyFriendsList Api */
  static Future<FamilyFriendsListModel> familyFriendsListApiCall(
      http.Client client, membershipId) async {
    var response = await getDataMethod(client,
        ApiConstanst.clubClassBaseUrl + familyFriendsRefList + '$membershipId');

    return FamilyFriendsListModel.fromJson(response);
  }

  /* referal delete Api */
  Future<dynamic> referalDelete(http.Client client, referalDeleteReq) async {
    var header = {
      'Content-Type': 'application/json',
      'Authorization': ApiConstanst.apiAuthorizationToken,
    };

    final response = await post(
        ApiConstanst.clubClassBaseUrl + deleteReferal, header, referalDeleteReq);

    return response;
  }

  /* Master List Api */
  Future<MasterListModel> masterListApiCall(http.Client client) async {
    final response =
        await getDataMethod(client, ApiConstanst.clubClassBaseUrl + masterList);


    return MasterListModel.fromJson(response);
  }

  /* Add Refrral  Api */
  Future<dynamic> addRefrralApiCall(http.Client client, addRefrralReq) {
    final response =
        post(ApiConstanst.clubClassBaseUrl + addRefrral, header1, addRefrralReq);

    return response;
  }

  /* My Points Api  */
  static Future<MyPointsModel> myPointsApiCall(
      http.Client client, mypointsReq) async {
    var header = {
      'Content-Type': 'application/json',
      'Authorization': ApiConstanst.apiAuthorizationToken,
      'TP_APPLICATION_KEY': tpApplicationKey,
      'CC_TOKEN': ccToken
    };
    var response = await post(
        ApiConstanst.clubClassBaseUrl + ApiConstanst.pointsUrl,
        header,
        mypointsReq);

    return MyPointsModel.fromJson(response);
  }

  Future<dynamic> memberSavingPoints(http.Client client, membershipId) {
    final response = getDataMethod(client,
        ApiConstanst.simplikaBaseUrl + memberSavingBal + '$membershipId');

    return response;
  }

  static Future<CountryListModel> countryListApiCall(http.Client client) async {
    final response = await getDataMethod(
        client, ApiConstanst.simplikaBaseUrl + 'users/countryList');
    return CountryListModel.fromJson(response);
  }

  static Future<dynamic> deleteAccountApi(
      http.Client client, deleteaccountrequest) async {
    var header = {
      'Content-Type': contentjson,
      'Authorization': ApiConstanst.apiAuthorizationToken,
      'TP_APPLICATION_KEY': tpApplicationKey,
    };
    final response = await post(ApiConstanst.simplikaBaseUrl + deleteaccounturl,
        header, deleteaccountrequest);

    return response;
  }
}
