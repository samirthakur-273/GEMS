import 'package:intl/intl.dart';

class Constants {
  // static String baseUrl = "https://eshop.bounzrewards.com/rest/V1/"; // prod
  // static String baseUrlMain = "https://eshop.bounzrewards.com/"; // prod
  // static String Authorization =
  //     "Bearer g8lo0qmcs87qw7qf5oqj6a9zkzs25382"; //prod

  // static String baseUrl = "http://bounzuat.vernost.in/rest/V1/"; // UAT
  // static String baseUrlMain = "http://en-ae-rnb-uat.vernost.co.in/"; // UAT
  // static String Authorization = "Bearer on9eaq7ysu0lhy6eavcx12pxagdg560s"; //UAT

  // static String environment = "UAT";

  /// importan**/
// static String baseUrl = "http://en-sa-rnb-uat.vernost.co.in/rest/V1/";
  // static String baseUrl = "http://bounzuat.vernost.in/rest/V1/"; // UAT
  // static String baseUrl = "https://en-ae.randbfashion.com/rest/V1/";// prod
  // static String baseUrlMain = "https://en-ae.randbfashion.com/";// prod
  // static String baseUrlMain = "http://en-ae-rnb-uat.vernost.co.in/"; // UAT
// static String Authorization = "Bearer 7spvcpr3t4s4ufxhblugrazg8gxs2yjl";
  // static String Authorization = "Bearer on9eaq7ysu0lhy6eavcx12pxagdg560s"; //UAT
//   static String Authorization = "Bearer 1fmvgvt50hi8uloy7e0y5i1v287xwir7"; //prod
  static String brandCode = "1";
  static String countryCode = "main_website_store";
  static String langCode = "1"; // arabic 2 english 1 10 qatar
  static String rAndBCode = "42";
// static String rAndBCode = "2";// UAT
  static String customerId = customerId;
  static String? guestId;
  static int responseUpdatetime = 10; // 15 minutes
  static int timeoutLimit = 40; //15 for uat and 7 for prod
  static String priceFormatter(inputPoint) {
    String data =
        NumberFormat("#,###,###,###.##").format(inputPoint).toString();
    return data.contains(".") ? data : data + ".00";
  }

  static String pricePointsFormatter(inputPoint) {
    String data = NumberFormat("#,###,###,###").format(inputPoint).toString();
    return data;
  }

  static burnPoints(String productPrice, String burnRate, int qty) {
    if(burnRate==null || burnRate=="" || burnRate=="0"){
burnRate="0.1";
    }
    var amt = ((double.tryParse(
                productPrice.replaceAll("AED ", "").replaceAll(",", "")))! /
            double.tryParse(burnRate)!)
        .round();
    var priceformat = pricePointsFormatter(amt);

    return "$priceformat";
  }

  static earnPoints(String productPrice) {
    var amt = double.tryParse(
            productPrice.replaceAll("AED ", "").replaceAll(",", ""))! /
        4;
    var priceformat = pricePointsFormatter(amt);
    return "$priceformat";
  }

  /** payment gateway TEMp*/
// static String PGApiUrl = "https://api.sandbox.checkout.com/";
// static String PGApiUrlPayment = "http://en-sa-rnb-uat.vernost.co.in/rest/default/V1/checkout_com/mine/api/v3/";
// static String PGPublicKey = "pk_test_317612f8-b9d4-47d0-b157-6f6bdcbe6bcf";
  /** payment gateway*/

  /// payment gateway UAT */
  static String PGApiUrl = "https://api.sandbox.checkout.com/";
  static String PGApiUrlPayment =
      "http://en-ae-rnb-uat.vernost.co.in/rest/default/V1/checkout_com/mine/api/v3/";

  static String PGPublicKey = "pk_test_36829b6b-8f3a-4143-b967-ad6f20caed48";
  /** payment gateway*/

  /** payment gateway Prod */
  // static String PGApiUrl = "https://api.sandbox.checkout.com/";
  // static String PGPublicKey = Constants.brandCode == "8"?"pk_c16fdf1c-01b7-4cd8-8b47-68bb73582514":"pk_af8c5b0a-4888-4aa0-b624-f3018141f9c5";
  // static String PGApiUrlPayment = "https://en-ae.randbfashion.com/rest/default/V1/checkout_com/mine/api/v3/";
/** payment gateway*/

/** payment gateway Prod */
// static String PGApiUrl = "https://api.sandbox.checkout.com/";
// static String PGPublicKey = "pk_af8c5b0a-4888-4aa0-b624-f3018141f9c5";
// static String PGApiUrlPayment = "https://en-ae.randbfashion.com/rest/default/V1/checkout_com/mine/api/v3/";
/** payment gateway*/

/*RNB Qatar English use as below :
"brandcode" : "8",
"country_code": "rnb_qa_store",
"lang_code":"9"

RNB QATAR Arabic use as below :
"brandcode" : "8",
"country_code": "rnb_qa_store",
"lang_code":"10"*/

/* RNB UAE English use as below :
 "brandcode" : "1",
 "country_code": "rnb_store",
 "lang_code":"1"

 RNB UAE Arabic use as below :
 "brandcode" : "1",
 "country_code": "rnb_store",
 "lang_code":"2"*/
}
