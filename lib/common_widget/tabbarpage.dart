import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/Login_module/login_types/login_types.dart';
import 'package:gems_revamp/account/my_account.dart';
import 'package:gems_revamp/account/profile/user_profile_db/user_profile_db_model.dart';
import 'package:gems_revamp/account/profile/user_profile_db/user_profile_dbhelper.dart';
import 'package:gems_revamp/account/profile/user_profile_model.dart';
import 'package:gems_revamp/account/profile/user_profile_presenter.dart';
import 'package:gems_revamp/account/profile/user_profile_view.dart';
import 'package:gems_revamp/advanced_plus/advanced_plus_page.dart';
import 'package:gems_revamp/advanced_plus/advantage_plus_clubs.dart';
import 'package:gems_revamp/advanced_plus/advplus_cache.dart';
import 'package:gems_revamp/advanced_plus/api_utils/advantageplus_apiconfig.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_page.dart';
import 'package:gems_revamp/eshop_module_new/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/flight_module/flighthomepage.dart';
import 'package:gems_revamp/force_update/forece_update_design.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/database/giftcard_list_category_helper.dart';
import 'package:gems_revamp/homepage/apiconfig/apiconfighome.dart';
import 'package:gems_revamp/homepage/home_page.dart';
import 'package:gems_revamp/homepage/pointbalance/model_pointbalance.dart';
import 'package:gems_revamp/homepage/pointbalance/presenter_pointbalance.dart';
import 'package:gems_revamp/homepage/pointbalance/view_pointbalance.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_homepage.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/makesense_module/notification_module/notification_cache.dart';
import 'package:gems_revamp/makesense_module/notification_count_module/notification_count_model.dart';
import 'package:gems_revamp/makesense_module/notification_count_module/notification_count_presenter.dart';
import 'package:gems_revamp/makesense_module/notification_count_module/notification_count_view.dart';
import 'package:gems_revamp/offer_module/offer_detail/offer_detail.dart';
import 'package:gems_revamp/offer_module/offer_list/offer_list.dart';
import 'package:gems_revamp/point_conversion/airmiles_module/airtogems_module/airmilestogems.dart';
import 'package:gems_revamp/point_conversion/airmiles_module/gemtoair_module/gemstoairmiles.dart';
import 'package:gems_revamp/point_conversion/smiles_module/check_status.dart';
import 'package:gems_revamp/utilities/auth_utils.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/dialogAlert.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/maintenance_design.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Login_module/alumni_login/alumni_login.dart';
import '../eshop_module_new/Shop_home_module/Database/home_page_db_helper.dart';
import '../homepage/gemspointssearch_db/gemspoint_search_db_helper.dart';
import '../homepage/home_db/homepage_dbhelper.dart';
import '../homepage/offersearch_db/offer_search_db_helper.dart';
import '../my_purchase/flight_purchase/flt_db/flt_list_dbhelper.dart';
import '../my_purchase/gift_purchase/gc_db/gc_list_dbhelper.dart';
import '../my_purchase/hotel_purchase/hlt_db/hlt_dbhelper.dart';
import '../offer_module/offer_list/databasefiles/outlet_db_helper.dart';
import '../utm_demo/deeplink_dbhelper.dart';

class TabsScreen extends StatefulWidget {
  final initialIndex;

