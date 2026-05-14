import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Login_module/login_types/login_types.dart';
import '../all_partners/fee_redemption/fee_redemption.dart';
import '../all_partners/fee_redemption/fee_redmption_details_page.dart';
import '../all_partners/insurance_partners/insurance_partners.dart';
import '../all_partners/other_partners/other_partners.dart';
import '../all_partners/travel_partners/travel_partners.dart';
import '../common_widget/tabbarpage.dart';
import '../eshop_module_new/product_detail/product_detal_new.dart';
import '../eshop_module_new/product_list_module/Model/product_wishlisht_count_provider.dart';
import '../eshop_module_new/product_list_module/View/product_list_view.dart';
import '../eshop_module_new/tab_bar_page.dart';
import '../family_and_friends/add_family_friends.dart';
import '../flight_module/flighthomepage.dart';
import '../giftcard_module/giftcard_homepage/giftcard_homepage.dart';
import '../homepage/apiconfig/apiconfighome.dart';
import '../hotel_module/hotel_homepage/hotel_homepage.dart';
import '../makesense_module/makesense_apiconfig.dart';
import '../offer_module/offer_detail/offer_detail.dart';
import '../offer_module/offer_list/offer_list.dart';
import '../offer_module/offer_webview.dart';
import '../point_conversion/airmiles_module/switch_options_airmiles.dart';
import '../point_conversion/grocery_module/grocery_steps.dart';
import '../point_conversion/home_point_conversion.dart';
import '../point_conversion/mwm_points_conversion_module/mwm_point_home_page.dart';
import '../point_conversion/smiles_module/check_status.dart';
import '../point_conversion/smiles_module/switch_options_smiles.dart';
import '../utilities/auth_utils.dart';
import '../utils/gemsGlobals.dart';
import '../utm_demo/deeplink_dbhelper.dart';

class DynamicLinkHandler {
  DynamicLinkHandler._();
  static final instance = DynamicLinkHandler._();
  final _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  final _appLinks = AppLinks();
  bool _isInitialized = false;
  var brandcode;
  var outletcode;
  var partnerbrand;
  var catCode;
  var catName = '';
  var altCatName;
  var subSecCode = '';
  var emailFromDeeplink;
  late BuildContext context;
  String? subsecName;

