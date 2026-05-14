/* Author : Sanjana Shetty
 Date created : 21-April-2022
 Discription : New Home Page Ui*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/Login_module/alumni_login/alumni_login.dart';
import 'package:gems_revamp/account/my_account.dart';
import 'package:gems_revamp/account/mypoints/mypoints_design.dart';
import 'package:gems_revamp/account/mysaving/mysaving_design.dart';
import 'package:gems_revamp/account/profile/profile_utils/user_apiconfig.dart';
import 'package:gems_revamp/account/profile/user_profile_db/user_profile_db_model.dart';
import 'package:gems_revamp/account/profile/user_profile_db/user_profile_dbhelper.dart';
import 'package:gems_revamp/account/profile/user_profile_model.dart';
import 'package:gems_revamp/account/profile/user_profile_presenter.dart';
import 'package:gems_revamp/account/profile/user_profile_view.dart';
import 'package:gems_revamp/advanced_plus/advanced_plus_page.dart';
import 'package:gems_revamp/advanced_plus/advantage_plus_clubs.dart';
import 'package:gems_revamp/advanced_plus/advplus_cache.dart';
import 'package:gems_revamp/advanced_plus/api_utils/advantageplus_apiconfig.dart';
import 'package:gems_revamp/all_partners/fee_redemption/fee_redemption.dart';
import 'package:gems_revamp/all_partners/fee_redemption/fee_redmption_details_page.dart';
import 'package:gems_revamp/all_partners/insurance_partners/insurance_partners.dart';
import 'package:gems_revamp/all_partners/other_partners/other_partners.dart';
import 'package:gems_revamp/all_partners/travel_partners/travel_partners.dart';
import 'package:gems_revamp/booking_slots/booking_slots.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/Shop_home_module/Database/home_page_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_wishlisht_count_provider.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_page.dart';
import 'package:gems_revamp/family_and_friends/add_family_friends.dart';
import 'package:gems_revamp/flight_module/flighthomepage.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/giftcard_homepage.dart';

import 'package:gems_revamp/homepage/apiconfig/apiconfighome.dart';
import 'package:gems_revamp/homepage/cachedata.dart';
import 'package:gems_revamp/homepage/gemspointssearch_db/gemspoint_search_db_helper.dart';
import 'package:gems_revamp/homepage/home_db/homepage_db_model.dart';
import 'package:gems_revamp/homepage/home_db/homepage_dbhelper.dart';
import 'package:gems_revamp/homepage/homesearch/common_search.dart';
import 'package:gems_revamp/homepage/offersearch_db/offer_search_db_helper.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_homepage.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flt_db/flt_list_dbhelper.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gc_db/gc_list_dbhelper.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hlt_db/hlt_dbhelper.dart';
import 'package:gems_revamp/offer_module/offer_detail/offer_detail.dart';
import 'package:gems_revamp/offer_module/offer_list/databasefiles/outlet_db_helper.dart';
import 'package:gems_revamp/offer_module/offer_list/databasefiles/outlet_db_model.dart';
import 'package:gems_revamp/offer_module/offer_list/model_offerlist.dart';
import 'package:gems_revamp/offer_module/offer_list/offer_list.dart';
import 'package:gems_revamp/offer_module/offer_list/presenter_offerlist.dart';
import 'package:gems_revamp/offer_module/offer_list/view_offerlist.dart';
import 'package:gems_revamp/offer_module/offer_webview.dart';
import 'package:gems_revamp/offer_module/view_more/view_more.dart';
import 'package:gems_revamp/point_conversion/airmiles_module/switch_options_airmiles.dart';
import 'package:gems_revamp/point_conversion/home_point_conversion.dart';
import 'package:gems_revamp/point_conversion/smiles_module/check_status.dart';
import 'package:gems_revamp/point_conversion/smiles_module/switch_options_smiles.dart';
import 'package:gems_revamp/utilities/auth_utils.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/dialogAlert.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/internetconnectingbox.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import '../eshop_module_new/product_list_module/View/product_list_view.dart';
import '../giftcard_module/giftcard_homepage/database/giftcard_list_category_helper.dart';
import '../hotel_module/hotel_detail/select_room/select_room.dart';
import '../point_conversion/grocery_module/grocery_steps.dart';
import '../utils/member_not_found.dart';
import 'homepage_webview.dart';
import 'package:gems_revamp/utm_demo/deeplink_dbhelper.dart';


class MasterHomePage extends StatefulWidget {
  MasterHomePage();

  @override
  _MasterHomePageState createState() => _MasterHomePageState();
}

class _MasterHomePageState extends State<MasterHomePage>
    with SingleTickerProviderStateMixin
    implements UserProfileView, OfferListView {
  final _currentPageNotifier1 = ValueNotifier<int>(0);
  final _ex_currentPageNotifier = ValueNotifier<int>(0);
  final _gemscurrentPageNotifier = ValueNotifier<int>(0);
  final _earncurrentPageNotifier = ValueNotifier<int>(0);
  final _burncurrentPageNotifier = ValueNotifier<int>(0);
  var emailFromDeeplink;
  final _saveMOcurrentPageNotifier = ValueNotifier<int>(0);
  var _bannerImages;
  var _epbannerImages;
  var itemImage = [];
  var _gemsCauroselImages = [];
  var _redeemgemsCarouselImages = [];
  var _earngemsCarouselImage = [];
  var _gemsPoints;
  var _earngemsPoints;
  var _burngemsPoints;
  bool _savefromhome = false;
  bool _isloading = false;
  final _currentPageNotifierbanner = ValueNotifier<int>(0);
  int _currentPage = 0;
  Color _textcolor = Color(0xff71726a);
  Color advplusCardColor = advantagePlus_member_tile_color;
  String advPlusgif = ImageConstants.advplus_arwdwn;

  var _saveMOCaurselImages = [];
  var _saveMOdata;
  var _dineDelivery;
  var _dineDelSubcat;
  var _dineDelCitylist;
  var exclusiveitemImage = [];
  var _gemsPlusMembershipNo;
  var _gemsPlusMembershipExpiryDate;
  var _gemsPlusUrl;
  bool checkFlag = false;

  PageController _pageControlller1 = PageController(
    initialPage: 0,
  );
  bool lblList = true;
  bool lblGrid = false;

  String? _firstName;

  List<dynamic> _homeSectionArray = [];
  int _current = 0;
  int _homepagecurrent = 0;
  int _excurrent = 0;
  int _gemsIndex = 0;
  int _earngemsIndex = 0;
  int _burngemsIndex = 0;

  int _saveMOIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool checkboxclicked = false;
  var totallist = [];
  late bool homedirtycache;
  var custId;
  var noConnection;
  var _cityData;
  var _offerSubsection;
  var set = 1;
  var campaignImage = "";
  StreamSubscription? sub;
  var noonMoonurl;
  bool? seeMoreLess = false;
  bool isConvert = false;
  var userFamilyInfo;
  var advCardStatus = '';
  var iconContainerHeight = 50.00;
  bool? bookingdotcomloader = false;

  UserProfileModel? _profileModel;
  OfferListPresenter? _offerlistpresenter;
  bool advplusRegistrationImageCheck = false;
  var advplusRegistrationImage;
  var partnerbrandid;
  var _reviewController = TextEditingController();
  var brandcode;
  var outletcode;
  var partnerbrand;
  var catCode;
  var catName = "";
  var altCatName = "";
  var subseccode;
  String? subsecName;
  String? description;
  String? androidUrl;
  String? webUrl;
  final UtmManager utmManager = UtmManager();
  String? utmSource;
  String? utmMedium;
  String? utmCampaign;

  affilatePartnerAPi(String affilateID) {
    if (GemsGLobals.userType != "guest") {
      var body = {
        "customer_id": GemsGLobals.membershipNo,
        "partner_id": affilateID
      };

      HomeApiconfig.affilatePartner(http.Client(), body).then((result) async {
        if (result["status"] == true) {
          var url = result["values"]["partner_url"] ?? "";
          bool isExternalBrowser = result["values"]["is_external_browser"];
          if (isExternalBrowser == false) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeWebview(
                          appbarname: GemsGLobals.gemsreward,
                          weburl: url,
                        )));
          } else {
            await launchUrl(
            Uri.parse(url),
            mode: LaunchMode.externalApplication,
          );
          }
        }
      });
    }
  }

  void elevateGetUrlAPi() {
    if (GemsGLobals.userType != "guest") {
      var body = {
        "customer_id": GemsGLobals.membershipNo,
      };

      HomeApiconfig.elevateTripApi(http.Client(), body).then((result) async {
        if (result["status"] == true) {
          var url = result["URL"] ?? "";
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ForYouWeb(
                          appbarname: GemsGLobals.gemsreward,
                          weburl: url,
                        )));
            bookingdotcomloader = false;
          });
        } else {
          setState(() {
            bookingdotcomloader = false;
          });
        }
      });
    }
  }

  Future<void> _launchInWebViewWithoutJavaScript(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: true),
    )) {
      throw Exception('Could not launch $url');
    }
  }

  _launchURLForyou(url) async {
    var newUri = Uri.parse(url);
    _launchInWebViewWithoutJavaScript(newUri);
  }

  makesenseEventHomescreenViewedCall() {
    String keyName = GemsGLobals.eventHomescreenViewed;
    var segmentReq = {GemsGLobals.intSource: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }


  makesenseHomeClicked(request) {
    String keyName = GemsGLobals.eventHomescreenClicked;
    MakesenseApiClass.makesenseEventsApi(http.Client(), request, keyName);
  }


  Future<List<HomePageDbModel>> gethomeListDataFromDb() {
    var data = HomePageListDBHelper().getHomepageListData();

    return data;
  }

  void updatefirebasetokenApi() {
    var upadatefirebasetokenreq = {
      "membership_no": GemsGLobals.membershipNo ?? "",
      "customer_id": GemsGLobals.userId ?? "",
      "os": Platform.isAndroid ? "android" : "ios",
      "device_id": "",
      "fcm_token": GemsGLobals.fcmToken,
      "type": "login"
    };
    MakesenseApiConfig.updateFirebaseToken(
            http.Client(), upadatefirebasetokenreq)
        .then((value) {
      if (value["status"] == true) {
        setState(() {
          GemsGLobals.updatedFireBaseToken = true;
        });
      } else {
        setState(() {
          GemsGLobals.updatedFireBaseToken = false;
        });
      }
    });
  }

  Future _dialogOpen() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => StatefulBuilder(
             builder: (context, setState) => 
                  PopScope(
          canPop: false,
          onPopInvoked: (canPop) async {
             Future.value(false);},
                  child: Dialog(
                      elevation: 0,
                      backgroundColor: transColor,
                      insetPadding: EdgeInsets.only(bottom: 20),
                      child: Container(
                          height: 300,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 300,
                                child: ClipRRect(
                                  child: CachedNetworkImage(
                                    alignment: Alignment.center,
                                    fit: BoxFit.fill,
                                    imageUrl: campaignImage,
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: -10,
                                  right: -7,
                                  child: InkWell(
                                      onTap: ()async {
                                        setState(() {
                                          GemsGLobals.dontShowPopup = true;
                                          if (Navigator.canPop(context)) {
                                            Navigator.pop(context);
                                            }
                                        });
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 2, color: white_color),
                                          color: black_color,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: white_color,
                                          size: 18,
                                        ),
                                      )))
                            ],
                          ))),
                )));
  }

  void homeApiCall() {
    var homeReq = {
      "customer_id": GemsGLobals.membershipNo,
      "lat": GemsGLobals.lat,
      "long": GemsGLobals.long,
      "usertype": GemsGLobals.userType,
      "school_code": GemsGLobals.schoolcode,
    };

    HomeApiconfig().homesection(http.Client(), homeReq).then((result) async {
      if (result["status"] == true) {
        if (result["message"]
            .toString()
            .contains('Member profile cannot be found')) {
          String? errorText = result['message'];
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => MemberNotFound(
                        text: '$errorText',
                      )),
              (route) => false);

          return;
        } else {
          setState(() async {
            _isloading = false;

            _homeSectionArray = result['values']['sectionarr'];
            for (int i = 0; i < _homeSectionArray.length; i++) {
              if (_homeSectionArray[i]["scode"].toString().toLowerCase() ==
                  "campaign") {
                if (_homeSectionArray[i]["subsection"].length != 0) {
                  campaignImage = _homeSectionArray[i]["subsection"][0]
                          ["sub_sec_image"] ??
                      "";
                } else {
                  campaignImage = "";
                }


                if (GemsGLobals.dontShowPopup == false && campaignImage != "") {
                  
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String? campaignImage = prefs.getString("campaignImage");
                  if(campaignImage == null){
                    prefs.setString("campaignImage", 'campaignImage');
                    _dialogOpen();


                     }
                  
                }
              }
            }

            dynamic eventbanner, eventoffers;
            for (var i = 0; i < _homeSectionArray.length; i++) {
              if (_homeSectionArray[i]['scode'].toString().toUpperCase() ==
                  'GEMSBANNER') {
                setState(() {
                  eventbanner = _homeSectionArray[i]["subsection"];
                });
              }

              if (_homeSectionArray[i]['scode'].toString().toUpperCase() ==
                  "EARN") {
                setState(() {
                  _offerSubsection = _homeSectionArray[i]['subsection'];
                  eventoffers = _offerSubsection;
                });
              }
            }
          });
        }
      }
    });
  }

  void _homeSectionApi(
      usreType, gender, skulcode, skulemirate, skulsegment, nationality) {
    cachedata().gethome("main").then((data) {
      if (data == null) {
      } else {
        setState(() {
          _isloading = false;
          dynamic jsondata = jsonDecode(data);
          for (int i = 0; i < jsondata.length; i++) {
            setState(() {
              _homeSectionArray.add(jsondata[i]);
            });
          }
          for (var i = 0; i < _homeSectionArray.length; i++) {
            if (_homeSectionArray[i]["scode"].toString().toUpperCase() ==
                "SAVE") {
              setState(() {
                _offerSubsection = _homeSectionArray[i]["subsection"];
              });
            }
            if (_homeSectionArray[i]["scode"].toString().toUpperCase() ==
                    "FORYOU" &&
                _homeSectionArray[i]["svtype"].toString().toUpperCase() ==
                    "SLIDER") {
              setState(() {
                _bannerImages = _homeSectionArray[i]["subsection"];
                _dineDelivery = _homeSectionArray[i]["dine_category"];
              });
            } else if (_homeSectionArray[i]["scode"].toString().toUpperCase() ==
                    "EPOFFER" &&
                _homeSectionArray[i]["svtype"].toString().toUpperCase() ==
                    "SLIDER") {
              setState(() {
                _epbannerImages = _homeSectionArray[i]["subsection"];
              });
            } else if (_homeSectionArray[i]["scode"].toString().toUpperCase() ==
                    "GEMS" &&
                _homeSectionArray[i]["svtype"].toString().toUpperCase() ==
                    "SLIDER") {
              setState(() {
                _gemsPoints = _homeSectionArray[i]["subsection"];
              });
            } else if (_homeSectionArray[i]["scode"].toString().toUpperCase() ==
                    "EARNGEMS" &&
                _homeSectionArray[i]["svtype"].toString().toUpperCase() ==
                    "SLIDER") {
              setState(() {
                _earngemsPoints = _homeSectionArray[i]["subsection"];
              });
            } else if (_homeSectionArray[i]["scode"].toString().toUpperCase() ==
                    "REDEEMGEMS" &&
                _homeSectionArray[i]["svtype"].toString().toUpperCase() ==
                    "SLIDER") {
              setState(() {
                _burngemsPoints = _homeSectionArray[i]["subsection"];
              });
            } else if (_homeSectionArray[i]["scode"].toString().toUpperCase() ==
                    "POFFER" &&
                _homeSectionArray[i]["svtype"].toString().toUpperCase() ==
                    "SLIDER") {
              setState(() {
                _saveMOdata = _homeSectionArray[i]["subsection"];
              });
            }
          }
          if (_offerSubsection != null) {
            for (var i = 0; i < _offerSubsection.length && i < 1; i++) {
              setState(() {
                _cityData = _offerSubsection[0]["citydata"];
              });
            }
          }
          if (_dineDelivery != null) {
            for (var j = 0; j < _dineDelivery.length; j++) {
              if (_dineDelivery[j]["cname"].toString().toLowerCase() ==
                  "dine delivery") {
                setState(() {
                  _dineDelSubcat = _dineDelivery[j]["subcategory"];
                  _dineDelCitylist = _dineDelivery[j]["citydata"];
                });
              }
            }
          }
        });
      }
    }).catchError((onError) {});
  }

  String loginKey = 'isLogin';
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences? _sharedPreferences;

  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  SharedPreferences? _sharedPreference;

  Future<String?> getuserType(_sharedPreferences, _pref) async {
    _sharedPreference = await _pref;
    String? token = AuthUtils.getuserType(_sharedPreference!);

    return token;
  }

  List profiledetail = [];
  var usertype;
  var userToken;
  var saveaed;
  bool hideCrash = false;
  var gemsPlusIsMemberOrNot;
  var gemsPlusMembershipNo;
  var gemsPlusExpiryDate;
  var gemsPlusMemberPhoto;
  var gemsMemberRelationCode;
  var openPageIndex;
  late UserProfilePresenter? _userProfilePresenter;

  ScrollController _scrollController = ScrollController(initialScrollOffset: 0);
  Timer? _timer;

  void _scrollListener() {
    GemsGLobals.openHomePage = false;
    if (_scrollController.position.atEdge) {
      bool isTop = _scrollController.position.pixels == 0;
      if (isTop) {
      } else {
        if (!_scrollController.hasClients) {
          final position = _scrollController.position.minScrollExtent;
          Timer(Duration(milliseconds: 1), () {
            _scrollController.jumpTo(position);
          });
        }
      }
    }
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (iconContainerHeight != 0)
        setState(() {
          iconContainerHeight = 0;
        });
    }
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (iconContainerHeight == 0)
        setState(() {
          iconContainerHeight = 50;
        });
    }
  }

  void clearAllUserData() {
    setState(() {
      UserProfileDbHelper().truncateTable();
      HotelPurchaseListDBHelper().truncateTable();
      FLTPurchaseListDBHelper().truncateTable();
      GiftCardPurchaseListDBHelper().truncateTable();
      GiftCardListDBHelper().truncateTable();
      OutletDBHelper().truncateTable();
      HomePageListDBHelper().truncateTable();
      HomePageDBHelper().truncateHomePageData();
      OfferSearchListDBHelper().truncateofferSearchHistory();
      GemsPointListDBHelper().truncategemspointSearchHistory();
    });
  }

  logoutapi() {
    var logoutmakesenseReq = {
      "membership_no": GemsGLobals.membershipNo ?? "",
      "customer_id": GemsGLobals.userId ?? "",
      "os": Platform.isAndroid ? "android" : "ios",
      "device_id": "",
      "fcm_token": GemsGLobals.fcmToken,
      "type": "logout"
    };

    Internetconnectivity().isConnected().then((isConnected) async {
      if (isConnected == true) {
        MakesenseApiConfig.updateFirebaseToken(
                http.Client(), logoutmakesenseReq)
            .then((value) async {
          if (value["status"] == true) {
            await FirebaseMessaging.instance.deleteToken();
            setState(() {
              GemsGLobals.membershipNo = null;
              GemsGLobals.userFirstName = null;
              GemsGLobals.userLastName = null;
              GemsGLobals.userType = null;
              GemsGLobals.pointbalance = 0;
              GemsGLobals.custEncryptedId = null;
              GemsGLobals.alumniStatus = false;
              GemsGLobals.deeplinkloader = false;
              clearAllUserData();
              GemsGLobals.totalunreadnotifications = 0;
            });
            UserProfileDbHelper().truncateTable();

            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear();

            await AuthUtils.setStringValue("checFirstInstall", "true");

            setState(() {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AlumniLogin(
                            email: GemsGLobals.email,
                            usertype: "alumni",
                            data: isConvert == true ? "isConvert" : "0",
                          )));
            });
          } else {
            await FirebaseMessaging.instance.deleteToken();
            setState(() {
              GemsGLobals.membershipNo = null;
              GemsGLobals.userFirstName = null;
              GemsGLobals.userLastName = null;
              GemsGLobals.userType = null;
              GemsGLobals.pointbalance = 0;
              GemsGLobals.custEncryptedId = null;
              clearAllUserData();
            });
            UserProfileDbHelper().truncateTable();

            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear();

            await AuthUtils.setStringValue("checFirstInstall", "true");

            setState(() {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AlumniLogin(
                            email: GemsGLobals.email,
                            usertype: "alumni",
                            data: isConvert == true ? "isConvert" : "0",
                          )));
            });
          }
        });
      } else {
        var noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
      }
    });
  }

  bool getvalue = false;
  void _scrollToPosition(int position) {
    int intValue = position;

    double pixels = intValue * 96.0;

    print(pixels);
    if (_scrollController.hasClients &&
        pixels > _scrollController.position.pixels) {
      if (intValue == 1) {
        _scrollController.jumpTo(
          0.0,
        );
      } else if (intValue == 2) {
        _scrollController.jumpTo(
          300,
        );
      } else if (intValue == 3) {
        _scrollController.jumpTo(MediaQuery.of(context).size.height);
      } else if (intValue == 4 || intValue == 5) {
        _scrollController.jumpTo(MediaQuery.of(context).size.height * 1.5);
      } else {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    }
  }

  _getWidget(Widget child) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (GemsGLobals.openHomePage == true) {
        _scrollToPosition(int.parse(GemsGLobals.homepageIndex ?? "0"));
      }
    });
    if (_scrollController.hasClients == true) {
      if (_scrollController.position.extentBefore > 2.0 && getvalue == false) {
        setState(() {
          getvalue = false;
        });
        return child;
      } else {
        return child;
      }
    }

    return child;
  }

  Future<void> newExtractDataUri(Uri uri) async {
    if (uri.toString().contains(GemsGLobals.homepage) ||
        uri.toString().contains(GemsGLobals.welcomepage)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => TabsScreen(
                    initialIndex: 0,
                  )));
    } else {
      uri.queryParameters.forEach((k, v) async {
        String selectedOptionString = k;

        Constant selectedOption = getEnumFromString(selectedOptionString);

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
            GemsGLobals.subSecCode = v;
            break;
        }
        if (k == GemsGLobals.deeplinkindex) {
          GemsGLobals.homepageIndex = v;
        }

        if (k == 'firstname') {
          GemsGLobals.saveusername = v;
          GemsGLobals.brandcode = null;
        } else if (k == 'lastname') {
        } else if (k == 'schoolcode') {
          GemsGLobals.schoolcode = v;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(AuthUtils.savingschoolcode, GemsGLobals.schoolcode);
        } else if (k == 'type') {
        } else if (k == 'email') {
          emailFromDeeplink = v;
          GemsGLobals.email = v;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(AuthUtils.savinguseremail, GemsGLobals.email);
        } else if (k == 'mobile') {
        } else if (k == 'membertype') {
          GemsGLobals.type = v;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(AuthUtils.savingusertype, GemsGLobals.type);
        } else if (k == 'nationality') {
        } else if (k == 'productcode') {
        } else if (k == 'gender') {
        } else if (k == 'username') {
          GemsGLobals.saveusername = v;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(AuthUtils.savingusername, GemsGLobals.saveusername);
        }
      });
    }
  }

  String capitalize(String value) {
    var result = value[0].toUpperCase();
    bool cap = true;
    for (int i = 1; i < value.length; i++) {
      if (value[i - 1] == " " && cap == true) {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
        cap = false;
      }
    }
    return result;
  }

  _showlogoutDialog() async {
    await Future.delayed(Duration(milliseconds: 50));
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return PopScope(
          canPop: false,
          onPopInvoked: (canPop) async {
          Future.value(false);},
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Container(
                margin: EdgeInsets.only(top: 25, left: 15, right: 15),
                height: 120,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextWidget(
                        text:
                            "Already logged in as ${capitalize(GemsGLobals.userType) == "Alumni" ? "an " : "a "}${capitalize(GemsGLobals.userType)} account.\nAre you sure you want to log out?",
                        size: text_font_size_small,
                        weight: FontWeight.bold,
                        color: Colors.grey[700],
                        alignment: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 22),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: blue_color,
                                ),
                                borderRadius: BorderRadius.circular(3)),
                            child: new TextButton(
                              child: TextWidget(
                                text: "No",
                                color: blue_color,
                                textAlign: TextAlign.center,
                                size: text_font_size_small,
                                weight: FontWeight.bold,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                GemsGLobals.alumniStatus = false;
                              },
                            ),
                          ),
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: blue_color,
                                ),
                                borderRadius: BorderRadius.circular(3)),
                            child: new TextButton(
                              child: TextWidget(
                                text: "Yes",
                                color: blue_color,
                                textAlign: TextAlign.center,
                                size: text_font_size_small,
                                weight: FontWeight.bold,
                              ),
                              onPressed: () async {
                                setState(() {
                                  logoutapi();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  _onlylogoutDialog() async {
    await Future.delayed(Duration(milliseconds: 50));
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return PopScope(
          canPop: false,
          onPopInvoked: (canPop) async {
             Future.value(false);},
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Container(
                margin: EdgeInsets.only(top: 25, left: 15, right: 15),
                height: 120,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextWidget(
                        text:
                            "Your profile as ${capitalize(GemsGLobals.userType) == "Alumni" ? "an " : "a "}${capitalize(GemsGLobals.userType)} already exists.\nAre you sure you want to logout?",
                        size: text_font_size_small,
                        weight: FontWeight.bold,
                        color: Colors.grey[700],
                        alignment: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 22),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: blue_color,
                                ),
                                borderRadius: BorderRadius.circular(3)),
                            child: new TextButton(
                              child: TextWidget(
                                text: "No",
                                color: blue_color,
                                textAlign: TextAlign.center,
                                size: text_font_size_small,
                                weight: FontWeight.bold,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                GemsGLobals.alumniStatus = false;
                              },
                            ),
                          ),
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: blue_color,
                                ),
                                borderRadius: BorderRadius.circular(3)),
                            child: new TextButton(
                              child: TextWidget(
                                text: "Yes",
                                color: blue_color,
                                textAlign: TextAlign.center,
                                size: text_font_size_small,
                                weight: FontWeight.bold,
                              ),
                              onPressed: () async {
                                setState(() {
                                  logoutapi();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showParentStaffExistingDialog() async {
    await Future.delayed(Duration(milliseconds: 10));
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return PopScope(
          canPop: false,
          onPopInvoked: (canPop) async {
             Future.value(false);},
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Container(
                margin: EdgeInsets.only(top: 25, left: 15, right: 15),
                height: 100,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextWidget(
                        text:
                            "Your profile as a ${capitalize(GemsGLobals.userType)} already exists.",
                        size: text_font_size_small,
                        weight: FontWeight.bold,
                        color: Colors.grey[700],
                        alignment: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 22, bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: blue_color,
                                ),
                                borderRadius: BorderRadius.circular(3)),
                            child: new TextButton(
                              child: TextWidget(
                                text: "OK",
                                color: blue_color,
                                textAlign: TextAlign.center,
                                size: text_font_size_small,
                                weight: FontWeight.bold,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showFnfConverttoAlumniDialog() async {
    await Future.delayed(Duration(milliseconds: 10));
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return PopScope(
          canPop: false,
          onPopInvoked: (canPop) async {
             Future.value(false);},
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Container(
                margin: EdgeInsets.only(top: 25, left: 15, right: 15),
                height: 120,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextWidget(
                        text:
                            "Your Family & Friends account\nis upgraded to Alumni.",
                        size: text_font_size_small,
                        weight: FontWeight.bold,
                        color: Colors.grey[700],
                        alignment: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 22, bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: blue_color,
                                ),
                                borderRadius: BorderRadius.circular(3)),
                            child: new TextButton(
                              child: TextWidget(
                                text: "OK",
                                color: blue_color,
                                textAlign: TextAlign.center,
                                size: text_font_size_small,
                                weight: FontWeight.bold,
                              ),
                              onPressed: () {
                                setState(() {
                                  isConvert = true;
                                  logoutapi();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  // Future<void> initUniLinks(data) async {
  //   sub = linkStream.listen((String? link) async {
  //     if (link != null) {
  //       GemsGLobals.isDeepLink = true;

  //       var uri = Uri.parse(link);
  //       if (Platform.isIOS) {
  //         // var data = await FirebaseDynamicLinks.instance.getDynamicLink(uri);
  //         // var iosLink = data?.link;
  //         // newExtractDataUri(iosLink!);
  //       } else {
  //         newExtractDataUri(uri);
  //       }
  //       if (emailFromDeeplink == null) {
  //         GemsGLobals.alumniStatus = false;
  //       } else {
  //         setState(() {
  //           GemsGLobals.alumniStatus = true;
  //         });
  //       }
  //       if (uri.queryParameters.keys.contains(GemsGLobals.categoriesKey)) {
  //         uri.queryParameters.forEach((k, v) async {
  //           if (k == GemsGLobals.catCodeKey) {
  //             catCode = v;
  //           }
  //           if (k == GemsGLobals.catNameKey) {
  //             catName = v;
  //           }
  //           if (k == GemsGLobals.altCatnameKey) {
  //             altCatName = v;
  //           }
  //           String utmKey = k;

  //     UtmEnum? selectedUtm = getUtmEnumFromString(utmKey);
  //      if (selectedUtm != null) {
  //     switch (selectedUtm) {
  //       case UtmEnum.utmSource:
  //         utmSource = v;
  //         GemsGLobals.utmSource = v;
  //         break;

  //       case UtmEnum.utmMedium:
  //         utmMedium = v;
  //         GemsGLobals.utmMedium = v;
  //         break;

  //       case UtmEnum.utmCampaign:
  //         utmCampaign = v;
  //         GemsGLobals.utmCampaign = v;
  //         break;
  //       default:
  //         break;
  //     }}
           
  //         });
  //         Get.to(() => OfferListing(
  //             subseccode: GemsGLobals.subSecCode,
  //             categoryCode: catCode,
  //             categoryName: catName,
  //             categoryheading: altCatName));
  //       } else if (uri.queryParameters.keys
  //           .contains(GemsGLobals.gemspointsKey)) {
  //         Map<String, dynamic> queryParams = uri.queryParameters;

  //         String subsectionString = queryParams['subsection'];
  //         List<dynamic> subSecList = json.decode(subsectionString);
  //         var affiliateId;
  //         if (uri.toString().contains(GemsGLobals.travelKey)) {
  //           uri.queryParameters.forEach((k, v) async {
  //             if (k == GemsGLobals.affiliateId && affiliateId == null) {
  //               affiliateId = v;
  //             }
  //             String selectedOptionString = v;

  //             TravelEnum selectedOption =
  //                 getTravelEnumFromString(selectedOptionString);
  //             switch (selectedOption) {
  //               case TravelEnum.hotel:
  //                 Get.to(() => HotelHomePage());
  //                 break;
  //               case TravelEnum.flight:
  //                 Get.to(() => FlightHomePage(
  //                       tabIndex: 0,
  //                     ));
  //                 break;
  //               case TravelEnum.affiliate:
  //                 setState(() {
  //                   bookingdotcomloader = true;
  //                 });

  //                 affilatePartnerAPi(affiliateId);
  //                 break;
  //               case TravelEnum.eletrips:
  //                 setState(() {
  //                   bookingdotcomloader = true;
  //                 });
  //                 elevateGetUrlAPi();
  //                 break;
  //               case TravelEnum.travelpartner:
  //                 Get.to(() => TravelPartners(
  //                       travelsubection: subSecList,
  //                     ));
  //                 break;
  //             }
  //           });
  //         } else if (uri.toString().contains(GemsGLobals.insuranceKey)) {
  //           uri.queryParameters.forEach((k, v) async {
  //             if (k == GemsGLobals.affiliateId && affiliateId == null) {
  //               affiliateId = v;
  //             }

  //             String selectedOptionString = v;

  //             InsuranceEnum selectedOption =
  //                 getInsuranceEnumFromString(selectedOptionString);

  //             switch (selectedOption) {
  //               case InsuranceEnum.affiliate:
  //                 affilatePartnerAPi(affiliateId);
  //                 break;

  //               case InsuranceEnum.insurancehome:
  //                 Get.to(() => InsurancePartners(
  //                       travelsubection: subSecList,
  //                     ));
  //                 break;
  //             }
  //           });
  //         } else if (uri.toString().contains(GemsGLobals.otherPartnersKey)) {
  //           uri.queryParameters.forEach((k, v) async {
  //             switch (v) {
  //               case "bounce":
  //                 Get.to(() => OfferDetail(
  //                       isHomepage: true,
  //                       brandcode: brandcode,
  //                       outletcode: outletcode,
  //                       partnerbrandid: partnerbrand,
  //                       catcode: catCode,
  //                       catname: catName,
  //                       subcatheading: altCatName,
  //                     ));

  //                 break;
  //               case "default":
  //                 Get.to(() => OtherPartners(
  //                       travelsubection: subSecList,
  //                     ));
  //                 break;
  //             }
  //           });
  //         } else if (uri.toString().contains(GemsGLobals.exchangePointsKey)) {
  //           uri.queryParameters.forEach((k, v) async {
  //             String selectedOptionString = v;

  //             SmileEnum selectedOption =
  //                 getSmileEnumFromString(selectedOptionString);

  //             switch (selectedOption) {
  //               case SmileEnum.airmiles:
  //                 Get.to(() => AirMilesSwitchOptions());
  //                 break;
  //               case SmileEnum.smiles:
  //                 Get.to(() => CheckStatus());
  //                 break;
  //               case SmileEnum.points:
  //                 Get.to(() => PointConversionHomePage(
  //                       data: subSecList,
  //                     ));
  //                 break;
  //             }
  //           });
  //         } else if (uri.toString().contains(GemsGLobals.groceryKey)) {
  //           dynamic htmlData;
  //           dynamic iosUrl;
  //           dynamic androidUrl;

  //           uri.queryParameters.forEach((k, v) async {
  //             if (k == GemsGLobals.subsecHtmlKey) {
  //               htmlData = v;
  //             }

  //             if (k == GemsGLobals.androidKey) {
  //               androidUrl = v;
  //             }
  //             if (k == GemsGLobals.iosKey) {
  //               iosUrl = v;
  //             }
  //           });
  //           Get.to(() => GrocerySteps(
  //               htmlData: htmlData,
  //               iosUrl: iosUrl,
  //               androidUrl: androidUrl.toString()));
  //         } else if (uri.toString().contains(GemsGLobals.educationSpendsKey)) {
  //           uri.queryParameters.forEach((k, v) async {
  //             if (k == GemsGLobals.subsecname) {
  //               subsecName = v;
  //             }
  //             if (k == GemsGLobals.subsecdesc) {
  //               description = v;
  //             }
  //             if (k == GemsGLobals.adroidlink) {
  //               androidUrl = v;
  //             }
  //             if (k == GemsGLobals.weblink) {
  //               webUrl = v;
  //             }

  //             String selectedOptionString = v;

  //             EducationEnum selectedOption =
  //                 getEducationEnumFromString(selectedOptionString);

  //             switch (selectedOption) {
  //               case EducationEnum.sfee:
  //                 await Get.to(() => FeeRedemptionDetailsPage(
  //                       routeFrom: GemsGLobals.schoolroute,
  //                       title: subsecName,
  //                       description: description,
  //                       urlforandroid: androidUrl,
  //                     ));
  //                 break;

  //               case EducationEnum.bfee:
  //                 await Get.to(() => FeeRedemptionDetailsPage(
  //                       routeFrom: GemsGLobals.busroute,
  //                       title: subsecName,
  //                       description: description,
  //                       urlforandroid: androidUrl,
  //                     ));
  //                 break;
  //               case EducationEnum.uni_red:
  //                 Get.to(() => FeeRedemptionDetailsPage(
  //                     routeFrom: GemsGLobals.uniformroute,
  //                     title: subsecName,
  //                     description: description,
  //                     url: webUrl));
  //                 break;
  //               case EducationEnum.education:
  //                 Get.to(() => FeeRedemptionPage(
  //                       data: subSecList,
  //                       title: subsecName,
  //                     ));
  //             }
  //           });
  //         } else if (uri.toString().contains(GemsGLobals.giftcardsKey)) {
  //           Get.to(() => GiftCardCategory());
  //         } else if (uri.toString().contains(GemsGLobals.eshopKey)) {
  //           Get.to(() => ShopTabBarPage(
  //                 index: 0,
  //                 tabIndex: 0,
  //               ));
  //         } else if (uri.toString().contains(GemsGLobals.welcomepage)) {
  //           Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => TabsScreen(
  //                   initialIndex: 0,
  //                 ),
  //               ));
  //         } else if (uri.toString().contains(GemsGLobals.deeplinkindex)) {
  //           uri.queryParameters.forEach((k, v) async {
  //             if (k == GemsGLobals.deeplinkindex) {
  //               GemsGLobals.homepageIndex = v;
  //             }

  //             setState(() {
  //               GemsGLobals.openHomePage = true;
  //             });
  //           });
  //         }
  //        } else if (uri.toString().contains(GemsGLobals.friendFamilyText)) {
  //        Get.to(() => AddFamilyAndFriends());
  //        }
  //        else if (uri.toString().contains(GemsGLobals.smilesPageText)) {
  //        Get.to(() => SmilesSwitchOptions());
  //        }
  //          else if (uri.toString().contains(GemsGLobals.airlinePageText)) {
  //     Get.to(() => AirMilesSwitchOptions());
  //   }
  //       else {
  //         if (brandcode != null && GemsGLobals.membershipNo != null) {
  //           GemsGLobals.alumniStatus = false;
  //           catCode = catCode.toString().replaceAll('\"', '');
  //           brandcode = brandcode.toString().replaceAll('\"', '');
  //           outletcode = outletcode.toString().replaceAll('\"', '');
  //           partnerbrand = partnerbrand.toString().replaceAll('\"', '');
  //           catName = catName.toString().replaceAll('"', '');
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => OfferDetail(
  //                         isHomepage: true,
  //                         brandcode: brandcode,
  //                         outletcode: outletcode,
  //                         partnerbrandid: partnerbrand,
  //                         catcode: catCode,
  //                         catname: catName,
  //                         subcatheading: altCatName,
  //                       )));
  //         }
  //         GemsGLobals.email = GemsGLobals.email.toString().replaceAll('"', '');
  //         GemsGLobals.email = GemsGLobals.email.toString().toLowerCase();
  //         GemsGLobals.useremail =
  //             GemsGLobals.useremail.toString().toLowerCase();
  //         if (GemsGLobals.alumniStatus == true &&
  //             (GemsGLobals.useremail != GemsGLobals.email) &&
  //             GemsGLobals.userType == GemsGLobals.referral &&
  //             GemsGLobals.select != 2) {
  //           _showlogoutDialog();
  //         } else if (GemsGLobals.alumniStatus == true &&
  //             (GemsGLobals.useremail == GemsGLobals.email) &&
  //             GemsGLobals.userType == GemsGLobals.referral &&
  //             GemsGLobals.select != 2) {
  //           _showFnfConverttoAlumniDialog();
  //         } else if (GemsGLobals.alumniStatus == true &&
  //             (GemsGLobals.userType == GemsGLobals.staff ||
  //                 GemsGLobals.userType == GemsGLobals.parent &&
  //                     GemsGLobals.select != 2)) {
  //           if (GemsGLobals.useremail != GemsGLobals.email) {
  //             _onlylogoutDialog();
  //           } else {
  //             _showParentStaffExistingDialog();
  //           }
  //         } else if (GemsGLobals.alumniStatus == true &&
  //             GemsGLobals.useremail != GemsGLobals.email &&
  //             GemsGLobals.userType == GemsGLobals.alumni &&
  //             GemsGLobals.select != 2) {
  //           _showlogoutDialog();
  //         } else if (GemsGLobals.alumniStatus == true &&
  //             GemsGLobals.userType == GemsGLobals.alumni &&
  //             GemsGLobals.select != 2) {}
  //       }
  //     }
  //   }, onError: (err) {});
  // }

  @override
  void initState() {
    GemsGLobals.searchText = "";
    //initUniLinks("0");
    _scrollController.addListener(_scrollListener);

    if (GemsGLobals.membershipNo == null || GemsGLobals.membershipNo == '') {
      _isloading = true;
    }

    getuserType(_sharedPreferences, _prefs).then((result) {
      setState(() {
        usertype = result;
        setState(() {
          if (result == "0") {
            GemsGLobals.userType = "parent";
          } else if (result == "1") {
            GemsGLobals.userType = "staff";
          } else if (result == "2") {
            GemsGLobals.userType = "referral";
          } else if (result == "3") {
            GemsGLobals.userType = "alumni";
          } 
          else if (result == "4") {
            GemsGLobals.userType = GemsGLobals.defaultSource.toString().toLowerCase();
          }
          else {
            GemsGLobals.userType = "Guest";
            GemsGLobals.userType = "guest";
          }
        });
      });
    });
    makesenseEventHomescreenViewedCall();

    _userProfilePresenter = UserProfilePresenter(this);

    getProfileDataDB().then((value) {
      Future.delayed(const Duration(seconds: 1), () async {
        userProfileApi(GemsGLobals.membershipNo);
      });
      

      homeApiCall();
    });

    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(milliseconds: 1000), (Timer timer) {
      if (timer.tick > 2) {
        _timer!.cancel();
        timer.cancel();

        setState(() {});
      }
    });

    AuthUtils.getGemsPlusMemberOrNot().then((value) {
      GemsGLobals.gemsPlusIsMemberOrNot = value;
      gemsPlusIsMemberOrNot = GemsGLobals.gemsPlusIsMemberOrNot;
    });

    AuthUtils.getGemsPlusMembershipNo().then((value) {
      GemsGLobals.gemsPlusMembershipNo = value;
      gemsPlusMembershipNo = GemsGLobals.gemsPlusMembershipNo;
    });

    AuthUtils.getGemsPlusExpiryDate().then((value) {
      GemsGLobals.gemsPlusExpiryDate = value;
      gemsPlusExpiryDate = GemsGLobals.gemsPlusExpiryDate;
    });

    AuthUtils.getGemsPlusMemberPhoto().then((value) {
      GemsGLobals.gemsPlusMemberPhoto = value;
      gemsPlusMemberPhoto = GemsGLobals.gemsPlusMemberPhoto;
    });

    AuthUtils.getGemsPlusMemberRelationShipCode().then((value) {
      GemsGLobals.gemsMemberRelationCode = value;
      gemsMemberRelationCode = GemsGLobals.gemsMemberRelationCode;
    });
    Future.delayed(const Duration(seconds: 4), () async {
      checkRouting();
    });
    GemsGLobals.lastVisitPageName = GemsGLobals.homepage;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    GemsGLobals.openHomePage = false;
  }

  checkRouting() {
    switch (GemsGLobals.routeTo) {
      case 'mycart':
        GemsGLobals.routeTo = null;
        setState(() {
          GemsGLobals.backbutton = "false";
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShopTabBarPage(
                    index: 2,
                  )),
        );
        break;
      case 'wishlist':
        GemsGLobals.routeTo = null;
        setState(() {
          GemsGLobals.backbutton = "false";
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShopTabBarPage(
                    index: 3,
                  )),
        );
        break;
      case 'myaccount':
        GemsGLobals.routeTo = null;
        setState(() {
          GemsGLobals.backbutton = "false";
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShopTabBarPage(
                    index: 4,
                  )),
        );
        break;
      default:
    }
  }

  void offerlistapi(sortby) {
    var request = {
      "customer_id": GemsGLobals.membershipNo,
      "lat": GemsGLobals.lat,
      "long": GemsGLobals.long,
      "search_text": "",
      "sortby": sortby,
      "user_type": GemsGLobals.userType
    };
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _offerlistpresenter!.offerListAPI(request);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));

        if (connectionResult) {
          setState(() {});
          _offerlistpresenter!.offerListAPI(request);
        }
      }
    });
  }

  void getMemberSavingBalance() {
    Internetconnectivity().isConnected().then((isConnected) {
      if (isConnected) {
        UserApiConfig()
            .memberSavingPoints(http.Client(), GemsGLobals.membershipNo)
            .then((value) {
          if (value['status'] == true) {
            setState(() {
              GemsGLobals.userSavingBalance =
                  value['values']['saving_point'].toString();
            });
          }
        });
      }
    });
  }

  void getAdvancedPlusMemberData() {
    var advPlusNo;
    if (GemsGLobals.gemsPlusIsMemberOrNot == "yes") {
      advPlusNo = GemsGLobals.gemsPlusMembershipNo;
    } else {
      advPlusNo = GemsGLobals.membershipNo;
    }

    AdvPlusCache().fetchAdvantagePlusMemberDetailsData().then((value) {
      if (value == null) {
        AdvantageplusApiConfig.advantagePlusDetailsDataApi(
                http.Client(), advPlusNo)
            .then((response) {
          if (response["status"] == true) {
            userFamilyInfo = response["data"]["values"];
            advCardStatus = userFamilyInfo["membership_status"];
            if (advCardStatus == 'expired') {
              advplusCardColor = advantagePlus_grey_color;
              _textcolor = advantagePlus_text_grey_color;
              advPlusgif = ImageConstants.advArrow_grey;
            } else if (advCardStatus == 'payment_defaulted_on_hold' ||
                advCardStatus == 'cancelled') {
              advplusCardColor = advantagePlus_red_color;
              _textcolor = advantagePlus_whitetext_red_color;
              advPlusgif = ImageConstants.advArrow_forRed;
            } else if (advCardStatus == 'processing') {
              advplusCardColor = advantagePlus_blue_color;
              _textcolor = advantagePlus_whitetext_red_color;
              advPlusgif = ImageConstants.advArrow_forRed;
            } else {
              advplusCardColor = advantagePlus_member_tile_color;
              _textcolor = Color(0xff71726a);
              advPlusgif = ImageConstants.advplus_arwdwn;
            }

            AdvPlusCache().saveAdvantagePlusMemberDetailsData(userFamilyInfo);
          } else {
            setState(() {
              hideCrash = true;
            });
          }
        });
      } else {
        userFamilyInfo = jsonDecode(value);
        advCardStatus = userFamilyInfo["membership_status"];
        if (advCardStatus == 'expired') {
          advplusCardColor = advantagePlus_grey_color;
          _textcolor = advantagePlus_text_grey_color;
          advPlusgif = ImageConstants.advArrow_grey;
        } else if (advCardStatus == 'payment_defaulted_on_hold' ||
            advCardStatus == 'cancelled') {
          advplusCardColor = advantagePlus_red_color;
          _textcolor = advantagePlus_whitetext_red_color;
          advPlusgif = ImageConstants.advArrow_forRed;
        } else if (advCardStatus == 'processing') {
          advplusCardColor = advantagePlus_blue_color;
          _textcolor = advantagePlus_whitetext_red_color;
          advPlusgif = ImageConstants.advArrow_forRed;
        } else {
          advplusCardColor = advantagePlus_member_tile_color;
          _textcolor = Color(0xff71726a);
          advPlusgif = ImageConstants.advplus_arwdwn;
        }
      }
    });
  }

  String gemsMemberId = '2347578791';
  String usertypes = 'parent';

  Future<void> getProfileDataDB() async {
    List<UserProfileDbModel> userProfileDBModel =
        await UserProfileDbHelper().fetchUserProfileData();
    if (userProfileDBModel.isNotEmpty) {
      try {
        UserProfileModel model =
            userModelFromJson(userProfileDBModel.first.userprofiledata);
        setState(() {
          var membershipId;
          membershipId = model.values?.membershipNo ?? '';
          GemsGLobals.membershipNo = membershipId;
        });
      } catch (e) {
        UserProfileModel model =
            userModelFromJson(userProfileDBModel.first.userprofiledata);
        setState(() {
          var membershipId;
          membershipId = model.values?.membershipNo ?? '';
          GemsGLobals.membershipNo = membershipId;
        });
      }
    }
  }

  void userProfileApi(membershipNo) {
    Internetconnectivity().isConnected().then((connected) async {
      if (connected) {
        _userProfilePresenter!.userProfileResonse(membershipNo);
        getMemberSavingBalance();
      }
    });
  }

  customerredeemdetail() {
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _isloading = true;
        if (GemsGLobals.userType != "guest") {}

        if (GemsGLobals.userType == "guest") {
          _homeSectionApi(GemsGLobals.userType, null, null, null, null, null);
        }
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          _isloading = false;
          customerredeemdetail();
        }
      }
    });
  }

  void registerdevicecall() async {
    GemsGLobals.makesenseDeviceID =
        await AuthUtils.getStringValue("makesenseDevideId");
  }

/* Function to store user data after 10 days -- implemented by Animesh */
  Future<SharedPreferences> _date = SharedPreferences.getInstance();
  SharedPreferences? _newdate;

  Future<String?> _getdate(_sharedPreferences, _date) async {
    _newdate = await _date;
    var storedDate = AuthUtils.getdate(_newdate!);
    return storedDate;
  }

  dateformater(userData) {
    var date = new DateTime.now();
    var newDate = date.add(Duration(days: 10));
    /* shared preferences GET method for date is called */
    _getdate(_newdate, _date).then((result) {
      setState(() {
        if (result == null) {
          AuthUtils.setdate(newDate.toString());
          AuthUtils.setuserData((json.encode(userData)).toString());
        } else {
          var diff = DateTime.parse(result).difference(date);

          if (diff.inDays <= 0) {
            setState(() {
              AuthUtils.setdate(newDate.toString());
              AuthUtils.setuserData((json.encode(userData)).toString());
            });
          }
          setState(() {
            AuthUtils.setuserData((json.encode(userData)).toString());
          });
        }
      });
    });
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
/* *****Start OFFER Section ************* */
    Widget exploreOffers(data) {
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 5, left: 15, top: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: TextWidget(
                        text: data["sname"],
                        size: text_font_medium_x_size,
                        weight: FontWeight.bold,
                        color: brown),
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 4,
                        childAspectRatio: 0.75),
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: min(data["subsection"].length, 8),
                    itemBuilder: (context, index) {
                      if (seeMoreLess == false &&
                          data["subsection"].length > 8 &&
                          index == 7) {
                        return GestureDetector(
                            onTap: () {
                              if (GemsGLobals.userType == "guest") {
                                setState(() {
                                  DialogAlert.showLoginAlert(context);
                                });
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewMore(
                                            offerSubsection:
                                                _offerSubsection)));
                              }
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 0,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width /
                                              4 -
                                          13,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(14)),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            ImageConstants.seeMoreOffers,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                ImageConstants.noimages,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          )),
                                    ),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                              4 -
                                          13,
                                      padding:
                                          EdgeInsets.only(bottom: 2, top: 0),
                                      child: TextWidget(
                                        alignment: TextAlign.center,
                                        text: "More",
                                        color: brown,
                                        size: text_font_size_small,
                                        weight: FontWeight.w500,
                                      )),
                                ],
                              ),
                            ));
                      } else {
                        return GestureDetector(
                          onTap: () async {
                            var segmentReq = {                              
                               GemsGLobals.componentType: data["sname"],
                               GemsGLobals.clickedOnParam: data["subsection"][index]["category_name"] ??"",
                               GemsGLobals.navigationType: GemsGLobals.internalText,
                               GemsGLobals.intSource: GemsGLobals.lastVisitPageName
                            };
                            makesenseHomeClicked(segmentReq);
                            
                            if (GemsGLobals.userType == "guest") {
                              setState(() {
                                DialogAlert.showLoginAlert(context);
                              });
                            } else {
                              if (data["subsection"][index]['offer_brand'] ==
                                  "noon_food_LLC") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OfferDetail(
                                              brandcode: data["subsection"]
                                                      [index]["offer_brand"] ??
                                                  "",
                                              outletcode: data["subsection"]
                                                          [index]
                                                      ["offer_brand_outlet"] ??
                                                  "",
                                              partnerbrandid: data["subsection"]
                                                          [index]
                                                      ["partner_brndid"] ??
                                                  "",
                                              catcode: data["subsection"][index]
                                                      ["category_code"] ??
                                                  "",
                                              catname: data["subsection"][index]
                                                      ["category_name"] ??
                                                  "",
                                              subcatheading: data["subsection"]
                                                      [index]["alt_cat_name"] ??
                                                  "",
                                            ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OfferListing(
                                            subseccode: data["subsection"]
                                                [index]["sub_sec_code"],
                                            categoryCode: data["subsection"]
                                                    [index]["category_code"] ??
                                                '',
                                            categoryName: data["subsection"]
                                                    [index]["category_name"] ??
                                                '',
                                            categoryheading: data["subsection"]
                                                    [index]["alt_cat_name"] ??
                                                ""))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                              }
                            }
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 0,
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 4 -
                                            13,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: data["subsection"][index]
                                                        ["category_image"] !=
                                                    null &&
                                                data["subsection"][index]
                                                        ["category_image"] !=
                                                    ""
                                            ? data["subsection"][index]
                                                ["category_image"]
                                            : '',
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          ImageConstants.noimages,
                                          fit: BoxFit.cover,
                                        ),
                                        fadeInDuration:
                                            Duration(microseconds: 1),
                                        placeholderFadeInDuration:
                                            Duration(microseconds: 1),
                                        fadeOutDuration:
                                            Duration(microseconds: 1),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          ImageConstants.noimages,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Container(
                                      width: MediaQuery.of(context).size.width /
                                              4 -
                                          13,
                                      padding:
                                          EdgeInsets.only(bottom: 0, top: 0),
                                      child: TextWidget(
                                        alignment: TextAlign.center,
                                        text: data["subsection"][index]
                                                        ["sub_sec_name"] !=
                                                    null ||
                                                data["subsection"][index]
                                                        ["sub_sec_name"] !=
                                                    ""
                                            ? toBeginningOfSentenceCase(
                                                data["subsection"][index]
                                                        ["sub_sec_name"]
                                                    .toString())
                                            : '',
                                        color: brown,
                                        size: text_font_size_small,
                                        weight: FontWeight.w500,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    })),
            Container(
              height: 15,
              decoration: BoxDecoration(
                color: searchbar,
              ),
            )
          ],
        ),
      );
    }



    List<Widget> trendingofferListStructure(info) {
      List<Widget> _list = [];

      for (var i = 0; i < info.length; i++) {
        _list.add(Container(
          child: Row(
            children: [
              Container(
                  margin: EdgeInsets.only(left: 5, right: 7, top: 5),
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          child: GestureDetector(
                        onTap: () async {
                          var segmentRequest = {                            
                             GemsGLobals.componentType: info[i]["sub_sec_code"] ??'',
                             GemsGLobals.clickedOnParam: info[i]["outlet_name"]??'',
                             GemsGLobals.navigationType: GemsGLobals.internalText,
                             GemsGLobals.intSource: GemsGLobals.lastVisitPageName
                          };
                          makesenseHomeClicked(segmentRequest);
                          if (GemsGLobals.userType == "guest") {
                            setState(() {
                              DialogAlert.showLoginAlert(context);
                            });
                          } else {
                            if (info[i]["sub_sec_code"] != null ||
                                info[i]["sub_sec_code"] != "") {
                              switch (info[i]["sub_sec_code"]
                                  .toString()
                                  .toLowerCase()) {
                                case "affiliate":
                                  await affilatePartnerAPi(
                                      info[i]["affiliate_id"] ?? "11");
                                  break;

                                case "banner":
                                  await LaunchUrl.openLink(
                                      url: info[i]['sub_sec_url']);
                                  break;

                                case "partner":
                                  await _launchURLForyou(info[i]
                                          ['sub_sec_url'] +
                                      GemsGLobals.userId);
                                  break;

                                case 'offer':
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              OfferDetail(
                                                brandcode: info[i]
                                                    ["brand_code"],
                                                outletcode: info[i]
                                                    ["outlet_code"],
                                                partnerbrandid: info[i]
                                                    ["partner_brndid"],
                                                catcode: info[i]
                                                        ["category_code"] ??
                                                    "",
                                                catname: info[i]
                                                        ["category_name"] ??
                                                    "",
                                                subcatheading: info[i]
                                                        ["alt_cat_name"] ??
                                                    "",
                                              ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                                  break;

                                case 'hotel':
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (contex) =>
                                              HotelHomePage())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                                  break;
                                case 'flight':
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (contex) => FlightHomePage(
                                                tabIndex: 0,
                                              ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                                  break;
                                case 'giftcard':
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (contex) =>
                                              GiftCardCategory())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                                  break;

                                default:
                                  await _launchURLForyou(
                                      info[i]['sub_sec_url']);
                                  break;
                              }
                            }
                          }
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                child: CachedNetworkImage(
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    ImageConstants.noimages,
                                    fit: BoxFit.fill,
                                  ),
                                  imageUrl: info[i]['sub_sec_image'] ?? "",
                                  height: 125,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: 120,
                                    height: 170,
                                    child: Image.asset(
                                      ImageConstants.noimages,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ))),
                      )),
                      SizedBox(height: 5),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 2, left: 3),
                              alignment: Alignment.centerLeft,
                              child: TextWidget(
                                text: info[i]["sub_sec_name"] != null ||
                                        info[i]["sub_sec_name"] != ""
                                    ? info[i]["sub_sec_name"]
                                    : "",
                                color: home_title_text_orange,
                                overflow: TextOverflow.ellipsis,
                                weight: FontWeight.bold,
                                size: text_font_size_x_small,
                              ),
                            ),
                            SizedBox(height: 3),
                            info[i]["offer_title"] != null ||
                                    info[i]["offer_title"] != ""
                                ? Container(
                                    child: TextWidget(
                                      text: info[i]["offer_title"],
                                      color: greyish,
                                      weight: FontWeight.w400,
                                      size: text_font_size_small,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                : Container(
                                    height: 0,
                                  )
                          ],
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ));
      }
      return _list;
    }

    Widget _trendingOfferListView(listData) {
      return Container(
          alignment: Alignment.centerLeft,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 0, left: 15, bottom: 0),
                        child: TextWidget(
                            text: listData["sname"],
                            size: text_font_medium_x_size,
                            weight: FontWeight.bold,
                            color: brown),
                      ),
                    ),
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(left: 0, bottom: 10, right: 0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: ScrollPhysics(),
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children:
                            trendingofferListStructure(listData["subsection"]),
                      ),
                    )),
                Container(
                  height: 15,
                  decoration: BoxDecoration(
                    color: searchbar,
                  ),
                )
              ]));
    }

    Widget _latestOfferGrid(info, index) {
      return Container(
        width: MediaQuery.of(context).size.width / 2.3,
        margin: EdgeInsets.only(bottom: 20, left: 0, right: 0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: grey_gunsmoke_text_color, width: 0.1),
              borderRadius: BorderRadius.circular(14)),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  var segmentReq = {
                     GemsGLobals.componentType: info[index]["sub_sec_code"]??'',
                     GemsGLobals.clickedOnParam: info[index]["outlet_name"] ?? "",
                     GemsGLobals.navigationType: GemsGLobals.internalText,
                     GemsGLobals.intSource: GemsGLobals.lastVisitPageName
                  };
                  makesenseHomeClicked(segmentReq);
                  if (GemsGLobals.userType == "guest") {
                    setState(() {
                      DialogAlert.showLoginAlert(context);
                    });
                  } else {
                    if (info[index]["sub_sec_code"] != null ||
                        info[index]["sub_sec_code"] != "") {
                      switch (info[index]["sub_sec_code"]
                          .toString()
                          .toLowerCase()) {
                        case "affiliate":
                          await affilatePartnerAPi(
                              info[index]["affiliate_id"] ?? "11");
                          break;

                        case "banner":
                          await LaunchUrl.openLink(
                              url: info[index]['sub_sec_url']);
                          break;

                        case "partner":
                          await _launchURLForyou(
                              info[index]['sub_sec_url'] + GemsGLobals.userId);
                          break;

                        case 'offer':
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      OfferDetail(
                                        brandcode: info[index]["brand_code"],
                                        outletcode: info[index]["outlet_code"],
                                        partnerbrandid: info[index]
                                            ["partner_brndid"],
                                        catcode:
                                            info[index]["category_code"] ?? "",
                                        catname:
                                            info[index]["category_name"] ?? "",
                                        subcatheading:
                                            info[index]["alt_cat_name"] ?? "",
                                      ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                          break;

                        case 'hotel':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) => HotelHomePage())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                          break;
                        case 'flight':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) => FlightHomePage(
                                        tabIndex: 0,
                                      ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                          break;
                        case 'giftcard':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) => GiftCardCategory())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                          break;

                        default:
                          await _launchURLForyou(info[index]['sub_sec_url']);
                          break;
                      }
                    }
                  }
                },
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: info[index]['sub_sec_image'] ?? "",
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Container(
                        child: Image.asset(
                          ImageConstants.noimages,
                          fit: BoxFit.cover,
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        return Image.asset(
                          ImageConstants.noimages,
                          fit: BoxFit.fill,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
                alignment: Alignment.centerLeft,
                child: TextWidget(
                    text: info[index]["sub_sec_name"],
                    color: home_title_text_black,
                    overflow: TextOverflow.ellipsis,
                    size: text_font_size_x_small,
                    weight: FontWeight.w600),
              ),
              info[index]["sub_sec_desc"] != null &&
                      info[index]["sub_sec_desc"] != ''
                  ? Container(
                      color: transColor,
                      margin: EdgeInsets.only(
                          top: 0, left: 10, bottom: 10, right: 10),
                      alignment: Alignment.centerLeft,
                      child: TextWidget(
                        text: info[index]["sub_sec_desc"] != null ||
                                info[index]["sub_sec_desc"] != ""
                            ? info[index]["sub_sec_desc"].toString().length > 25
                                ? info[index]["sub_sec_desc"]
                                : info[index]["sub_sec_desc"] + '\n'
                            : "",
                        color: Color(0xff969390),
                        size: text_font_size_small,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                      ))
                  : Container(
                      height: 10,
                      color: transColor,
                      child: TextWidget(
                        text: ' ',
                        size: text_font_size_small,
                      ),
                    ),
            ],
          ),
        ),
      );
    }

    List<Widget> trendingofferGridStructureLooping(info) {
      List<Widget> _list = [];
      for (var i = 0; i < info.length; i++) {
        _list.add(_latestOfferGrid(info, i));
      }
      return _list;
    }

    Widget _trendingOfferGridView(listData) {
      return Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 15, bottom: 10),
            child: TextWidget(
              text: listData["sname"],
              size: text_font_medium_x_size,
              weight: FontWeight.bold,
              color: brown,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                children:
                    trendingofferGridStructureLooping(listData["subsection"])),
          ),
          Container(
            height: 15,
            decoration: BoxDecoration(
              color: searchbar,
            ),
          )
        ],
      ));
    }

