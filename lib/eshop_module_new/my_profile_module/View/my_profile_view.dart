import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/address/address.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/Database/cart_details_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/Database/shipping_method_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/my_orders_list.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Database/my_profile_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/details_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/my_profile_db_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/my_profile_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/View/details_view.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/View/sellerwise_policy.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/presenter/details_presenter.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/presenter/my_profile_pesenter.dart';
import 'package:gems_revamp/eshop_module_new/my_wishlist/Database/my_wishlist_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_wishlisht_count_provider.dart';
import 'package:gems_revamp/eshop_module_new/service_unavailable/service_unavailable.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_page.dart';
import 'package:gems_revamp/eshop_module_new/utils/shimmer/myprofile_shiimer.dart';
import 'package:gems_revamp/splashscreen.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
// import 'package:gems_revamp/eshop_module_new/sign_in_up/SignInUp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common_widget/back_to_gems.dart';

class MyProfilePage extends StatefulWidget {
  List? titlekeyaboutus, titlekeycontact;
  List<ContactUs>? titlekeycustomer;
  ShopTabBarPageState? tabBarPageState;

  MyProfilePage(
      {this.titlekeyaboutus,
      this.titlekeycontact,
      this.titlekeycustomer,
      this.tabBarPageState});

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage>
    with TickerProviderStateMixin
    implements MyProfileViewContract, DetailsView {
  late MyProfilePresenter _presenter;
  MyProfileModel? _model;

  int? index;

  late MyDetailsPresenter _detailsPresenter;
  DetailsModel? _detailsModel;

  var _noConnection;
  bool _isLoading = true;
  bool selected1 = true;
  bool selected2 = true;
  bool selected3 = true;

  final formKey = new GlobalKey<FormState>();

  var userEmail;
  var userName;
  String version = "";

  @override
  void initState() {
    super.initState();

    _presenter = MyProfilePresenter(this);
    if (GemsGLobals.membershipId != null || GemsGLobals.membershipNo != "0") {
      _presenter.getMyProfileData();
    }

    packageInfo();
  }

  packageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
  }

  void onMyProfileViewSuccess(MyProfileModel response) {
    setState(() {
      if (response.success == 'true' && response.updateResponse == true) {
        dbHelper.truncateMyProfileData();
      }
      if (response.success == 'true') {
        _model = response;
        userEmail = _model?.customer?.email;
        userName = _model?.customer?.fullName;
        _isLoading = false;
        if (response.orderList != null) {
          getProfileDataFromDb().then((value) async {
            if (value.length < 1) {
              // if nodata Insert profile data into database /
              var prefs = await SharedPreferences.getInstance();
              prefs.setString(
                  'profileapiresponsetime', DateTime.now().toString());
              return dbHelper.save(
                  MyProfileDataModel(null, json.encode(_model!.toJson())));
            }
          });
        }
      }
    });
  }

