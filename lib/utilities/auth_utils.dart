import 'package:shared_preferences/shared_preferences.dart';

class AuthUtils {
  static final String loginKey = 'isLogin';

  static final String notii = 'noti';
  static final String userType = 'user_type';
  static final String isClink = 'isClink';
  static final String isfav = 'isfav';
  static final String isfirstinstallation = 'isfirstinstallation';

  static final String userData = "userdata";
  static final String recentSearchData = "data";
  static final String userDateUpdateDate = "2020-02-22 13:48:12.936511";
  static final String userDateUpdateDate1 = "2020-02-22 13:48:12.936511";
  static final String userIDDecryptedKey = 'userIddecryptedKey';
  static final String studentdData = "studentdData";

  static final String showRating = "rating";
  static final String ratingTime = "rating_time";
  static final String gemsPlusMemberOrNot = "gemsPlusMemberOrNot";
  static final String gemsPlusMembershipNo = "gemsPlusMembershipNo";
  static final String gemsPlusExpiryDate = "gemsPlusExpiryDate";
  static final String gemsPlusMemberPhoto = "gemsPlusMemberPhoto";
  static final String gemsPlusMemberRelationshipCode =
      "gemsPlusMemberRelationshipCode";

  static final String loggedin = 'isLoggedin';

  static final String endPoint = '';
  static final String fcm_token = 'fcm_token';

  static final String ath_key = 'isLogin';
    static final String savingusername = 'savingusername';
 static final String savingschoolcode = 'savingschoolcode';
  static final String savingusertype = 'savingusertype';
  static final String savinguseremail = 'savinguseremail';

  //Set&Get User Type
  static String? getLoggedInUser(SharedPreferences prefs) {
    return prefs.getString(loggedin);
  }

  static setLoggedInUser(var response) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(loggedin, response);
  }

  static setTokenID(var response) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(ath_key, response);
  }

  static setStringValue(key, value) async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.setString(key, value);
  }

  static getStringValue(key) async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString(key) ?? null;
  }

  //firstinstallation

  static String? getFirstinstallation(SharedPreferences prefs) {
    return prefs.getString(isfirstinstallation);
  }

  static setFrstinstallation(var response) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(isfirstinstallation, response);
  }

//Set&GET User ID
  static String? getToken(SharedPreferences prefs) {
    return prefs.getString(loginKey);
  }

  static String? getNoti(SharedPreferences prefs) {
    return prefs.getString(notii);
  }

  static String? getDeviceId(SharedPreferences prefs) {
    return prefs.getString("device_id");
  }

  static String? getCustomerID(SharedPreferences prefs) {
    return prefs.getString("customer_id");
  }

  static String? setUserIdDecrypted(SharedPreferences prefs) {
    return prefs.getString(userIDDecryptedKey);
  }

//Set&Get User Type
  static String? getuserType(SharedPreferences prefs) {
    return prefs.getString(userType);
  }

  static setuserType(var response) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userType, response);
  }

/* user data for redemption -- implemented by Animesh */
  static setuserData(value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(userData, value);
  }

  static getuserData(SharedPreferences prefs) {
    return prefs.getString(userData);
  }

  static setdate(response) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userDateUpdateDate, response);
  }

  static String? getdate(SharedPreferences prefs) {
    return prefs.getString(userDateUpdateDate);
  }

  //newly added
  static setuserData1(value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(recentSearchData, value);
  }

  static getuserData1(SharedPreferences prefs) {
    return prefs.getString(recentSearchData);
  }

  static String? getIsClink(SharedPreferences prefs) {
    return prefs.getString(isClink);
  }

  static setIsClink(var response) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(isClink, response);
  }

  ///
  static Future<dynamic> saveGemsPlusMemberOrNot(
      String? gemsPlusMemberOrNotCheck) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(gemsPlusMemberOrNot, gemsPlusMemberOrNotCheck!);
  }

  static Future<String?> getGemsPlusMemberOrNot() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(gemsPlusMemberOrNot);
  }

  static Future<dynamic> saveGemsPlusMembershipNo(
      String? gemsPlusMembershipNoCheck) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(gemsPlusMembershipNo, gemsPlusMembershipNoCheck!);
  }

  static Future<String?> getGemsPlusMembershipNo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(gemsPlusMembershipNo);
  }

  ///
  static Future<dynamic> saveGemsPlusExpiryDate(
      String? gemsPlusExpiryDateCheck) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(gemsPlusExpiryDate, gemsPlusExpiryDateCheck!);
  }

  static Future<String?> getGemsPlusExpiryDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(gemsPlusExpiryDate);
  }

  ///
  static Future<bool?> saveGemsPlusMemberPhoto(
      String? gemsPlusMemberPhotoCheck) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(gemsPlusMemberPhoto, gemsPlusMemberPhotoCheck!);
  }

  static Future<String?> getGemsPlusMemberPhoto() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(gemsPlusMemberPhoto);
  }

  //
  static Future<dynamic> saveGemsPlusRelationShipCode(
      String? gemsPlusMemberRelationshipCodecheck) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(
        gemsPlusMemberRelationshipCode, gemsPlusMemberRelationshipCodecheck?? '');
  }

  static Future<String?> getGemsPlusMemberRelationShipCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(gemsPlusMemberRelationshipCode);
  }

  static Future<void> setIntValue(String key, int value) async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setInt(key, value);
  }

  static Future<int?> getIntValue(String key) async {
    final SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getInt(key);
  }
}
