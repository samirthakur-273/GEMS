// import 'dart:convert';
// import 'dart:developer';

// // import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'package:gems_revamp/all_partners/fee_redemption/fee_redemption.dart';
// import 'package:gems_revamp/all_partners/fee_redemption/fee_redmption_details_page.dart';
// import 'package:gems_revamp/all_partners/insurance_partners/insurance_partners.dart';
// import 'package:gems_revamp/all_partners/other_partners/other_partners.dart';
// import 'package:gems_revamp/all_partners/travel_partners/travel_partners.dart';
// import 'package:gems_revamp/eshop_module_new/product_detail/product_detal_new.dart';
// import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_wishlisht_count_provider.dart';
// import 'package:gems_revamp/eshop_module_new/product_list_module/View/product_list_view.dart';
// import 'package:gems_revamp/eshop_module_new/tab_bar_page.dart';
// import 'package:gems_revamp/family_and_friends/add_family_friends.dart';
// import 'package:gems_revamp/flight_module/flighthomepage.dart';
// import 'package:gems_revamp/giftcard_module/giftcard_homepage/giftcard_homepage.dart';
// import 'package:gems_revamp/homepage/apiconfig/apiconfighome.dart';
// import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_homepage.dart';
// import 'package:gems_revamp/offer_module/offer_detail/offer_detail.dart';
// import 'package:gems_revamp/offer_module/offer_webview.dart';
// import 'package:gems_revamp/point_conversion/airmiles_module/switch_options_airmiles.dart';
// import 'package:gems_revamp/point_conversion/grocery_module/grocery_steps.dart';
// import 'package:gems_revamp/point_conversion/home_point_conversion.dart';
// import 'package:gems_revamp/point_conversion/smiles_module/check_status.dart';
// import 'package:gems_revamp/point_conversion/smiles_module/switch_options_smiles.dart';
// import 'package:gems_revamp/utilities/auth_utils.dart';
// import 'package:gems_revamp/utils/gemsGlobals.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';

// import 'common_widget/tabbarpage.dart';
// import 'offer_module/offer_list/offer_list.dart';
// import 'package:http/http.dart' as http;
// import 'package:gems_revamp/utm_demo/deeplink_dbhelper.dart';

// class DynamicRouting {
//   var brandcode;
//   var outletcode;
//   var partnerbrand;
//   var catCode;
//   var catName = "";
//   var altCatName;
//   var subSecCode = '';
//   var emailFromDeeplink;
//   final dynamicLink = FirebaseDynamicLinks.instance;
//   late BuildContext context;
//   String? subsecName;

//   String? description;
//   String? androidUrl;
//   String? webUrl;
//   final UtmManager utmManager = UtmManager();
//   String? utmSource;
//   String? utmMedium;
//   String? utmCampaign;

//   Future initDynamicLinksNew() async {
//     FirebaseDynamicLinks.instance.onLink
//         .listen((PendingDynamicLinkData? dynamiclink) {
//       final Uri deepLink = dynamiclink!.link;
//       log(deepLink.toString());
//       if (GemsGLobals.membershipNo == null) {
//         Get.to(() => TabsScreen(
//               initialIndex: 0,
//             ));
//       } else {
//         extractDataAndNavigate(deepLink);
//       }
//       return;
//     });

//     final PendingDynamicLinkData? data = await dynamicLink.getInitialLink();
//     if (data != null) {
//       GemsGLobals.isDeepLink = true;
//     }
//     final Uri link = data!.link;
//     if (GemsGLobals.membershipNo == null) {
//       GemsGLobals.alumniStatus = false;
//       AuthUtils.setIsClink("false");
//       GemsGLobals.membershipNo = null;
//       GemsGLobals.userType = "guest";
//       Get.to(() => TabsScreen(
//             initialIndex: 0,
//           ));
//     } else {
//       extractDataAndNavigate(link);
//     }
//   }

//   affilatePartnerAPi(String affilateID) {
//     if (GemsGLobals.userType != "guest") {
//       var body = {
//         "customer_id": GemsGLobals.membershipNo,
//         "partner_id": affilateID
//       };

//       HomeApiconfig.affilatePartner(http.Client(), body).then((result) async {
//         if (result["status"] == true) {
//           var url = result["values"]["partner_url"] ?? "";
//           if (await canLaunchUrl(Uri.parse(url))) {
//             await launchUrl(Uri.parse(url));
//           } else {
//             throw 'Could not launch $url';
//           }
//         }
//       });
//     }
//   }

