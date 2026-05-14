import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/account/mypoints/model_mypoints.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/utils/connectivity.dart';
import 'package:gems_revamp/homepage/apiconfig/apiconfighome.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flight_purchase_list/flight_purchase_list_model.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flight_purchase_list/flight_purchase_list_page.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flight_purchase_list/flight_purchase_list_presenter.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flight_purchase_list/flight_purchase_list_view.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flt_db/flt_list_db_model.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flt_db/flt_list_dbhelper.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gc_db/gc_list_db_model.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gc_db/gc_list_dbhelper.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gift_purchase_list/gift_purchase_list_model.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gift_purchase_list/gift_purchase_list_page.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gift_purchase_list/gift_purchase_list_presenter.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gift_purchase_list/gift_purchase_list_view.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hlt_db/hlt_db_model.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hlt_db/hlt_dbhelper.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_list/hotel_purchase_list_model.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_list/hotel_purchase_list_page.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_list/hotel_purchase_list_presenter.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_list/hotel_purchase_list_view.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../account/mypoints/presenter_mypoints.dart';
import '../account/mypoints/view_mypoints.dart';
import '../common_widget/bottombar.dart';
import '../eshop_module_new/my_orders_list.dart';
import '../eshop_module_new/my_profile_module/Model/my_profile_model.dart';
import '../eshop_module_new/my_profile_module/presenter/my_profile_pesenter.dart';
import '../eshop_module_new/product_list_module/Model/product_wishlisht_count_provider.dart';
import '../offer_module/offer_webview.dart';
import '../utils/no_internet.dart';

class MyPurchaseHomePage extends StatefulWidget {
  MyPurchaseHomePage({Key? key}) : super(key: key);

  @override
  _MyPurchasePageState createState() => _MyPurchasePageState();
}