  const TabsScreen({Key? key, this.initialIndex}) : super(key: key);
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin
    implements MyPointsBalanceView, UserProfileView, NotificationCountView {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<bool> _isDisabled = [false, true, false];

  TabController? _tabController;

  int _selectedPageIndex = 0;
  // GemsGLobals.select=0
  final GlobalKey<ScaffoldState> _tabscaffoldKey = GlobalKey<ScaffoldState>();
  MyPointsModel pointbalancedata = MyPointsModel();
  MyPointsBalancePresenter? _pointbalancepresenter;
  var _pointbalancedata;
  var advCardStatus = '';
  late UserProfilePresenter? _userProfilePresenter;
  Map<String, dynamic>? _extraData;
  var gemsPlusIsMemberOrNot;
  var gemsPlusMembershipNo;
  var gemsPlusExpiryDate;
  var gemsPlusMemberPhoto;
  var gemsMemberRelationCode;
  var userFamilyInfo;
  bool checkadvplusdata = true;
  bool hideCrash = false;
  bool isConvert = false;
  int _unReadNoticount = 0;
  late DateFormat dateFormat;
  NotificationCountPresenter? notificationCountPresenter;
  final Location location = Location();
  String advPlusgif = ImageConstants.advplus_arwdwn;
  Color _textcolor = Color(0xff71726a);
  Color advplusCardColor = advantagePlus_member_tile_color;
  StreamSubscription? sub;
  final UtmManager utmManager = UtmManager();


  @override
  void initState() {
    forceupdateApi();
   _userProfilePresenter = UserProfilePresenter(this);
    userProfileApi(GemsGLobals.membershipNo);
    GemsGLobals.email = GemsGLobals.email.toString().replaceAll('"', '');
    GemsGLobals.email = GemsGLobals.email.toString().toLowerCase();
    GemsGLobals.useremail = GemsGLobals.useremail.toString().toLowerCase();

    if ((GemsGLobals.brandcode != null || GemsGLobals.brandcode != "") &&
        GemsGLobals.membershipNo == null) {
    } else {}
    if (GemsGLobals.emailFromDeeplink == null ||
        GemsGLobals.emailFromDeeplink == "") {
      GemsGLobals.alumniStatus = false;
    }
    if (GemsGLobals.showAlumnipopup == true) {
      if (GemsGLobals.alumniStatus == true &&
              (GemsGLobals.useremail != GemsGLobals.email) &&
              GemsGLobals.userType == "referral" &&
              GemsGLobals.select != 2
          // || GemsGLobals.email != GemsGLobals.alumniEmail
          ) {
        _showlogoutDialog();
        GemsGLobals.showAlumnipopup = false;
      } else if (GemsGLobals.alumniStatus == true &&
          (GemsGLobals.useremail == GemsGLobals.email) &&
          GemsGLobals.userType == "referral" &&
          GemsGLobals.select != 2) {
        _showFnfConverttoAlumniDialog();
        GemsGLobals.showAlumnipopup = false;
      } else if (GemsGLobals.alumniStatus == true &&
          (GemsGLobals.userType == "staff" ||
              GemsGLobals.userType == "parent") &&
          _selectedPageIndex != 2) {
        if (GemsGLobals.useremail != GemsGLobals.email) {
          _onlylogoutDialog();
        } else {
          _showParentStaffExistingDialog();
        }
        GemsGLobals.showAlumnipopup = false;
      } else if (GemsGLobals.alumniStatus == true &&
          GemsGLobals.useremail != GemsGLobals.email &&
          GemsGLobals.userType == "alumni" &&
          _selectedPageIndex != 2) {
        _showlogoutDialog();
        GemsGLobals.showAlumnipopup = false;
      } else if (GemsGLobals.alumniStatus == true &&
          GemsGLobals.userType == "alumni" &&
          _selectedPageIndex != 2) {
        // _showlogoutDialog();
      }
    }

    /// alumni integration code end
    dateFormat = DateFormat("yyyy-MM-ddHH:mm:ss");
    notificationCountPresenter = NotificationCountPresenter(this);
    _notificationApiCall();
    _checkLocation().then((result) {
      if (result != null) {
        setState(() {
          GemsGLobals.lat = result.latitude;
          GemsGLobals.long = result.longitude;
        });
      } else {}
    });

    GemsGLobals.updatedFireBaseToken = true;

    // _callNotification();
    _selectedPageIndex = widget.initialIndex;
    GemsGLobals.select = widget.initialIndex;
    AuthUtils.setStringValue("checFirstInstall", "true");
    AuthUtils.getStringValue('checFirstInstall');

    _tabController = TabController(
        initialIndex: widget.initialIndex, length: 3, vsync: this);
    _tabController!.addListener(_selectPage);
    _pointbalancepresenter = MyPointsBalancePresenter(this);
    // callpointbalanceapi();

    if (GemsGLobals.checkNotiRoute == false) {
      firebaseCloudMessagingListeners();
    }

    super.initState();
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
              // actions: <Widget>[],
            ),
          );
        });
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
      // dbHelper.truncateTable();
      OfferSearchListDBHelper().truncateofferSearchHistory();
      GemsPointListDBHelper().truncategemspointSearchHistory();
    });
  }

  logoutapi() {
    // var logoutmakesenseReq = {
    //   "membership_no": GemsGLobals.membershipNo,
    //   "logout_datetime": DateTime.now().millisecondsSinceEpoch,
    // };
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
              // logoutcheck = false;
              GemsGLobals.membershipNo = null;
              // GemsGLobals.fcmToken = null;
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
            // var alumnilogin =
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

            // await Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => LoginHomePage()));
          } else {
            await FirebaseMessaging.instance.deleteToken();
            setState(() {
              // logoutcheck = false;
              GemsGLobals.membershipNo = null;
              GemsGLobals.userFirstName = null;
              GemsGLobals.userLastName = null;
              GemsGLobals.userType = null;
              // GemsGLobals.fcmToken = null;
              GemsGLobals.pointbalance = 0;
              GemsGLobals.custEncryptedId = null;
              clearAllUserData();
            });
            UserProfileDbHelper().truncateTable();

            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear();

            await AuthUtils.setStringValue("checFirstInstall", "true");

            // await Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => LoginHomePage()));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => AlumniLogin(
                          email: GemsGLobals.email,
                          usertype: "alumni",
                          data: isConvert == true ? "isConvert" : "0",
                        )));
          }
        });
      } else {
        var noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
      }
    });
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

  /// alumni integration
  _showlogoutDialog() async {
    await Future.delayed(Duration(milliseconds: 50));
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return PopScope(
          canPop: true,
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
                                //  _makesenseeventcall("logout");
                                setState(() {
                                  // logoutcheck = true;
                                  logoutapi();
                                });
                                // Navigator.of(context).pop();
                                // await Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => LoginHomePage()));
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // actions: <Widget>[],
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
                                //  _makesenseeventcall("logout");
                                setState(() {
                                  // logoutcheck = true;
                                  logoutapi();
                                });
                                // Navigator.of(context).pop();
                                // await Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => LoginHomePage()));
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // actions: <Widget>[],
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
          // return object of type Dialog
          return PopScope(
          canPop: false,
          onPopInvoked: (canPop) async { Future.value(false);},
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
              // actions: <Widget>[],
            ),
          );
        });
  }

 _notificationApiCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var newcurrrentTimestamp = prefs.getString(GemsGLobals.notificationSyncDateText);
    GemsGLobals.notificationLoader = true;
    NotificationCache().notificationSaveCache(null, GemsGLobals.notificationDataText);
    notificationCountPresenter!.notificationCountsApiCall();
  }



  void _callNotification() {
    try {
      var initializationSettingsAndroid =
          new AndroidInitializationSettings('@mipmap/app_icon');
      var initializationSettingsIOS = new DarwinInitializationSettings();
      var initializationSettings = new InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
    } catch (err) {}
  }

  showNotification(RemoteMessage msg) async {
    var android = new AndroidNotificationDetails('chanel_id', "CHANNLE NAME",
        channelDescription: "channelDescription",
        // channelDescription: "channelDescription",
        importance: Importance.max,
        priority: Priority.high);
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    var iOS = new DarwinNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);

    await flutterLocalNotificationsPlugin.show(
      0,
      msg.notification?.title,
      msg.notification?.body,
      platform,
      payload: 'Default_Sound',
    );
  }

  _checkLocation() async {
    PermissionStatus _permissionGranted;
    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      if (GemsGLobals.locationPermision == false) {
        _permissionGranted = await location.requestPermission();
      }

      setState(() {
        GemsGLobals.locationPermision = true;
      });
    } else {
      setState(() {
        GemsGLobals.locationPermision = true;
      });
      return location.getLocation();
    }
  }

  void iOS_Permission() {
    FirebaseMessaging.instance
        .requestPermission(sound: true, badge: true, alert: true);
    FirebaseMessaging.instance.getNotificationSettings();
  }

  makesenseEventNotificationClickedCall(type,name,url,campaignId) {
    String keyName = GemsGLobals.eventNotificationClicked;
    var segmentReq = {
      'notification_type': type,
      'notification_name':name,
      'notification_url': url,
      'campaign_id': campaignId,
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  Future _onNotificationSelectRoute(message) async {
    if (GemsGLobals.checkNotiRoute == false) {
      setState(() {
        GemsGLobals.checkNotiRoute = true;
      });
    }

    if (message.data.containsKey("extra_data")) {
      _extraData = json.decode(message.data["extra_data"]);
    }

    makesenseEventNotificationClickedCall('push',message.data["campaignName"] ??"",message.data["url"] ??"",message.data["campaign_id"] ??"");
    if (message != null) {
        String? utmSource = message.data[GemsGLobals.utmSourceKey];
        String? utmMedium = message.data[GemsGLobals.utmMediumKey];
        String? utmCampaign = message.data[GemsGLobals.utmCampaignKey];
         
        setState(() {
        GemsGLobals.utmSource = utmSource;
        GemsGLobals.utmMedium = utmMedium;
        GemsGLobals.utmCampaign = utmCampaign;
        });        

        if (utmSource != null && utmMedium != null && utmCampaign != null) {
          utmManager.saveOrUpdateUtmData(utmSource, utmMedium, utmCampaign);
        }
      }

    if (message.data["deep_linking"] == "internal") {
      if (message.data["internal_link"].toString().contains("/")) {
        var urlroute = message.data["internal_link"].toString().split("/");

        switch (urlroute[0]) {
          case 'offer_listing_page':
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OfferListing(
                          categoryCode: urlroute[1],
                          route: GemsGLobals.pushNotificationRouteType
                        )));

            break;

          case "offer_details_page":
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OfferDetail(
                          catcode: urlroute[1],
                          brandcode: urlroute[2],
                          outletcode: urlroute[3],
                          partnerbrandid: urlroute[4],
                          route: GemsGLobals.pushNotificationRouteType
                        )));
            break;

          case "air_miles":
            //Print(urlroute[1]);
            if (urlroute[1] == "gems_to_airmiles") {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GemsToAimiles(
                    route: GemsGLobals.pushNotificationRouteType
                  )));
            } else {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AimilesToGems(
                    route: GemsGLobals.pushNotificationRouteType
                  )));
            }
            break;

          case 'hotel_booking':
          message.data["selected_city_hotel"] == "undefined"
                ? await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HotelHomePage(route: GemsGLobals.pushNotificationRouteType)))
                : await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HotelHomePage(
                            stayCityNotif:
                                message.data["selected_city_hotel"],
                            destiId: urlroute[1],
                            route: GemsGLobals.pushNotificationRouteType)));
            break;

          case 'flight_booking':
         message.data["selected_city_src"] == "undefined" ||
                    message.data["selected_city_dst"] == "undefined"
                ? await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (contex) => FlightHomePage(
                              tabIndex: 0,
                              route: GemsGLobals.pushNotificationRouteType
                            )))
                : await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FlightHomePage(
                              route: GemsGLobals.pushNotificationRouteType,
                              sourceCity:
                                  message.data["selected_city_src"],
                              destinationCity:
                                  message.data["selected_city_dst"],
                              srcCity: message.data["selected_city_src_cityname"],
                              destiCity: message.data["selected_city_dest_cityname"],
                              srcCode: urlroute[1],
                              destiCode: urlroute[2],
                              tabIndex: 0,
                            )));
            break;
        }
      } else {
        switch (message.data["internal_module"].toString().toLowerCase()) {
          case 'smiles':
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => CheckStatus(
                  route: GemsGLobals.pushNotificationRouteType
                )));
            break;

          case 'shop':
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShopTabBarPage(
                          index: 0,
                          tabIndex: 0,
                        )));
            break;

          case 'homepage':
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TabsScreen(
                          initialIndex: 0,
                        )));
            break;

          default:
            TabsScreen(
              initialIndex: 0,
            );
        }
      }
    } else {
      if (message.data['external_link'] != null) {
        _launchURLForyou(message.data['external_link']);
      }
    }
  }

  _launchURLForyou(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      } else {
      throw 'Could not launch $url';
    }
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOS_Permission();

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('mipmap/app_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    // var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(
        android: android, iOS: initializationSettingsDarwin);
    flutterLocalNotificationsPlugin.initialize(
      platform,
    );
    FirebaseMessaging.instance.getToken().then((token) async {
      await AuthUtils.setStringValue('fcm_token', token);
      setState(() {
        GemsGLobals.fcmToken = token;
      });
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        String? utmSource = message.data[GemsGLobals.utmSourceKey];
        String? utmMedium = message.data[GemsGLobals.utmMediumKey];
        String? utmCampaign = message.data[GemsGLobals.utmCampaignKey];
        setState(() {
          GemsGLobals.utmSource = utmSource;
        GemsGLobals.utmMedium = utmMedium;
        GemsGLobals.utmCampaign = utmCampaign;
        });

        if (utmSource != null && utmMedium != null && utmCampaign != null) {
          try{
          utmManager.saveOrUpdateUtmData(utmSource, utmMedium, utmCampaign);
          }
          catch(e){
            return false;
          }
        }

        setState(() {
          GemsGLobals.notificationMessage = message;
        });

      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      if (message != null) {
        String? utmSource = message.data[GemsGLobals.utmSourceKey];
        String? utmMedium = message.data[GemsGLobals.utmMediumKey];
        String? utmCampaign = message.data[GemsGLobals.utmCampaignKey];
         
        setState(() {
        GemsGLobals.utmSource = utmSource;
        GemsGLobals.utmMedium = utmMedium;
        GemsGLobals.utmCampaign = utmCampaign;
        });        

        if (utmSource != null && utmMedium != null && utmCampaign != null) {
          utmManager.saveOrUpdateUtmData(utmSource, utmMedium, utmCampaign);
        }
      }

      setState(() {
        GemsGLobals.checkNotiRoute = false;
        GemsGLobals.notificationMessage = message;
      });

      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      setState(() {
        GemsGLobals.notificationMessage = message;
      });

      _onNotificationSelectRoute(message);
    });
  }

  void onDidReceiveNotificationResponse(NotificationResponse payload) {
    if (GemsGLobals.checkNotiRoute == false) {
      setState(() {
        GemsGLobals.checkNotiRoute = true;
      });
      _onNotificationSelectRoute(GemsGLobals.notificationMessage);
    }
  }

  Future onSelectNotification(String? payload) async {
    if (GemsGLobals.checkNotiRoute == false) {
      setState(() {
        GemsGLobals.checkNotiRoute = true;
      });
      _onNotificationSelectRoute(GemsGLobals.notificationMessage);
    }
  }

  void callpointbalanceapi() {
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _pointbalancepresenter!.myPointsBalanceAPI();
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));

        if (connectionResult) {
          setState(() {});
          _pointbalancepresenter!.myPointsBalanceAPI();
        }
      }
    });
  }

  void userProfileApi(membershipNo) {
    Internetconnectivity().isConnected().then((connected) async {
      if (connected) {
        _userProfilePresenter!.userProfileResonse(membershipNo);
      }
    });
  }

  void forceupdateApi() {
    if (GemsGLobals.checkvalueno == true) {
    } else {
      var forceupdatereq = {"app_ver": GemsGLobals.appVersion};
      HomeApiconfig.forceUpdateApi(http.Client(), forceupdatereq)
          .then((value) => {
                if (value['status'] == true)
                  {
                    AuthUtils.setIntValue(
                        GemsGLobals.daysCountKey, value["data"]['number_of_days']),
                    if (value["data"]["update"] == true)
                      {
                        if (value["data"]['is_android'] == true)
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ForceUpdate(
                                          value: value["data"]["is_android"],
                                        )))
                          }
                        else if (value["data"]['is_ios'] == true)
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ForceUpdate(
                                          value: value["data"]["is_ios"],
                                        )))
                          }
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (BuildContext context) => ForceUpdate(
                        //               value: false,
                        //             )))
                      }
                    else if (value["data"]["force_update"] == true)
                      {
                        if (value["data"]['is_android'] == true)
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ForceUpdate(
                                          value: value["data"]["is_android"],
                                        )))
                          }
                        else if (value["data"]['is_ios'] == true)
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ForceUpdate(
                                          value: value["data"]["is_ios"],
                                        )))
                          }
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (BuildContext context) => ForceUpdate(
                        //               value: value["data"]["force_update"],
                        //             )))
                      }
                    else if (value["data"]['is_under_maintenance'])
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MaintanencePage()))
                      }
                    // else if (value["data"]['is_android'] == true)
                    //   {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (BuildContext context) => ForceUpdate(
                    //                   value: value["data"]["is_android"],
                    //                 )))
                    //   }
                    // else if (value["data"]['is_ios'] == true)
                    //   {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (BuildContext context) => ForceUpdate(
                    //                   value: value["data"]["is_ios"],
                    //                 )))
                    //   }
                  }
              });
    }
  }

  void getAdvancedPlusMemberData() {
    var advPlusNo;
    if (GemsGLobals.gemsPlusIsMemberOrNot == "yes") {
      advPlusNo = GemsGLobals.gemsPlusMembershipNo;
    // } else {
    //   advPlusNo = GemsGLobals.membershipNo;
    // }
    AdvPlusCache().fetchAdvantagePlusMemberDetailsData().then((value) {
      if (value == null) {
        AdvantageplusApiConfig.advantagePlusDetailsDataApi(
                http.Client(), advPlusNo)
            .then((response) async {
          if (response["status"] == true) {
            setState(() {
              userFamilyInfo = response["data"]["values"]; //response["values"];
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

              checkadvplusdata = false;
            });
            //Print(userFamilyInfo);
            AdvPlusCache().saveAdvantagePlusMemberDetailsData(userFamilyInfo);
          } else {
            setState(() {
              checkadvplusdata = false;
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
  }}

  void _selectPage() {
    setState(() {
      _selectedPageIndex = _tabController!.index;
      GemsGLobals.select = _tabController!.index;
    });
  }

  Widget _body() {
    return TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          MasterHomePage(),
          MyAccount(),
          GemsGLobals.userType != "guest"
              ? MyAccount()
              : Container(
                  height: MediaQuery.of(context).size.height,
                  color: grey200_color,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                        text: 'Please Login to view My Account',
                        size: text_font_medium18_size,
                        weight: FontWeight.w500,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.2,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          gradient: gradient_theme_color,
                        ),
                        margin: EdgeInsets.only(top: 15),
                        child: MaterialButton(
                          child: TextWidget(
                            text: "Login",
                            color: Colors.white,
                            size: text_font_medium18_size,
                          ),
                          onPressed: () {
                            setState(() {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginHomePage()));
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
        ]);
  }

  Widget _tabbar() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      // padding: EdgeInsets.fromLTRB(3, 6, 3, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0),
          topRight: Radius.circular(18.0),
        ),
        color: white_text_color,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, -3), //(x,y)
            blurRadius: 10.0,
          ),
        ],
        // image: DecorationImage(
        // // scale: 1,
        //     fit: BoxFit.fill,
        //     image: AssetImage(

        //       ImageConstants.tabbar,
        //     ))
      ),
      child: TabBar(
        isScrollable: false,
        controller: _tabController,
        indicatorColor: Colors.transparent,
        labelColor: black_color,
        tabs: [
          Tab(
            child: FittedBox(
              child: Container(
                margin: EdgeInsets.only(top: 2),
                child: Column(
                  children: [
                    Container(
                        child: _selectedPageIndex == 0 ||
                                _tabController!.index == 0
                            ? SvgPicture.asset(
                                ImageConstants.slt_home_icon,
                                height: 20,
                              )
                            : SvgPicture.asset(
                                ImageConstants.un_slt_home_icon,
                                height: 20,
                              )
                        //  Icon(Icons.home, size: 24, color: Colors.black)
                        // : Icon(
                        //     Icons.home,
                        //     size: 24,
                        //     color: Colors.grey,
                        //   ),

                        ),
                    TextWidget(
                      text: "Home",
                      size: text_font_size_xx_small,
                      color:
                          _selectedPageIndex == 0 || _tabController!.index == 0
                              ? home_tabbar_text_slt_color
                              : home_tabbar_text_un_color,
                    )
                  ],
                ),
              ),
            ),
          ),
          Tab(
            child: Padding(
              padding: const EdgeInsets.only(right: 2.0, top: 15),
              child: FittedBox(
                child: TextWidget(
                  text: "GEMS Rewards Plus",
                  size: 15,
                  color: home_tabbar_text_un_color,
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              margin: const EdgeInsets.only(left: 10.0),
              child: FittedBox(
                child: Stack(
                  children: [
                    GemsGLobals.totalunreadnotifications != 0
                        ? Positioned(
                            right: 12,
                            bottom: 25,
                            child: Container(
                              //  height: 15,
                              //  padding: EdgeInsets.all(3) ,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.red[700],
                                  shape: BoxShape.circle),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Center(
                                  child: TextWidget(
                                    text: GemsGLobals.totalunreadnotifications
                                        .toString(),
                                    // "${GemsGLobals.notificationCount}",
                                    size: 7,
                                    color: white_text_color,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 0,
                          ),
                    Container(
                      margin: EdgeInsets.only(top: 2),
                      child: Column(
                        children: [
                          Container(
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 1),
                                child: _selectedPageIndex == 2 ||
                                        _tabController!.index == 2
                                    ? SvgPicture.asset(
                                        ImageConstants.slt_account_icon,
                                        height: 20,
                                      )
                                    : SvgPicture.asset(
                                        ImageConstants.un_slt_account_icon,
                                        height: 20,
                                      )),
                          ),
                          TextWidget(
                            text: "My Account",
                            size: text_font_size_xx_small,
                            color: _selectedPageIndex == 2 ||
                                    _tabController!.index == 2
                                ? home_tabbar_text_slt_color
                                : home_tabbar_text_un_color,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        onTap: (tabIndex) {
          if (_isDisabled[_tabController!.index]) {
            int index = _tabController!.previousIndex;
            setState(() {
              _tabController!.index = index;
            });
          }
          String tabIndexValue = GemsGLobals.homepage;
          if (tabIndex == 0) {
            tabIndexValue = GemsGLobals.homepage;
          } else if (tabIndex == 1) {
            tabIndexValue = GemsGLobals.gemsRewardsTabLabel;
          } else if (tabIndex == 2) {
            tabIndexValue = GemsGLobals.myAccountPageName;
          }
          var segmentReq = {
            GemsGLobals.componentType: GemsGLobals.footerTab,
            GemsGLobals.clickedOnParam: tabIndexValue,
            GemsGLobals.navigationType: "",
            GemsGLobals.intSource: GemsGLobals.lastVisitPageName
          };
          
          switch (tabIndex) {
            case 0:
              GemsGLobals.lastVisitPageName = GemsGLobals.homepage;
              _selectedPageIndex = 0;
              GemsGLobals.select = 0;

              break;
            case 1:
              _selectedPageIndex = 1;
              GemsGLobals.select = 1;

              break;
            case 2:
              GemsGLobals.lastVisitPageName = GemsGLobals.myAccountPageName;
              _selectedPageIndex = 2;
              GemsGLobals.select = 2;

              break;

            default:
              _selectedPageIndex = 0;
              GemsGLobals.select = 0;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _onWillPop() {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Container(
              margin: EdgeInsets.only(top: 25, left: 15, right: 15),
              height: 120,
              child: Column(
                children: <Widget>[
                  Container(
                    child: TextWidget(
                      text: 'Are you sure you',
                      size: 12,
                      weight: FontWeight.bold,
                      color: Colors.grey[700]!,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: TextWidget(
                      text: 'want to exit?',
                      size: 12,
                      weight: FontWeight.bold,
                      color: Colors.grey[700]!,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 22),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(3)),
                          child: MaterialButton(
                            child: TextWidget(
                                text: 'No',
                                alignment: TextAlign.center,
                                size: 12,
                                weight: FontWeight.bold),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                        ),
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(3)),
                          child: MaterialButton(
                            child: TextWidget(
                                text: 'Yes',
                                alignment: TextAlign.center,
                                size: 12,
                                weight: FontWeight.bold),
                            onPressed: () async {
                              GemsGLobals.alumniStatus = false;
                              SystemChannels.platform
                                  .invokeMethod('SystemNavigator.pop');
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    }

    void showAdvantagePlusMemberDetailDialog(
        BuildContext context, userFamilyInfo) {
      showDialog(
        barrierDismissible: false,
        barrierColor: white_text_color.withOpacity(0.9),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 70, right: 10, left: 10),
                child: Material(
                  color: advplusCardColor, //advantagePlus_member_tile_color,
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
                                  // margin: EdgeInsets.only(
                                  //   left: 15,
                                  // ),
                                  height: 60,
                                  width: 160,
                                  decoration: BoxDecoration(
                                    // color: black_color,
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
                                              ImageConstants.gemsRewardPlus),
                                          fit: BoxFit.fitWidth),
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
                                          FittedBox(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 1, right: 0, top: 0),
                                              child: TextWidget(
                                                text: "Powered by ADV+ "
                                                    .toUpperCase(),
                                                weight: FontWeight.w500,
                                                color: _textcolor,
                                              ),
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
                                                height: 30,
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
                                                  // fontStyle: FontStylefa.italic,
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
                        userFamilyInfo==null?
                        Container():
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
                                                  color: Color(0xff837f6b),
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
                                      //Print("=========");
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
            );
          });
        },
      );
    }

    return SafeArea(
      bottom: true,
      top: false,
      child: Container(
        color: white_color,
        child: PopScope(
            canPop: false,
            onPopInvoked: (canPop) async {
            GemsGLobals.alumniStatus = false;
            _onWillPop();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: _tabscaffoldKey,
            appBar: PreferredSize(
                child: Container(height: 0), preferredSize: Size.fromHeight(0)),
            body: _body(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: InkWell(
              onTap: () async {
                if (GemsGLobals.userType == "guest") {
                  setState(() {
                    DialogAlert.showLoginAlert(context);
                  });
                } else {
                  setState(() {
                  });
      
                  if (GemsGLobals.gemsPlusIsMemberOrNot != "yes" ||
                      GemsGLobals.gemsPlusIsMemberOrNot == null) {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdvantagePlusWebPage()))
                        .whenComplete(() {
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
              },
              child: Container(
                height: 50,
                width: 50,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    ImageConstants.brandLogoRewardsPlus,
                    fit: BoxFit.fill,
                  ),
                ),
                decoration: BoxDecoration(
                  color: white_color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
      
                      offset: Offset(0, -3),
                      blurRadius: 10.0,
                    ),
                  ],
                ),
              ),
            ),
          bottomNavigationBar: _tabbar(),
          ),
        ),
      ),
    );
  }

  static Future onWillLoading(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Container(
            margin: EdgeInsets.only(top: 25, left: 15, right: 15),
            alignment: Alignment.center,
            height: 120,
            child: SpinKitCircle(
              color: blue_color,
            ),
          ),
        );
      },
    );
  }

  @override
  void mypointsbalanceResponseSuccess(MyPointsModel mypointsModel) {
    _pointbalancedata = mypointsModel;
    setState(() {
      if (_pointbalancedata.status == true) {
        AuthUtils.setStringValue("pointbalance",
            gemsPointsFormatter(_pointbalancedata.values.pointBalance));
        GemsGLobals.pointbalance = _pointbalancedata.values.pointBalance;
      } else {
        GemsGLobals.pointbalance = 0;
      }
    });
  }

  @override
  void networkError(err) {
    // TODO: implement networkError
  }

  @override
  void userProfileErrorRespone(Error error) {
    // TODO: implement userProfileErrorRespone
  }

  UserProfileModel? _profileModel;

  @override
  void userProfileSuceessRespone(UserProfileModel userProfileModel) {
    _profileModel = userProfileModel;
    if (_profileModel!.status == true) {
      if (_profileModel!.values!.isAdvantagePlusMember == "yes") {
        getAdvancedPlusMemberData();
      }
      setState(() {
        GemsGLobals.partnerName = _profileModel!.values!.partnerName ?? "";
        GemsGLobals.membershipNo = _profileModel!.values!.membershipNo ?? "";
        GemsGLobals.userFirstName = _profileModel!.values!.firstName ?? "";
        GemsGLobals.userLastName = _profileModel!.values!.lastName ?? "";
        GemsGLobals.userId = _profileModel!.values!.gemsCustomerId ?? "";
        GemsGLobals.userType = _profileModel!.values!.type ?? "";
        GemsGLobals.mobilenumber = _profileModel!.values!.phone ?? "";
        GemsGLobals.countryCode = _profileModel!.values!.countryCode ?? "";
        GemsGLobals.school = _profileModel!.values!.school ?? "";
        GemsGLobals.schoolcode = _profileModel!.values!.schoolCode ?? "";
        GemsGLobals.nationality = _profileModel!.values!.nationality ?? "";
        GemsGLobals.emirate = _profileModel!.values!.schoolEmirateCode ?? "";
        GemsGLobals.corporateImage=_profileModel?.values?.partnerImage;
        GemsGLobals.custEncryptedId = (GemsGLobals.userType == GemsGLobals.alumni ||
                GemsGLobals.userType == GemsGLobals.referral)
            ? _profileModel!.values!.encrytedMembershipNo
            : _profileModel!.values!.encrytedCustomerId;

        GemsGLobals.useremail = _profileModel!.values!.email.toString();
        GemsGLobals.userId = _profileModel!.values!.gemsCustomerId;

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

        // if (gemsPlusIsMemberOrNot == "yes") {
        //   getAdvancedPlusMemberData();
        // } else {}

        AuthUtils.setStringValue("pointbalance",
            gemsPointsFormatter(_profileModel!.values!.pointBalance!));
        GemsGLobals.pointbalance = _profileModel!.values!.pointBalance!;
        UserProfileDbHelper().insertUserProfileData(
            UserProfileDbModel(null, json.encode(userProfileModel.toJson())));

        AuthUtils.setStringValue("pointbalance",
            gemsPointsFormatter(_profileModel!.values!.pointBalance!));
        GemsGLobals.pointbalance = _profileModel!.values!.pointBalance!;
        UserProfileDbHelper().insertUserProfileData(
            UserProfileDbModel(null, json.encode(userProfileModel.toJson())));
      });
    }
  }

  setSyncTime(date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var date1 = prefs.getString(GemsGLobals.notificationSyncDateText);

    prefs.setString(GemsGLobals.notificationSyncDateText, date.toString());
  }

  @override
  void notificationCountSuccess(NotificationCountModel notificationCountModel) {
if (notificationCountModel.status == true) {
      setState(() {
        _unReadNoticount = 0;
        if (notificationCountModel.meta != null) {
          if (notificationCountModel.meta!.countsTotalUnread != null) {
            GemsGLobals.totalunreadnotifications =
                notificationCountModel.meta!.countsTotalUnread;
          } else {
            GemsGLobals.totalunreadnotifications = 0;
          }
        }

        for (int i = 0; i < notificationCountModel.values!.length; i++) {
          if (notificationCountModel.values![i].isRead != 1) {
            _unReadNoticount++;
          }
        }
        GemsGLobals.notificationLoader = false;
        GemsGLobals.notificationCount = _unReadNoticount;
        NotificationCache().notificationSaveCache(
            notificationCountModel.values!, GemsGLobals.notificationDataText);
        setSyncTime(DateTime.now());
      });
    } else {
      setState(() {
        GemsGLobals.notificationLoader = false;
        GemsGLobals.notificationCount = _unReadNoticount;
      });
    }
  }

  @override
  void notiificationCountError(Error error) {
  }
}