  String? description;
  String? androidUrl;
  String? webUrl;
  final UtmManager utmManager = UtmManager();
  String? utmSource;
  String? utmMedium;
  String? utmCampaign;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    _appLinks.uriLinkStream.listen(
      (Uri uri) async {
        if (GemsGLobals.membershipNo == null ||
            GemsGLobals.userType == null ||
            GemsGLobals.userType == 'guest') {
          final result = await Get.to(LoginHomePage.new);
          if (result &&
              GemsGLobals.membershipNo != null &&
              GemsGLobals.userType != null &&
              GemsGLobals.userType != 'guest') {
            extractDataAndNavigate(uri);
          }
        } else {
          extractDataAndNavigate(uri);
        }
      },
      onError: (err) {},
    );

    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (GemsGLobals.membershipNo == null ||
              GemsGLobals.userType == null ||
              GemsGLobals.userType == 'guest') {
            final result = await Get.to(LoginHomePage.new);
            if (result == true &&
                GemsGLobals.membershipNo != null &&
                GemsGLobals.userType != null &&
                GemsGLobals.userType != 'guest') {
              extractDataAndNavigate(initialUri);
            }
          } else {
            extractDataAndNavigate(initialUri);
          }
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (GemsGLobals.brandcode != null &&
              GemsGLobals.membershipNo == null) {
            GemsGLobals.alumniStatus = false;
            AuthUtils.setIsClink('false');
            GemsGLobals.membershipNo = null;
            GemsGLobals.userType = 'guest';
            Get.to(() => const TabsScreen(
                  initialIndex: 0,
                ));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginHomePage()));
          }
        });
      }
    } on PlatformException {}
  }

  affilatePartnerAPi(String affilateID) {
    if (GemsGLobals.userType != 'guest') {
      final body = {
        'customer_id': GemsGLobals.membershipNo,
        'partner_id': affilateID
      };

      HomeApiconfig.affilatePartner(http.Client(), body).then((result) async {
        if (result['status'] == true) {
          final url = result['values']['partner_url'] ?? '';
          launch(url);
        }
      });
    }
  }

  void elevateGetUrlAPi() {
    if (GemsGLobals.userType != 'guest') {
      final body = {
        'customer_id': GemsGLobals.membershipNo,
      };

      HomeApiconfig.elevateTripApi(http.Client(), body).then((result) async {
        if (result['status'] == true) {
          final url = result['URL'] ?? '';

          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ForYouWeb(
                        appbarname: GemsGLobals.gemsreward,
                        weburl: url,
                      )));
        }
      });
    }
  }

  _makesenseEventCall(segmentreq, keyName) {
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentreq, keyName);
  }

  void extractDataAndNavigate(Uri uri) {
    uri.queryParameters.forEach((k, v) async {
      final utmKey = k;

      final selectedUtm = getUtmEnumFromString(utmKey);
      if (selectedUtm != null) {
        switch (selectedUtm) {
          case UtmEnum.utmSource:
            utmSource = v;
            GemsGLobals.utmSource = v;
            break;

          case UtmEnum.utmMedium:
            utmMedium = v;
            GemsGLobals.utmMedium = v;
            break;

          case UtmEnum.utmCampaign:
            utmCampaign = v;
            GemsGLobals.utmCampaign = v;
            break;
        }
        if (utmSource != null && utmMedium != null && utmCampaign != null) {
          utmManager.saveOrUpdateUtmData(utmSource, utmMedium, utmCampaign);
          final eventName = 'Deeplink';
          final segmentReq = {
            'event': eventName,
            'properties': {
              'utm_source': utmSource,
              'utm_medium': utmMedium,
              'utm_campaign': utmCampaign
            }
          };
          _makesenseEventCall(segmentReq, eventName);
        }
      }
      if (k == GemsGLobals.deeplinkindex) {
        GemsGLobals.homepageIndex = v;
      }
      final selectedOptionString = k;

      final selectedOption = getEnumFromString(selectedOptionString);

      switch (selectedOption) {
        case Constant.brandCode:
          brandcode = v;
          GemsGLobals.alumniStatus = false;
          break;
        case Constant.offerBrandOutlet:
          outletcode = v;
          break;
        case Constant.partnerBrndId:
          partnerbrand = v;
          break;
        case Constant.categoryCode:
          catCode = v;
          GemsGLobals.catCode = catCode;
          break;
        case Constant.categoryName:
          catName = v;
          GemsGLobals.catName = catName;
          break;
        case Constant.altCatName:
          altCatName = v;
          GemsGLobals.altCatName = altCatName;
          break;
        case Constant.subSecCode:
          subSecCode = v;
          GemsGLobals.subSecCode = v;
          break;
      }

      if (k == GemsGLobals.firstName) {
        GemsGLobals.saveusername = v;
        brandcode = null;
        GemsGLobals.brandcode = null;
      } else if (k == GemsGLobals.lastName) {
      } else if (k == GemsGLobals.schoolCodeKey) {
        GemsGLobals.schoolcode = v;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(AuthUtils.savingschoolcode, GemsGLobals.schoolcode);
      } else if (k == 'type') {
      } else if (k == 'email') {
        GemsGLobals.emailFromDeeplink = v;
        emailFromDeeplink = v;

        GemsGLobals.email = v;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(AuthUtils.savinguseremail, GemsGLobals.email);
      } else if (k == 'mobile') {
      } else if (k == 'membertype') {
        GemsGLobals.type = v;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(AuthUtils.savingusertype, GemsGLobals.type);
      } else if (k == 'nationality') {
      } else if (k == 'productcode') {
      } else if (k == 'gender') {
      } else if (k == 'username') {
        GemsGLobals.saveusername = v;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString(AuthUtils.savingusername, GemsGLobals.saveusername);
      }
    });

    if (uri.toString().contains(GemsGLobals.categoriesKey)) {
      Get.to(() => OfferListing(
          subseccode: GemsGLobals.subSecCode,
          categoryCode: GemsGLobals.catCode ?? '',
          categoryName: GemsGLobals.catName,
          categoryheading: GemsGLobals.altCatName));
    } else if (uri.toString().contains(GemsGLobals.gemspointsKey)) {
      final Map<String, dynamic> queryParams = uri.queryParameters;

      final String subsectionString = queryParams['subsection'];
      final List<dynamic> subSecList = json.decode(subsectionString);
      var affiliateId;

      if (uri.toString().contains(GemsGLobals.mwmHomePageKey)) {
        final partnerCurrencyId =
            uri.queryParameters[GemsGLobals.partnerCurrencyIdKey];
        final partnerLogo = uri.queryParameters[GemsGLobals.partnerLogoKey];
        final partnerType = uri.queryParameters[GemsGLobals.partnerTypeKey];
        Get.to(() => MwmPointsHomePage(
              partnerCurrencyCode: partnerCurrencyId,
              partnerLogo: partnerLogo,
              partnerType: partnerType,
            ));
        return;
      } else if (uri.toString().contains(GemsGLobals.travelKey)) {
        uri.queryParameters.forEach((k, v) async {
          if (k == GemsGLobals.affiliateId && affiliateId == null) {
            affiliateId = v;
          }
          final selectedOptionString = v;
          final selectedOption = getTravelEnumFromString(selectedOptionString);
          switch (selectedOption) {
            case TravelEnum.hotel:
              Get.to(HotelHomePage.new);
              break;
            case TravelEnum.flight:
              Get.to(() => FlightHomePage(tabIndex: 0));
              break;
            case TravelEnum.affiliate:
              affilatePartnerAPi(affiliateId);
              break;
            case TravelEnum.eletrips:
              elevateGetUrlAPi();
              break;
            case TravelEnum.travelpartner:
              Get.to(() => TravelPartners(travelsubection: subSecList));
              break;
          }
        });
      } else if (uri.toString().contains(GemsGLobals.insuranceKey)) {
        uri.queryParameters.forEach((k, v) async {
          if (k == GemsGLobals.affiliateId && affiliateId == null) {
            affiliateId = v;
          }
          final selectedOptionString = v;
          final selectedOption =
              getInsuranceEnumFromString(selectedOptionString);
          switch (selectedOption) {
            case InsuranceEnum.affiliate:
              affilatePartnerAPi(affiliateId);
              break;
            case InsuranceEnum.insurancehome:
              Get.to(() => InsurancePartners(travelsubection: subSecList));
              break;
          }
        });
      } else if (uri.toString().contains(GemsGLobals.otherPartnersKey)) {
        uri.queryParameters.forEach((k, v) async {
          switch (v) {
            case 'bounce':
              Get.to(() => OfferDetail(
                    isHomepage: true,
                    brandcode: brandcode,
                    outletcode: outletcode,
                    partnerbrandid: partnerbrand,
                    catcode: catCode,
                    catname: catName,
                    subcatheading: altCatName,
                  ));
              break;
            case 'default':
              Get.to(() => OtherPartners(travelsubection: subSecList));
              break;
          }
        });
      } else if (uri.toString().contains(GemsGLobals.exchangePointsKey)) {
        uri.queryParameters.forEach((k, v) async {
          final selectedOptionString = v;
          final selectedOption = getSmileEnumFromString(selectedOptionString);
          switch (selectedOption) {
            case SmileEnum.airmiles:
              Get.to(AirMilesSwitchOptions.new);
              break;
            case SmileEnum.smiles:
              Get.to(() => const CheckStatus());
              break;
            case SmileEnum.points:
              Get.to(() => PointConversionHomePage(data: subSecList));
              break;
          }
        });
      } else if (uri.toString().contains(GemsGLobals.groceryKey)) {
        dynamic htmlData;
        dynamic iosUrl;
        dynamic androidUrl;
        uri.queryParameters.forEach((k, v) async {
          if (k == GemsGLobals.subsecHtmlKey) {
            htmlData = v;
          }
          if (k == GemsGLobals.androidKey) {
            androidUrl = v;
          }
          if (k == GemsGLobals.iosKey) {
            iosUrl = v;
          }
        });
        Get.to(() => GrocerySteps(
            htmlData: htmlData, iosUrl: iosUrl, androidUrl: androidUrl));
      } else if (uri.toString().contains(GemsGLobals.educationSpendsKey)) {
        uri.queryParameters.forEach((k, v) async {
          switch (k) {
            case 'sub_sec_name':
              subsecName = v;
              break;
            case 'sub_sec_desc':
              description = v;
              break;
            case 'android_deep_link':
              androidUrl = v;
              break;
            case 'web_deep_link':
              webUrl = v;
              break;
          }
          final selectedOptionString = v;
          final selectedOption =
              getEducationEnumFromString(selectedOptionString);
          switch (selectedOption) {
            case EducationEnum.sfee:
              await Get.to(() => FeeRedemptionDetailsPage(
                    routeFrom: GemsGLobals.busroute,
                    title: subsecName,
                    description: description,
                    urlforandroid: androidUrl,
                  ));
              break;
            case EducationEnum.bfee:
              await Get.to(() => FeeRedemptionDetailsPage(
                    routeFrom: GemsGLobals.busroute,
                    title: subsecName,
                    description: description,
                    urlforandroid: androidUrl,
                  ));
              break;
            case EducationEnum.uni_red:
              Get.to(() => FeeRedemptionDetailsPage(
                    routeFrom: GemsGLobals.uniformroute,
                    title: subsecName,
                    description: description,
                    url: webUrl,
                  ));
              break;
            case EducationEnum.education:
              Get.to(
                  () => FeeRedemptionPage(data: subSecList, title: subsecName));
          }
        });
      } else if (uri.toString().contains(GemsGLobals.giftcardsKey)) {
        Get.to(GiftCardCategory.new);
      } else if (uri.toString().contains(GemsGLobals.eshopKey)) {
        Get.to(() => ShopTabBarPage(index: 0, tabIndex: 0));
      }
    } else if (uri.toString().contains(GemsGLobals.homepage)) {
      Get.to(() => const TabsScreen(
            initialIndex: 0,
          ));
    } else if (uri.toString().contains(GemsGLobals.deeplinkindex)) {
      GemsGLobals.openHomePage = true;
    } else if (uri.toString().contains(GemsGLobals.friendFamilyText)) {
      Get.to(AddFamilyAndFriends.new);
    } else if (uri.toString().contains(GemsGLobals.eShopHome)) {
      Get.to(() => ShopTabBarPage(
            index: 1,
            tabIndex: 1,
          ));
    } else if (uri.toString().contains(GemsGLobals.eShopCategory)) {
      dynamic catId;
      dynamic brandId;
      dynamic brandName;
      dynamic catName;
      GemsGLobals.isEShopSubcategory = true;
      uri.queryParameters.forEach((k, v) {
        switch (k) {
          case 'cat_id':
            catId = v;
            break;
          case 'brand_id':
            brandId = v;
            break;
          case 'brand_name':
            brandName = v;
            break;
        }
        if (k == GemsGLobals.categoryName) {
          catName = v;
        }
      });
      Get.to(() => ChangeNotifierProvider(
            create: (context) => WishListCartCount(),
            child: ProductListView(
              catId: catId,
              brandId: brandId,
              brandName: brandName,
              catName: catName,
            ),
          ));
    } else if (uri.toString().contains(GemsGLobals.eShopPDP)) {
      dynamic productCode;
      dynamic burnRate;
      uri.queryParameters.forEach((k, v) async {
        if (k == GemsGLobals.productCode) {
          productCode = v;
        }
        if (k == GemsGLobals.burnRate) {
          burnRate = v;
        }
      });
      if (GemsGLobals.isEShopPDPDeepLink == true) {
        Get.back();
      }
      Get.to(() => ChangeNotifierProvider(
            create: (context) => WishListCartCount(),
            child: ProductDetailNew(
              productcode: productCode,
              burnRate: burnRate,
            ),
          ));
      GemsGLobals.isEShopPDPDeepLink = true;
    } else if (uri.toString().contains(GemsGLobals.smilesPageText)) {
      Get.to(() => const SmilesSwitchOptions());
    } else if (uri.toString().contains(GemsGLobals.airlinePageText)) {
      Get.to(AirMilesSwitchOptions.new);
    } else {
      Get.to(
          () => OfferDetail(
                isHomepage: true,
                brandcode: brandcode,
                outletcode: outletcode,
                partnerbrandid: partnerbrand,
                catcode: catCode,
                catname: catName,
                subcatheading: altCatName,
              ),
          preventDuplicates: false);
    }
  }

  Future<void> openAppLink(Uri uri, String path) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final currentRoute =
          ModalRoute.of(_navigatorKey.currentContext!)?.settings.name;
      if (currentRoute != path)
        await _navigatorKey.currentState
            ?.pushNamed('/$path', arguments: uri.queryParameters);
    });
  }
}
