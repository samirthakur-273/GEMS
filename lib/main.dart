//TODO: To be resolve code smells- https://vernost.atlassian.net/browse/GE-5472

import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gems_revamp/Login_module/alumni_login/alumni_login.dart';
import 'package:gems_revamp/Login_module/parent_login/check_member/parent_poratId_page.dart';
import 'package:gems_revamp/Login_module/staff_login/staff_login/staff_login.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/splashscreen.dart';
import 'package:gems_revamp/utilities/auth_utils.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login_module/login_types/login_types.dart';
import 'dynamic_link_inapp/dynamic_handler.dart';

GlobalKey tabbarkey = GlobalKey();
Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences? _sharedPreferences;

    var isLogin;
    var isLoginCust = await AuthUtils.getStringValue("customer_id");

    var isLoginMember = await AuthUtils.getStringValue("membershipNo");
    var useremail;
    var gememailid;
    
    if (isLoginCust == null || isLoginCust == '') {
      isLogin = await AuthUtils.getStringValue("membershipNo");

      useremail = await AuthUtils.getStringValue("alumni") ?? "";
    } else if (isLoginMember == null || isLoginMember == '') {
      isLogin = await AuthUtils.getStringValue("customer_id");
    } else {
      isLogin = await AuthUtils.getStringValue("membershipNo");
      useremail = await AuthUtils.getStringValue("alumni") ?? "";
    }
    var firstInstall = await AuthUtils.getStringValue('checFirstInstall');
    var makesenseDeviceID = await AuthUtils.getStringValue("makesenseDevideId");
    GemsGLobals.useremail = useremail ?? "";
    GemsGLobals.userType = await AuthUtils.getStringValue("usertype");
    GemsGLobals.membershipNo = isLogin;
    GemsGLobals.makesenseDeviceID = makesenseDeviceID;
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(MyHomePge(
      isLogin: isLogin,
      firstInstall: firstInstall,
    ));

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((res) {
      _fetchSessionAndNavigate(_sharedPreferences, _prefs).then((session) {
        _fetchFirstLogin(_sharedPreferences, _prefs).then((result) {
          runApp(new MyHomePge(
            screen: session,
            firstInstall: result,
          ));
        });
      });
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(statusBarColor: transColor));
  }, (Object error, StackTrace stack) async {});
}

final routes = <String, WidgetBuilder>{};

void setErrorBuilder() {
  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return Scaffold(
        body: Center(
            child: TextWidget(
      text: "Oops! Something went wrong...",
    )));
  };
}

void initDynamicLinks() async {
  // final PendingDynamicLinkData? data =
  //     await FirebaseDynamicLinks.instance.getInitialLink();
}

Future<String?> _fetchFirstLogin(_sharedPreferences, _prefs) async {
  _sharedPreferences = await _prefs;
  String? authToken = AuthUtils.getFirstinstallation(_sharedPreferences);
  return authToken ?? "";
}

Future<String> _fetchSessionAndNavigate(_sharedPreferences, _prefs) async {
  _sharedPreferences = await _prefs;
  String? authToken = AuthUtils.getToken(_sharedPreferences);
  String? getNoti = AuthUtils.getNoti(_sharedPreferences);
  GemsGLobals.notificationVAlue = getNoti!;
  return authToken ?? "";
}

class MyHomePge extends StatelessWidget {
  const MyHomePge({this.isLogin, this.firstInstall, this.screen});

  final String? isLogin;
  final String? firstInstall;
  final String? screen;

  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) async {
      if (Platform.isIOS) {
        GemsGLobals.osType = "iOS";
        GemsGLobals.devicemodel = "";
        GemsGLobals.deviceversion = "";
        GemsGLobals.deviceId = "";
        GemsGLobals.deviceName = "";
        var osType = await AuthUtils.setStringValue("os", "iOS");
        var deviceID = await AuthUtils.setStringValue("deviceId", "");
      } else {
        GemsGLobals.osType = "Android";

        GemsGLobals.devicemodel = "";
        GemsGLobals.deviceversion = "";
        GemsGLobals.deviceId = "";
        GemsGLobals.deviceName = "";

        var osType = await AuthUtils.setStringValue("os", "Android");
        var deviceID = await AuthUtils.setStringValue("deviceId", "");
      }
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;

      GemsGLobals.appVersion = packageInfo.version;

      String buildNumber = packageInfo.buildNumber;
    });

    setErrorBuilder();
    return GetMaterialApp(
        title: 'Gems App',
        navigatorKey: DynamicLinkHandler.instance.navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Calibri',
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: SplashScreen(
          firstInstall: firstInstall,
          isLogin: isLogin,
        ),
        ),
        routes: <String, WidgetBuilder>{
          '/tabbarpage': (BuildContext context) => TabsScreen(
                initialIndex: 0,
              ),
          '/login': (BuildContext context) => LoginHomePage(),
          '/splash': (BuildContext context) => SplashScreen(
                firstInstall: firstInstall,
                isLogin: isLogin,
              ),
          '/alumni': (BuildContext context) => AlumniLogin(
                usertype: "alumni",
                email: GemsGLobals.email,
              ),
          '/staff': (BuildContext context) => StaffLogin(
                usertype: "staff",
              ),
          '/parent': (BuildContext context) => ParentPortalId(
                usertype: "staff",
              ),
        });
  }
}
