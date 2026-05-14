import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:barcode_widgets/barcode_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/Login_module/login_types/login_types.dart';
import 'package:gems_revamp/account/favourites/my_favourites_page.dart';
import 'package:gems_revamp/account/help_support/help_support.dart';
import 'package:gems_revamp/account/mypoints/mypoints_design.dart';
import 'package:gems_revamp/account/mysaving/mysaving_design.dart';
import 'package:gems_revamp/account/profile/profile.dart';
import 'package:gems_revamp/account/profile/profile_utils/user_apiconfig.dart';
import 'package:gems_revamp/account/profile/user_profile_db/user_profile_dbhelper.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/Shop_home_module/Database/home_page_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/utils/customloader/custome_circle_loader.dart';
// import 'package:gems_revamp/eshop_module_new/Shop_home_module/Database/home_page_db_helper.dart';
import 'package:gems_revamp/family_and_friends/family_friends_list/family_and_friends.dart';
import 'package:gems_revamp/flight_module/database.dart';
import 'package:gems_revamp/homepage/gemspointssearch_db/gemspoint_search_db_helper.dart';
import 'package:gems_revamp/homepage/home_db/homepage_dbhelper.dart';
import 'package:gems_revamp/homepage/offersearch_db/offer_search_db_helper.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/makesense_module/notification_module/new_notification.dart';
import 'package:gems_revamp/makesense_module/notification_module/notification_cache.dart';
import 'package:gems_revamp/makesense_module/notification_count_module/notification_count_model.dart';
import 'package:gems_revamp/makesense_module/notification_count_module/notification_count_presenter.dart';
import 'package:gems_revamp/makesense_module/notification_count_module/notification_count_view.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flight_purchase_list/flight_purchase_list_model.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flight_purchase_list/flight_purchase_list_presenter.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flight_purchase_list/flight_purchase_list_view.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flt_db/flt_list_db_model.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flt_db/flt_list_dbhelper.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gc_db/gc_list_db_model.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gc_db/gc_list_dbhelper.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gift_purchase_list/gift_purchase_list_model.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gift_purchase_list/gift_purchase_list_presenter.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gift_purchase_list/gift_purchase_list_view.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hlt_db/hlt_db_model.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hlt_db/hlt_dbhelper.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_list/hotel_purchase_list_model.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_list/hotel_purchase_list_presenter.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_list/hotel_purchase_list_view.dart';
import 'package:gems_revamp/my_purchase/my_purchase_homepage.dart';
import 'package:gems_revamp/offer_module/offer_list/databasefiles/outlet_db_helper.dart';
import 'package:gems_revamp/offer_module/offer_webview.dart';
import 'package:gems_revamp/utilities/auth_utils.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:gems_revamp/utils/privacyPolicyweb.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common_widget/bottombar.dart';
import '../giftcard_module/giftcard_homepage/database/giftcard_list_category_helper.dart';
import '../utils/constants_files/color_constants.dart';
import '../utils/constants_files/text_constants.dart';

class MyAccount extends StatefulWidget {
  final String? fromscreen;