//   void elevateGetUrlAPi() {
//     if (GemsGLobals.userType != "guest") {
//       var body = {
//         "customer_id": GemsGLobals.membershipNo,
//       };

//       HomeApiconfig.elevateTripApi(http.Client(), body).then((result) async {
//         if (result["status"] == true) {
//           var url = result["URL"] ?? "";

//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => ForYouWeb(
//                         appbarname: GemsGLobals.gemsreward,
//                         weburl: url,
//                       )));
//         }
//       });
//     }
//   }

//   extractDataAndNavigate(Uri uri) {
//     uri.queryParameters.forEach((k, v) async {
//       String utmKey = k;

//       UtmEnum? selectedUtm = getUtmEnumFromString(utmKey);
//       if (selectedUtm != null) {

//       switch (selectedUtm) {
//         case UtmEnum.utmSource:
//           utmSource = v;
//           GemsGLobals.utmSource = v;
//           break;

//         case UtmEnum.utmMedium:
//           utmMedium = v;
//           GemsGLobals.utmMedium = v;
//           break;

//         case UtmEnum.utmCampaign:
//           utmCampaign = v;
//           GemsGLobals.utmCampaign = v;
//           break;
//         default:
//           break;
//       }
//       if (utmSource != null && utmMedium != null && utmCampaign != null) {
//         utmManager.saveOrUpdateUtmData(utmSource, utmMedium, utmCampaign);
//       }}
//       if (k == GemsGLobals.deeplinkindex) {
//         GemsGLobals.homepageIndex = v;
//       }
//       String selectedOptionString = k;

//       Constant selectedOption = getEnumFromString(selectedOptionString);

//       switch (selectedOption) {
//         case Constant.brandCode:
//           brandcode = v;
//           GemsGLobals.alumniStatus = false;
//           break;
//         case Constant.offerBrandOutlet:
//           outletcode = v;
//           break;
//         case Constant.partnerBrndId:
//           partnerbrand = v;
//           break;
//         case Constant.categoryCode:
//           catCode = v;
//           GemsGLobals.catCode = catCode;
//           break;
//         case Constant.categoryName:
//           catName = v;
//           GemsGLobals.catName = catName;
//           break;
//         case Constant.altCatName:
//           altCatName = v;
//           GemsGLobals.altCatName = altCatName;
//           break;
//         case Constant.subSecCode:
//           subSecCode = v;
//           GemsGLobals.subSecCode = v;
//           break;
//       }

//       if (k == GemsGLobals.firstName) {
//         GemsGLobals.saveusername = v;
//         brandcode = null;
//         GemsGLobals.brandcode = null;
//       } else if (k == GemsGLobals.lastName) {
//       } else if (k == GemsGLobals.schoolCodeKey) {
//         GemsGLobals.schoolcode = v;
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setString(AuthUtils.savingschoolcode, GemsGLobals.schoolcode);
//       } else if (k == 'type') {
//       } else if (k == 'email') {
//         GemsGLobals.emailFromDeeplink = v;
//         emailFromDeeplink = v;

//         GemsGLobals.email = v;
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setString(AuthUtils.savinguseremail, GemsGLobals.email);
//       } else if (k == 'mobile') {
//       } else if (k == 'membertype') {
//         GemsGLobals.type = v;
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setString(AuthUtils.savingusertype, GemsGLobals.type);
//       } else if (k == 'nationality') {
//       } else if (k == 'productcode') {
//       } else if (k == 'gender') {
//       } else if (k == 'username') {
//         GemsGLobals.saveusername = v;
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setString(AuthUtils.savingusername, GemsGLobals.saveusername);
//       }
//     });
//     if (Get.currentRoute == '/OfferDetail') {
//       Get.back();
//     } else if (uri.toString().contains(GemsGLobals.categoriesKey)) {
//       Get.to(() => OfferListing(
//           subseccode: GemsGLobals.subSecCode,
//           categoryCode: GemsGLobals.catCode ?? '',
//           categoryName: GemsGLobals.catName,
//           categoryheading: GemsGLobals.altCatName));
//     } else if (uri.toString().contains(GemsGLobals.gemspointsKey)) {
//       Map<String, dynamic> queryParams = uri.queryParameters;

