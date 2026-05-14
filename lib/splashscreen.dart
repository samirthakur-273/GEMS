import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:gems_revamp/Login_module/login_types/login_types.dart';
import 'package:gems_revamp/Login_module/login_types/presenter_registerdevice.dart';
import 'package:gems_revamp/Login_module/login_types/view_registerdevice.dart';
import 'package:gems_revamp/Login_module/staff_login/staff_login/staff_login.dart';
import 'package:gems_revamp/account/profile/user_profile_model.dart';
import 'package:gems_revamp/account/profile/user_profile_presenter.dart';
import 'package:gems_revamp/account/profile/user_profile_view.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/dynamiclink_routing.dart';
import 'package:gems_revamp/eshop_module_new/Shop_home_module/Database/home_page_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/Shop_home_module/Model/home_page_db_model.dart';
import 'package:gems_revamp/eshop_module_new/Shop_home_module/Model/shop_home_model.dart';
import 'package:gems_revamp/eshop_module_new/Shop_home_module/Presenter/shop_home_presenter.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_list_model.dart';
import 'package:gems_revamp/family_and_friends/family_friends_master_list/master_list_model.dart';
import 'package:gems_revamp/family_and_friends/family_friends_master_list/master_list_presenter.dart';
import 'package:gems_revamp/family_and_friends/family_friends_master_list/master_list_view.dart';
import 'package:gems_revamp/family_and_friends/master_list_db/master_list_db_helper.dart';
import 'package:gems_revamp/family_and_friends/master_list_db/master_list_db_model.dart';
import 'package:gems_revamp/homepage/apiconfig/apiconfighome.dart';
import 'package:gems_revamp/homepage/home_db/homepage_dbhelper.dart';
import 'package:gems_revamp/hotel_module/hotel_detail/select_room/select_room.dart';
import 'package:gems_revamp/main.dart';
import 'package:gems_revamp/offer_module/offer_detail/offer_detail.dart';
import 'package:gems_revamp/rooted_device/root_detection.dart';
import 'package:gems_revamp/utilities/auth_utils.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/country_list/country_list_model.dart';
import 'package:gems_revamp/utils/country_list/country_list_presenter.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/maintenance_design.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:http/http.dart' as http;
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:location/location.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login_module/login_types/model_registerdevice.dart';
import 'dynamic_link_inapp/dynamic_handler.dart';
import 'force_update/forece_update_design.dart';
import 'makesense_module/makesense_apiconfig.dart';
import 'offer_module/offer_list/offer_list.dart';

class SplashScreen extends StatefulWidget {
  final String? isLogin;
  final String? firstInstall;
  final String? screen;

