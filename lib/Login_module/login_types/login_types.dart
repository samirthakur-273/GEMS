import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/Login_module/alumni_login/alumni_login.dart';
import 'package:gems_revamp/Login_module/friend&family_login/fnf_login/f&f_loginpage.dart';
import 'package:gems_revamp/Login_module/login_types/model_registerdevice.dart';
import 'package:gems_revamp/Login_module/login_types/presenter_registerdevice.dart';
import 'package:gems_revamp/Login_module/login_types/view_registerdevice.dart';
import 'package:gems_revamp/Login_module/parent_login/check_member/parent_poratId_page.dart';
import 'package:gems_revamp/Login_module/staff_login/staff_login/staff_login.dart';
import 'package:gems_revamp/account/profile/user_profile_db/user_profile_dbhelper.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/Shop_home_module/Database/home_page_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/loader_widget.dart';
import 'package:gems_revamp/force_update/forece_update_design.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/database/giftcard_list_category_helper.dart';
import 'package:gems_revamp/homepage/apiconfig/apiconfighome.dart';
import 'package:gems_revamp/homepage/gemspointssearch_db/gemspoint_search_db_helper.dart';
import 'package:gems_revamp/homepage/home_db/homepage_dbhelper.dart';
import 'package:gems_revamp/homepage/offersearch_db/offer_search_db_helper.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flt_db/flt_list_dbhelper.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gc_db/gc_list_dbhelper.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hlt_db/hlt_dbhelper.dart';
import 'package:gems_revamp/offer_module/offer_detail/offer_detail.dart';
import 'package:gems_revamp/offer_module/offer_list/databasefiles/outlet_db_helper.dart';
// import 'package:gems_revamp/login_modue/parent_module/parent_id.dart';
import 'package:gems_revamp/utilities/auth_utils.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/maintenance_design.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widget/colors_widget.dart';
import '../../flight_module/database.dart';
import '../../utils/connectivity.dart';
import '../alumni_login/alumni_register/alumni_register_model.dart';
import '../alumni_login/alumni_register/alumni_register_presenter.dart';
import '../alumni_login/alumni_register/alumni_register_view.dart';

bool _initialUriIsHandled = false;

class LoginHomePage extends StatefulWidget {
  @override
  _LoginHomePageState createState() => _LoginHomePageState();
}