/* *****End Trending Section ************* */

/* *****Offer For you Section ************* */

    List<Widget> offerForYouListStructure(info) {
      List<Widget> _list = [];

      for (var i = 0; i < info.length; i++) {
        _list.add(Container(
            child: Container(
          width: MediaQuery.of(context).size.width / 1.35,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  var segmentRequest = {
                     GemsGLobals.componentType: info[i]["sub_sec_code"] ?? "",
                     GemsGLobals.clickedOnParam: info[i]["outlet_name"] ?? "",
                     GemsGLobals.navigationType: GemsGLobals.internalText,
                     GemsGLobals.intSource: GemsGLobals.lastVisitPageName
                  };
                  makesenseHomeClicked(segmentRequest);
                  if (GemsGLobals.userType == "guest") {
                    setState(() {
                      DialogAlert.showLoginAlert(context);
                    });
                  } else {
                    if (info[i]["sub_sec_code"] != null ||
                        info[i]["sub_sec_code"] != "") {
                      switch (
                          info[i]["sub_sec_code"].toString().toLowerCase()) {
                        case "affiliate":
                          await affilatePartnerAPi(
                              info[i]["affiliate_id"] ?? "11");
                          break;

                        case "banner":
                          await LaunchUrl.openLink(url: info[i]['sub_sec_url']);
                          break;

                        case "partner":
                          await _launchURLForyou(
                              info[i]['sub_sec_url'] + GemsGLobals.userId);
                          break;

                        case 'offer':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      OfferDetail(
                                        brandcode: info[i]["brand_code"],
                                        outletcode: info[i]["outlet_code"],
                                        partnerbrandid: info[i]
                                            ["partner_brndid"],
                                        catcode: info[i]["category_code"] ?? "",
                                        catname: info[i]["category_name"] ?? "",
                                        subcatheading:
                                            info[i]["alt_cat_name"] ?? "",
                                      ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                          break;

                        case 'hotel':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) => HotelHomePage())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                          break;
                        case 'flight':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) => FlightHomePage(
                                        tabIndex: 0,
                                      ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                          break;
                        case 'giftcard':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) => GiftCardCategory())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                          break;

                        default:
                          await _launchURLForyou(info[i]['sub_sec_url']);
                          break;
                      }
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => OfferDetail(
                                    brandcode: info[i]["brand_code"],
                                    outletcode: info[i]["outlet_code"],
                                    partnerbrandid: info[i]["partner_brndid"],
                                    catcode: info[i]["category_code"] ?? "",
                                    catname: info[i]["category_name"] ?? "",
                                    subcatheading:
                                        info[i]["alt_cat_name"] ?? "",
                                  ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                    }
                  }
                },
                child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width / 1.35,
                  child: Card(
                      color: Colors.transparent,
                      elevation: 0.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15)),
                        child: CachedNetworkImage(
                          errorWidget: (context, url, error) {
                            return Image.asset(
                              ImageConstants.noimages,
                              fit: BoxFit.fill,
                            );
                          },
                          imageUrl: info[i]['sub_sec_image'] ?? "",
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Container(
                            child: Image.asset(
                              ImageConstants.noimages,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      )),
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 4, left: 10),
                      alignment: Alignment.centerLeft,
                      child: TextWidget(
                        text: info[i]["sub_sec_name"] != null ||
                                info[i]["sub_sec_name"] != ""
                            ? info[i]["sub_sec_name"]
                            : "",
                        size: text_font_size_x_small,
                        color: home_title_text_orange,
                        overflow: TextOverflow.ellipsis,
                        weight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: ReadMoreText(
                        info[i]["sub_sec_desc"] != null
                            ? info[i]["sub_sec_desc"]
                            : "",
                        style: TextStyle(
                            color: Color(0xff969390),
                            fontSize: text_font_size_small),
                        trimLength: 38,
                        trimMode: TrimMode.Length,
                        trimCollapsedText: "... read more",
                        trimExpandedText: "...read less",
                        moreStyle: TextStyle(
                            color: aqua_blue, fontWeight: FontWeight.bold),
                        lessStyle: TextStyle(
                            color: aqua_blue, fontWeight: FontWeight.bold),
                        delimiter: " ",
                        callback: (val) {},
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )));
      }
      return _list;
    }


    Widget noonGrid(info, index) {
      return Container(
        width: MediaQuery.of(context).size.width / 2.0,
        margin: EdgeInsets.only(bottom: 20, left: 0, right: 0, top: 10),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: grey_gunsmoke_text_color, width: 0.1),
              borderRadius: BorderRadius.circular(14)),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  var segmentRequest = {
                    GemsGLobals.componentType: info[index]["sub_sec_code"]  ?? "",
                    GemsGLobals.clickedOnParam: info[index]["sub_sec_code"]  ?? "",
                    GemsGLobals.navigationType: GemsGLobals.internalText,
                    GemsGLobals.intSource: GemsGLobals.lastVisitPageName
                  };
                  makesenseHomeClicked(segmentRequest);
                  if (GemsGLobals.userType == "guest") {
                    setState(() {
                      DialogAlert.showLoginAlert(context);
                    });
                  } else {
                    if (info[index]["sub_sec_code"] != null ||
                        info[index]["sub_sec_code"] != "") {
                      switch (info[index]["sub_sec_code"]
                          .toString()
                          .toLowerCase()) {
                        case "affiliate":
                          await affilatePartnerAPi(
                              info[index]["affiliate_id"] ?? "11");
                          break;

                        case "banner":
                          await LaunchUrl.openLink(
                              url: info[index]['sub_sec_url']);
                          break;

                        case "partner":
                          await _launchURLForyou(
                              info[index]['sub_sec_url'] + GemsGLobals.userId);
                          break;

                        case 'offer':
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      OfferDetail(
                                        brandcode: info[index]["brand_code"],
                                        outletcode: info[index]["outlet_code"],
                                        partnerbrandid: info[index]
                                            ["partner_brndid"],
                                        catcode:
                                            info[index]["category_code"] ?? "",
                                        catname:
                                            info[index]["category_name"] ?? "",
                                        subcatheading:
                                            info[index]["alt_cat_name"] ?? "",
                                      ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                          break;

                        case 'hotel':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) => HotelHomePage())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                          break;
                        case 'flight':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) => FlightHomePage(
                                        tabIndex: 0,
                                      ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                          break;
                        case 'giftcard':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) => GiftCardCategory())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                          break;

                        default:
                          await _launchURLForyou(info[index]['sub_sec_url']);
                          break;
                      }
                    }
                  }
                },
                child: Container(
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: info[index]['sub_sec_image'] ?? "",
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Container(
                        child: Image.asset(
                          ImageConstants.noimages,
                          fit: BoxFit.cover,
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        return Image.asset(
                          ImageConstants.noimages,
                          fit: BoxFit.fill,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    List<Widget> noonGridStructureLooping(info) {
      List<Widget> _list = [];
      for (var i = 0; i < info.length; i++) {
        _list.add(noonGrid(info, i));
      }
      return _list;
    }

    Widget _noonGridView(listData) {
      return Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                children: noonGridStructureLooping(listData["subsection"])),
          ),
          Container(
            height: 15,
            decoration: BoxDecoration(
              color: searchbar,
            ),
          )
        ],
      ));
    }

    Widget foryouCorosolnewnoon(listData) {
      return CarouselSlider.builder(
        options: CarouselOptions(
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          pauseAutoPlayOnTouch: true,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
              _currentPageNotifier1.value = _current;
            });
          },
        ),
        itemCount: listData["subsection"].length,
        itemBuilder: (BuildContext context, int itemIndex, realIndex) =>
            GestureDetector(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 3, 5, 0),
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: listData["subsection"][itemIndex]
                                ["sub_sec_image"] ??
                            ImageConstants.noimages,
                        placeholder: (context, url) => Image.asset(
                          ImageConstants.noimages,
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) {
                          return Image.asset(
                            ImageConstants.noimages,
                            fit: BoxFit.fill,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () async {
            var segmentReq = {
                  GemsGLobals.componentType: listData["subsection"][itemIndex]["sub_sec_code"],
                  GemsGLobals.clickedOnParam: listData["subsection"][itemIndex]['outlet_name'] ?? '',
                  GemsGLobals.navigationType: GemsGLobals.internalText,
                  GemsGLobals.intSource: GemsGLobals.lastVisitPageName
            };
            makesenseHomeClicked(segmentReq);
            if (GemsGLobals.userType == "guest") {
              setState(() {
                DialogAlert.showLoginAlert(context);
              });
            } else {
              if (listData["subsection"][itemIndex]["sub_sec_code"] != null ||
                  listData["subsection"][itemIndex]["sub_sec_code"] != "") {
                switch (listData["subsection"][itemIndex]["sub_sec_code"]
                    .toString()
                    .toLowerCase()) {
                  case "affiliate":
                    await affilatePartnerAPi(listData["subsection"][itemIndex]
                            ["affiliate_id"] ??
                        "11");
                    break;

                  case "banner":
                    await LaunchUrl.openLink(
                        url: listData["subsection"][itemIndex]['sub_sec_url']);
                    break;

                  case "partner":
                    await _launchURLForyou(listData["subsection"][itemIndex]
                            ['sub_sec_url'] +
                        GemsGLobals.userId);
                    break;

                  case 'offer':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => OfferDetail(
                                  brandcode: listData["subsection"][itemIndex]
                                      ["brand_code"],
                                  outletcode: listData["subsection"][itemIndex]
                                      ["outlet_code"],
                                  partnerbrandid: listData["subsection"]
                                      [itemIndex]["partner_brndid"],
                                  catcode: listData["subsection"][itemIndex]
                                          ["category_code"] ??
                                      "",
                                ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                    break;

                  case 'hotel':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (contex) => HotelHomePage())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                    break;
                  case 'flight':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (contex) => FlightHomePage(
                                  tabIndex: 0,
                                ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                    break;
                  case 'giftcard':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (contex) => GiftCardCategory())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                    break;

                  default:
                    await _launchURLForyou(
                        listData["subsection"][itemIndex]['sub_sec_url']);
                    break;
                }
              }
            }
          },
        ),
      );
    }

    Widget _noonslider(listData) {
      return Container(
          padding: EdgeInsets.only(bottom: 0, top: 10, right: 10, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[foryouCorosolnewnoon(listData)],
          ));
    }

    /* *****Noon Section End************* */

    Widget _offerForYouListView(listData) {
      return Container(
          color: red_color,
          margin: EdgeInsets.only(left: 5, right: 5, top: 0),
          alignment: Alignment.centerLeft,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 0, left: 10, bottom: 5),
                        child: TextWidget(
                            text: listData["sname"],
                            size: text_font_medium_x_size,
                            weight: FontWeight.bold,
                            color: brown),
                      ),
                    ),
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(left: 5, bottom: 10, right: 5),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: ScrollPhysics(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            offerForYouListStructure(listData["subsection"]),
                      ),
                    )),
                Container(
                  height: 15,
                  decoration: BoxDecoration(
                    color: searchbar,
                  ),
                )
              ]));
    }

    List<Widget> latestofferListStructure(info) {
      List<Widget> _list = [];

      for (var i = 0; i < info.length; i++) {
        _list.add(Container(
          child: Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: grey_gunsmoke_text_color, width: 0.1),
                      borderRadius: BorderRadius.circular(14)),
                  margin: EdgeInsets.only(left: 0, right: 7, top: 10),
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          if (GemsGLobals.userType == "guest") {
                            setState(() {
                              DialogAlert.showLoginAlert(context);
                            });
                          } else {
                            if (info[i]["sub_sec_code"] != null ||
                                info[i]["sub_sec_code"] != "") {
                              switch (info[i]["sub_sec_code"]
                                  .toString()
                                  .toLowerCase()) {
                                case "affiliate":
                                  await affilatePartnerAPi(
                                      info[i]["affiliate_id"] ?? "11");
                                  break;

                                case "banner":
                                  await LaunchUrl.openLink(
                                      url: info[i]['sub_sec_url']);
                                  break;

                                case "partner":
                                  await _launchURLForyou(info[i]
                                          ['sub_sec_url'] +
                                      GemsGLobals.userId);
                                  break;

                                case 'offer':
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              OfferDetail(
                                                brandcode: info[i]
                                                    ["brand_code"],
                                                outletcode: info[i]
                                                    ["outlet_code"],
                                                partnerbrandid: info[i]
                                                    ["partner_brndid"],
                                                catcode: info[i]
                                                        ["category_code"] ??
                                                    "",
                                                catname: info[i]
                                                        ["category_name"] ??
                                                    "",
                                                subcatheading: info[i]
                                                        ["alt_cat_name"] ??
                                                    "",
                                              ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                                  break;

                                case 'hotel':
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (contex) =>
                                              HotelHomePage())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                                  break;
                                case 'flight':
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (contex) => FlightHomePage(
                                                tabIndex: 0,
                                              ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                                  break;
                                case 'giftcard':
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (contex) =>
                                              GiftCardCategory())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                                  break;

                                default:
                                  _launchURLForyou(info[i]['sub_sec_url']);
                                  break;
                              }
                            }
                            var segmentReq = {
                              GemsGLobals.componentType: info[i]["sub_sec_code"] ?? "",
                              GemsGLobals.clickedOnParam: info[i]['outlet_name'] ?? "",
                              GemsGLobals.navigationType: GemsGLobals.internalText,
                              GemsGLobals.intSource: GemsGLobals.lastVisitPageName
                            };
                            makesenseHomeClicked(segmentReq);
                          }
                        },
                        child: Container(
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: CachedNetworkImage(
                                      errorWidget: (context, url, error) {
                                        return Image.asset(
                                          ImageConstants.noimages,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                      imageUrl: info[i]['sub_sec_image'] ?? "",
                                      height: 125,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        width: 120,
                                        height: 170,
                                        child: Image.asset(
                                          ImageConstants.noimages,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )))),
                      ),
                      SizedBox(height: 5),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 4, left: 0),
                              alignment: Alignment.centerLeft,
                              child: TextWidget(
                                text: info[i]["sub_sec_name"] != null ||
                                        info[i]["sub_sec_name"] != ""
                                    ? info[i]["sub_sec_name"]
                                    : "",
                                color: black_color,
                                overflow: TextOverflow.ellipsis,
                                weight: FontWeight.bold,
                                size: text_font_size_x_small,
                              ),
                            ),
                            SizedBox(height: 4),
                            Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: ReadMoreText(
                                info[i]["sub_sec_desc"] != null ||
                                        info[i]["sub_sec_desc"] != ""
                                    ? info[i]["sub_sec_desc"]
                                    : '',
                                style: TextStyle(
                                    color: greyish,
                                    fontWeight: FontWeight.w400,
                                    fontSize: text_font_size_small),
                                trimLength: 20,
                                trimMode: TrimMode.Length,
                                trimCollapsedText: "... read more",
                                trimExpandedText: "...read less",
                                moreStyle: TextStyle(
                                    color: aqua_blue,
                                    fontWeight: FontWeight.bold),
                                lessStyle: TextStyle(
                                    color: aqua_blue,
                                    fontWeight: FontWeight.bold),
                                delimiter: " ",
                                callback: (val) {},
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ));
      }
      return _list;
    }

    Widget _latestOfferListView(listData) {
      return Container(
          alignment: Alignment.centerLeft,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 0, left: 15, bottom: 0),
                        child: TextWidget(
                            text: listData["sname"],
                            size: text_font_medium_x_size,
                            weight: FontWeight.bold,
                            color: brown),
                      ),
                    ),
                  ],
                ),
                Container(
                    child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: latestofferListStructure(listData["subsection"]),
                  ),
                ))
              ]));
    }


    Widget demoforyouCorosol() {
      return Stack(children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            pauseAutoPlayOnTouch: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
                _currentPageNotifier1.value = _current;
              });
            },
          ),
          itemCount: 3,
          itemBuilder: (BuildContext context, int itemIndex, realIndex) =>
              GestureDetector(
            child: Container(
              height: 200,
              color: Colors.red,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: bg_color,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 3, 5, 0),
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(8.0),
                    child: Image.asset(
                      ImageConstants.noimages,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            onTap: () {},
          ),
        ),
      ]);
    }

    Widget corosol(list, i) {
      return Container(
        width: MediaQuery.of(context).size.width / 1.2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () async {                
                var bannerClickedRequest = {
                  GemsGLobals.componentType: GemsGLobals.banner,
                  GemsGLobals.clickedOnParam: list[i]['bnr_name'] ??'',
                  GemsGLobals.navigationType: GemsGLobals.internalText,
                  GemsGLobals.intSource: GemsGLobals.lastVisitPageName
                };
                makesenseHomeClicked(bannerClickedRequest);

                if (list[i]['bnr_code'] == 'adv_plus_registration') {
                  if (GemsGLobals.userType == "guest") {
                    setState(() {
                      DialogAlert.showLoginAlert(context);
                    });
                  } else {
                    setState(() {
                      checkFlag = true;
                    });

                    await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdvantagePlusWebPage()))
                        .whenComplete(() {
                      setState(() {
                        userProfileApi(GemsGLobals.membershipNo);
                      });
                    });
                  }
                } else if (list[i]['bnr_code'].toString().toLowerCase() ==
                    'shop') {
                  if (GemsGLobals.userType == "guest") {
                    setState(() {
                      DialogAlert.showLoginAlert(context);
                    });
                  } else {
                    setState(() {
                      GemsGLobals.backbutton = "false";
                    });
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShopTabBarPage(
                                  index: 0,
                                  tabIndex: 0,
                                ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                  }
                } else if (list[i]['routeType'].toString().toLowerCase() ==
                    'affiliate') {
                  await affilatePartnerAPi(list[i]["affiliate_id"]);
                } else if (list[i]['routeType'].toString().toLowerCase() ==
                    'offers') {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => OfferDetail(
                                brandcode: list[i]['bnr_brand'],
                                outletcode: list[i]['bnr_outlet'],
                                partnerbrandid: '',
                                catcode: "",
                                catname: "",
                                subcatheading: "",
                              ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                } else {
                  if (list[i]['bnr_url'] != null || list[i]['bnr_url'] != '') {
                    await LaunchUrl.openLink(url: list[i]['bnr_url']);
                  }
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 160,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(14)),
                margin: EdgeInsets.only(left: 0, right: 10),
                child: Card(
                    color: Colors.transparent,
                    elevation: 0.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: CachedNetworkImage(
                        errorWidget: (context, url, error) {
                          return Image.asset(
                            ImageConstants.noimages,
                            fit: BoxFit.fill,
                          );
                        },
                        imageUrl: "${list[i]['bnr_image']}",
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Container(
                          child: Image.asset(ImageConstants.noimages,
                              fit: BoxFit.fill),
                        ),
                      ),
                    )),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 0,
                      left: 5,
                    ),
                    alignment: Alignment.centerLeft,
                    child: TextWidget(
                      text: list[i]['bnr_name'],
                      color: home_title_text_black,
                      overflow: TextOverflow.ellipsis,
                      weight: FontWeight.bold,
                      size: text_font_size_x_small,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 10),
                    child: ReadMoreText(
                      list[i]['bnr_desc'] == null || list[i]['bnr_desc'] == ''
                          ? ''
                          : list[i]['bnr_desc'],
                      style: TextStyle(
                          color: Color(0xff969390),
                          fontSize: text_font_size_small),
                      trimLength: 85,
                      trimMode: TrimMode.Length,
                      trimCollapsedText: "... read more",
                      trimExpandedText: "...read less",
                      moreStyle: TextStyle(
                          color: aqua_blue, fontWeight: FontWeight.bold),
                      lessStyle: TextStyle(
                          color: aqua_blue, fontWeight: FontWeight.bold),
                      delimiter: " ",
                      callback: (val) {},
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

    List<Widget> _homeBannerStructure(banner) {
      List<Widget> _list = [];

      for (var i = 0; i < banner.length; i++) {
        _list.add(Container(
          child: corosol(banner, i),
        ));
      }
      return _list;
    }

    Widget _homeBannerWidget(info) {
      return Column(
        children: [
          Container(
              margin: EdgeInsets.only(left: 13, right: 5, bottom: 5),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _homeBannerStructure(info['subsection'])),
              )),
          Container(
            height: 15,
            decoration: BoxDecoration(
              color: searchbar,
            ),
          )
        ],
      );
    }

    Widget userInformation() {
      return iconContainerHeight == 0
          ? Container(
              height: 0,
            )
          : Container(
              padding: EdgeInsets.only(top: 10, bottom: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyAccount(
                                    fromscreen: "home_welcome",
                                  )),
                        );
                      },
                      child: Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(
                            left: 10,
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: TextWidget(
                                  text: "Welcome",
                                  size: text_font_medium19_size,
                                  color: greyshade,
                                )),
                                Row(
                                  children: <Widget>[
                                    Container(
                                        alignment: Alignment.centerLeft,
                                        margin: EdgeInsets.only(right: 5),
                                        child: TextWidget(
                                          text:
                                              '${GemsGLobals.userFirstName ?? ''}  ',
                                          size: text_font_medium19_size,
                                          weight: FontWeight.w600,
                                        )),
                                  ],
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              color: Color(0xffD1F1FF),
                              borderRadius: BorderRadius.circular(10)),
                          child: FittedBox(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyPointsDesignPage()),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(height: 5),
                                        Container(
                                          child: TextWidget(
                                            text: "GEMS Points",
                                            color: greyshade,
                                            size: text_font_medium_x_size,
                                          ),
                                        ),
                                        new SizedBox(
                                          height: 2,
                                        ),
                                        Container(
                                          child: TextWidget(
                                            text: gemsPointsFormatter(
                                                GemsGLobals.pointbalance),
                                            size: text_font_medium19_size,
                                            color: black_color,
                                            weight: FontWeight.w700,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                new SizedBox(
                                  width: 10,
                                ),
                                new SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MySaveingDesignPage()),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        color: Color(0xff00A3E0),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15,
                                          bottom: 10,
                                          top: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(height: 5),
                                          Container(
                                            child: TextWidget(
                                              text: "Total Savings",
                                              color: white_color,
                                              size: text_font_medium_x_size,
                                            ),
                                          ),
                                          new SizedBox(
                                            height: 2,
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: TextWidget(
                                              text: GemsGLobals
                                                          .userSavingBalance !=
                                                      null
                                                  ? "AED ${gemsPointsFormatter(double.tryParse(GemsGLobals.userSavingBalance!.toString())?.ceil())} "
                                                  : "",
                                              size: text_font_medium19_size,
                                              color: white_color,
                                              weight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )))
                ],
              ),
            );
    }


    Widget _earnCorosol(data) {
      return Stack(children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            height: 200,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            pauseAutoPlayOnTouch: true,
            onPageChanged: (index, reason) {
              setState(() {
                _earngemsIndex = index;
                _earncurrentPageNotifier.value = _earngemsIndex;
              });
            },
          ),
          itemCount: _earngemsCarouselImage.length,
          itemBuilder: (BuildContext context, int itemIndex, re) =>
              GestureDetector(
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: bg_color,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 3, 5, 0),
                  child: ClipRRect(
                    borderRadius: new BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: _earngemsCarouselImage[itemIndex] ??
                          ImageConstants.noimages,
                      errorWidget: (context, url, error) {
                        return Image.asset(
                          ImageConstants.noimages,
                          fit: BoxFit.fill,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            onTap: () async {
              var bannerClickedRequest = {         
                GemsGLobals.componentType: data["sub_sec_code"] ?? "",
                GemsGLobals.clickedOnParam:  _earngemsCarouselImage[itemIndex] ??"",
                GemsGLobals.navigationType: GemsGLobals.internalText,
                GemsGLobals.intSource: GemsGLobals.lastVisitPageName
              };
              makesenseHomeClicked(bannerClickedRequest);
            },
          ),
        ),
        _buildCircleIndicator(
            _earngemsCarouselImage.length, _earncurrentPageNotifier)
      ]);
    }

    Widget earngemscarousel(listData) {
      return Container(
          padding: EdgeInsets.only(top: 5, bottom: 20, right: 5, left: 5),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 8, left: 10, bottom: 10),
                        child: TextWidget(
                          text: listData["sname"],
                          size: text_font_medium_x_size,
                          weight: FontWeight.bold,
                          color: brown,
                        ),
                      ),
                    ),
                  ],
                ),
                _earngemsCarouselImage.length != 0
                    ? _earnCorosol(listData)
                    : demoforyouCorosol()
              ]));
    }


    Widget _searchBar() {
      return GestureDetector(
        onTap: () {
          setState(() {
            GemsGLobals.searchText = "";
          });

          var segmentRequest = {
            GemsGLobals.componentType: GemsGLobals.searchKeyword,
            GemsGLobals.clickedOnParam: GemsGLobals.searchKeyword,
            GemsGLobals.navigationType: GemsGLobals.internalText,
            GemsGLobals.intSource: GemsGLobals.lastVisitPageName
          };
          makesenseHomeClicked(segmentRequest);
          
          Navigator.push(
              context,
              MaterialPageRoute(
                  maintainState: false,
                  builder: (cxt) => CommonSearch())).then((value) {
                 GemsGLobals.lastVisitPageName = GemsGLobals.homepage;
            var search = value;
            if (search != null && search != '') {
              internetCall(
                  context,
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                              create: (context) => WishListCartCount(),
                              child: ProductListView(
                                catId: null,
                                searchValue: search,
                                categorypage: "yes",
                              )))));
            }
          });
        },
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: searchbar,
          ),
          height: 45.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 10),
                  child: SvgPicture.asset(
                    ImageConstants.searchicon,
                    height: 20,
                  )),
              SizedBox(
                width: 10,
              ),
              Container(
                child: TextWidget(
                  text: "What are you looking for?",
                  size: text_font_medium15_size,
                  overflow: TextOverflow.ellipsis,
                  color: const Color(0xff969390),
                  weight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      );
    }

    Widget earngemsPointListContainer(data) {
      return GestureDetector(
          onTap: () async {
            var bannerclickedReq = {
              GemsGLobals.componentType: data["sub_sec_code"]??'',
              GemsGLobals.clickedOnParam: data["sub_sec_code"]??'',
              GemsGLobals.navigationType: GemsGLobals.internalText,
              GemsGLobals.intSource: GemsGLobals.lastVisitPageName
            };
            makesenseHomeClicked(bannerclickedReq);
            if (data["sub_sec_code"].toString().toLowerCase() == "travel") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => TravelPartners(
                            travelsubection: data['subsection'],
                          ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
            } else if (data["sub_sec_code"].toString().toLowerCase() ==
                "insurance") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => InsurancePartners(
                            travelsubection: data['subsection'],
                          ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
            } else if (data["sub_sec_code"].toString().toLowerCase() ==
                "partner") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => OtherPartners(
                            travelsubection: data['subsection'],
                          ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
            } else if (data["sub_sec_code"].toString().toLowerCase() ==
                "giftcard") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => GiftCardCategory())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
            } else if (data["sub_sec_code"].toString().toLowerCase() ==
                "ecommerce") {
              setState(() {
                GemsGLobals.backbutton = "false";
              });

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ShopTabBarPage(
                            index: 0,
                            tabIndex: 0,
                          ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
            } else if (data["sub_sec_code"].toString().toLowerCase() ==
                "exchangepoints") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          PointConversionHomePage(data: data["subsection"]))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
            } else if (data["sub_sec_code"].toString().toLowerCase() == "fee") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => FeeRedemptionPage(
                            data: data["subsection"],
                            title: data["sub_sec_name"].toString(),
                          ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
            }
          },
          child: Container(
              padding: EdgeInsets.only(left: 0, right: 7, top: 0, bottom: 0),
              decoration: BoxDecoration(),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      clipBehavior: Clip.antiAlias,
                      elevation: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 4 - 19,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: data["sub_sec_image"] != null &&
                                    data["sub_sec_image"] != ""
                                ? data["sub_sec_image"]
                                : '',
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              )),
                            ),
                            placeholder: (context, url) => Image.asset(
                              ImageConstants.noimages,
                              fit: BoxFit.cover,
                            ),
                            fadeInDuration: Duration(microseconds: 1),
                            placeholderFadeInDuration:
                                Duration(microseconds: 1),
                            fadeOutDuration: Duration(microseconds: 1),
                            errorWidget: (context, url, error) => Image.asset(
                              ImageConstants.noimages,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width / 4 - 13,
                        padding: EdgeInsets.only(bottom: 0, top: 0),
                        child: TextWidget(
                          alignment: TextAlign.center,
                          text: data["sub_sec_name"] != null
                              ? data["sub_sec_name"] == "32"
                                  ? "Apple-E-Shop"
                                  : data["sub_sec_name"] == "33"
                                      ? "GEMS-E-Shop"
                                      : data["sub_sec_name"]
                              : "",
                          color: brown,
                          size: text_font_size_small,
                          weight: FontWeight.w500,
                        )),
                    new SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              )));
    }

    List<Widget> earngemsPonitListStruture(info) {
      List<Widget> _list = [];

      for (var i = 0; i < info.length; i++) {
        _list.add(Container(
          child: earngemsPointListContainer(info[i]),
        ));
      }
      return _list;
    }

    Widget _earngemspointsListWidget(listData) {
      return Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 0, left: 15, bottom: 5),
                      child: TextWidget(
                        text: listData["sname"],
                        size: text_font_medium_x_size,
                        weight: FontWeight.bold,
                        color: brown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: earngemsPonitListStruture(listData["subsection"]),
                  ),
                )),
            Container(
              height: 15,
              decoration: BoxDecoration(
                color: searchbar,
              ),
            )
          ]));
    }


    Widget _earngemsPointsGridWidget(listData) {
      return Container(
          padding: EdgeInsets.only(top: 5, left: 0, right: 0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 5, left: 15, bottom: 5),
                    child: TextWidget(
                        text: listData["sname"],
                        size: text_font_medium_x_size,
                        weight: FontWeight.bold,
                        color: brown),
                  ),
                ),
              ],
            ),
            Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 4,
                        childAspectRatio: 0.75),
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listData["subsection"].length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          var bannerClickedRequest = {
                            GemsGLobals.componentType: listData["sname"] ?? "",
                            GemsGLobals.clickedOnParam: listData["subsection"][index]["sub_sec_code"] ?? "",
                            GemsGLobals.navigationType: GemsGLobals.internalText,
                            GemsGLobals.intSource: GemsGLobals.lastVisitPageName
                          };
                          makesenseHomeClicked(bannerClickedRequest);
                          if (GemsGLobals.userType == "guest") {
                            setState(() {
                              DialogAlert.showLoginAlert(context);
                            });
                          } else {
                            if (listData["subsection"][index]["sub_sec_code"]
                                    .toString()
                                    .toLowerCase() ==
                                "travel") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          TravelPartners(
                                            travelsubection:
                                                listData["subsection"][index]
                                                    ['subsection'],
                                          ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                            } else if (listData["subsection"][index]
                                        ["sub_sec_code"]
                                    .toString()
                                    .toLowerCase() ==
                                "insurance") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          InsurancePartners(
                                            travelsubection:
                                                listData["subsection"][index]
                                                    ['subsection'],
                                          ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                            } else if (listData["subsection"][index]
                                        ["sub_sec_code"]
                                    .toString()
                                    .toLowerCase() ==
                                "partner") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          OtherPartners(
                                            travelsubection:
                                                listData["subsection"][index]
                                                    ['subsection'],
                                          ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                            } else if (listData["subsection"][index]
                                        ["sub_sec_code"]
                                    .toString()
                                    .toLowerCase() ==
                                "giftcard") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          GiftCardCategory())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                            } else if (listData["subsection"][index]
                                        ["sub_sec_code"]
                                    .toString()
                                    .toLowerCase() ==
                                "ecommerce") {
                              setState(() {
                                GemsGLobals.backbutton = "false";
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ShopTabBarPage(
                                            index: 0,
                                            tabIndex: 0,
                                          ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                            } else if (listData["subsection"][index]
                                        ["sub_sec_code"]
                                    .toString()
                                    .toLowerCase() ==
                                "exchangepoints") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PointConversionHomePage(
                                              data: listData["subsection"]
                                                  [index]['subsection']))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                            } else if (listData["subsection"][index]
                                        ["sub_sec_code"]
                                    .toString()
                                    .toLowerCase() ==
                                "smiles_grocery") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GrocerySteps(
                                            htmlData: listData["subsection"]
                                                    [index]["subsec_html_desc"]
                                                .toString(),
                                            iosUrl: listData["subsection"]
                                                    [index]["ios_deep_link"]
                                                .toString(),
                                            androidUrl: listData["subsection"]
                                                    [index]["android_deep_link"]
                                                .toString(),
                                          ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                            } else if (listData["subsection"][index]
                                        ["sub_sec_code"]
                                    .toString()
                                    .toLowerCase() ==
                                "fee") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          FeeRedemptionPage(
                                              title: listData["subsection"]
                                                  [index]["sub_sec_name"],
                                              data: listData["subsection"]
                                                  [index]['subsection']))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                            }
                          }
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                clipBehavior: Clip.antiAlias,
                                elevation: 0,
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 4 -
                                      19,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: listData["subsection"][index]
                                                      ["sub_sec_image"] !=
                                                  null &&
                                              listData["subsection"][index]
                                                      ["sub_sec_image"] !=
                                                  ""
                                          ? listData["subsection"][index]
                                              ["sub_sec_image"]
                                          : '',
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        )),
                                      ),
                                      placeholder: (context, url) =>
                                          Image.asset(
                                        ImageConstants.noimages,
                                        fit: BoxFit.cover,
                                      ),
                                      fadeInDuration: Duration(microseconds: 1),
                                      placeholderFadeInDuration:
                                          Duration(microseconds: 1),
                                      fadeOutDuration:
                                          Duration(microseconds: 1),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        ImageConstants.noimages,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 4 -
                                            13,
                                    padding: EdgeInsets.only(bottom: 0, top: 0),
                                    child: TextWidget(
                                      alignment: TextAlign.center,
                                      text: listData["subsection"][index]
                                                      ["sub_sec_name"] !=
                                                  null ||
                                              listData["subsection"][index]
                                                      ["sub_sec_name"] !=
                                                  ""
                                          ? toBeginningOfSentenceCase(
                                              listData["subsection"][index]
                                                      ["sub_sec_name"]
                                                  .toString())
                                          : '',
                                      color: brown,
                                      size: text_font_size_small,
                                      weight: FontWeight.w500,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      );
                    })),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 15,
              decoration: BoxDecoration(
                color: searchbar,
              ),
            )
          ]));
    }

    /* Popular Offers  UI Section */

    List<Widget> _popularOfferListStructure(info) {
      List<Widget> _list = [];

      for (var i = 0; i < info.length; i++) {
        _list.add(Container(
            child: Container(
                margin: EdgeInsets.only(left: 2, right: 3),
                width: MediaQuery.of(context).size.width / 1.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        var bannerClickedRequest = {
                          GemsGLobals.componentType: info[i]["sub_sec_code"] ?? "",
                          GemsGLobals.clickedOnParam: info[i]['offer_title'] ?? "",
                          GemsGLobals.navigationType: GemsGLobals.internalText,
                          GemsGLobals.intSource: GemsGLobals.lastVisitPageName
                        };
                        makesenseHomeClicked(bannerClickedRequest);
                        if (GemsGLobals.userType == "guest") {
                          setState(() {
                            DialogAlert.showLoginAlert(context);
                          });
                        } else {
                          if (info[i]["sub_sec_code"] != null ||
                              info[i]["sub_sec_code"] != "") {
                            switch (info[i]["sub_sec_code"]
                                .toString()
                                .toLowerCase()) {
                              case "affiliate":
                                await affilatePartnerAPi(
                                    info[i]["affiliate_id"] ?? "11");
                                break;

                              case "banner":
                                await LaunchUrl.openLink(
                                    url: info[i]['sub_sec_url']);
                                break;

                              case "partner":
                                await _launchURLForyou(info[i]['sub_sec_url'] +
                                    GemsGLobals.userId);
                                break;

                              case "offer":
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            OfferDetail(
                                              brandcode: info[i]["brand_code"],
                                              outletcode: info[i]
                                                  ["outlet_code"],
                                              partnerbrandid: info[i]
                                                  ["partner_brndid"],
                                              catcode: info[i]
                                                      ["category_code"] ??
                                                  "",
                                              catname: info[i]
                                                      ["category_name"] ??
                                                  "",
                                              subcatheading:
                                                  info[i]["alt_cat_name"] ?? "",
                                            ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                                break;

                              case 'hotel':
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (contex) => HotelHomePage())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                                break;
                              case 'flight':
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (contex) => FlightHomePage(
                                              tabIndex: 0,
                                            ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                                break;
                              case 'giftcard':
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (contex) =>
                                            GiftCardCategory())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                                break;
                              default:
                                _launchURLForyou(info[i]['sub_sec_url']);
                                break;
                            }
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 0.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14)),
                            height: 170,
                            margin: EdgeInsets.only(right: 0, bottom: 0),
                            child: Card(
                                elevation: 0.0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(14),
                                      topRight: Radius.circular(14),
                                      bottomRight: Radius.circular(14),
                                      bottomLeft: Radius.circular(14)),
                                  child: CachedNetworkImage(
                                    errorWidget: (context, url, error) {
                                      return Image.asset(
                                        ImageConstants.noimages,
                                        fit: BoxFit.fill,
                                      );
                                    },
                                    imageUrl: info[i]['sub_sec_image'] == null
                                        ? ''
                                        : info[i]['sub_sec_image'],
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => Container(
                                      child: Image.asset(
                                        ImageConstants.noimages,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ))),
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 0, left: 5),
                            alignment: Alignment.centerLeft,
                            child: TextWidget(
                              text: info[i]["sub_sec_name"] != null ||
                                      info[i]["sub_sec_name"] != ""
                                  ? info[i]["sub_sec_name"]
                                  : "",
                              color: home_title_text_orange,
                              overflow: TextOverflow.ellipsis,
                              weight: FontWeight.bold,
                              size: text_font_size_x_small,
                            ),
                          ),
                          SizedBox(height: 3),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: ReadMoreText(
                              info[i]["sub_sec_desc"] != null ||
                                      info[i]["sub_sec_desc"] != ""
                                  ? info[i]["sub_sec_desc"]
                                  : '',
                              style: TextStyle(
                                  color: Color(0xff969390),
                                  fontSize: text_font_size_small),
                              trimLength: 60,
                              trimMode: TrimMode.Length,
                              trimCollapsedText: "... read more",
                              trimExpandedText: "...read less",
                              moreStyle: TextStyle(
                                  color: aqua_blue,
                                  fontWeight: FontWeight.bold),
                              lessStyle: TextStyle(
                                  color: aqua_blue,
                                  fontWeight: FontWeight.bold),
                              delimiter: " ",
                              callback: (val) {},
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ))));
      }
      return _list;
    }

    Widget _popularOfferListView(listData) {
      return Container(
          margin: EdgeInsets.only(left: 10, right: 5),
          alignment: Alignment.centerLeft,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 0, left: 5, bottom: 0),
                        child: TextWidget(
                            text: listData["sname"],
                            size: text_font_medium_x_size,
                            weight: FontWeight.bold,
                            color: brown),
                      ),
                    ),
                  ],
                ),
                Container(
                    margin:
                        EdgeInsets.only(left: 0, bottom: 10, right: 5, top: 5),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: ScrollPhysics(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            _popularOfferListStructure(listData["subsection"]),
                      ),
                    )),
                Container(
                  height: 15,
                  decoration: BoxDecoration(
                    color: searchbar,
                  ),
                )
              ]));
    }

    List<Widget> _popularOfferGridStructure(info) {
      var size = MediaQuery.of(context).size;
      final double itemHeight = (size.height) / 3.4;
      final double itemWidth = size.width / 2;
      List<Widget> _list = [];
      _list.add(GestureDetector(
        child: Container(
          margin: EdgeInsets.only(left: 5, right: 5, top: 5),
          child: GridView.count(
              crossAxisCount: 1,
              crossAxisSpacing: 14,
              mainAxisSpacing: 6,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              childAspectRatio: (itemWidth / itemHeight),
              children: new List.generate(info.length, (index) {
                return Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    width: MediaQuery.of(context).size.width / 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            var bannerclickedReq = {
                              GemsGLobals.componentType: info[index]["sub_sec_code"] ?? "",
                              GemsGLobals.clickedOnParam: info[index]['offer_title'] ?? "",
                              GemsGLobals.navigationType: GemsGLobals.internalText,
                              GemsGLobals.intSource: GemsGLobals.lastVisitPageName
                            };

                            makesenseHomeClicked(bannerclickedReq);
                            if (GemsGLobals.userType == "guest") {
                              setState(() {
                                DialogAlert.showLoginAlert(context);
                              });
                            } else {
                              if (info[index]["sub_sec_code"] != null ||
                                  info[index]["sub_sec_code"] != "") {
                                switch (info[index]["sub_sec_code"]
                                    .toString()
                                    .toLowerCase()) {
                                  case "affiliate":
                                    await affilatePartnerAPi(
                                        info[index]["affiliate_id"] ?? "11");
                                    break;

                                  case "banner":
                                    await LaunchUrl.openLink(
                                        url: info[index]['sub_sec_url']);
                                    break;

                                  case "partner":
                                    await _launchURLForyou(info[index]
                                            ['sub_sec_url'] +
                                        GemsGLobals.userId);
                                    break;

                                  case 'offer':
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                OfferDetail(
                                                  brandcode: info[index]
                                                      ["brand_code"],
                                                  outletcode: info[index]
                                                      ["outlet_code"],
                                                  partnerbrandid: info[index]
                                                      ["partner_brndid"],
                                                  catcode: info[index]
                                                          ["category_code"] ??
                                                      "",
                                                  catname: info[index]
                                                          ["category_name"] ??
                                                      "",
                                                  subcatheading: info[index]
                                                          ["alt_cat_name"] ??
                                                      "",
                                                ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                                    break;

                                  case 'hotel':
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (contex) =>
                                                HotelHomePage())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                                    break;
                                  case 'flight':
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (contex) => FlightHomePage(
                                                  tabIndex: 0,
                                                ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                                    break;
                                  case 'giftcard':
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (contex) =>
                                                GiftCardCategory())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                                    break;

                                  default:
                                    _launchURLForyou(
                                        info[index]['sub_sec_url']);
                                    break;
                                }
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 0.0),
                            child: Container(
                                height: 160,
                                margin: EdgeInsets.only(right: 0, bottom: 0),
                                child: Card(
                                    color: Colors.transparent,
                                    elevation: 0.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                          bottomRight: Radius.circular(15),
                                          bottomLeft: Radius.circular(15)),
                                      child: CachedNetworkImage(
                                        errorWidget: (context, url, error) {
                                          return Image.asset(
                                            ImageConstants.noimages,
                                            fit: BoxFit.fill,
                                          );
                                        },
                                        imageUrl:
                                            info[index]['sub_sec_image'] ?? "",
                                        fit: BoxFit.fill,
                                        placeholder: (context, url) =>
                                            Container(
                                          child: Image.asset(
                                            ImageConstants.noimages,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ))),
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: 0, left: 5),
                                alignment: Alignment.centerLeft,
                                child: TextWidget(
                                  text: info[index]["sub_sec_name"] != null ||
                                          info[index]["sub_sec_name"] != ""
                                      ? info[index]["sub_sec_name"]
                                      : "",
                                  color: home_title_text_orange,
                                  overflow: TextOverflow.ellipsis,
                                  weight: FontWeight.bold,
                                  size: text_font_size_x_small,
                                ),
                              ),
                              SizedBox(height: 3),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: ReadMoreText(
                                  info[index]["sub_sec_desc"] != null ||
                                          info[index]["sub_sec_desc"] != ""
                                      ? info[index]["sub_sec_desc"]
                                      : '',
                                  style: TextStyle(
                                      color: Color(0xff969390),
                                      fontSize: text_font_size_small),
                                  trimLength: 38,
                                  trimMode: TrimMode.Length,
                                  trimCollapsedText: "... read more",
                                  trimExpandedText: "...read less",
                                  moreStyle: TextStyle(
                                      color: aqua_blue,
                                      fontWeight: FontWeight.bold),
                                  lessStyle: TextStyle(
                                      color: aqua_blue,
                                      fontWeight: FontWeight.bold),
                                  delimiter: " ",
                                  callback: (val) {},
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ));
              })),
        ),
      ));

      return _list;
    }

    Widget _popularOfferGridView(listData) {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          alignment: Alignment.centerLeft,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 0, left: 10, bottom: 0),
                  child: TextWidget(
                      text: listData["sname"],
                      size: text_font_medium_x_size,
                      weight: FontWeight.bold,
                      color: brown),
                ),
                Container(
                    height: 260,
                    margin: EdgeInsets.only(left: 5, bottom: 0, right: 5),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: ScrollPhysics(),
                      children: <Widget>[
                        Row(
                          children: _popularOfferGridStructure(
                              listData["subsection"]),
                        ),
                      ],
                    ))
              ]));
    }

    int infolistlen = 0;

    Widget _morewaystoearnstructure_compList(info) {
      int index = info.length - infolistlen;
      return Container(
          width: MediaQuery.of(context).size.width / 1.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  if (GemsGLobals.userType != "guest") {
                    if (info[index]['sub_sec_code'] != null ||
                        info[index]['sub_sec_code'] != "") {
                      switch (info[index]['sub_sec_code']
                          .toString()
                          .toLowerCase()) {
                        case "partner":
                          _launchURLForyou(
                              info[index]['sub_sec_url'] + GemsGLobals.userId);
                          break;
                        case "affiliate":
                          await affilatePartnerAPi(
                              "${info[index]["affiliate_id"] ?? "11"}");
                          break;
                        case "banner":
                          await LaunchUrl.openLink(
                              url: info[index]['sub_sec_url']);
                          break;

                        case 'offer':
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      OfferDetail(
                                        brandcode: info[index]["brand_code"],
                                        outletcode: info[index]["outlet_code"],
                                        partnerbrandid: info[index]
                                            ["partner_brndid"],
                                        catcode:
                                            info[index]["category_code"] ?? "",
                                        catname:
                                            info[index]["category_name"] ?? "",
                                        subcatheading:
                                            info[index]["alt_cat_name"] ?? "",
                                      )));
                          break;

                        case 'hotel':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) => HotelHomePage()));
                          break;
                        case 'flight':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) => FlightHomePage(
                                        tabIndex: 0,
                                      )));
                          break;
                        case 'giftcard':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) => GiftCardCategory()));
                          break;

                        default:
                          await _launchURLForyou(info[index]['sub_sec_url']);
                          break;
                      }
                    }
                  } else {
                    DialogAlert.showLoginAlert(context);
                  }
                },
                child: Container(
                    margin: EdgeInsets.only(bottom: 0, left: 0, right: 5),
                    height: MediaQuery.of(context).size.height / 5,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                            child: CachedNetworkImage(
                              imageUrl: info[index]["sub_sec_image"] ?? "",
                              height: MediaQuery.of(context).size.height / 6,
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Container(
                                width: 120,
                                height: 175,
                                child: Placeholder(),
                              ),
                            )))),
              ),
            ],
          ));
    }

    List<Widget> _morewaystoearnstructure_list_componetList(info) {
      List<Widget> mylist = [];
      do {
        mylist.add(_morewaystoearnstructure_compList(info));
        infolistlen--;
      } while (infolistlen != 0);
      return mylist;
    }

    List<Widget> _morewaystoearnstructure_Grid(info) {
      List<Widget> mylist = [];
      infolistlen = info.length;
      do {
        Widget row = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _morewaystoearnstructure_list_componetList(info),
        );
        mylist.add(row);
      } while (infolistlen != 0);
      return mylist;
    }

    Widget _morewaystoearnstructureList(info) {
      return Container(
        child: Column(
          children: _morewaystoearnstructure_Grid(info),
        ),
      );
    }

    Widget morewaystoearnList(listData) {
      return Container(
          margin: EdgeInsets.only(bottom: 0, right: 10, left: 10, top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 5, left: 10, bottom: 10),
                      child: TextWidget(
                          text: listData["sname"],
                          size: text_font_medium_x_size,
                          weight: FontWeight.bold,
                          color: brown),
                    ),
                  ),
                ],
              ),
              Container(
                  height: 180,
                  margin: EdgeInsets.only(left: 0, right: 0),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          _morewaystoearnstructureList(listData["subsection"])
                        ],
                      ),
                    ],
                  ))
            ],
          ));
    }

    Widget _morewaystoearnstructure_comp(info) {
      int index = info.length - infolistlen;
      return Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Container(
              child: GestureDetector(
                onTap: () async {
                  var segmentReq = {
                  GemsGLobals.componentType: info[index]['sub_sec_code']??'',
                  GemsGLobals.clickedOnParam: info[index]['sub_sec_name'] ?? '',
                  GemsGLobals.navigationType: GemsGLobals.internalText,
                  GemsGLobals.intSource: GemsGLobals.lastVisitPageName
                  };
                  makesenseHomeClicked(segmentReq);

                  if (GemsGLobals.userType != "guest") {
                    if (info[index]['sub_sec_code'] != null ||
                        info[index]['sub_sec_code'] != "") {
                      switch (info[index]['sub_sec_code']
                          .toString()
                          .toLowerCase()) {
                        case "partner":
                          _launchURLForyou(
                              info[index]['sub_sec_url'] + GemsGLobals.userId);
                          break;
                        case "affiliate":
                          await affilatePartnerAPi(
                              "${info[index]["affiliate_id"] ?? "11"}");
                          break;
                        case "fab":
                          await affilatePartnerAPi(
                              "${info[index]["affiliate_id"] ?? "11"}");
                          break;
                        case "banner":
                          await LaunchUrl.openLink(
                              url: info[index]['sub_sec_url']);
                          break;

                        case 'offer':
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      OfferDetail(
                                        brandcode: info[index]["brand_code"],
                                        outletcode: info[index]["outlet_code"],
                                        partnerbrandid: info[index]
                                            ["partner_brndid"],
                                        catcode:
                                            info[index]["category_code"] ?? "",
                                        catname:
                                            info[index]["category_name"] ?? "",
                                        subcatheading:
                                            info[index]["alt_cat_name"] ?? "",
                                      ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                          break;

                        case 'hotel':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) => HotelHomePage())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                          break;
                        case 'flight':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) => FlightHomePage(
                                        tabIndex: 0,
                                      ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                          break;
                        case 'giftcard':
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (contex) => GiftCardCategory())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                          break;

                        default:
                          await _launchURLForyou(info[index]['sub_sec_url']);
                          break;
                      }
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => OfferDetail(
                                    brandcode: info[index]["brand_code"],
                                    outletcode: info[index]["outlet_code"],
                                    partnerbrandid: info[index]
                                        ["partner_brndid"],
                                    catcode: info[index]["category_code"] ?? "",
                                    catname: info[index]["category_name"] ?? "",
                                    subcatheading:
                                        info[index]["alt_cat_name"] ?? "",
                                  ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                    }
                  } else {
                    DialogAlert.showLoginAlert(context);
                  }
                },
                child: Container(
                  height: 160,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: CachedNetworkImage(
                          imageUrl: info[index]["sub_sec_image"],
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Container(
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset(ImageConstants.noimages),
                          ),
                        ),
                      )),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ));
    }

    Widget noonMoonBanner(info) {
      return InkWell(
        onTap: () async {
         var segmentReq = {
                  GemsGLobals.componentType: info['sub_sec_code']??'',
                  GemsGLobals.clickedOnParam: info['sub_sec_url'] ?? '',
                  GemsGLobals.navigationType: GemsGLobals.internalText,
                  GemsGLobals.intSource: GemsGLobals.lastVisitPageName
                  };
                  makesenseHomeClicked(segmentReq);

          if (GemsGLobals.userType != "guest") {
            if (info['sub_sec_code'] != null || info['sub_sec_code'] != "") {
              switch (info['sub_sec_code'].toString().toLowerCase()) {
                case "partner":
                  _launchURLForyou(info['sub_sec_url'] + GemsGLobals.userId);
                  break;
                case "affiliate":
                  await affilatePartnerAPi("${info["affiliate_id"] ?? "11"}");
                  break;
                case "banner":
                  await LaunchUrl.openLink(url: info['sub_sec_url']);
                  break;
                case "wpl":
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              BookingSlots(slotBanner: info["sub_sec_image"])));
                  break;

                case "hp":
                  if (info['sub_sec_url'] == null ||
                      info['sub_sec_url'] == "") {
                  } else {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForYouWeb(
                                appbarname: "GEMS REWARDS",
                                weburl: info['sub_sec_url'])));
                  }
                  break;

                case 'offer':
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => OfferDetail(
                                brandcode: info["brand_code"],
                                outletcode: info["outlet_code"],
                                partnerbrandid: info["partner_brndid"],
                                catcode: info["category_code"] ?? "",
                                catname: info["category_name"] ?? "",
                                subcatheading: info["alt_cat_name"] ?? "",
                              ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                  break;

                case 'hotel':
                  Navigator.push(context,
                      MaterialPageRoute(builder: (contex) => HotelHomePage()));
                  break;
                case 'flight':
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contex) => FlightHomePage(
                                tabIndex: 0,
                              )));
                  break;
                case 'giftcard':
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contex) => GiftCardCategory()));
                  break;

                default:
                  await _launchURLForyou(info['sub_sec_url']);
                  break;
              }
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => OfferDetail(
                            brandcode: info["brand_code"],
                            outletcode: info["outlet_code"],
                            partnerbrandid: info["partner_brndid"],
                            catcode: info["category_code"] ?? "",
                            catname: info["category_name"] ?? "",
                            subcatheading: info["alt_cat_name"] ?? "",
                          ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
            }
          } else {
            DialogAlert.showLoginAlert(context);
          }
        },
        child: Container(
          height: 160,
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  imageUrl: info["sub_sec_image"],
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Container(
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      ImageConstants.noimages,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              )),
        ),
      );
    }

    List<Widget> _morewaystoearnstructure_list_componet(info) {
      List<Widget> mylist = [];
      mylist.add(_morewaystoearnstructure_comp(info));
      infolistlen--;
      if (infolistlen > 0) {
        mylist.add(_morewaystoearnstructure_comp(info));
        infolistlen--;
      }
      return mylist;
    }

    List<Widget> _morewaystoearnstructure_list(info) {
      List<Widget> mylist = [];
      infolistlen = info.length;
      do {
        Widget row = Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _morewaystoearnstructure_list_componet(info),
        );

        mylist.add(row);
      } while (infolistlen != 0);
      return mylist;
    }

    Widget _morewaystoearnstructure(info) {
      return Container(
        child: Column(
          children: _morewaystoearnstructure_list(info),
        ),
      );
    }

    Widget morewaystoearn(listData) {
      return Container(
          padding: EdgeInsets.only(top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 0, left: 15, bottom: 5),
                      child: TextWidget(
                          text: listData["sname"],
                          size: text_font_medium_x_size,
                          weight: FontWeight.bold,
                          color: brown),
                    ),
                  ),
                ],
              ),
              Container(
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    _morewaystoearnstructure(listData["subsection"])
                  ],
                ),
              ),
            ],
          ));
    }

    Widget foryouCorosolnew(listData) {
      return CarouselSlider.builder(
        options: CarouselOptions(
          height: 240,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          pauseAutoPlayOnTouch: true,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
              _currentPageNotifier1.value = _current;
            });
          },
        ),
        itemCount: listData["subsection"].length,
        itemBuilder: (BuildContext context, int itemIndex, realIndex) =>
            GestureDetector(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 180,
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 3, 5, 0),
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(8.0),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: listData["subsection"][itemIndex]
                                ["sub_sec_image"] ??
                            ImageConstants.noimages,
                        placeholder: (context, url) => Image.asset(
                          ImageConstants.noimages,
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) {
                          return Image.asset(
                            ImageConstants.noimages,
                            fit: BoxFit.fill,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 3, 0, 0),
                  child: Container(
                    child: TextWidget(
                        text: listData["subsection"][itemIndex]
                                ["sub_sec_name"] ??
                            "",
                        color: home_title_text_black,
                        overflow: TextOverflow.ellipsis,
                        size: text_font_size_x_small,
                        weight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 2, 0, 0),
                  child: Container(
                      child: TextWidget(
                    text: listData["subsection"][itemIndex]["sub_sec_desc"] !=
                                null ||
                            listData["subsection"][itemIndex]["sub_sec_desc"] !=
                                ""
                        ? listData["subsection"][itemIndex]["sub_sec_desc"]
                        : "",
                    color: Color(0xff969390),
                    size: text_font_size_small,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                  )),
                )
              ],
            ),
          ),
          onTap: () async {
            var segmentReq = {
                  GemsGLobals.componentType: listData["subsection"][itemIndex]["sub_sec_code"] ?? "",
                  GemsGLobals.clickedOnParam: listData["subsection"][itemIndex]['outlet_id'] ?? "",
                  GemsGLobals.navigationType: GemsGLobals.internalText,
                  GemsGLobals.intSource: GemsGLobals.lastVisitPageName
            };
            makesenseHomeClicked(segmentReq);
            if (GemsGLobals.userType == "guest") {
              setState(() {
                DialogAlert.showLoginAlert(context);
              });
            } else {
              if (listData["subsection"][itemIndex]["sub_sec_code"] != null ||
                  listData["subsection"][itemIndex]["sub_sec_code"] != "") {
                switch (listData["subsection"][itemIndex]["sub_sec_code"]
                    .toString()
                    .toLowerCase()) {
                  case "affiliate":
                    await affilatePartnerAPi(listData["subsection"][itemIndex]
                            ["affiliate_id"] ??
                        "11");
                    break;

                  case "banner":
                    await LaunchUrl.openLink(
                        url: listData["subsection"][itemIndex]['sub_sec_url']);
                    break;

                  case "partner":
                    await _launchURLForyou(listData["subsection"][itemIndex]
                            ['sub_sec_url'] +
                        GemsGLobals.userId);
                    break;

                  case 'offer':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => OfferDetail(
                                  brandcode: listData["subsection"][itemIndex]
                                      ["brand_code"],
                                  outletcode: listData["subsection"][itemIndex]
                                      ["outlet_code"],
                                  partnerbrandid: listData["subsection"]
                                      [itemIndex]["partner_brndid"],
                                  catcode: listData["subsection"][itemIndex]
                                          ["category_code"] ??
                                      "",
                                ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                    break;

                  case 'hotel':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (contex) => HotelHomePage()));
                    break;
                  case 'flight':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (contex) => FlightHomePage(
                                  tabIndex: 0,
                                )));
                    break;
                  case 'giftcard':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (contex) => GiftCardCategory()));
                    break;

                  default:
                    await _launchURLForyou(
                        listData["subsection"][itemIndex]['sub_sec_url']);
                    break;
                }
              }
            }
          },
        ),
      );
    }

    Widget _slider(listData) {
      return Container(
          padding: EdgeInsets.only(bottom: 0, top: 0, right: 10, left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10, bottom: 5),
                child: TextWidget(
                  text: listData["sname"],
                  size: text_font_medium_x_size,
                  weight: FontWeight.bold,
                  color: brown,
                ),
              ),
              foryouCorosolnew(listData)
            ],
          ));
    }

    void showAdvantagePlusMemberDetailDialog(
        BuildContext context, userFamilyInfo) {
      showDialog(
        barrierDismissible: false,
        barrierColor: white_text_color.withOpacity(0.9),
        context: context,
        builder: (BuildContext cxt) {
          return PopScope(
          canPop: false,
          onPopInvoked: (canPop) async {
             Future.value(false);},
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 70, right: 10, left: 10),
                child: Material(
                  color: advplusCardColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 60,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    color: black_color,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0)),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      left: 0.8,
                                      right: 0.8,
                                      bottom: 0.8,
                                    ),
                                    height: 60,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      color: white_text_color,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              ImageConstants.brandLogoRewardsPlus),
                                          fit: BoxFit.fill),
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0)),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 15, top: 10),
                                  child: TextWidget(
                                      weight: FontWeight.bold,
                                      color: _textcolor,
                                      text: "Member Name".toUpperCase(),
                                      size: text_font_medium_x_size),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 15, top: 0),
                                  child: TextWidget(
                                      weight: FontWeight.bold,
                                      color: _textcolor,
                                      text:
                                          "${GemsGLobals.userFirstName} ${GemsGLobals.userLastName}",
                                      size: 19),
                                ),
                                GemsGLobals.gemsMemberRelationCode == "JUNIOR"
                                    ? Container(
                                        margin:
                                            EdgeInsets.only(left: 15, top: 5),
                                        child: TextWidget(
                                            weight: FontWeight.normal,
                                            color: _textcolor,
                                            text: "(under 21)",
                                            size: text_font_size_x_small),
                                      )
                                    : Container(
                                        height: 0,
                                      )
                              ],
                            ),
                            Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                right: 0, top: 0),
                                            child: TextWidget(
                                              text: "Powered by ADV+ "
                                                  .toUpperCase(),
                                              weight: FontWeight.bold,
                                              color: _textcolor,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(top: 0),
                                              child: Image.asset(
                                                ImageConstants.adv_close_icon,
                                                height: 35,
                                                color: _textcolor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      new SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: 100,
                                        width: 90,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 0.8,
                                                color: black_color)),
                                        child: Container(
                                          color: white_text_color,
                                          child: GemsGLobals
                                                      .gemsPlusMemberPhoto ==
                                                  null
                                              ? Image.asset(
                                                  ImageConstants
                                                      .gems_logo_black,
                                                  color: Colors.grey[400],
                                                  fit: BoxFit.fill,
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: GemsGLobals
                                                      .gemsPlusMemberPhoto,
                                                  errorWidget:
                                                      (context, url, error) {
                                                    return Image.asset(
                                                        ImageConstants
                                                            .gems_placeholder,
                                                        fit: BoxFit.fill);
                                                  },
                                                  placeholder: (context, url) =>
                                                      Image.asset(
                                                          ImageConstants
                                                              .gems_logo_black,
                                                          color:
                                                              Colors.grey[400]),
                                                  fit: BoxFit.fill,
                                                ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          ],
                        ),
                        new SizedBox(height: 10),
                        advCardStatus == 'processing'
                            ? Container(
                                width: 0,
                              )
                            : Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, top: 10),
                                              child: TextWidget(
                                                  weight: FontWeight.bold,
                                                  color: _textcolor,
                                                  text: "Membership Number"
                                                      .toUpperCase(),
                                                  size:
                                                      text_font_medium_x_size),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, top: 0),
                                              child: TextWidget(
                                                  color: _textcolor,
                                                  text: GemsGLobals
                                                      .gemsPlusMembershipNo
                                                      .toString(),
                                                  size: 20),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    new SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      child: Image.asset(
                                        advPlusgif,
                                        height: advPlusgif ==
                                                ImageConstants.advplus_arwdwn
                                            ? 25
                                            : 12,
                                        width: advPlusgif ==
                                                ImageConstants.advplus_arwdwn
                                            ? 25
                                            : 12,
                                      ),
                                    ),
                                    new SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: 10, top: 10),
                                              child: TextWidget(
                                                  weight: FontWeight.bold,
                                                  color: _textcolor,
                                                  text: "Expired On"
                                                      .toUpperCase(),
                                                  size:
                                                      text_font_medium_x_size),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  right: 10, top: 0),
                                              child: TextWidget(
                                                  color: _textcolor,
                                                  text: GemsGLobals
                                                      .gemsPlusExpiryDate
                                                      .toString(),
                                                  size: 20),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 15, top: 10),
                                child: TextWidget(
                                    weight: FontWeight.bold,
                                    color: _textcolor,
                                    text: "Membership Type".toUpperCase(),
                                    size: text_font_medium_x_size),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 15, top: 0),
                                child: TextWidget(
                                    weight: FontWeight.bold,
                                    color: _textcolor,
                                    text: toBeginningOfSentenceCase(
                                        userFamilyInfo == null
                                            ? ''
                                            : userFamilyInfo["membership_type"]
                                                .toString()),
                                    size: 19),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    userFamilyInfo["kids"].length != 0
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: TextWidget(
                                                weight: FontWeight.bold,
                                                color: _textcolor,
                                                text: "CHILDREN",
                                                size: text_font_medium_x_size),
                                          )
                                        : Container(height: 0),
                                    Container(
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: userFamilyInfo == null
                                              ? 0
                                              : userFamilyInfo["kids"].length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              margin: EdgeInsets.only(
                                                  left: 10, top: 0),
                                              child: TextWidget(
                                                  softwrap: true,
                                                  weight: FontWeight.w400,
                                                  color: Color.fromARGB(
                                                      255, 236, 231, 205),
                                                  text: userFamilyInfo == null
                                                      ? ""
                                                      : userFamilyInfo["kids"][
                                                                          index]
                                                                      [
                                                                      "first_name"] ==
                                                                  null &&
                                                              userFamilyInfo["kids"]
                                                                          [
                                                                          index]
                                                                      [
                                                                      "last_name"] ==
                                                                  null
                                                          ? ''
                                                          : "${userFamilyInfo["kids"][index]["first_name"] ?? ""} ${userFamilyInfo["kids"][index]["last_name"] ?? ""}" +
                                                              " | " +
                                                              "${userFamilyInfo["kids"][index]["age"]} years",
                                                  size: 14),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                DialogAlert.whatsappBottomModalAdvPlusDrawer(
                                    context, "971521294354");
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: 10, bottom: 20, top: 20),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(bottom: 0),
                                      child: Image(
                                        image: AssetImage(
                                            ImageConstants.adv_whatsapp_logo),
                                        height: 20,
                                        color: _textcolor,
                                      ),
                                    ),
                                    new SizedBox(
                                      width: 5,
                                    ),
                                    TextWidget(
                                      text: "Help Desk",
                                      weight: FontWeight.bold,
                                      color: _textcolor,
                                      size: text_font_medium_x_size,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            advCardStatus == 'processing'
                                ? Container(
                                    width: 0,
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdvantagePlusClubsWebPage()));
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: 10, left: 20),
                                      width: 180,
                                      child: TextWidget(
                                        fontStyle: FontStyle.italic,
                                        decoration: TextDecoration.underline,
                                        weight: FontWeight.bold,
                                        color: _textcolor,
                                        size: text_font_medium_x_size,
                                        text:
                                            "View real-time clubs availability and discounts",
                                        softwrap: true,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                        new SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    Widget _bannerCorousel(bannerdata) {
      return Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider.builder(
              options: CarouselOptions(
                height: 160,
                viewportFraction: 1.00,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 5),
                autoPlayAnimationDuration: bannerdata["subsection"].length >= 2
                    ? Duration(milliseconds: 800)
                    : Duration(milliseconds: 0),
                pauseAutoPlayOnTouch: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _homepagecurrent = index;
                    _currentPageNotifierbanner.value = _homepagecurrent;
                  });
                },
              ),
              itemCount: bannerdata["subsection"].length,
              itemBuilder: (BuildContext context, int itemIndex, realIndex) =>
                  GestureDetector(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: bannerdata["subsection"][itemIndex]
                          ['bnr_image'],
                      placeholder: (context, url) => Container(
                        child: Image.asset(
                          ImageConstants.noimages,
                          fit: BoxFit.cover,
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        return Image.asset(
                          ImageConstants.noimages,
                          fit: BoxFit.fill,
                        );
                      },
                    ),
                  ),
                ),
                onTap: () async {
                  var bannerClickedRequest = {
                    GemsGLobals.componentType: GemsGLobals.banner,
                    GemsGLobals.clickedOnParam: bannerdata["subsection"][itemIndex]['bnr_name'] ?? "",
                    GemsGLobals.navigationType: bannerdata["subsection"][itemIndex]['routeType'] ==
                            'inapp' ? GemsGLobals.internalText : GemsGLobals.external,
                    GemsGLobals.intSource: GemsGLobals.lastVisitPageName
                  };
                  makesenseHomeClicked(bannerClickedRequest);
                  if (GemsGLobals.userType == "guest") {
                    setState(() {
                      DialogAlert.showLoginAlert(context);
                    });
                  } else {
                    if (bannerdata["subsection"][itemIndex]['bnr_code'] ==
                        'adv_plus_registration') {
                      if (GemsGLobals.userType == "guest") {
                        setState(() {
                          DialogAlert.showLoginAlert(context);
                        });
                      } else {
                        setState(() {
                          checkFlag = true;
                        });

                        if (GemsGLobals.gemsPlusIsMemberOrNot != "yes" ||
                            GemsGLobals.gemsPlusIsMemberOrNot == null) {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AdvantagePlusWebPage())).whenComplete(() {
                            setState(() {
                              userProfileApi(GemsGLobals.membershipNo);
                            });
                          });
                        } else {
                          await Future.delayed(const Duration(seconds: 1)).then(
                              (value) => {
                                    showAdvantagePlusMemberDetailDialog(
                                        context, userFamilyInfo)
                                  });
                        }
                      }
                    } else if (bannerdata["subsection"][itemIndex]['bnr_code'].toString().toLowerCase() ==
                        GemsGLobals.shop) {
                      if (GemsGLobals.userType == GemsGLobals.guest) {
                        setState(() {
                          DialogAlert.showLoginAlert(context);
                        });
                      } else {
                        setState(() {
                          GemsGLobals.backbutton = "false";
                        });
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShopTabBarPage(
                                      index: 0,
                                      tabIndex: 0,
                                    ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                      }
                    } else if (bannerdata["subsection"][itemIndex]['routeType']
                            .toString()
                            .toLowerCase() ==
                        'affiliate') {
                      await affilatePartnerAPi(
                          bannerdata["subsection"][itemIndex]["affiliate_id"]);
                    } else if (bannerdata["subsection"][itemIndex]['routeType']
                            .toString()
                            .toLowerCase() ==
                        'offers') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => OfferDetail(
                                    brandcode: bannerdata["subsection"]
                                            [itemIndex]['bnr_brand'] ??
                                        "",
                                    outletcode: bannerdata["subsection"]
                                            [itemIndex]['bnr_outlet'] ??
                                        "",
                                    partnerbrandid: bannerdata["subsection"]
                                            [itemIndex]['partner_brndid'] ??
                                        "",
                                    catcode: bannerdata["subsection"][itemIndex]
                                            ["category_code"] ??
                                        "",
                                    catname: bannerdata["subsection"][itemIndex]
                                            ["category_name"] ??
                                        "",
                                    subcatheading: bannerdata["subsection"]
                                            [itemIndex]["alt_cat_name"] ??
                                        "",
                                  ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                    } else if ((bannerdata["subsection"][itemIndex]['bnr_url'] != null ||
                            bannerdata["subsection"][itemIndex]['bnr_url'] !=
                                '') &&
                        bannerdata["subsection"][itemIndex]['routeType'] ==
                            'inapp') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForYouWeb(
                                  appbarname: "GEMS REWARDS",
                                  weburl: bannerdata["subsection"][itemIndex]
                                      ['bnr_url']))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                    } else if (bannerdata["subsection"][itemIndex]['routeType']
                            .toString()
                            .toLowerCase() ==
                        'list') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OfferListing(
                                  subseccode: bannerdata["subsection"]
                                      [itemIndex]["sub_sec_code"],
                                  categoryCode: bannerdata["subsection"]
                                          [itemIndex]["bnr_ofr_category"] ??
                                      '',
                                  categoryName: bannerdata["subsection"]
                                      [itemIndex]["category_name"],
                                  categoryheading: bannerdata["subsection"]
                                      [itemIndex]["alt_cat_name"]))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                    } else if (bannerdata["subsection"][itemIndex]['routeType']
                            .toString()
                            .toLowerCase() ==
                        GemsGLobals.travel) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => TravelPartners(
                                    travelsubection: bannerdata["subsection"]
                                        [itemIndex]['subsection'],
                                  ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                    } else if (bannerdata["subsection"][itemIndex]['routeType']
                            .toString()
                            .toLowerCase() ==
                        GemsGLobals.insurance) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  InsurancePartners(
                                    travelsubection: bannerdata["subsection"]
                                        [itemIndex]['subsection'],
                                  ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                    } else if (bannerdata["subsection"][itemIndex]['routeType'].toString().toLowerCase() == GemsGLobals.partner) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => OtherPartners(
                                    travelsubection: bannerdata["subsection"]
                                        [itemIndex]['subsection'],
                                  ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                    } else if (bannerdata["subsection"][itemIndex]['routeType'].toString().toLowerCase() == GemsGLobals.giftcard) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  GiftCardCategory())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                    } else if (bannerdata["subsection"][itemIndex]['routeType'].toString().toLowerCase() == GemsGLobals.ecommerce) {
                      setState(() {
                        GemsGLobals.backbutton = "false";
                      });

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => ShopTabBarPage(
                                    index: 0,
                                    tabIndex: 0,
                                  ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                    } else if (bannerdata["subsection"][itemIndex]['routeType'].toString().toLowerCase() == GemsGLobals.exchangePoints) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  PointConversionHomePage(
                                      data: bannerdata["subsection"][itemIndex]
                                          ['subsection']))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                    } else if (bannerdata["subsection"][itemIndex]['routeType'].toString().toLowerCase() == GemsGLobals.fee) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  FeeRedemptionPage(
                                    data: bannerdata["subsection"][itemIndex]
                                        ['subsection'],
                                    title: bannerdata["subsection"][itemIndex]
                                            ["sub_sec_name"]
                                        .toString(),
                                  ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                    } else if (bannerdata["subsection"][itemIndex]['routeType'].toString().toLowerCase() == GemsGLobals.smilesGrocery) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GrocerySteps(
                                    htmlData: bannerdata["subsection"]
                                            [itemIndex]["subsec_html_desc"]
                                        .toString(),
                                    iosUrl: bannerdata["subsection"][itemIndex]
                                            ["ios_deep_link"]
                                        .toString(),
                                    androidUrl: bannerdata["subsection"]
                                            [itemIndex]["android_deep_link"]
                                        .toString(),
                                  ))).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                    } else if (bannerdata["subsection"][itemIndex]['routeType'].toString().toLowerCase() == 'accountlinking') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CheckStatus())).then((value) => GemsGLobals.lastVisitPageName = GemsGLobals.homepage);
                    } else {
                      if (bannerdata["subsection"][itemIndex]['bnr_url'] !=
                              null ||
                          bannerdata["subsection"][itemIndex]['bnr_url'] !=
                              '') {
                        await LaunchUrl.openLink(
                            url: bannerdata["subsection"][itemIndex]
                                ['bnr_url']);
                      }
                    }
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Center(
                  child: DotsIndicator(
                dotsCount: bannerdata["subsection"].length ?? 0,
                position: _homepagecurrent.toDouble(),
                decorator: DotsDecorator(
                  color: Colors.grey.shade300,
                  activeColor: blue_color,
                  size: Size(10.5, 7.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0)),
                  activeSize: const Size(38.0, 7.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              )),
            ),
          ],
        ),
      );
    }

    List<Widget> homeStructure(info) {
      List<Widget> _list = [];

      /******* OFFER SECTION ********/
      for (var i = 0; i < info.length; i++) {
        if (info[i]["scode"].toString().toLowerCase() == 'gemsbanner') {
          if (info[i]["subsection"].length > 0) {
            if (info[i]["svtype"].toString().toLowerCase() == "list") {
              _list.add(_homeBannerWidget(info[i]));
            } else if (info[i]["svtype"].toString().toLowerCase() == "slider") {
              _list.add(_bannerCorousel(info[i]));
            }
          } else {}
        } else if (info[i]["scode"].toString().toLowerCase() == "earn") {
          if (info[i]["subsection"].length > 0) {
            if (info[i]["svtype"].toString().toLowerCase() == "list") {
              _list.add(exploreOffers(info[i]));
            } else {}
          }
        }

        /******* GEMS Points SECTION ********/
        else if (info[i]["scode"].toString().toLowerCase() == "gemspoints") {
          if (info[i]["subsection"].length > 0) {
            if (info[i]["svtype"] == null ||
                info[i]["svtype"].toString().toLowerCase() == 'list') {
              _list.add(_earngemspointsListWidget(info[i]));
            } else if (info[i]["svtype"].toString().toLowerCase() == "grid") {
              _list.add(_earngemsPointsGridWidget(info[i]));
            } else if (info[i]["svtype"].toString().toLowerCase() == "slider") {
              _list.add(earngemscarousel(info[i]));
            }
          }
        }
        /******* Noon Moon SECTION ********/
        else if (info[i]["scode"].toString().toLowerCase() == "noon_moon") {
          if (info[i]["subsection"].length > 0) {
            if (info[i]["svtype"] == null ||
                info[i]["svtype"].toString().toLowerCase() == 'list') {
              _list.add(noonMoonBanner(info[i]['subsection'][0]));
            } else if (info[i]["svtype"].toString().toLowerCase() == "grid") {
              _list.add(_noonGridView(info[i]));
            } else if (info[i]["svtype"].toString().toLowerCase() == "slider") {
              _list.add(_noonslider(info[i]));
            }
          }
        }

        /******* POPULAR OFFER SECTION ********/
        else if (info[i]["scode"].toString().toLowerCase() == "popoffers") {
          if (info[i]["subsection"].length > 0) {
            if (info[i]["svtype"].toString().toLowerCase() == "list") {
              _list.add(_popularOfferListView(info[i]));
            } else if (info[i]["svtype"].toString().toLowerCase() == "slider") {
              _list.add(_slider(info[i]));
            } else {
              _list.add(_popularOfferGridView(info[i]));
            }
          }
        }

        // /******* LATESTOFFERS SECTION ********/
        else if (info[i]["scode"].toString().toLowerCase() == "latestoffers") {
          if (info[i]["subsection"].length > 0) {
            if (info[i]["svtype"].toString().toLowerCase() == "list") {
              _list.add(_latestOfferListView(info[i]));
            } else if (info[i]["svtype"].toString().toLowerCase() == "slider") {
              _list.add(_slider(info[i]));
            } else {
              _list.add(_trendingOfferGridView(info[i]));
            }
          }
        }

        /******* OFFERFORYOU SECTION ********/
        else if (info[i]["scode"].toString().toLowerCase() == "offerforyou") {
          if (info[i]["subsection"].length > 0) {
            if (info[i]["svtype"].toString().toLowerCase() == "list") {
              _list.add(_offerForYouListView(info[i]));
            } else if (info[i]["svtype"].toString().toLowerCase() == "slider") {
              _list.add(_slider(info[i]));
            } else {
              _list.add(_trendingOfferGridView(info[i]));
            }
          }
        }

        // /******* TRENDING SECTION ********/
        else if (info[i]["scode"].toString().toLowerCase() == "offertrending") {
          if (info[i]["subsection"].length > 0) {
            if (info[i]["svtype"].toString().toLowerCase() == "list") {
              _list.add(_trendingOfferListView(info[i]));
            } else if (info[i]["svtype"].toString().toLowerCase() == "slider") {
              _list.add(_slider(info[i]));
            } else {
              _list.add(_trendingOfferGridView(info[i]));
            }
          }
        } else if (info[i]["scode"].toString().toLowerCase() == "poffer") {
          if (info[i]["subsection"].length > 0) {
            if (info[i]["svtype"].toString().toLowerCase() == "list") {
              _list.add(morewaystoearnList(info[i]));
            } else if (info[i]["svtype"].toString().toLowerCase() == "grid") {
              _list.add(morewaystoearn(info[i]));
            } else if (info[i]["svtype"].toString().toLowerCase() == "slider") {
              _list.add(_slider(info[i]));
            } else {
              _list.add(morewaystoearn(info[i]));
            }
          }
        }

        _list.add(SizedBox(height: 5));
      }
      return _list;
    }


    Widget _body() {
      return _isloading == false
          ? Container(
              padding: EdgeInsets.only(top: 35),
              color: white_color,
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, right: 0),
                child: Column(
                  children: <Widget>[
                    GemsGLobals.userType != "guest"
                        ? AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            child: _getWidget(userInformation()),
                          )
                        : Container(
                            height: 0,
                          ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      child: _searchBar(),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView(controller: _scrollController, children: [
                        Container(
                          child: Column(
                              children: homeStructure(_homeSectionArray)),
                        ),
                      ]),
                    ),
                  ],
                ),
              ))
          : Center(
              child: SpinKitCircle(
                color: btn_bg_color,
              ),
            );
    }

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: white_color,
        body: _body(),
      ),
    );
  }