  const MyAccount({Key? key, this.fromscreen}) : super(key: key);
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount>
    implements
        FlightPurchaseListView,
        HotelPurchaseListView,
        GiftPurchaseListView,
        NotificationCountView {
  int _unReadNoticount = 0;

  NotificationCountPresenter? notificationCountPresenter;
  final dbHelper = DatabaseHelper.instance;
  bool logoutcheck = false;
  late DateFormat dateFormat;

// maleback.png
  @override
  void initState() {
    super.initState();
    GemsGLobals.alumniStatus = false;

    dateFormat = DateFormat("yyyy-MM-ddHH:mm:ss");
    notificationCountPresenter = NotificationCountPresenter(this);
    _notificationApiCall();
    truncateAllTable().whenComplete(() {
      setState(() {
        FlightPurchaseListPresenter(this)
            .fltPurchaseListApiRes(GemsGLobals.membershipNo);
        HotelPurchaseListPresenter(this)
            .hotelPurchaseListResApi(GemsGLobals.membershipNo);
        GiftPurchaseListPresenter(this)
            .giftPurchaseListApiRes(GemsGLobals.membershipNo, 30);
      });
    });
  }

  Future<void> truncateAllTable() async {
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        setState(() {
          FLTPurchaseListDBHelper().truncateTable();
          HotelPurchaseListDBHelper().truncateTable();
          GiftCardPurchaseListDBHelper().truncateTable();
          GiftCardListDBHelper().truncateTable();
        });
      }
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
      dbHelper.truncateTable();
      OfferSearchListDBHelper().truncateofferSearchHistory();
      GemsPointListDBHelper().truncategemspointSearchHistory();
    });
  }

  _notificationApiCall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var newcurrrentTimestamp =
        prefs.getString(GemsGLobals.notificationSyncDateText);
    GemsGLobals.notificationLoader = true;
    NotificationCache()
        .notificationSaveCache(null, GemsGLobals.notificationDataText);
    notificationCountPresenter!.notificationCountsApiCall();
  }

  setSyncTime(date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var date1 = prefs.getString("notificationSyncDate");

    prefs.setString("notificationSyncDate", date.toString());
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
            setState(() {
              logoutcheck = false;
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
              GemsGLobals.referralRelationType = "";
            });
            UserProfileDbHelper().truncateTable();

            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.clear();

            await AuthUtils.setStringValue("checFirstInstall", "true");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginHomePage()),
                ModalRoute.withName("/"));
          } else {
            setState(() {
              logoutcheck = false;
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

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginHomePage()),
                ModalRoute.withName("/"));

            // await Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) => LoginHomePage()));
          }
        });
      } else {
        var noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
      }
    });
  }

  void deleteaccountapi() {
    var deleteAccountReq = {
      "member_id": GemsGLobals.membershipNo,
    };
    Internetconnectivity().isConnected().then((isConnected) async {
      if (isConnected == true) {
        UserApiConfig.deleteAccountApi(http.Client(), deleteAccountReq)
            .then((value) async {
          if (value["status"] == true) {
            await Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginHomePage()));
          } else if (value["status"] == false) {
            Navigator.pop(context);
            Fluttertoast.showToast(
                msg: value['message'],
                toastLength: Toast.LENGTH_LONG,
                backgroundColor: Color(0xAA000000),
                textColor: white_text_color,
                gravity: ToastGravity.CENTER);
          }
        });
      } else {
        var noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
      }
    });
  }

  Widget _barcode() {
    return Column(
      children: [
        Center(
          child: BarCodeImage(
            params: Code39BarCodeParams(
              GemsGLobals.userType == GemsGLobals.referralValue ||
                      GemsGLobals.userType == GemsGLobals.alumniValue
                  ? '${GemsGLobals.membershipNo}'
                  : '${GemsGLobals.userId}',
              barHeight: 50.0,
              withText: false,
            ),
            onError: (error) {},
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: Container(
              decoration: BoxDecoration(gradient: gradient_theme_color),
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(
                top: Platform.isIOS ? 35 : 25,
              ),
              height: 90,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: TextWidget(
                          text: AppTexts.myAccountText,
                          size: text_font_medium18_size,
                          weight: FontWeight.w500,
                          color: white_text_color,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
        body: _body(),
        bottomNavigationBar: widget.fromscreen == AppTexts.homeWelcomeText
            ? SizedBox(height: 95, child: _tabbar())
            : Container(
                height: 0,
              ),
      ),
    );
  }

  Widget _getProfileImage() {
    final gender = GemsGLobals.gender.toString().toLowerCase();

    if (GemsGLobals.corporateImage != null &&
        GemsGLobals.corporateImage!.isNotEmpty) {
      return Container(
        width: 100,
        height: 100,
        child: Image.network(
          GemsGLobals.corporateImage ?? '',
          fit: BoxFit.fill,
        ),
      );
    } else {
      switch (gender) {
        case AppTexts.maleText:
          return Image.asset(ImageConstants.profile_male_img);
        case AppTexts.femaleText:
          return Image.asset(ImageConstants.profile_female_img);
        default:
          return Image.asset(ImageConstants.profile_common_img);
      }
    }
  }

  Widget _userinfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getProfileImage(),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: toBeginningOfSentenceCase(
                    '${GemsGLobals.userFirstName}  ${GemsGLobals.userLastName}'),
                size: text_font_medium16_size,
                weight: FontWeight.w600,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: 'GEMS Points',
                          // color: primaryColor,
                          size: text_font_size_xx_small,
                          weight: FontWeight.w400,
                        ),
                        TextWidget(
                          text: gemsPointsFormatter(GemsGLobals.pointbalance),

                          // color: primaryColor,
                          size: text_font_medium16_size,
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: 'Total Savings',
                          size: text_font_size_xx_small,
                          weight: FontWeight.w400,
                        ),
                        TextWidget(
                          text:
                              "AED ${gemsPointsFormatter(double.tryParse(GemsGLobals.userSavingBalance != null ? GemsGLobals.userSavingBalance.toString() : '0')?.ceil())}",
                          size: text_font_medium16_size,
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  // Future<dynamic> logoutDialog(BuildContext context) {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return Dialog(
  //           shape:
  //               RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(vertical: 20),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 TextWidget(
  //                   text: 'Are you sure you',
  //                   size: text_font_medium17_size,
  //                 ),
  //                 SizedBox(
  //                   height: 7,
  //                 ),
  //                 TextWidget(
  //                   text: 'want to logout?',
  //                   size: text_font_medium17_size,
  //                 ),
  //                 SizedBox(
  //                   height: 27,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.only(right: 10),
  //                       child: InkWell(
  //                         onTap: () {
  //                           Navigator.of(context).pop();
  //                         },
  //                         child: Container(
  //                           height: 35,
  //                           width: 70,
  //                           // margin: const EdgeInsets.only(right: 10),
  //                           decoration: BoxDecoration(
  //                             gradient: gradient_theme_color,
  //                             border: Border.all(color: blue_color, width: 1.5),
  //                             borderRadius: BorderRadius.circular(10),
  //                           ),
  //                           child: Center(
  //                             child: TextWidget(
  //                               text: 'No',
  //                               size: text_font_medium_size,
  //                               color: white_text_color,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.only(left: 10),
  //                       child: InkWell(
  //                         onTap: () async {
  //                           onWillLoading(context);
  //                           logoutapi();
  //                           // setState(() {
  //                           //   GemsGLobals.membershipNo = null;
  //                           //   GemsGLobals.userFirstName = null;
  //                           //   GemsGLobals.userLastName = null;
  //                           //   GemsGLobals.userType = null;
  //                           //   GemsGLobals.pointbalance = 0;
  //                           // });
  //                           // UserProfileDbHelper().truncateTable();

  //                           // SharedPreferences preferences =
  //                           //     await SharedPreferences.getInstance();
  //                           // preferences.clear();

  //                           // await AuthUtils.setStringValue(
  //                           //     "checFirstInstall", "true");

  //                           // Navigator.pushReplacement(
  //                           //     context,
  //                           //     MaterialPageRoute(
  //                           //         builder: (context) => LoginHomePage()));
  //                         },
  //                         child: Container(
  //                           height: 35,
  //                           width: 70,
  //                           decoration: BoxDecoration(
  //                             gradient: gradient_theme_color,
  //                             border: Border.all(color: blue_color, width: 1.5),
  //                             borderRadius: BorderRadius.circular(10),
  //                           ),
  //                           child: Center(
  //                             child: TextWidget(
  //                               text: 'Yes',
  //                               size: text_font_medium_size,
  //                               color: white_text_color,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Widget _body() {
    return Container(
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(left: 20, right: 20),
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 20,
          ),
          _userinfo(),
          SizedBox(
            height: 20,
          ),
          _barcode(),
          SizedBox(
            height: 10,
          ),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
            color: AppColors.lightGreyShade,
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 5, 10, 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      TextWidget(
                        text:
                            '${AppTexts.membershipNoText}${GemsGLobals.membershipNo}',
                        weight: FontWeight.w500,
                        size: text_font_medium15_size,
                      ),
                      Spacer(),
                      Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: white_text_color,
                            borderRadius: BorderRadius.circular(8)),
                        child: InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(
                                      text: GemsGLobals.membershipNo!))
                                  .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        duration: Duration(seconds: 1),
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(
                                            GemsGLobals.copyClipboardText)));
                              });
                            },
                            child: SvgPicture.asset(
                              ImageConstants.membershipCopy,
                            )),
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      TextWidget(
                        text:
                            '${GemsGLobals.customerIdText}${GemsGLobals.userId == GemsGLobals.userSavingsPoints ? AppTexts.notAvailableText : GemsGLobals.userId}',
                        weight: FontWeight.w500,
                        size: text_font_medium15_size,
                      ),
                      Spacer(),
                      GemsGLobals.userId != GemsGLobals.userSavingsPoints
                          ? Container(
                              height: 40,
                              width: 40,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: white_text_color,
                                  borderRadius: BorderRadius.circular(8)),
                              child: InkWell(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(
                                            text: GemsGLobals.userId!))
                                        .then((value) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              duration: Duration(seconds: 1),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              content: Text(GemsGLobals
                                                  .copyClipboardText)));
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    ImageConstants.membershipCopy,
                                  )),
                            )
                          : Container(
                              height: 40,
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          userAccounts(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          _logout(),
          SizedBox(
            height: 20,
          ),
          _connectApps(),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }

  Widget _connectApps() {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          versionanaccountdelete(),
          SizedBox(
            height: 2,
          ),
          Divider(),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForYouWeb(
                              appbarname: "Terms and Conditions",
                              weburl:
                                  "https://www.gemsrewards.com/terms-and-conditions",
                            )),
                  );
                },
                child: TextWidget(
                  text: 'Terms & Conditions',
                  size: text_font_size_x_small,
                  color: deepdark_orange_color,
                ),
              ),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrivacyForYouWeb(
                                appbarname: "Privacy Policy",
                                weburl:
                                    "https://www.gemsrewards.com/privacy-policy",
                              )),
                    );
                  },
                  child: TextWidget(
                      text: 'Privacy Policy',
                      size: text_font_size_x_small,
                      color: deepdark_orange_color))
            ],
          )
        ],
      ),
    );
  }

  Widget versionanaccountdelete() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          text: 'Version ${GemsGLobals.appVersion}',
          weight: FontWeight.w600,
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return deletebottomSheet();
                });
          },
          child: Container(
            child: TextWidget(
              text: 'Delete My Account',
              size: text_font_size_x_small,
              // weight: FontWeight.w500,
              color: deepdark_orange_color,
            ),
          ),
        ),
      ],
    );
  }

  Widget userContainer(text, _info) {
    return Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: grey200_color,
        ),
        child: Row(
          children: [
            TextWidget(
                text: text,
                weight: FontWeight.w500,
                size: text_font_medium19_size),
            Spacer(),
            TextWidget(
                text: _info,
                color: grey_gunsmoke_text_color,
                size: text_font_medium19_size),
          ],
        ));
  }

  Widget userAccountContainer(text, image, Function ontap) {
    return Column(
      children: [
        GestureDetector(
            onTap: () => ontap(),
            child: Container(
                color: transColor,
                padding: EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: deepdark_orange_color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: SvgPicture.asset(image),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    TextWidget(
                      text: text,
                      weight: FontWeight.w500,
                      size: text_font_medium14_size,
                    ),
                    if (text == "My Notification" &&
                        GemsGLobals.totalunreadnotifications == 0)
                      SizedBox(width: 10),
                    if (text == "My Notification" &&
                        GemsGLobals.totalunreadnotifications != 0)
                      Container(
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.red[700], shape: BoxShape.circle),
                        child: TextWidget(
                          text: GemsGLobals.totalunreadnotifications.toString(),
                          // "${GemsGLobals.notificationCount}",
                          size: 12,
                          color: white_text_color,
                        ),
                      ),
                  ],
                ))),
        Divider(
          indent: 50,
        )
      ],
    );
  }

  Widget newbottomSheet(stateSetter) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      // padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
      width: MediaQuery.of(context).size.width,
      decoration: new BoxDecoration(
          color: Color(0XFFF3F6FF),
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(22.0),
              topRight: const Radius.circular(22.0))),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, bottom: 5),
            height: 5,
            width: 35,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(24)),
          ),
          SizedBox(
            height: 60,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: SvgPicture.asset(ImageConstants.logout_logo),
              ),
              SizedBox(
                height: 10,
              ),
              TextWidget(
                text: "Sign Out",
                size: text_font_medium15_size,
                color: Color(0XFF1C304F),
                weight: FontWeight.w600,
              ),
              SizedBox(
                height: 5,
              ),
              TextWidget(
                text: "Are you sure you want to leave?",
                size: text_font_size_x_small,
                color: grey_background,
                weight: FontWeight.w500,
              ),
              SizedBox(
                height: Platform.isIOS ? 70 : 100,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    logoutcheck == true
                        ? Expanded(
                            child: SpinKitCircle(
                              size: 30,
                              color: blue_color,
                            ),
                          )
                        : Expanded(
                            child: Container(
                              height: 55,
                              // width: 130,
                              decoration: BoxDecoration(
                                  color: Color(0XFFE0E2EE),
                                  borderRadius: BorderRadius.circular(10)),
                              child: new MaterialButton(
                                onPressed: () {
                                  stateSetter(() {
                                    logoutcheck = true;

                                    // GemsGLobals.alumniStatus=false;

                                    logoutapi();
                                  });
                                },
                                child: Center(
                                  child: TextWidget(
                                    text: "Yes",
                                    color: Color(0XFF2C2C36),
                                    size: text_font_size_x_small,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 55,
                          //  width: 130,
                          decoration: BoxDecoration(
                              gradient: gradient_theme_color,
                              borderRadius: BorderRadius.circular(10)),

                          child: Center(
                            child: TextWidget(
                              text: "No",
                              color: white_text_color,
                              size: text_font_size_x_small,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget deletebottomSheet() {
    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: white_text_color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 10, 8, 5),
            child: new Text(
              'Confirm',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(7.0, 4, 5, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextWidget(
                      text: 'Are you sure you want to delete your account ',
                      size: text_font_medium15_size),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(
                        text: 'permanently ',
                        size: text_font_medium15_size,
                      ),
                      Image.asset(
                        ImageConstants.sad_face,
                        width: 25,
                        height: 25,
                      ),
                      TextWidget(text: '?'),
                    ],
                  )
                ],
              )),
          new Container(
            decoration: BoxDecoration(
              border: Border.fromBorderSide(
                  BorderSide(color: Colors.grey.shade300, width: 0.5)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                onWillLoading(context);
                deleteaccountapi();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    'Yes',
                    style: TextStyle(
                      fontSize: text_font_medium17_size,
                    ),
                  ),
                ],
              ),
            ),
          ),
          new Container(
            decoration: BoxDecoration(
              border: Border.fromBorderSide(
                  BorderSide(color: Colors.grey.shade300, width: 0.5)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 10),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    'No',
                    style: TextStyle(
                      fontSize: text_font_medium17_size,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabbar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // color: black_color,
      child: BottomBar(
        initialIndex: 2,
        tabvalue: "myaccount",
      ),
    );
  }

  Widget _logout() {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            showModalBottomSheet(
                isDismissible: false,
                backgroundColor: Colors.transparent,
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                builder: (context) {
                  return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: StatefulBuilder(builder:
                          (BuildContext context, StateSetter stateSetter) {
                        return newbottomSheet(stateSetter);
                      }));
                });
            // logoutDialog(context);
          },
          child: Card(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Container(
              height: 56,
              width: MediaQuery.of(context).size.width / 1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: deepdark_orange_color),
              child: Center(
                child: TextWidget(
                  text: 'Logout',
                  color: white_text_color,
                  size: text_font_medium_size,
                  weight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget userAccounts() {
    return Column(
      children: [
        userAccountContainer('My Profile', ImageConstants.Acc_profile, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyProfile()),
          );
        }),
        userAccountContainer('My Savings', ImageConstants.Acc_savings, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MySaveingDesignPage()),
          );
        }),
        userAccountContainer('My Purchases', ImageConstants.Acc_purchases, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyPurchaseHomePage()),
          );
        }),
        userAccountContainer('My Points', ImageConstants.Acc_points, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyPointsDesignPage()),
          );
        }),
        userAccountContainer('My Favorites', ImageConstants.Acc_favourite, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyFavourites()),
          );
        }),
        userAccountContainer('My Notification', ImageConstants.Acc_notification,
            () {
          Navigator.of(context).push(
            PageRouteBuilder(
              fullscreenDialog: false,
              barrierDismissible: true,

              maintainState: true,

              barrierColor: Colors.grey.shade600.withOpacity(0.9),
              opaque: false, // set to false
              pageBuilder: (_, __, ___) => NewNotificationPage(),
            ),
          );
          // .then((value) => _notificationApiCall());
        }),
        GemsGLobals.userType != "referral"
            ? userAccountContainer(
                'My Family & Friends', ImageConstants.Acc_family_friends, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FamilyandFriends()),
                );
              })
            : Container(
                height: 0,
              ),
        userAccountContainer('Help & Support', ImageConstants.Acc_helpSupport,
            () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HelpSupport()),
          );
        }),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  /* gc purchase start */

  Future<List<GiftCardPurchaseListDbModel>> getPurchaseListDataFromDb() {
    var data = GiftCardPurchaseListDBHelper().getGiftcardPurchaseListData();
    return data;
  }

  @override
  void gcPurchaseListErrorRes(Error error) {}

  @override
  void gcPurchaseListSuccessRes(
      GiftCardPurchaseListModel giftCardPurchaseListModel) {
    if (giftCardPurchaseListModel.status == true) {
      getPurchaseListDataFromDb().then((value) {
        if (value.length < 1) {
          return GiftCardPurchaseListDBHelper().save(
              GiftCardPurchaseListDbModel(
                  null, json.encode(giftCardPurchaseListModel.toJson())));
        }
      });
    } else {
      getPurchaseListDataFromDb().then((value) {
        if (value.length < 1) {
          return GiftCardPurchaseListDBHelper().save(
              GiftCardPurchaseListDbModel(
                  null, json.encode(giftCardPurchaseListModel.toJson())));
        }
      });
    }
  }

  /* gc purchase end */

  /* flt purchase start */

  Future<List<FLTPurchaseListDbModel>> getFLTPurchaseListDataFromDb() {
    var data = FLTPurchaseListDBHelper().getFLTPurchaseListData();
    return data;
  }

  @override
  void fltPurchaseListErrorRes(Error error) {}

  @override
  void fltPurchaseListSuccessRes(
      FlightPurchaseListModel flightPurchaseListModel) {
    if (flightPurchaseListModel.status == true) {
      getFLTPurchaseListDataFromDb().then((value) async {
        if (value.length < 1) {
          return FLTPurchaseListDBHelper().save(FLTPurchaseListDbModel(
              null, json.encode(flightPurchaseListModel.toJson())));
        }
      });
    } else {
      getFLTPurchaseListDataFromDb().then((value) async {
        if (value.length < 1) {
          return FLTPurchaseListDBHelper().save(FLTPurchaseListDbModel(
              null, json.encode(flightPurchaseListModel.toJson())));
        }
      });
    }
  }

  /* flt purchase end */

  /* htl purchase start */

  Future<List<HotelPurchaseListDbModel>> getHLTPurchaseListDataFromDb() {
    var data = HotelPurchaseListDBHelper().getHLTPurchaseListData();
    return data;
  }

  @override
  void hltPurchaseListErrorRes(Error error) {}

  @override
  void hltPurchaseListSuccessRes(
      HotelPurchaseListModel hotelPurchaseListModel) {
    if (hotelPurchaseListModel.status == true) {
      getHLTPurchaseListDataFromDb().then((value) {
        if (value.length < 1) {
          return HotelPurchaseListDBHelper().save(HotelPurchaseListDbModel(
              null, json.encode(hotelPurchaseListModel.toJson())));
        }
      });
    } else {
      getHLTPurchaseListDataFromDb().then((value) {
        if (value.length < 1) {
          return HotelPurchaseListDBHelper().save(HotelPurchaseListDbModel(
              null, json.encode(hotelPurchaseListModel.toJson())));
        }
      });
    }
  }

  @override
  void notificationCountSuccess(
      NotificationCountModel notificationCountModel) async {
    if (notificationCountModel.status == true) {
      setState(() {
        _unReadNoticount = 0;

        for (int i = 0; i < notificationCountModel.values!.length; i++) {
          if (notificationCountModel.values![i].isRead != 1) {
            _unReadNoticount++;
          }
        }
        GemsGLobals.notificationLoader = false;
        GemsGLobals.notificationCount = _unReadNoticount;

        if (notificationCountModel.meta != null) {
          if (notificationCountModel.meta!.countsTotalUnread != null) {
            GemsGLobals.totalunreadnotifications =
                notificationCountModel.meta!.countsTotalUnread;
          } else {
            GemsGLobals.totalunreadnotifications = 0;
          }
        }

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
  void notiificationCountError(Error error) {}
}

class MaterialTransparentRoute<T> extends PageRoute<T>
    with MaterialRouteTransitionMixin<T> {
  MaterialTransparentRoute({
    this.builder,
    RouteSettings? settings,
    this.maintainState = true,
    bool fullscreenDialog = false,
  })  : assert(builder != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder? builder;

  @override
  Widget buildContent(BuildContext context) => builder!(context);

  @override
  bool get opaque => false;

  @override
  final bool maintainState;

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}