class _MyPurchasePageState extends State<MyPurchaseHomePage>
    implements
        FlightPurchaseListView,
        HotelPurchaseListView,
        GiftPurchaseListView,
        MyProfileViewContract,
        MyPointsView {
  Color _flightColor = Color(0xfffbf4de);
  Color _hotelColor = Color(0xffe2f8f5);
  Color _gcColor = Color(0xfff0e8ff);

  MyProfileModel? _model;
  late MyProfilePresenter _presenter;
  MyPointsPresenter? _pointspresenter;
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    _pointspresenter = MyPointsPresenter(this);
    callmypointsapi();
    _presenter = MyProfilePresenter(this);
    if (GemsGLobals.membershipId != "" || GemsGLobals.membershipNo != "0") {
      _presenter.getMyProfileData();
    }

    FlightPurchaseListPresenter(this)
        .fltPurchaseListApiRes(GemsGLobals.membershipNo);
    HotelPurchaseListPresenter(this)
        .hotelPurchaseListResApi(GemsGLobals.membershipNo);
    GiftPurchaseListPresenter(this)
        .giftPurchaseListApiRes(GemsGLobals.membershipNo, 10);

    super.initState();
    check();
  }

  void callmypointsapi() {
    var request = {
      "offset": "0",
      "limit": "100",
      "membership_no": GemsGLobals.membershipNo,
      "type": GemsGLobals.userType,
    };

    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _pointspresenter!.myPointsAPI(request);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          setState(() {});
          _pointspresenter!.myPointsAPI(request);
        }
      }
    });
  }

  void onMyProfileViewSuccess(MyProfileModel response) {
    setState(() {
      if (response.success == 'true') {
        _model = response;
        _eshopordersCount = _model!.orderList!.length;
      }
    });
  }

  int? _giftPurchaseCount = 0;
  int? _hotelBookCount = 0;
  int? _flightBookCount = 0;
  int? _eshopordersCount = 0;
  int elevateCount = 0;
  int? _receiptBookcount = 0;

  List<dynamic> purchaselistArray = [
    {
      'section': 'flights',
      'section_name': 'Flights',
      'section_image': ImageConstants.flight_purchase,
      'section_bg_image': ImageConstants.flt_purchase_bg,
      'date': '2022-02-24 09:23:36'
    },
    {
      'section': 'hotels',
      'section_name': 'Hotels',
      'section_image': ImageConstants.hotel_purchase,
      'section_bg_image': ImageConstants.htl_purchase_bg,
      'date': '2022-02-24 09:23:36'
    },
    {
      'section': 'giftcard',
      'section_name': 'Gift Cards',
      'section_image': ImageConstants.gift_purchase,
      'section_bg_image': ImageConstants.gc_purchase_bg,
      'date': '2022-02-24 09:23:36'
    },
    {
      'section': 'elevate_trips',
      'section_name': 'GEMS Holidays', //'Elevate Trips',
      'section_image': ImageConstants.experience_purchase,
      'section_bg_image': ImageConstants.gc_purchase_bg,
      'date': '2022-02-24 09:23:36'
    },
    {
      'section': 'eshop_orders',
      'section_name': 'Eshop Orders', //'Elevate Trips',
      'section_image': "", //ImageConstants.eshop_purchase_bg,
      'section_bg_image':ImageConstants.eshop_purchase_bg,
      'date': '2022-02-24 09:23:36'
    },
  ];

  Map<String, List> purchaseListingarray = {};

  void check() {
    purchaseListingarray = {};

    for (var j = 0; j < purchaselistArray.length; j++) {
      var date = purchaselistArray[j]["date"];
      var fromatedDate = DateTime.parse(date);

      String _date = getDate(fromatedDate);
      purchaseListingarray[_date] ??= [];

      purchaseListingarray[_date]?.add(purchaselistArray[j]);
    }
  }

  void elevateBookingAPi() {
    if (GemsGLobals.userType != "guest") {
      var body = {
        "customer_id": GemsGLobals.membershipNo,
      };

      HomeApiconfig.elevateBookingApi(http.Client(), body).then((result) async {
        if (result["status"] == true) {
          var url = result["URL"] ?? "";
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ForYouWeb(
                          appbarname: "GEMS REWARDS",
                          weburl: url,
                        )));
            // LaunchUrl.openLink(url: url);
          });
        } else {
          // setState(() {
          //   _isLoading = false;
          // });
        }
      });
    } else {
      // DialogAlert.showLoginAlert(context);
    }
  }

  String getDate(DateTime dateTime) {
    Duration dur = DateTime.now().difference(dateTime);

    var days = dur.inDays;

    switch (days) {
      case 0:
        return DateFormat("MMMM yyyy").format(dateTime);

      default:
        return DateFormat("MMMM yyyy").format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Widget _body() {
    //   return Container(
    //     color: Colors.white,
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [Expanded(child: myPurchaseList())],
    //     ),
    //   );
    // }

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

    Widget _menuoptions(menu, i) {
      return GestureDetector(
        onTap: () {
          if (menu['section'] == 'flights') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FlightPurchaseListPage()));
          } else if (menu['section'] == 'hotels') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HotelPurchaseListPage()));
          } else if (menu['section'] == 'giftcard') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GiftPurchaseListPage()));
          } else if (menu['section'] == 'elevate_trips') {
            setState(() {
              elevateBookingAPi();
            });
          } else if (menu['section'] == 'eshop_orders') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                      create: (context) => WishListCartCount(),
                      child: MyOrderList(
                        model: [],
                        route: "confirm",
                      ))),
            );
          }
        },
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 5),
          height: 100,
          child: Card(
            semanticContainer: true,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 0.3, color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 0,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            left: 15,
                          ),
                          height: 50,
                          width: 50,
                          child: SvgPicture.asset(menu['section_bg_image']),
                        ),
                        Positioned(
                            top: 13,
                            left: 28,
                            child: Center(
                              child: Container(
                                height: 25,
                                width: 25,
                                child: SvgPicture.asset(menu['section_image'], fit: BoxFit.fill,),
                              ),
                            ))
                      ],
                    ),
                    // Container(
                    //   margin: const EdgeInsets.only(
                    //     left: 15,
                    //   ),
                    //   height: 45,
                    //   width: 45,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(8),
                    //     shape: BoxShape.rectangle,
                    //     // color: purchaseList['section'] == 'flight'
                    //     //     ? flight_purchase_bg
                    //     //     : purchaseList['section'] == 'hotels'
                    //     //         ? hotel_purchase_bg
                    //     //         : gift_purchase_bg,
                    //   ),
                    //   child: Padding(
                    //       padding: EdgeInsets.all(5),
                    //       child: menu['section'] == 'flight'
                    //           ? SvgPicture.asset(ImageConstants.flight_purchase,
                    //               height: 5, width: 5, fit: BoxFit.scaleDown)
                    //           : menu['section'] == 'hotels'
                    //               ? SvgPicture.asset(
                    //                   ImageConstants.hotel_purchase,
                    //                   height: 5,
                    //                   width: 5,
                    //                   fit: BoxFit.scaleDown)
                    //               : SvgPicture.asset(
                    //                   ImageConstants.gift_purchase,
                    //                   height: 5,
                    //                   width: 5,
                    //                   fit: BoxFit.scaleDown)),
                    // ),

                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: TextWidget(
                        text:
                            // 'flight',
                            menu['section_name'],
                        color: purchase_text_color,
                        weight: FontWeight.w600,
                        size: text_font_medium17_size,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 15,
                  ),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      shape: BoxShape.rectangle,
                      color: common_gray_color
                      // Color(purchaselistArray[index]['color']
                      ),
                  child: Center(
                    child: TextWidget(
                      text: menu['itemCount'],
                      // purchaselistArray[index]['count'],
                      color: purchase_text_color,
                      size: text_font_medium17_size,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    List<Widget> _listoftap(data) {
      List<Widget> list = [];
      for (var i = 0; i < data.length; i++) {
        if (data[i]["section"] == "flights") {
          data[i]["itemCount"] = _flightBookCount.toString();
        } else if (data[i]["section"] == "hotels") {
          data[i]["itemCount"] = _hotelBookCount.toString();
        } else if (data[i]["section"] == "giftcard") {
          data[i]["itemCount"] = _giftPurchaseCount.toString();
        } else if (data[i]["section"] == "eshop_orders") {
          data[i]["itemCount"] = _eshopordersCount.toString();
        } else if (data[i]["section"] == "elevate_trips") {
          data[i]["itemCount"] = elevateCount.toString();
        } else {
          data[i]["itemCount"] = "0";
        }
        list.add(_menuoptions(data[i], i));
      }
      return list;
    }

    Widget _maenuConatiner() {
      return Container(
        margin: EdgeInsets.only(left: 5, right: 5, top: 10),
        child: Column(
          children: _listoftap(purchaselistArray),
        ),
      );
    }

    return Container(
      color: const Color(0xFFFFFFFF),
      child: SafeArea(
        bottom: true,
        top: false,
        child: Scaffold(
          extendBody: true,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(100.0),
              child: GradientAppBar(
                title: "My Purchases",
                color: white_text_color,
                size: 18,
                weight: FontWeight.w500,
                centerTitle: true,
                height: 100,
              )
              //  AppBar(
              //   backgroundColor: Colors.white,
              //   elevation: 0.0,
              //   leading: GestureDetector(
              //     onTap: () {
              //       Navigator.pop(context);
              //     },
              //     child: Container(
              //       margin: const EdgeInsets.only(left: 10, top: 10),
              //       height: 15,
              //       width: 15,
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(10),
              //           shape: BoxShape.rectangle,
              //           color: appbar_backarw_bg_color),
              //       child: Padding(
              //           padding: EdgeInsets.only(left: 0),
              //           child: SvgPicture.asset(
              //             ImageConstants.backbutton,
              //             height: 50,
              //             width: 50,
              //             fit: BoxFit.scaleDown,
              //           )),
              //     ),
              //   ),
              //   centerTitle: true,
              //   title: Container(
              //     margin: const EdgeInsets.only(top: 10),
              //     child: TextWidget(
              //       text: 'My Purchases',
              //       size: 21,
              //       weight: FontWeight.w500,
              //       color: white_text_color,
              //     ),
              //   ),
              //   flexibleSpace: Image.asset(
              //     ImageConstants.appbarbgimage,
              //     fit: BoxFit.fill,
              //   ),
              // ),
              ),
          body: _isLoading == true
              ? SpinKitCircle(color: blue_color)
              : ListView(
                  children: [_maenuConatiner()],
                ),
         bottomNavigationBar: SizedBox(
           height: 95,
           child: _tabbar(),
         ),
        ),
      ),
    );
  }

  Future<List<FLTPurchaseListDbModel>> getFLTPurchaseListDataFromDb() {
    var data = FLTPurchaseListDBHelper().getFLTPurchaseListData();
    return data;
  }

  @override
  void fltPurchaseListSuccessRes(
      FlightPurchaseListModel flightPurchaseListModel) {
    if (flightPurchaseListModel.status == true) {
      setState(() {
        _flightBookCount = flightPurchaseListModel.values!.length;
      });
      getFLTPurchaseListDataFromDb().then((value) async {
        if (value.length < 1) {
          return FLTPurchaseListDBHelper().save(FLTPurchaseListDbModel(
              null, json.encode(flightPurchaseListModel.toJson())));
        }
      });
    }
  }

  @override
  void fltPurchaseListErrorRes(Error error) {}

  Future<List<GiftCardPurchaseListDbModel>> getPurchaseListDataFromDb() {
    var data = GiftCardPurchaseListDBHelper().getGiftcardPurchaseListData();
    return data;
  }

  @override
  void gcPurchaseListSuccessRes(
      GiftCardPurchaseListModel giftCardPurchaseListModel) {
    if (giftCardPurchaseListModel.status == true) {
      setState(() {
        _giftPurchaseCount = giftCardPurchaseListModel.objects!.length;
      });
      getPurchaseListDataFromDb().then((value) async {
        if (value.length < 1) {
          return GiftCardPurchaseListDBHelper().save(
              GiftCardPurchaseListDbModel(
                  null, json.encode(giftCardPurchaseListModel.toJson())));
        }
      });
    }
  }

  @override
  void gcPurchaseListErrorRes(Error error) {}

  Future<List<HotelPurchaseListDbModel>> getHLTPurchaseListDataFromDb() {
    var data = HotelPurchaseListDBHelper().getHLTPurchaseListData();
    return data;
  }

  @override
  void hltPurchaseListSuccessRes(
      HotelPurchaseListModel hotelPurchaseListModel) {
    if (hotelPurchaseListModel.status == true) {
      setState(() {
        _hotelBookCount = hotelPurchaseListModel.values!.length;
      });
      getHLTPurchaseListDataFromDb().then((value) async {
        if (value.length < 1) {
          return HotelPurchaseListDBHelper().save(HotelPurchaseListDbModel(
              null, json.encode(hotelPurchaseListModel.toJson())));
        }
      });
      setState(() {});
    }
  }

  @override
  void hltPurchaseListErrorRes(Error error) {}

  @override
  void onMyProfileViewError(error) {
    // TODO: implement onMyProfileViewError
  }

  @override
  void onProfileTimeout() {
    // TODO: implement onProfileTimeout
  }

  @override
  void mypointsResponseSuccess(MyPointsModel mypointsModel) {
    // TODO: implement mypointsResponseSuccess
    _isLoading = false;

    setState(() {
      if (mypointsModel.status == true) {
        int? len = mypointsModel.values?.data?.length;

        for (var i = 0; i < len!; i++) {
          if (mypointsModel.values!.data![i].activityCode!
                  .contains('ELETRIPS') ||
              mypointsModel.values!.data![i].activityCode!
                  .contains('ELEACRL')) {
            elevateCount++;
          }
        }
      } else {}
    });
  }
}
