class ApiConstanst {
  /* ================================COMMON CONTENTS========================================= */
  static var contentjson = 'application/json';
  static var tpppkey = '6ad6ce68-0816-4ca5-9b89-5177e2bd9185';
  static var cctoken = '59f07010-eb63-11e9-be54-579a069e8abb';
  static var tpApplicationKey = '9d04cea4-af10-472b-80f0-7f2c4b9584ed';
  static int shoptimeoutLimit = 40;

  /* MakeSense main base Url*/
  static const String makesenseBaseUrl = mainBaseUrl + 'GEMSMS/api/sdk/';

  /* CC main base Url*/
  static const String clubClassBaseUrl = mainBaseUrl + 'GEMSCC/';

  /* TY main base Url*/
  static const String simplikaBaseUrl = mainBaseUrl + 'GEMSTY/rest/V1/';

  /* EShop main base Url*/
  static const String eShopBaseUrl = mainBaseUrl + 'eshop/rest/V2/';

  /* GiftCard main base Url*/
  static const String giftCardBaseUrl = mainBaseUrl + "GEMSGC/api/V1/client/";

  /* flight main base Url*/
  static const String flightBaseUrl = mainBaseUrl + "Flights/rest/V1/flights/";

  /* Hotel main base url */
  static const String hotelBaseURL = mainBaseUrl + 'Hotels/rest/V1/hotels/';

  static const String PAYMENT_URL =
      'https://typanel.bounzrewards.com/tyimages/uploads/pg_loader.gif';
  // 'https://tyadminuat.bounz.io/tyimages/uploads/pg_loader.gif';
  static const String PAYMENT_URL_FAIL =
      'https://typanel.bounzrewards.com/tyimages/uploads/pg_failed.gif';
  // 'https://typanel.bounzrewards.com/tyimages/uploads/pg_failed.gif';

  /* End point URL*/
  static const String wishlistUrl = 'offers/wishList';
  static const String savingsUrl = 'offers/mySavings';
  static const String homesectionUrl = 'users/home';
  static const String affiliateUrl = 'users/customer_visit_url';
  static const String elevategetUrl = 'users/getURL';
  static const String elevateBookingDetails = 'users/getBookingDetail';
  static const String pointsUrl = 'mobile/user/fetch_transaction_list';
  static const String forceupdate = 'users/checkForceUpdate';

  /* Eshop */
  static String brandCode = "1";
  static String countryCode = "main_website_store";
  static String langCode = "1";
  static String rAndBCode = "42";
  //
  // /* ================================UAT URLS============================================ */

  static var apiAuthorizationToken =
      'Basic Qy1MQlZmNTY6ZTgxMDgyNDNhNjk0ODdkNTRmYjFkZGIyYTUzMTFjNTgxZTE3NzkzZg==';
  /*SIT Url for MWM conversion
  static const String partnerBaseUrl='https://gemsapisimuat.clubclass.io/target/mwm/api/auth/session/';
  static const String partnerApiKey='chx5dR6bVDoehHkFk2dRJg==';
  static const String partnerAuthorizationKey='Basic Qy1pTjhVOGQ6MjFiOWVlYWI2Y2JmNDYyYTlmNWNjMzQ5OTQ0MmE4OWVlY2QyNTliZQ==';
  */
  static const String partnerBaseUrl =
      'https://gemsapisimp.clubclass.io/target/mwm/api/auth/session/';
  static const String partnerApiKey = 'chx5dR6bVDoehHkFk2dRJg==';
  static const String partnerAuthorizationKey =
      'Basic Qy03UGs3RTg6MmE5NWRmMDNiMTQ4ZTZmNjA2ZWUwN2ZhMmYwYmRhNGUzNWZhODZiNg==';
  static const bool mwmTestKey = false;

  static const String makesenseClubClassNewBaseUrl =
      'https://gemsanalyticssdk.clubclass.io/';

  static const String advantagePlusApiBaseUrl =
      'https://gemsapisimuat.clubclass.io/';

  static const String authorizationEshopKey =
      'Basic Qy1MQlZmNTY6ZTgxMDgyNDNhNjk0ODdkNTRmYjFkZGIyYTUzMTFjNTgxZTE3NzkzZg==';

  static const String makesenseClubClassBaseUrl =
      'https://gemsmigsdkmssit.clubclass.io/';
  static const String mainBaseUrl =
      'https://gemsapisimuat.clubclass.io/target/';

  static const String makesenseNewApiKey =
      '07509dcd-a0e7-47b1-b5d2-8997e36e31b8';
  static const String makesenseNewAppKey =
      '910d3473-04c7-4a7e-a67a-a952b34bbb7f';
  static const String makesenseBaseUrlCCRoute =
  makesenseClubClassNewBaseUrl + 'api/sdk/';

  static const String eshopCategtoyId = '78';

  // /* Advantage Plus main base url */
  static const String advantagePlusBaseUrl = mainBaseUrl + 'advplus/rest/V1/';
  static const String advantagePlusAffiliateId = "10";

  // /* GemsConnect deeplink*/
  static const androidPackageName = "com.gems.connecttst";
  static const iosUrlScheme = "com.gems.gcapplepay";

  /* ================================PROD URLS============================================ */
  // static const String partnerBaseUrl =
  //     'https://gemsapisimp.clubclass.io/target/mwmapi/api/auth/session/';
  // static const String partnerApiKey = 'chx5dR6bVDoehHkFk2dRJg==';
  // static const String partnerAuthorizationKey =
  //     'Basic Qy1mbkJpSEk6ODgxZGE1ZjhiM2FjZDg1YmVkOWY5Nzk4ZTliYzk5YzcwODk1ZmU5Yw==';
  //  static const bool mwmTestKey = true;
  

  // static const String makesenseNewAppKey =
  //     '910d3473-04c7-4a7e-a67a-a952b34bbb7f';

  // static const String makesenseClubClassNewBaseUrl =
  //     'https://gemsanalyticsprodsdk.clubclass.io/';

  // static const String makesenseBaseUrlCCRoute =
  //     makesenseClubClassNewBaseUrl + 'api/sdk/';

  // static var apiAuthorizationToken =
  //     'Basic Qy1MQlZmNTY6OTBkZTc4ZWFjODQyNTc2MjNmYjliYmU3ZjdlYTQxNDg0ZTdhODIwYw==';

  // static const String makesenseClubClassBaseUrl =
  //     'https://gemsrevampsdk.clubclass.io/';

  // static const String mainBaseUrl = 'https://gemsapisimp.clubclass.io/target/';

  // static const String advantagePlusApiBaseUrl =
  //     'https://gemsapisimp.clubclass.io/';

  // static const String authorizationEshopKey =
  //     'Basic Qy1MQlZmNTY6OTBkZTc4ZWFjODQyNTc2MjNmYjliYmU3ZjdlYTQxNDg0ZTdhODIwYw==';

  // static const String makesenseNewApiKey =
  //     '07509dcd-a0e7-47b1-b5d2-8997e36e31b8';

  // static const String eshopCategtoyId = '35';

  // /* Advantage plus main base url */
  // static const String advantagePlusBaseUrl = mainBaseUrl + 'advplus/rest/V1/';
  // static const String advantagePlusAffiliateId = "4";

  // /* GemsConnect deeplink*/
  // static const androidPackageName = "com.GEMS.Connect";
 // static const iosUrlScheme = "com.GEMS.Connect://";
}