  const SplashScreen({Key? key, this.isLogin, this.firstInstall, this.screen})
      : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    implements
        MasterListView,
        ShopHomeViewContract,
        RegisterDeviceView,
        UserProfileView {
  CountryListPresenter? _countryListPresenter;
  MasterListPresenter? _masterListPresenter;
  CountryListModel? _countryListModel;
  MasterListModel? _masterListModel;

  String? deviceinfo = "";
  String? deviceversion;
  String? platform;
  String? devicemodel;
  String? deviceimei;
  String? deviceid;
  Location location = new Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  RegisterDeviceModel registerdevicedata = RegisterDeviceModel();
  RegisterDevicePresenter? _registerdevicepresenter;
  var registerdataresponse;
  UserProfileModel? _profileModel;
  late UserProfilePresenter? _userProfilePresenter;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences? _sharedPreferences;

  void countryListResponse() {
    Internetconnectivity().isConnected().then((value) {
      if (value == true) {
        _countryListPresenter!.countryListApiCall();
      } else {
        _countryListPresenter!.countryListApiCall();
      }
    });
  }

  void masterListResponse() {
    Internetconnectivity().isConnected().then((value) {
      if (value == true) {
        _masterListPresenter!.masterListResponse();
      } else {
        _masterListPresenter!.masterListResponse();
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

  @override
  void initState() {
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
      makesenseEventCall();
      _userProfilePresenter = UserProfilePresenter(this);
      userProfileApi(GemsGLobals.membershipNo);
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;

      GemsGLobals.appVersion = packageInfo.version;

      String buildNumber = packageInfo.buildNumber;
    }).then((value) {
      callregisterdeviceapi();
    });
    GemsGLobals.lastVisitPageName = GemsGLobals.splashScreenPageName;

    _masterListPresenter = MasterListPresenter(this);
    masterListResponse();

    _registerdevicepresenter = RegisterDevicePresenter(this);

    callregisterdeviceapi();

    _fetchusertype(_sharedPreferences, _prefs).then((value) {
      switch (value) {
        case "0":
          GemsGLobals.userType = GemsGLobals.parent;
          break;
        case "1":
          GemsGLobals.userType = GemsGLobals.staff;
          break;
        case "2":
          GemsGLobals.userType = GemsGLobals.referral;
          break;
        case "3":
          GemsGLobals.userType = GemsGLobals.alumni;
          break;
        case "4":
          GemsGLobals.userType = GemsGLobals.smallCorporateText;
          break;
        default:
          GemsGLobals.userType = GemsGLobals.guest;
          break;
      }
    }).then((value) {
      Future.delayed(const Duration(milliseconds: 30)).then((value) {
        if (widget.isLogin != null && widget.isLogin != '') {
          homeApiCall();
        }
      });
    });

    Future.delayed(const Duration(seconds: 2), () async {
    final detector = JailbreakRootDetection.instance;
    final isJailBroken = await detector.isJailBroken;
    if (isJailBroken) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const RootErrorPage(),
        ),
      );
    } else {
      DynamicLinkHandler.instance.initialize();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('campaignImage');

      if (_profileModel?.values?.loginExpired == 1 &&
          _profileModel?.values?.type == GemsGLobals.smallCorporateText) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StaffLogin(
                      usertype:
                          GemsGLobals.defaultSource.toString().toLowerCase(),
                      data: GemsGLobals.userSavingsPoints,
                    )));
      } else if (widget.isLogin == null || widget.isLogin == '') {
        if (GemsGLobals.brandcode != null && GemsGLobals.membershipNo == null) {
          GemsGLobals.alumniStatus = false;
          AuthUtils.setIsClink("false");
          GemsGLobals.membershipNo = null;
          GemsGLobals.userType = "guest";
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => TabsScreen(
                        key: tabbarkey,
                        initialIndex: 0,
                      )));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => LoginHomePage()));
        }
      } else {
        if (GemsGLobals.brandcode != null && GemsGLobals.membershipNo != null) {
          if (Platform.isAndroid) {
            if (GemsGLobals.outletcode == "null") {
              GemsGLobals.altCatName =
                  GemsGLobals.altCatName.toString().replaceAll('\"', '');
              GemsGLobals.catCode =
                  GemsGLobals.catCode.toString().replaceAll('\"', '');
              GemsGLobals.catName =
                  GemsGLobals.catName.toString().replaceAll('"', '');
              GemsGLobals.subSecCode =
                  GemsGLobals.subSecCode.toString().replaceAll('"', '');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OfferListing(
                          subseccode: GemsGLobals.subSecCode,
                          categoryCode: GemsGLobals.catCode ?? '',
                          categoryName: GemsGLobals.catName,
                          categoryheading: GemsGLobals.altCatName)));
            } else {
              GemsGLobals.alumniStatus = false;
              GemsGLobals.catCode =
                  GemsGLobals.catCode.toString().replaceAll('\"', '');
              GemsGLobals.brandcode =
                  GemsGLobals.brandcode.toString().replaceAll('\"', '');
              GemsGLobals.outletcode =
                  GemsGLobals.outletcode.toString().replaceAll('\"', '');
              GemsGLobals.partnerbrand =
                  GemsGLobals.partnerbrand.toString().replaceAll('\"', '');
              GemsGLobals.catName =
                  GemsGLobals.catName.toString().replaceAll('"', '');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OfferDetail(
                            isHomepage: true,
                            brandcode: GemsGLobals.brandcode,
                            outletcode: GemsGLobals.outletcode,
                            partnerbrandid: GemsGLobals.partnerbrand,
                            catcode: GemsGLobals.catCode,
                            catname: GemsGLobals.catName,
                            subcatheading: GemsGLobals.altCatName,
                          )));
            }
          } else {
            return;
          }
        } else {
          if (GemsGLobals.isDeepLink != true) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => TabsScreen(
                    key: tabbarkey,
                    initialIndex: 0,
                  ),
                ));
          }
          }
        }
      }
    });
  }

  makesenseEventCall() {
    String keyName = GemsGLobals.eventSplashscreenViewed;
    var segmentReq = {GemsGLobals.intSource: ""};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  void forceupdateApi() {
    if (GemsGLobals.checkvalueno == true) {
    } else {
      var forceupdatereq = {"app_ver": GemsGLobals.appVersion};
      HomeApiconfig.forceUpdateApi(http.Client(), forceupdatereq).then((value) {
        if (value['status'] == true) {
          AuthUtils.setIntValue(
              GemsGLobals.daysCountKey, value["data"]['number_of_days']);

          if (value["data"]["update"] == true) {
            if (value["data"]['is_android'] == true) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ForceUpdate(
                            value: value["data"]["is_android"],
                          )));
            } else if (value["data"]['is_ios'] == true) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ForceUpdate(
                            value: value["data"]["is_ios"],
                          )));
            }
          } else if (value["data"]["force_update"] == true) {
            if (value["data"]['is_android'] == true) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ForceUpdate(
                            value: value["data"]["is_android"],
                          )));
            } else if (value["data"]['is_ios'] == true) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ForceUpdate(
                            value: value["data"]["is_ios"],
                          )));
            }
          } else if (value["data"]['is_under_maintenance']) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MaintanencePage()));
          }
        } else {
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
          }).then((value) {
            callregisterdeviceapi();
          });

          _masterListPresenter = MasterListPresenter(this);
          masterListResponse();

          _registerdevicepresenter = RegisterDevicePresenter(this);

          callregisterdeviceapi();

          _fetchusertype(_sharedPreferences, _prefs).then((value) {
            switch (value) {
              case "0":
                GemsGLobals.userType = GemsGLobals.parent;
                break;
              case "1":
                GemsGLobals.userType = GemsGLobals.staff;
                break;
              case "2":
                GemsGLobals.userType = GemsGLobals.referral;
                break;
              case "3":
                GemsGLobals.userType = GemsGLobals.alumni;
                break;
              case "4":
                GemsGLobals.userType = GemsGLobals.smallCorporateText;
                break;
              default:
                GemsGLobals.userType = GemsGLobals.guest;
                break;
            }
          }).then((value) {
            Future.delayed(const Duration(milliseconds: 30)).then((value) {
              if (widget.isLogin != null && widget.isLogin != '') {
                homeApiCall();
              }
            });
          });

          Future.delayed(const Duration(seconds: 4), () async {
            if (widget.isLogin == null || widget.isLogin == '') {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginHomePage()));
            } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TabsScreen(
                      key: tabbarkey,
                      initialIndex: 0,
                    ),
                  ));
            }
          });
        }
      });
    }
  }

  Future<String?> _fetchusertype(_sharedPreferences, _prefs) async {
    _sharedPreferences = await _prefs;
    String? usertype = AuthUtils.getuserType(_sharedPreferences);
    return usertype ?? "";
  }

  Future<void> callregisterdeviceapi() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};

    String deviceid;

    String? _deviceid;

    if (!mounted) return;

    var _network = await (Connectivity().checkConnectivity());

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

  void homeApiCall() {
    var homeReq = {
      "customer_id": GemsGLobals.membershipNo,
      "lat": GemsGLobals.lat,
      "long": GemsGLobals.long,
      "usertype": GemsGLobals.userType,
      "school_code": GemsGLobals.schoolcode,
    };
    Internetconnectivity().isConnected().then((result) async {
      HomePageListDBHelper().truncateTable().whenComplete(() {
        HomeApiconfig().homesection(http.Client(), homeReq);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          top: false,
          bottom: false,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ImageConstants.splashScreenbg),
                    fit: BoxFit.cover)),
            child: Center(
              child: Container(
                margin: EdgeInsets.only(bottom: 60),
                child: Image.asset(
                  ImageConstants.splashScreenNewLogo,
                  height: 90,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void masterListErrorResp(Error error) {}

  @override
  void masterListSuccessResp(MasterListModel masterListModel) {
    if (masterListModel.status == true) {
      _masterListModel = masterListModel;

      MasterListDbHelper().insertMasterListData(
          MasterListDBModel(null, json.encode(masterListModel.toJson())));
    }
  }

  @override
  void onAddToWishListError(error) {}

  @override
  void onAddToWishListSuccess(AddToWishListModel response, index) {}

  @override
  void onDeleteToWishListSuccess(AddToWishListModel response, index) {}

  @override
  void onShopHomeViewError(error) {}

  Future<List<HomePageDbModel>> getHomePageDataFromDb() {
    var data = HomePageDBHelper().getHomePageData();
    return data;
  }

  @override
  void onShopHomeViewSuccess(ShopHomeModel homePageResponse) {
    setState(() {
      if (homePageResponse.success == 'true') {
        HomePageDBHelper().truncateHomePageData();
      }
      homePageResponse.updateResponse = false;

      getHomePageDataFromDb().then((value) async {
        /*  Insert home data into database */
        if (value.length == 0) {
          var prefs = await SharedPreferences.getInstance();
          prefs.setString('homeapiresponsetime', DateTime.now().toString());
          return HomePageDBHelper().save(
              HomePageDbModel(null, json.encode(homePageResponse.toJson())));
        }
      });
    });
  }

  @override
  void onTimeout() {}

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

  @override
  void networkError(err) {}

  @override
  void userProfileErrorRespone(Error error) {}

  @override
  void userProfileSuceessRespone(UserProfileModel userProfileModel) {
    _profileModel = userProfileModel;
  }
}