/* caurosel widget for exclusive patner*/
  Widget exlusivepartnerCorosol() {
    return Stack(children: [
      CarouselSlider.builder(
        options: CarouselOptions(
          height: 200,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          pauseAutoPlayOnTouch: true,
          onPageChanged: (index, reason) {
            setState(() {
              _excurrent = index;
              _ex_currentPageNotifier.value = _excurrent;
            });
          },
        ),
        itemCount: exclusiveitemImage.length,
        itemBuilder: (BuildContext context, int itemIndex, realIndex) =>
            GestureDetector(
          child: Container(
            height: 200,
            color: white_color,
            width: MediaQuery.of(context).size.width,
            child: Container(
              color: bg_color,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 3, 5, 0),
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: exclusiveitemImage[itemIndex],
                    placeholder: (context, url) => Container(
                      child: Image.asset(
                        ImageConstants.noimages,
                        fit: BoxFit.cover,
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      return Image.asset(
                        ImageConstants.noimages,
                        fit: BoxFit.fill,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          onTap: () async {},
        ),
      ),
      _buildCircleIndicator(exclusiveitemImage.length, _ex_currentPageNotifier)
    ]);
  }

/* for Common Circle indicator */
  Widget _buildCircleIndicator(length, pagenotifier) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: CirclePageIndicator(
        dotColor: Colors.blue[300],
        selectedDotColor: Colors.blue[500],
        selectedSize: 7,
        size: 5,
        itemCount: length,
        currentPageNotifier: pagenotifier,
      ),
    );
  }

  String? dobcheck;

  @override
  void networkError(err) {
    // TODO: implement networkError
  }

  @override
  void userProfileErrorRespone(Error error) {
    // TODO: implement userProfileErrorRespone
  }

  @override
  void userProfileSuceessRespone(UserProfileModel userProfileModel) {
    _profileModel = userProfileModel;
    if (_profileModel!.status == true) {
      setState(() async {
        GemsGLobals.membershipNo = _profileModel!.values!.membershipNo;
        GemsGLobals.userFirstName = _profileModel!.values!.firstName;
        GemsGLobals.userLastName = _profileModel!.values!.lastName;
        GemsGLobals.corporateImage=_profileModel?.values?.partnerImage;

        GemsGLobals.userId = _profileModel!.values!.gemsCustomerId;

        GemsGLobals.mobilenumber = _profileModel!.values!.phone;

        GemsGLobals.userId = _profileModel!.values!.gemsCustomerId;

        GemsGLobals.countryCode = _profileModel!.values!.countryCode;
        GemsGLobals.useremail = _profileModel!.values!.email.toString();
        GemsGLobals.gender = _profileModel!.values!.gender;

        GemsGLobals.dob =
            _profileModel!.values!.dob.toString().replaceAll(".", "/");

        GemsGLobals.custEncryptedId = (GemsGLobals.userType == "alumni" ||
                GemsGLobals.userType == "referral")
            ? _profileModel!.values!.encrytedMembershipNo
            : _profileModel!.values!.encrytedCustomerId;

        GemsGLobals.countryImage = _profileModel!.values!.countryFlag;

        GemsGLobals.gemsPlusIsMemberOrNot =
            _profileModel!.values!.isAdvantagePlusMember;
        GemsGLobals.gemsPlusMembershipNo =
            _profileModel!.values!.advantagePlusCardNo;
        GemsGLobals.gemsPlusExpiryDate =
            _profileModel!.values!.advantagePlusExpiryDate;
        GemsGLobals.gemsPlusMemberPhoto =
            _profileModel!.values!.advantagePlusPhoto;

        AuthUtils.saveGemsPlusMemberOrNot(
            _profileModel!.values!.isAdvantagePlusMember);

        AuthUtils.saveGemsPlusMembershipNo(
            _profileModel!.values!.advantagePlusCardNo);

        AuthUtils.saveGemsPlusExpiryDate(
            _profileModel!.values!.advantagePlusExpiryDate);

        AuthUtils.saveGemsPlusMemberPhoto(
            _profileModel!.values!.advantagePlusPhoto);

        AuthUtils.saveGemsPlusRelationShipCode(
            _profileModel!.values!.relationshipCode);

        gemsPlusIsMemberOrNot = _profileModel!.values!.isAdvantagePlusMember;

        gemsPlusMembershipNo = _profileModel!.values!.advantagePlusCardNo;

        gemsPlusExpiryDate = _profileModel!.values!.advantagePlusExpiryDate;

        gemsPlusMemberPhoto = _profileModel!.values!.advantagePlusPhoto;

        gemsMemberRelationCode = _profileModel!.values!.relationshipCode;

        GemsGLobals.gemsPlusAdvantagePlusMember =
            GemsGLobals.gemsPlusIsMemberOrNot;

        GemsGLobals.gemsPlusMembershipNoUpdate =
            GemsGLobals.gemsPlusMembershipNo;
        GemsGLobals.gemsPlusExpiryDateUpdate = GemsGLobals.gemsPlusExpiryDate;

        GemsGLobals.gemsPlusMemberPhotoUpdate = GemsGLobals.gemsPlusMemberPhoto;
        if (gemsPlusIsMemberOrNot == "yes") {
          getAdvancedPlusMemberData();
        } else {}

        AuthUtils.setStringValue("pointbalance",
            gemsPointsFormatter(_profileModel!.values!.pointBalance!));
        GemsGLobals.pointbalance = _profileModel!.values!.pointBalance!;
        updatefirebasetokenApi();
        UserProfileDbHelper().insertUserProfileData(
            UserProfileDbModel(null, json.encode(userProfileModel.toJson())));
      });
    }

    // TODO: implement userProfileSuceessRespone
  }

  Future<List<OutletDBModel>> getCountryDB() {
    var data = OutletDBHelper().getOutletListData();
    return data;
  }

  @override
  void offerlistFailure(error) {
    // TODO: implement offerlistFailure
  }

  @override
  void offerlistResponseSuccess(OfferList offerlistModel) {
    if (offerlistModel.status = true) {
      getCountryDB().then((value) {
        if (value.isEmpty) {
          OutletDBHelper()
              .save(OutletDBModel(null, json.encode(offerlistModel)));
        }
      });
    } else {}
  }

  @override
  void timeOutError(String error) {
    // TODO: implement timeOutError
  }
}