  Future<void> getData() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString("MyProfileJson") != null ||
        prefs.getString("MyProfileJson") != "") {
      var myProfileJson = prefs.getString("MyProfileJson");

      var map = json.decode(myProfileJson ?? "");
    }
  }

  static var dbHelper = MyProfileDBHelper();

  Future<List<MyProfileDataModel>> getProfileDataFromDb() {
    var data = dbHelper.getMyProfileData();
    return data;
  }

  @override
  void onMyProfileViewError(error) {
    setState(() {
      _isLoading = false;
    });
  }

  guestid() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString("Guestid") == null ||
        prefs.getString("Guestid") == "") {
      // ApiConfig().guestlogin().then((value) async {
      //   if (value != null) {
      //     prefs.setString("Guestid", value.body.toString());
      //     Constants.customerId = "";
      //     Constants.guestId = prefs.getString("Guestid") ?? "";
      //     setState(() {
      //       _isLoading = false;
      //       Fluttertoast.showToast(
      //           msg: "You have logged out successfully",
      //           gravity: ToastGravity.BOTTOM,
      //           backgroundColor: Color(0xAA000000),
      //           textColor: white_text_color,
      //           toastLength: Toast.LENGTH_LONG);
      //       widget.tabBarPageState!.apiCall();
      //     });
      //   }
      // });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: Container(
              decoration: BoxDecoration(gradient: gradient_theme_color),
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(
                top: 25,
              ),
              height: Platform.isIOS ? 100 : 90,
              child: Container(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     widget.tabBarPageState!.tabClick(0);
                    //   },
                    //   child: Container(
                    //     margin: EdgeInsets.only(left: 10),
                    //     height: 40,
                    //     width: 40,
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(8),
                    //       color: Colors.blue[400],
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.only(left: 10.0),
                    //       child: Container(
                    //         child: Icon(
                    //           Icons.arrow_back_ios,
                    //           size: 22,
                    //           color: white_text_color,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(right: 40),
                          child: TextWidget(
                            text: "My Account",
                            size: 18,
                            weight: FontWeight.w500,
                            color: white_text_color,
                          )),
                    )
                  ],
                ),
              )),
          // GradientAppBar(
          //   title: "My Account",
          //   color: white_text_color,
          //   size: 18,
          //   weight: FontWeight.w500,
          //   centerTitle: true,
          //   height: 90,
          // ),
        ),
        body: Stack(
          children: [
            _isLoading
                ? MyProfileShimmer()
                : Container(
                    color: white_text_color,
                    child: ListView(
                      children: [
                        userName == null
                            ? Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              )
                            : InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => MyAccount(
                                  //             customerData: _model?.customer,
                                  //           )),
                                  // ).then((value) {
                                  //   if (value != null) {
                                  //     dbHelper.truncateMyProfileData();
                                  //     internetCall(
                                  //         context,
                                  //         () => MyProfilePresenter(this)
                                  //             .getMyProfileData());
                                  //     setState(() {});
                                  //   }
                                  // });
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 15, right: 15, top: 10),
                                  color: transColor,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: GemsGLobals.userFirstName != ''
                                            ? "${toBeginningOfSentenceCase(GemsGLobals.userFirstName)}" +
                                                " " +
                                                "${toBeginningOfSentenceCase(GemsGLobals.userLastName)}"
                                            : "$userName",
                                        size: text_font_medium15_size,
                                        color: black_color,
                                        weight: FontWeight.w600,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextWidget(
                                        text: GemsGLobals.useremail != ''
                                            ? "${GemsGLobals.useremail}"
                                            : "$userEmail",
                                        size: text_font_medium15_size,
                                        color: Color(0XFF8B8B8B),
                                        weight: FontWeight.w500,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                        Container(
                          color: Colors.white,
                          child: Divider(
                            indent: 10,
                            endIndent: 10,
                            color: grey_color,
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          alignment: FractionalOffset.center,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (GemsGLobals.membershipNo != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangeNotifierProvider(
                                                      create: (context) =>
                                                          WishListCartCount(),
                                                      child: MyOrderList(
                                                        orderHistory: _model
                                                                ?.orderHistory ??
                                                            [],
                                                        model:
                                                            _model?.orderList ??
                                                                [],
                                                      ))),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SplashScreen()),
                                        ).then((value) {
                                          if (value) {
                                            setState(() {
                                              dataUpdate();
                                            });
                                          }
                                        });
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: new BoxDecoration(
                                            color: Color(0XFFE5F5F4),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(22.0),
                                            child: Image.asset(
                                              ImageConstants.orderNew_shop,
                                              color: black_color,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextWidget(
                                          text: "Orders",
                                          size: text_font_medium15_size,
                                          weight: FontWeight.w500,
                                          color: Color(0XFF703621),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      ContactUs policy =
                                          widget.titlekeycustomer!.firstWhere(
                                        (element) =>
                                            element.title == "Privacy Policy",
                                      );

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SellerWisePolicyPage(
                                                  policyData: policy,
                                                )),
                                      );

                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) => Policy(
                                      //             policyData: policy,
                                      //           )),
                                      // );
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: new BoxDecoration(
                                            color: Color(0XFFFFCF1DF),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(22.0),
                                            child: Image.asset(
                                              ImageConstants.policyNew_shop,
                                              color: black_color,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextWidget(
                                          text: "Policy",
                                          size: text_font_medium15_size,
                                          weight: FontWeight.w500,
                                          color: Color(0XFF703621),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (GemsGLobals.membershipNo != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddressView(
                                                    model:
                                                        _model?.address ?? null,
                                                  )),
                                        ).whenComplete(() {
                                          _presenter.getMyProfileData();
                                        });
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SplashScreen()),
                                        ).then((value) {
                                          if (value) {
                                            setState(() {
                                              dataUpdate();
                                            });
                                          }
                                        });
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          decoration: new BoxDecoration(
                                            color: Color(0XFFF9DCE1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(22.0),
                                            child: Image.asset(
                                              ImageConstants.addressNew_shop,
                                              color: black_color,
                                              height: 30,
                                              width: 30,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextWidget(
                                          text: "Address",
                                          size: text_font_medium15_size,
                                          weight: FontWeight.w500,
                                          color: Color(0XFF703621),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
            Positioned(
                bottom: 150, right: 0, child: Container(child: BackToGems())),
          ],
        ));
  }

  @override
  void onDetailsViewError(error) {}

  List? _data;

  @override
  void onDetailsViewSuccess(DetailsModel response) {
    setState(() {
      _detailsModel = response;
    });
  }

  void dataUpdate() {
    _isLoading = true;

    dbHelper.truncateMyProfileData();
    _presenter.getMyProfileData();

    widget.tabBarPageState?.apiCall();
    CartDetailsDBHelper().truncateCartDetailsData().then((value) => {});
    ShippingDetailsDBHelper().truncateShippingDetailsData();

    MyWishListDBHelper().truncateWishlistData();
  }

  @override
  void onProfileTimeout() {
    if (mounted)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cxt) => ServiceUnavailable(
                  onRetry: () => MyProfilePresenter(this).getMyProfileData())));
  }
}

class ProfileArabicText {
  var name;
  var image;

  ProfileArabicText(this.name, this.image);
}