//       String subsectionString = queryParams['subsection'];
//       List<dynamic> subSecList = json.decode(subsectionString);
//       var affiliateId;

//       if (uri.toString().contains(GemsGLobals.travelKey)) {
//         uri.queryParameters.forEach((k, v) async {
//           if (k == GemsGLobals.affiliateId && affiliateId == null) {
//             affiliateId = v;
//           }

//           String selectedOptionString = v;

//           TravelEnum selectedOption =
//               getTravelEnumFromString(selectedOptionString);

//           switch (selectedOption) {
//             case TravelEnum.hotel:
//               Get.to(() => HotelHomePage());
//               break;
//             case TravelEnum.flight:
//               Get.to(() => FlightHomePage(
//                     tabIndex: 0,
//                   ));
//               break;
//             case TravelEnum.affiliate:
//               affilatePartnerAPi(affiliateId);
//               break;
//             case TravelEnum.eletrips:
//               elevateGetUrlAPi();
//               break;
//             case TravelEnum.travelpartner:
//               Get.to(() => TravelPartners(
//                     travelsubection: subSecList,
//                   ));
//               break;
//           }
//         });
//       } else if (uri.toString().contains(GemsGLobals.insuranceKey)) {
//         uri.queryParameters.forEach((k, v) async {
//           if (k == GemsGLobals.affiliateId && affiliateId == null) {
//             affiliateId = v;
//           }

//           String selectedOptionString = v;

//           InsuranceEnum selectedOption =
//               getInsuranceEnumFromString(selectedOptionString);

//           switch (selectedOption) {
//             case InsuranceEnum.affiliate:
//               affilatePartnerAPi(affiliateId);
//               break;

//             case InsuranceEnum.insurancehome:
//               Get.to(() => InsurancePartners(
//                     travelsubection: subSecList,
//                   ));
//               break;
//           }
//         });
//       } else if (uri.toString().contains(GemsGLobals.otherPartnersKey)) {
//         uri.queryParameters.forEach((k, v) async {
//           switch (v) {
//             case "bounce":
//               Get.to(() => OfferDetail(
//                     isHomepage: true,
//                     brandcode: brandcode,
//                     outletcode: outletcode,
//                     partnerbrandid: partnerbrand,
//                     catcode: catCode,
//                     catname: catName,
//                     subcatheading: altCatName,
//                   ));

//               break;
//             case "default":
//               Get.to(() => OtherPartners(
//                     travelsubection: subSecList,
//                   ));
//               break;
//           }
//         });
//       } else if (uri.toString().contains(GemsGLobals.exchangePointsKey)) {
//         uri.queryParameters.forEach((k, v) async {
//           String selectedOptionString = v;

//           SmileEnum selectedOption =
//               getSmileEnumFromString(selectedOptionString);

//           switch (selectedOption) {
//             case SmileEnum.airmiles:
//               Get.to(() => AirMilesSwitchOptions());
//               break;
//             case SmileEnum.smiles:
//               Get.to(() => CheckStatus());
//               break;
//             case SmileEnum.points:
//               Get.to(() => PointConversionHomePage(
//                     data: subSecList,
//                   ));
//               break;
//           }
//         });
//       } else if (uri.toString().contains(GemsGLobals.groceryKey)) {
//         dynamic htmlData;
//         dynamic iosUrl;
//         dynamic androidUrl;

//         uri.queryParameters.forEach((k, v) async {
//           if (k == GemsGLobals.subsecHtmlKey) {
//             htmlData = v;
//           }

//           if (k == GemsGLobals.androidKey) {
//             androidUrl = v;
//           }
//           if (k == GemsGLobals.iosKey) {
//             iosUrl = v;
//           }
//         });
//         Get.to(() => GrocerySteps(
//             htmlData: htmlData, iosUrl: iosUrl, androidUrl: androidUrl));
//       } else if (uri.toString().contains(GemsGLobals.educationSpendsKey)) {
//         uri.queryParameters.forEach((k, v) async {
//           switch (k) {
//             case 'sub_sec_name':
//               subsecName = v;
//               break;
//             case 'sub_sec_desc':
//               description = v;
//               break;
//             case 'android_deep_link':
//               androidUrl = v;
//               break;
//             case "web_deep_link":
//               webUrl = v;
//               break;
//           }

//           String selectedOptionString = v;