class _LoginHomePageState extends State<LoginHomePage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin
    implements RegisterDeviceView, AlumniRegisterView {
  String? deviceinfo = "";
  String? deviceversion;
  String? platform;
  String? devicemodel;
  String? deviceimei;
  String? deviceid;
  bool isloading = true;
  bool checkmaintenance = false;
  var noConnection;
  var _loginType;
  List _list = [];
  var arrayStr;
  var urlParam;
  var paramalues;

  Location location = new Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  RegisterDeviceModel registerdevicedata = RegisterDeviceModel();
  RegisterDevicePresenter? _registerdevicepresenter;
  var registerdataresponse;
  var brandcode;
  var outletcode;
  var partnerbrand;
  var catCode;
  var catName = "";
  var altCatName = "";
  final dbHelper = DatabaseHelper.instance;
  bool logoutcheck = false;
  late AlumniRegisterPresenter _alumniRegisterPresenter;
  StreamSubscription? sub;
  String lastPageName = '';

  Future<String> gethome(String cat) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setInt("hodedatatime", 0);
    prefs.setString("homedatamain", "");
    prefs.setString("homedatasave", "");
    prefs.setString("homedataearn", "");
    prefs.setString("topbannersmain", "");
    prefs.setString("topbannerssave", "");
    prefs.setString("topbannersearn", "");
    return "";
  }

  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;

  // Future<void> initUniLinks(data) async {
  //   sub = linkStream.listen((String? link) async {
  //     if (link != null) {
  //       var uri = Uri.parse(link);
  //       if (Platform.isIOS) {
  //         // var data = await FirebaseDynamicLinks.instance.getDynamicLink(uri);
  //         var iosLink = data?.link;
  //         newExtractDataUri(iosLink!);
  //       } else {
  //         newExtractDataUri(uri);
  //       }
  //       // newExtractDataUri(uri);
  //       //  if(GemsGLobals.getdata=="no"){
  //       if (brandcode != null) {
  //         if (GemsGLobals.membershipNo == null) {
  //           AuthUtils.setIsClink("false");
  //           GemsGLobals.membershipNo = null;
  //           // AuthUtils.setuserType("guest");
  //           GemsGLobals.userType = "guest";
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => TabsScreen(
  //                         initialIndex: 0,
  //                       )));
  //         } else if (GemsGLobals.membershipNo != null) {
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
  //                         brandcode: brandcode,
  //                         outletcode: outletcode,
  //                         partnerbrandid: partnerbrand,
  //                         catcode: catCode,
  //                         catname: catName,
  //                         subcatheading: altCatName,
  //                       )));
  //         }
  //       } else {
  //         // alumniRegisterApicall(data);
  //         if (GemsGLobals.alumniEmail == null ||
  //             GemsGLobals.alumniEmail == '') {
  //           GemsGLobals.alumniStatus = false;
  //         } else {
  //           alumniRegisterApicall(data);
  //         }
  //       }
  //       link = null;
  //     }
  //   }, onError: (err) {});
  // }

  @override
  void initState() {
    super.initState();
    lastPageName = GemsGLobals.lastVisitPageName;
    GemsGLobals.lastVisitPageName = GemsGLobals.loginTypesPageName;
    _notification();
    forceupdateApi();
    WidgetsBinding.instance!.addObserver(this);
    GemsGLobals.dontShowPopup = false;
    // initUniLinks("0");

    // _handleIncomingLinks();
    // _handleInitialUri();
    callconnect();
    autoLogout();
    if (GemsGLobals.alumniEmail == null || GemsGLobals.alumniEmail == '') {
      GemsGLobals.alumniStatus = false;
    }

    // GemsGLobals.deeplinkloader=true;

    _alumniRegisterPresenter = AlumniRegisterPresenter(this);
    if (GemsGLobals.alumniStatus == true) {
      alumniRegisterApicall("");
    }

    _checkLocation().then((result) {
      if (result != null) {
        setState(() {
          GemsGLobals.lat = result.latitude;
          GemsGLobals.long = result.longitude;
        });
      } else {}
    });

    _registerdevicepresenter = RegisterDevicePresenter(this);
    // _currentScreen();
    gethome("main");

    AuthUtils.setFrstinstallation("loggedin");
    // locationfunction();
    // pointsCall();

    if (Platform.isAndroid) {
      platform = "android";
      // DeviceDetails.androidinfo().then((andrioddetail) {
      devicemodel = "";
      deviceversion = "";
      deviceid = "";
      // });
    } else {
      platform = "ios";
      // DeviceDetails.iosinfo().then((iosdetails) {
      setState(() {
        deviceinfo = "";
        devicemodel = "";
        deviceversion = "";
        deviceid = "";
        // });
      });
    }

    callregisterdeviceapi();
    AuthUtils.setIsClink("false");
    // maintenance();
    isloading = false;
  }

  _notification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  void forceupdateApi() {
    if (GemsGLobals.checkvalueno == true) {
    } else {
      var forceupdatereq = {"app_ver": GemsGLobals.appVersion};

      HomeApiconfig.forceUpdateApi(http.Client(), forceupdatereq)
          .then((value) => {
                if (value['status'] == true)
                  {
                    AuthUtils.setIntValue(GemsGLobals.daysCountKey,
                        value["data"]['number_of_days']),
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
                      }
                    else if (value["data"]['is_under_maintenance'])
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    MaintanencePage()))
                      }
                  }
              });
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  _showFnfConverttoAlumniDialog() async {
    await Future.delayed(Duration(milliseconds: 10));
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
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
          );
        });
  }

  void _handleIncomingLinks(urinew) {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      // sub = uriLinkStream.listen((Uri? uri) async{
      Uri uri = urinew;
      if (!mounted) return;
      setState(() {
        _latestUri = uri;
        _err = null;
        newExtractDataUri(_latestUri!);
        alumniRegisterApicall("");
      });
      // },
      // onError: (Object err) {
      //   if (!mounted) return;
      //   print('got err: $err');
      //   setState(() {
      //     _latestUri = null;
      //     if (err is FormatException) {
      //       _err = err;
      //     } else {
      //       _err = null;
    }
    // });
    // });
  }
  // }

  Future<void> newExtractDataUri(Uri uri) async {
    uri.queryParameters.forEach((k, v) async {
      if (k == 'brand_code') {
        brandcode = v;
        GemsGLobals.alumniStatus = false;
      }
      if (k == 'offer_brand_outlet') {
        outletcode = v;
      }
      if (k == 'partner_brndid') {
        partnerbrand = v;
      }
      if (k == 'category_code') {
        catCode = v;
      }
      if (k == 'category_name') {
        catName = v;
      }
      if (k == 'alt_cat_name') {
        altCatName = v;
      }
      if (k == 'firstname') {
        GemsGLobals.saveusername = v;
        brandcode = null;
        GemsGLobals.brandcode = null;
      } else if (k == 'lastname') {
      } else if (k == 'schoolcode') {
        GemsGLobals.schoolcode = v;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(AuthUtils.savingschoolcode, GemsGLobals.schoolcode);
      } else if (k == 'type') {
      } else if (k == 'email') {
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

    // alumniRegisterApicall();
  }

  /// Handle the initial Uri - the one the app was started with
  ///
  /// **ATTENTION**: `getInitialLink`/`getInitialUri` should be handled
  /// ONLY ONCE in your app's lifetime, since it is not meant to change
  /// throughout your app's life.
  ///
  /// We handle all exceptions, since it is called from initState.
  // Future<void> _handleInitialUri() async {
  //   // In this example app this is an almost useless guard, but it is here to
  //   // show we are not going to call getInitialUri multiple times, even if this
  //   // was a weidget that will be disposed of (ex. a navigation route change).
  //   if (!_initialUriIsHandled) {
  //     _initialUriIsHandled = true;
  //     // _showSnackBar('_handleInitialUri called');
  //     print("tryyyyyyyyyyyyyyyyyyyy");
  //     try {
  //       var uri = await getInitialUri();

  //       if (uri == null) {
  //         print('no initial uri');
  //       } else {
  //         print('got initial uri: $uri');
  //         print("came hereeeeeeeeeeeeeee");
  //         _handleIncomingLinks(uri);
  //       }
  //       if (!mounted) return;
  //       setState(() => _initialUri = uri);
  //     } on PlatformException {
  //       // Platform messages may fail but we ignore the exception
  //       print('falied to get initial uri');
  //     } on FormatException catch (err) {
  //       if (!mounted) return;
  //       print('malformed initial uri');
  //       setState(() => _err = err);
  //     }
  //   }
  // }

  void callconnect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    GemsGLobals.saveusername = prefs.getString(AuthUtils.savingusername)!;
    GemsGLobals.schoolcode = prefs.getString(AuthUtils.savingschoolcode)!;
    GemsGLobals.type = prefs.getString(AuthUtils.savingusertype)!;
    GemsGLobals.email = prefs.getString(AuthUtils.savinguseremail)!;
  }

  void alumniRegisterApicall(data) {
    setState(() {
      GemsGLobals.deeplinkloader = true;
    });
    GemsGLobals.email = GemsGLobals.email.replaceAll('\"', "");
    var req = {"email": GemsGLobals.email};
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _alumniRegisterPresenter.alumniRegister(req, data);
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          alumniRegisterApicall(data);
        }
      }
    });
  }

  Future<void> callregisterdeviceapi() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    String deviceid;

    String? _deviceid;

    var _network = await (Connectivity().checkConnectivity());

    // setState(() {
    //   _deviceid = '$deviceid';
    // });

    // setState(() {
    //   _deviceData = deviceData;
    // });
    var request;
    if (Platform.isAndroid) {
      request = {
        "details": {
          "company": "NA",
          "model": "NA",
          "ram": "NA",
          "internal": "NA",
          "network": _network == ConnectivityResult.wifi ? 'wifi' : 'mobile',
          "platform": "android",
          "uid": "NA",
          "os": "android",
          "os_version": "NA",
        }
      };
    } else {
      request = {
        "details": {
          "company": "NA",
          "model": "NA",
          "ram": "NA",
          "internal": "NA",
          "network": _network == ConnectivityResult.wifi ? 'wifi' : 'mobile',
          "platform": "ios",
          "uid": "NA",
          "os": "ios",
          "os_version": "NA",
        }
      };
    }
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _registerdevicepresenter!.registerDeviceAPI(request);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          setState(() {});
          _registerdevicepresenter!.registerDeviceAPI(request);
        }
      }
    });
  }

  // Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  //   return <String, dynamic>{
  //     'version.securityPatch': build.version.securityPatch,
  //     'version.sdkInt': build.version.sdkInt,
  //     'version.release': build.version.release,
  //     'version.previewSdkInt': build.version.previewSdkInt,
  //     'version.incremental': build.version.incremental,
  //     'version.codename': build.version.codename,
  //     'version.baseOS': build.version.baseOS,
  //     'board': build.board,
  //     'bootloader': build.bootloader,
  //     'brand': build.brand,
  //     'device': build.device,
  //     'display': build.display,
  //     'fingerprint': build.fingerprint,
  //     'hardware': build.hardware,
  //     'host': build.host,
  //     'id': build.id,
  //     'manufacturer': build.manufacturer,
  //     'model': build.model,
  //     'product': build.product,
  //     'supported32BitAbis': build.supported32BitAbis,
  //     'supported64BitAbis': build.supported64BitAbis,
  //     'supportedAbis': build.supportedAbis,
  //     'tags': build.tags,
  //     'type': build.type,
  //     'isPhysicalDevice': build.isPhysicalDevice,
  //     'androidId': build.androidId,
  //     'systemFeatures': build.systemFeatures,
  //   };
  // }

  // Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  //   return <String, dynamic>{
  //     'name': data.name,
  //     'systemName': data.systemName,
  //     'systemVersion': data.systemVersion,
  //     'model': data.model,
  //     'localizedModel': data.localizedModel,
  //     'identifierForVendor': data.identifierForVendor,
  //     'isPhysicalDevice': data.isPhysicalDevice,
  //     'utsname.sysname:': data.utsname.sysname,
  //     'utsname.nodename:': data.utsname.nodename,
  //     'utsname.release:': data.utsname.release,
  //     'utsname.version:': data.utsname.version,
  //     'utsname.machine:': data.utsname.machine,
  //   };
  // }

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

  void clearAllUserData() {
    setState(() {
      UserProfileDbHelper().truncateTable();
      HotelPurchaseListDBHelper().truncateTable();
      FLTPurchaseListDBHelper().truncateTable();
      GiftCardPurchaseListDBHelper().truncateTable();
      OutletDBHelper().truncateTable();
      HomePageListDBHelper().truncateTable();
      HomePageDBHelper().truncateHomePageData();
      dbHelper.truncateTable();
      OfferSearchListDBHelper().truncateofferSearchHistory();
      GemsPointListDBHelper().truncategemspointSearchHistory();
    });
  }

  void autoLogout() async {
    await FirebaseMessaging.instance.deleteToken();
    setState(() {
      logoutcheck = false;
      GemsGLobals.membershipNo = null;
      // GemsGLobals.fcmToken = null;
      GemsGLobals.userFirstName = null;
      GemsGLobals.userLastName = null;
      GemsGLobals.userType = null;
      GemsGLobals.pointbalance = 0;
      GemsGLobals.custEncryptedId = null;
      GemsGLobals.alumniStatus = false;
      clearAllUserData();
    });
    UserProfileDbHelper().truncateTable();

    // SharedPreferences preferences =
    //     await SharedPreferences.getInstance();
    // preferences.clear();

    await AuthUtils.setStringValue("checFirstInstall", "true");
  }

  getLoc() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    GemsGLobals.lat = _locationData!.latitude!;
    GemsGLobals.long = _locationData!.longitude!;

    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {});
    });
    location.enableBackgroundMode(enable: true);
  }

  void pointsCall() async {
    int? totalpoints = AuthUtils.getStringValue("pointbalance");
    GemsGLobals.pointbalance = totalpoints != null ? totalpoints : 0;
  }

  makesenseEventClickedCall() {
    String keyName = GemsGLobals.eventSplashscreenClicked;
    var segmentReq = {GemsGLobals.intSource: lastPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
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

  @override
  Widget build(BuildContext context) {
    // DeepLinkBloc _bloc = DeepLinkBloc();
    // _handleInitialUri();
    Widget _gemsLogo() {
      return Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Center(
              child: Image.asset(
                ImageConstants.logo_login,
                height: 100,
                fit: BoxFit.fill,
                color: white_color,
              ),
            ),
          ),
        ],
      );
    }

    tilesImage(image, userType) {
      return Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: SvgPicture.asset(
                image,
                height: 60,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextWidget(
              text: userType,
              color: white_color,
              size: text_font_size_small,
              alignment: TextAlign.center,
              weight: FontWeight.w500,
            )
          ],
        ),
      );
    }

    Widget _loginTypes() {
      return Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                      onTap: () async {
                        setState(() {
                          AuthUtils.setuserType("0");
                        });
                        GemsGLobals.userType = GemsGLobals.parent;
                        makesenseEventClickedCall();

                        var parent = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ParentPortalId(
                                    usertype: GemsGLobals.parent)));
                      },
                      child: tilesImage(ImageConstants.newparent,
                          GemsGLobals.capitalizeParent)),
                  SizedBox(width: 50),
                  GestureDetector(
                      onTap: () async {
                        setState(() {
                          AuthUtils.setuserType("1");
                        });
                        GemsGLobals.userType = GemsGLobals.staff;
                        makesenseEventClickedCall();
                        var staff = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StaffLogin(
                                      usertype: GemsGLobals.staff,
                                    )));

                        if (GemsGLobals.geustLoginFlag != null) {
                          Navigator.pop(context);
                        }
                      },
                      child: tilesImage(ImageConstants.newemployee,
                          GemsGLobals.capitalizeEmployee))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () async {
                        setState(() {
                          AuthUtils.setuserType("2");
                        });
                        GemsGLobals.userType = GemsGLobals.referral;
                        makesenseEventClickedCall();
                        var fnflogin = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FrientFamilyLoginPage(
                                      usertype: GemsGLobals.referral,
                                    )));
                        if (GemsGLobals.geustLoginFlag != null) {
                          Navigator.pop(context);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: tilesImage(ImageConstants.newfamily,
                            GemsGLobals.capitalizeFnf),
                      )),
                  GestureDetector(
                      onTap: () async {
                        setState(() {
                          AuthUtils.setuserType("3");
                        });
                        GemsGLobals.userType = GemsGLobals.alumni;
                        makesenseEventClickedCall();
                        var alumnilogin = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AlumniLogin(
                                      email: "",
                                      usertype: GemsGLobals.alumni,
                                    )));
                        if (GemsGLobals.geustLoginFlag != null) {
                          Navigator.pop(context);
                        }
                      },
                      child: tilesImage(
                          ImageConstants.Alumni, GemsGLobals.capitalizeAlumni)),
                  GestureDetector(
                      onTap: () async {
                        setState(() {
                          AuthUtils.setuserType("4");
                        });
                        GemsGLobals.userType = GemsGLobals.defaultSource;
                        makesenseEventClickedCall();
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StaffLogin(
                                      usertype: GemsGLobals.defaultSource
                                          .toString()
                                          .toLowerCase(),
                                    )));
                        if (GemsGLobals.geustLoginFlag != null) {
                          Navigator.pop(context);
                        }
                      },
                      child: tilesImage(ImageConstants.loginCorporate,
                          GemsGLobals.defaultSource)),
                ],
              ),
              GestureDetector(
                  onTap: () {
                    // clearAllGlobal();
                    AuthUtils.setIsClink("false");
                    AuthUtils.setuserType("guest");
                    GemsGLobals.userType = "guest";
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TabsScreen(
                                  initialIndex: 0,
                                )));
                  },
                  child: Container(
                    width: 150,
                    height: 30,
                    color: Colors.transparent,
                    padding: EdgeInsets.only(top: 5),
                    margin: EdgeInsets.only(top: 15),
                    child: Center(
                      child: TextWidget(
                        text: "Skip",
                        color: white_text_color,
                        size: text_font_small,
                        weight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ))
            ],
          ));
    }

    Widget _body() {
      return Container(
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                // borderRadius: new BorderRadius.circular(10.0),
                gradient: gradient_theme_color,

                image: DecorationImage(
                    image: AssetImage(ImageConstants.logintypesparent),
                    fit: BoxFit.cover),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              // child: Image.asset(
              //   "images/login/login_landing_bg.jpg",
              //   fit: BoxFit.fill,
              // ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height / 1.32,
              left: MediaQuery.of(context).size.height / 10,
              child: _gemsLogo(),
            ),
            if (GemsGLobals.deeplinkloader == true)
              Center(
                child: Loader(),
              ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 20,
              child: _loginTypes(),
            )
          ],
        ),
      );
    }

    Widget _exitpopup() {
      return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 25, left: 15, right: 15),
                                height: 120,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: TextWidget(
                                        text: 'Are you sure you',
                                        size: text_font_size_small,
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
                                        size: text_font_size_small,
                                        weight: FontWeight.bold,
                                        color: Colors.grey[700]!,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 22),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            height: 30,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1.0,
                                                  color: grey_color,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(3)),
                                            child: MaterialButton(
                                              child: TextWidget(
                                                  text: 'No',
                                                  alignment: TextAlign.center,
                                                  size: text_font_size_small,
                                                  weight: FontWeight.bold),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(false);
                                              },
                                            ),
                                          ),
                                          Container(
                                            height: 30,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1.0,
                                                  color: grey_color,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(3)),
                                            child: MaterialButton(
                                              child: TextWidget(
                                                  text: 'Yes',
                                                  alignment: TextAlign.center,
                                                  size: text_font_size_small,
                                                  weight: FontWeight.bold),
                                              onPressed: () async {
                                                SystemChannels.platform
                                                    .invokeMethod(
                                                        'SystemNavigator.pop');
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
                      });
                    },
                    child: Image.asset(
                      "images/close.png",
                      height: 50,
                      color: white_text_color,
                    ),
                  ))
            ],
          ));
    }

    Future _onWillPop() {
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
                      size: text_font_size_small,
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
                      size: text_font_size_small,
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
                                color: grey_color,
                              ),
                              borderRadius: BorderRadius.circular(3)),
                          child: MaterialButton(
                            child: TextWidget(
                                text: 'No',
                                alignment: TextAlign.center,
                                size: text_font_size_small,
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
                                size: text_font_size_small,
                                weight: FontWeight.bold),
                            onPressed: () async {
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

    return Container(
        decoration: BoxDecoration(
          gradient: gradient_theme_color,
        ),
        child: PopScope(
          canPop: false,
          onPopInvoked: (canPop) async {
            _onWillPop();
            setState(() {
              GemsGLobals.isDialogShowing = false;
            });
            Future.value(false);
          },
          child: Scaffold(
            body: isloading == false
                ? checkmaintenance == true
                    ? _exitpopup()
                    : _body()
                : SpinKitCircle(
                    color: blue_color,
                  ),
          ),
        ));
  }

  Future<dynamic> copyVouchercode(BuildContext context, message) {
    // GemsGLobals.isDialogShowing = true;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          child: Container(
            margin: EdgeInsets.only(top: 0, left: 10, right: 5, bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.maybePop(context);
                    setState(() {
                      GemsGLobals.isDialogShowing = false;
                    });
                  },
                  child: Container(
                    height: 15,
                    margin: EdgeInsets.only(top: 5, bottom: 10, right: 5),
                    alignment: Alignment.topRight,
                    // child: Icon(
                    //   Icons.close_outlined,
                    //   color: shadow_color,
                    // )
                  ),
                ),
                Center(
                  child: TextWidget(
                    alignment: TextAlign.center,
                    text: message,
                    size: 15,
                    weight: FontWeight.bold,
                    softwrap: true,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 5),
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: blue_color,
                        ),
                        borderRadius: BorderRadius.circular(3)),
                    child: TextButton(
                      child: TextWidget(
                        text: 'OK',
                        alignment: TextAlign.center,
                        color: blue_color,
                        size: text_font_size_small,
                        weight: FontWeight.bold,
                      ),
                      onPressed: () async {
                        setState(() {
                          GemsGLobals.isDialogShowing = false;
                        });
                        var tempMsg = message.toString().toUpperCase();

                        if (tempMsg.contains("STAFF")) {
                          setState(() {
                            AuthUtils.setuserType("1");
                          });
                          Navigator.pop(context);
                          var staff = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StaffLogin(
                                        usertype: "staff",
                                      )));

                          if (GemsGLobals.geustLoginFlag != null) {
                            Navigator.pop(context);
                          }
                        } else if (tempMsg.contains("PARENT")) {
                          setState(() {
                            AuthUtils.setuserType("0");
                          });

                          Navigator.pop(context);

                          var parent = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ParentPortalId(
                                        usertype: "parent",
                                      )));
                        } else {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                )
              ],
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
                            data: "0",
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

            await Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginHomePage()));
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

  @override
  void registerdeviceResponseSuccess(RegisterDeviceModel registerdeviceModel) {
    registerdataresponse = registerdeviceModel;
    if (registerdataresponse.status == true) {
      setState(() {
        AuthUtils.setStringValue(
            "makesenseDevideId", registerdataresponse.values.deviceId);
        GemsGLobals.makesenseDeviceID = registerdataresponse.values.deviceId;
      });
    }
  }

  _showlogoutDialog() async {
    await Future.delayed(Duration(milliseconds: 50));
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
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
                      text:
                          "Already logged in as a ${capitalize(GemsGLobals.userType)} account.\nAre you sure you want to log out?",
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
          );
        });
  }

  _onlylogoutDialog() async {
    await Future.delayed(Duration(milliseconds: 50));
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
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
                      text:
                          "Your profile as ${capitalize(GemsGLobals.userType)} already exists.\nAre you sure you want to logout?",
                      // "Do you want to log out?",
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
          );
        });
  }

  _showParentStaffExistingDialog() async {
    await Future.delayed(Duration(milliseconds: 10));
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Dialog(
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
          );
        });
  }

  @override
  void alumniRegisterview(AlumniRegisterModel alumniRegisterModel, data) {
    isloading = false;
    setState(() {
      GemsGLobals.deeplinkloader = true;
    });
    if (alumniRegisterModel.status == true) {
      if (GemsGLobals.userType == null || GemsGLobals.userType == "") {
        if (alumniRegisterModel.message == 'Already registerd as alumni' ||
            alumniRegisterModel.message == "Alumni Registered Successful") {
          setState(() {
            GemsGLobals.deeplinkloader = false;
            AuthUtils.setuserType("3");
          });

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AlumniLogin(
                        email: GemsGLobals.email,
                        usertype: "alumni",
                        data: "0",
                      )));
// }
          setState(() {
            GemsGLobals.deeplinkloader = false;
          });
        } else if (alumniRegisterModel.message!.contains("Already register") ||
            alumniRegisterModel.message != 'Already registerd as alumni') {
          setState(() {
            GemsGLobals.deeplinkloader = false;
          });
          // if( GemsGLobals.isDialogShowing==false ){
          copyVouchercode(context, alumniRegisterModel.message);
          // }
        }
        // else if (alumniRegisterModel.message == 'Already registerd as parent') {
        //        setState(() {
        //     GemsGLobals.deeplinkloader=false;
        // });
        //     copyVouchercode(context, alumniRegisterModel.message);
        //   }
        //     setState(() {
        //    deeplinkloader=false;
        // });
      } else {
        setState(() {
          GemsGLobals.alumniStatus = true;
        });
        //  Navigator.push(context,
        //     MaterialPageRoute(builder: (BuildContext context) =>   TabsScreen(
        //         initialIndex: 0,
        //       ),));
        // if(data=="0" && GemsGLobals.userType.toString().toLowerCase()!="guest"){
        //   print("starttttttttttt s");
        //          Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => TabsScreen(initialIndex: GemsGLobals.select,)));
        // }
      }
    } else if ((alumniRegisterModel.message!.contains("Already register") ||
            alumniRegisterModel.message != 'Already registerd as alumni') &&
        alumniRegisterModel.status == true) {
      setState(() {
        GemsGLobals.deeplinkloader = false;
      });
      //  if( GemsGLobals.isDialogShowing==false ){
      copyVouchercode(context, alumniRegisterModel.message);
      //  }
    } else if (alumniRegisterModel.status == false) {
      GemsGLobals.alumniStatus = false;
      setState(() {
        GemsGLobals.deeplinkloader = false;
      });
      // setState(() {
      // isloading = false;
      if (alumniRegisterModel.message!.contains("Already register") ||
          alumniRegisterModel.message != 'Already registerd as alumni') {
        setState(() {
          GemsGLobals.deeplinkloader = false;
        });
        //      if ( GemsGLobals.userType == "referral" && GemsGLobals.select != 2
        //     // || GemsGLobals.email != GemsGLobals.alumniEmail
        //     ) {

        //   _showlogoutDialog();
        // }

        if (GemsGLobals.alumniStatus == true &&
                (GemsGLobals.useremail != GemsGLobals.email) &&
                GemsGLobals.userType == "referral" &&
                GemsGLobals.select != 2
            // || GemsGLobals.email != GemsGLobals.alumniEmail
            ) {
          // _showlogoutDialog();
        } else if (GemsGLobals.alumniStatus == true &&
            (GemsGLobals.useremail == GemsGLobals.email) &&
            GemsGLobals.userType == "referral" &&
            GemsGLobals.select != 2) {
          // _showFnfConverttoAlumniDialog();
        } else if ((GemsGLobals.userType == "staff" ||
            GemsGLobals.userType == "parent" && GemsGLobals.select != 2)) {
          if (GemsGLobals.useremail != GemsGLobals.email) {
            // _onlylogoutDialog();
          } else {
            // _showParentStaffExistingDialog();
          }
        } else if (GemsGLobals.useremail != GemsGLobals.email &&
            GemsGLobals.userType == "alumni" &&
            GemsGLobals.select != 2) {
          // _showlogoutDialog();
        } else if (GemsGLobals.userType == "alumni" &&
            GemsGLobals.select != 2) {
          // _showlogoutDialog();
        } else {
          // if(GemsGLobals.isDialogShowing ==false){
          copyVouchercode(context, alumniRegisterModel.message);
          // }
        }
      } else {
        Fluttertoast.showToast(
            msg: alumniRegisterModel.message.toString(),
            // msg:GemsGLobals.email,
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Color(0xAA000000),
            textColor: white_text_color,
            gravity: ToastGravity.BOTTOM);
        // });
      }
    } else {
      setState(() {
        GemsGLobals.deeplinkloader = false;
      });
    }
    // else if (alumniRegisterModel.status == false) {
    //   setState(() {
    //     isloading = false;
    //     Fluttertoast.showToast(
    //         msg: alumniRegisterModel.message.toString(),
    //         toastLength: Toast.LENGTH_LONG,
    //         backgroundColor: Color(0xAA000000),
    //         textColor: white_text_color,
    //         gravity: ToastGravity.BOTTOM);
    //   });
    // }
  }

  @override
  void allErr(error) {
    // TODO: implement allErr
  }
}