//           EducationEnum selectedOption =
//               getEducationEnumFromString(selectedOptionString);

//           switch (selectedOption) {
//             case EducationEnum.sfee:
//               await Get.to(() => FeeRedemptionDetailsPage(
//                     routeFrom: GemsGLobals.busroute,
//                     title: subsecName,
//                     description: description,
//                     urlforandroid: androidUrl,
//                   ));
//               break;

//             case EducationEnum.bfee:
//               await Get.to(() => FeeRedemptionDetailsPage(
//                     routeFrom: GemsGLobals.busroute,
//                     title: subsecName,
//                     description: description,
//                     urlforandroid: androidUrl,
//                   ));
//               break;
//             case EducationEnum.uni_red:
//               Get.to(() => FeeRedemptionDetailsPage(
//                   routeFrom: GemsGLobals.uniformroute,
//                   title: subsecName,
//                   description: description,
//                   url: webUrl));
//               break;
//             case EducationEnum.education:
//               Get.to(() => FeeRedemptionPage(
//                     data: subSecList,
//                     title: subsecName,
//                   ));
//           }
//         });
//       } else if (uri.toString().contains(GemsGLobals.giftcardsKey)) {
//         Get.to(() => GiftCardCategory());
//       } else if (uri.toString().contains(GemsGLobals.eshopKey)) {
//         Get.to(() => ShopTabBarPage(
//               index: 0,
//               tabIndex: 0,
//             ));
//       }
//     } else if (uri.toString().contains(GemsGLobals.welcomepage)) {
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TabsScreen(
//               initialIndex: 0,
//             ),
//           ));
//     } else if (uri.toString().contains(GemsGLobals.deeplinkindex)) {
//       GemsGLobals.openHomePage = true;
//     } else if (uri.toString().contains(GemsGLobals.friendFamilyText)) {
//       Get.to(() => AddFamilyAndFriends());
//     } else if (uri.toString().contains(GemsGLobals.eShopHome)) {
//       Get.to(() => ShopTabBarPage(
//             index: 1,
//             tabIndex: 1,
//           ));
//     } else if (uri.toString().contains(GemsGLobals.eShopCategory)) {
//       dynamic catId;
//       dynamic brandId;
//       dynamic brandName;
//       dynamic catName;
//       GemsGLobals.isEShopSubcategory = true;

//       uri.queryParameters.forEach((k, v) {
//         switch (k) {
//           case 'cat_id':
//             catId = v;
//             break;
//           case 'brand_id':
//             brandId = v;
//             break;
//           case 'brand_name':
//             brandName = v;
//             break;
//         }
//         if(k == GemsGLobals.categoryName){
//           catName = v;
//         }
//       });
//       Get.to(() => ChangeNotifierProvider(
//             create: (context) => WishListCartCount(),
//             child: ProductListView(
//               catId: catId,
//               brandId: brandId,
//               brandName: brandName,
//               catName: catName,
//             ),
//           ));
//     } else if (uri.toString().contains(GemsGLobals.eShopPDP)) {
//       dynamic productCode;
//       dynamic burnRate;
//       uri.queryParameters.forEach((k, v) async {
//         if (k == GemsGLobals.productCode) {
//           productCode = v;
//         }
//         if (k == GemsGLobals.burnRate) {
//           burnRate = v;
//         }
//       });
//       if (GemsGLobals.isEShopPDPDeepLink == true) {
//         Get.back();
//       }
//       Get.to(() => ChangeNotifierProvider(
//             create: (context) => WishListCartCount(),
//             child: ProductDetailNew(
//               productcode: productCode,
//               burnRate: burnRate,
//             ),
//           ));
//       GemsGLobals.isEShopPDPDeepLink = true;
//     } else if (uri.toString().contains(GemsGLobals.smilesPageText)) {
//       Get.to(() => SmilesSwitchOptions());
//     } else if (uri.toString().contains(GemsGLobals.airlinePageText)) {
//       Get.to(() => AirMilesSwitchOptions());
//     } else {
//       Get.to(
//           () => OfferDetail(
//                 isHomepage: true,
//                 brandcode: brandcode,
//                 outletcode: outletcode,
//                 partnerbrandid: partnerbrand,
//                 catcode: catCode,
//                 catname: catName,
//                 subcatheading: altCatName,
//               ),
//           preventDuplicates: false);
//     }
//   }
// }
