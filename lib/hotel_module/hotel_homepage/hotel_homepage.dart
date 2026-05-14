import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/checkinternet.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotelRequest.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_calender.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/database/database.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/hotel_desti_model.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/hotel_desti_presenter.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/hotel_desti_view.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/hotel_destination.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/hotel_popular_searh_city_db/popularcity_helper.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/hotel_popular_searh_city_db/popularcitydb_model.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/popular_city_model.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_guest.dart';
import 'package:gems_revamp/hotel_module/hotel_list/hotel_list_data/hotel_list_design.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/constants_files/text_constants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/time_out.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../common_widget/bottombar.dart';

class HotelHomePage extends StatefulWidget {
  final data;
  final stayCityNotif;
  final destiId;
  final route;
  HotelHomePage({
    this.data,
    this.stayCityNotif,
    Key? key,
    this.route,
    this.destiId,
  }) : super(key: key);

  @override
  _HotelHomePageState createState() => _HotelHomePageState();
}

class _HotelHomePageState extends State<HotelHomePage>
    with SingleTickerProviderStateMixin
    implements AutoSuggestHotelView {
  RoomModel rmodel = RoomModel();

  DateTime? startDateTime, endDateTime, firstDate;
  String? checkInDate, checkOutDate;
  String? _guestCount;
  String? _selectLoca;
  var _roomCount;
  var loca;
  var _destId;
  var _searchType;
  var noConnection;
  late TabController _controller;
  String? _hotelCityName;
  List<bool> recentBoolList = List.empty(growable: true);
  var destinationId, searchType, searchText, destType;
  final dbHelper = DatabaseHelper.instance;
  List<dynamic>? recentSearchList;
  late AutoSuggestHotelPresenter _autoSuggestHotelPresenter;
  int _tabselectindex = 0;
  final ScrollController topcontroller = ScrollController();
  late HotelRequestParameter _hotelRequestParameter;
  Suggestion listData = Suggestion(
    destinationId: 0,
    searchType: 0,
    searchText: "Search by City/Area/Hotel Name",
    count: 1511,
    destType: "other",
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _getAllRecentSearchFromDB();
    _internet();
    _autoSuggestHotelPresenter = AutoSuggestHotelPresenter(this);
    getPopularCity();
    _controller = new TabController(length: 2, vsync: this, initialIndex: 0);
    _controller.addListener(() {
      setState(() {});
    });

    _hotelRequestParameter = new HotelRequestParameter();
    _hotelRequestParameter.guestDetails = List.empty(growable: true);
    _hotelRequestParameter.rooms = List.empty(growable: true);

    rmodel.roomList.add(GuestModel(1, 0));
    setState(() {
      startDateTime = DateTime.now().add(Duration(days: 4));
      endDateTime = DateTime.now().add(Duration(days: 6));

      checkInDate = DateFormat("dd-MMM-yyyy").format(startDateTime!);
      checkOutDate = DateFormat("dd-MMM-yyyy").format(endDateTime!);
    });
    this.rmodel.resetRoomDetails();
    if (widget.route == GemsGLobals.notificationRouteType || widget.route == GemsGLobals.pushNotificationRouteType) {
      _hotelCityName = widget.stayCityNotif;
      destinationId = widget.destiId;
      searchType = 0;
      destType = "city";
    }

    if (widget.data != null) {
      _hotelCityName = widget.data["hotelCityName_inapp"];
      listData.searchText = widget.data["hotelCityName_inapp"];
      listData.destinationId = int.parse(widget.data["destination_id_inapp"]);
    }
    super.initState();
  }

  void _internet() async {
    CheckInternet().apiCall().then((value) => {});
  }

/* Popular city api call */
  void getPopularCity() {
    setState(() {
      CheckInternet().apiCall().then((value) => {
            if (value == true)
              {
                // _autoSuggestHotelPresenter.getpopularCity()
              }
            else
              {
                // Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (BuildContext context) => NoInternet()))
                //     .then((value) {
                //   Navigator.maybePop(context);
                // }),
              }
          });
    });
  }

  _getRoomdata() {
    if (this.rmodel.totalChildren() == 0) {
      return "${this.rmodel.totalAdults()} ${(this.rmodel.totalAdults() == 1 ? 'Adult' : 'Adults')} , ${this.rmodel.totalRoom()} Room";
    } else if (this.rmodel.totalChildren() == 1) {
      return "${this.rmodel.totalAdults()} ${(this.rmodel.totalAdults() == 1 ? 'Adult' : 'Adults')}  ${this.rmodel.totalChildren()} Child, ${this.rmodel.totalRoom()} Room";
    } else {
      return "${this.rmodel.totalAdults()} ${(this.rmodel.totalAdults() == 1 ? 'Adult' : 'Adults')}  ${this.rmodel.totalChildren()} Children, ${this.rmodel.totalRoom()} Room";
    }
  }

  /* get Recent search data from DB */
  void _getAllRecentSearchFromDB() async {
    List allRows = await dbHelper.getHotelRecentSearch();

    setState(() {
      recentSearchList = allRows;

      for (int i = 0; i < recentSearchList!.length; i++) {
        recentBoolList.add(false);
      }
    });
  }

  Widget earnburnWidget() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Color(0XFFf4f4f4),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: grey_border, width: 0.8)),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _tabselectindex = 0;
                });
              },
              child: Container(
                margin: EdgeInsets.all(3),
                height: 45,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: _tabselectindex == 0
                      ? button_bgemail_color
                      : Color(0XFFf4f4f4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: TextWidget(
                    text: "Collect GEMS Points",
                    color: _tabselectindex == 0
                        ? white_text_color
                        : flight_text_black_color,
                    size: text_font_medium14_size,
                    weight: _tabselectindex == 0
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _tabselectindex = 1;
                });
              },
              child: Container(
                margin: EdgeInsets.all(3),
                height: 45,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: _tabselectindex == 1
                      ? button_bgemail_color
                      : Color(0XFFf4f4f4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: TextWidget(
                    text: "Redeem GEMS Points",
                    color: _tabselectindex == 1
                        ? white_color
                        : flight_text_black_color,
                    size: text_font_medium14_size,
                    weight: _tabselectindex == 1
                        ? FontWeight.w600
                        : FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
          onPopInvoked: (canPop) async {
            if (widget.route == GemsGLobals.pushNotificationRouteType) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => TabsScreen(
                            initialIndex: 0,
                          )));
            }
            return Future.value(false);
          },
     child:  SafeArea(
          top: false,
          bottom: true,
       child: Scaffold(
        extendBody: true,
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
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).maybePop();
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue[400],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Container(
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 22,
                              color: white_text_color,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(right: 30),
                          child: TextWidget(
                            text: AppTexts.searchHotelsText,
                            size: 18,
                            weight: FontWeight.w500,
                            color: white_text_color,
                          )),
                    )
                  ],
                ),
              )),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: white_text_color,
          child: SingleChildScrollView(
            child: Column(
              children: [
                (GemsGLobals.referralRelationType != GemsGLobals.spouseValue &&
                        GemsGLobals.referralRelationType !=
                            GemsGLobals.childValue)
                    ? earnburnWidget()
                    : Container(),
                _body(),
              ],
            ),
          ),
        ),
            bottomNavigationBar: SizedBox(
              height: 95,
              child: _tabbar(),
            ),
       ),
     ),
    );
  }
Widget _tabbar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // color: black_color,
      child: BottomBar(
        initialIndex: 0,
        tabvalue: "myaccount",
      ),
    );
  }

/* Collect and redeem tab */
  Widget _tabs() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      // decoration: BoxDecoration(color: white_text_color, boxShadow: [
      //   BoxShadow(
      //     color: grey_color_300,
      //     blurRadius: 2.0,
      //     spreadRadius: 2.0,
      //   ),
      // ]),
      child: AppBar(
        backgroundColor: white_color,
        elevation: 0,
        bottom: TabBar(
          isScrollable: false,
          // indicator: UnderlineTabIndicator(
          //   insets: EdgeInsets.only(left: 10, right: 10),
          // ),
          labelColor: black_color,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          indicatorColor: blue_color,
          unselectedLabelColor: Colors.grey,
          controller: _controller,

          tabs: [
            Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: TextWidget(
                      text: "Collect GEMS",
                      size: 17,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Container(
                      child: TextWidget(
                        text: "Redeem GEMS",
                        size: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomOpacity: 1,
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 15.0, 8.0, 0.0),
            child: new Align(
                alignment: Alignment.topLeft,
                child: TextWidget(
                  text: "Book or stay at any Hotel and collect GEMS",
                  color: grey_color,
                  size: 13,
                )),
          ),
          Container(
            // height: MediaQuery.of(context).size.height / 2.5,
            child: Card(
              margin: EdgeInsets.all(20),
              child: Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: Column(
                  children: <Widget>[
                    sourceWidget(),
                    dividerLine(),
                    _dateWid(),
                    passengerWidget(),
                    dividerLine(),
                    // Spacer(),
                  ],
                ),
              ),
            ),
          ),
          // SizedBox(height: 10),
          searchFlightButton(),
          SizedBox(
            height: 10,
          ),
          new Container(
              height: MediaQuery.of(context).size.height / 2.5,
              child: recentSearchList != null
                  ? recentSearchList!.length > 0
                      ? new ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            new Container(
                              padding: EdgeInsets.only(left: 11, right: 13),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        4.0, 0.0, 0.0, 0.0),
                                    child: TextWidget(
                                      text: "Recent Searches",
                                      size: text_font_medium17_size,
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3,
                                      child: new ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: continueSearchCard(),
                                      ))
                                ],
                              ),
                            ),
                          ],
                        )
                      : SizedBox()
                  : SizedBox())
        ],
      ),
    );
  }

/* get Adult */
  _getAdultdata(adult) {
    if (adult == '1') {
      return "$adult Adult";
    } else {
      return "$adult Adults";
    }
  }

/* get child */
  _getChildData(child) {
    if (child != '0') {
      if (child == '1') {
        return ", $child Child";
      } else {
        return ", $child Children";
      }
    } else {
      return "";
    }
  }

/* get adult and child */
  _getGuestData(adult, child) {
    if (adult != null && child != null) {
      return '${_getAdultdata(adult)} ${_getChildData(child)}';
    } else {
      return '';
    }
  }

  /* Recent search list widget */
  List<Widget> continueSearchCard() {
    return List.generate(
        recentSearchList!.length,
        (i) => Container(
            width: MediaQuery.of(context).size.width / 2.4,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  for (int j = 0; j < recentBoolList.length; j++) {
                    if (j == i) {
                      recentBoolList[j] = true;
                    } else {
                      recentBoolList[j] = false;
                    }
                  }
                  destinationId =
                      int.parse(recentSearchList![i]["destination_id"]);
                  searchText = recentSearchList![i]["searchText"];
                  _hotelCityName = recentSearchList![i]["city"];
                  searchType = int.parse(recentSearchList![i]["searchType"]);
                  topcontroller.animateTo(0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                });
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                            imageUrl: recentSearchList![i]["image"] ?? '',
                            fit: BoxFit.fill,
                            height: 80,
                            width: MediaQuery.of(context).size.width / 2,
                            placeholder: (context, url) => Image.asset(
                                  ImageConstants.noimages,
                                  fit: BoxFit.cover,
                                  height: 80,
                                ),
                            errorWidget: (context, url, error) {
                              return Image.asset(
                                ImageConstants.noimages,
                                fit: BoxFit.cover,
                                height: 80,
                              );
                            })),
                    Container(
                      margin: EdgeInsets.only(left: 1, top: 5),
                      child: new Text(
                        'HOTEL',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 1, top: 3),
                      child: TextWidget(
                        text: "${recentSearchList![i]["city"]}",
                        size: text_font_medium14_size,
                        weight: FontWeight.bold,
                        softwrap: false,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 1, top: 1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextWidget(
                            text: _getGuestData(recentSearchList![i]["adult"],
                                recentSearchList![i]["child"]),
                            size: 11,
                            weight: FontWeight.bold,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          TextWidget(
                            text: (DateFormat("MMM dd").format(DateTime.parse(
                                    recentSearchList![i]["checkindate"]))) +
                                ' - ' +
                                (DateFormat("MMM dd").format(DateTime.parse(
                                    recentSearchList![i]["checkoutdate"]))),
                            size: 11,
                            weight: FontWeight.bold,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  Widget dividerLine() {
    return Container(
      color: white_text_color,
      child: Divider(
        height: 1,
        color: grey_background,
        endIndent: 20,
        indent: 20,
      ),
    );
  }

  Widget searchFlightButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_tabselectindex == 1) {
            GemsGLobals.usedGems = GemsGLobals.redeemValue;
          } else {
            GemsGLobals.usedGems = GemsGLobals.cashValue;
          }
        });

        if (_hotelCityName != null) {
          var selectdate = DateFormat("dd MMM yyyy").format(startDateTime!) +
              " - " +
              DateFormat("dd MMM yyyy").format(endDateTime!);
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => HotelList(
                      // countryName: "Dubai",
                      // selectDate: selectdate,
                      // roomDetails: _getRoomdata(),
                      destinationid: destinationId,
                      serachtype: int.parse(searchType.toString()),
                      destinationtype: destType,
                      country: _hotelCityName,
                      checkinDate: startDateTime,
                      checkoutDate: endDateTime,
                      guestcount: this.rmodel.totalGuests(),
                      adultcount: this.rmodel.totalAdults(),
                      childcount: this.rmodel.totalChildren(),
                      roomDetails: this.rmodel.getRoomDetails(),
                      mop: _tabselectindex == 0 ? 'cash' : 'redemption',
                      roomType: (this.rmodel.totalAdults() == 1
                              ? "${this.rmodel.totalAdults()} Adult"
                              : "${this.rmodel.totalAdults()} Adults") +
                          (this.rmodel.totalChildren() != 0
                              ? this.rmodel.totalChildren() == 1
                                  ? " ${this.rmodel.totalChildren()} Child"
                                  : " ${this.rmodel.totalChildren()} Children"
                              : '') +
                          ", ${this.rmodel.totalRoom()} Room",
                      roomcount: this.rmodel.totalRoom())))
              .then((value) {
            _getAllRecentSearchFromDB();
          });
        } else {
          Fluttertoast.showToast(
              msg: "Please select Destination!",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              textColor: white_text_color,
              fontSize: 14);
        }
      },
      child: Container(
          height: 55,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Container(
                decoration: BoxDecoration(
                    color: button_bgpdf_color,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: TextWidget(
                        text: "Search",
                        color: Colors.white,
                        weight: FontWeight.w500,
                        size: text_font_medium_size,
                      ),
                    ),
                  ],
                )),
          )),
    );
  }

  Widget passengerWidget() {
    return GestureDetector(
      onTap: () async {
        RoomModel? rmodel = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HotelGuestRoom(this.rmodel)));

        setState(() {
          if (rmodel != null) {
            this.rmodel = rmodel;
          }
        });
      },
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextWidget(
              text: "GUESTS",
              size: text_font_size_x_small,
              color: grey_gunsmoke_text_color,
              weight: FontWeight.w400,
              overflow: TextOverflow.fade,
            ),
            SizedBox(
              height: 10,
            ),
            TextWidget(
              text: _getRoomdata(), //" Guests ",
              color: black_color,
              weight: FontWeight.w500,
              size: text_font_medium15_size,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateWid() {
    /*This widget shows the date selected for the journey */
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CalenderPageHotel(
                        selectedStartDate: startDateTime,
                        returnDate: endDateTime,
                      ))).then((dateTime) {
            if (dateTime != null) {
              DateSelection dateSelection = dateTime;

              setState(() {
                startDateTime = dateSelection.selectedStartDate;
                endDateTime = dateSelection.returnDate;

                checkInDate = DateFormat("dd-MMM-yyyy").format(startDateTime!);
                if (DateFormat("dd-MMM-yyyy").format(startDateTime!) ==
                    DateFormat("dd-MMM-yyyy").format(endDateTime!)) {
                  endDateTime = startDateTime!.add(Duration(days: 1));
                }
                checkOutDate = DateFormat("dd-MMM-yyyy").format(endDateTime!);
              });
            }
          });
        },
        child: Container(
          margin: EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                width: MediaQuery.of(context).size.width / 2.7,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 0.5, color: grey_background),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: "CHECK-IN",
                      size: 13,
                      color: Color(0xff787878),
                      weight: FontWeight.w400,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                            alignment: Alignment.center,
                            height: 20,
                            width: 25,
                            child: SvgPicture.asset(
                              ImageConstants.calender,
                              color: blue_color,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TextWidget(
                              text: DateFormat("dd MMM yyyy")
                                  .format(startDateTime!),
                              size: text_font_medium15_size,
                              weight: FontWeight.w500,
                              color: black_color,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                width: MediaQuery.of(context).size.width / 2.7,
                padding: EdgeInsets.only(top: 20, bottom: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 0.5, color: grey_background),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: "CHECK-OUT",
                      size: 13,
                      color: Color(0xff787878),
                      weight: FontWeight.w400,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                            alignment: Alignment.center,
                            height: 20,
                            width: 25,
                            child: SvgPicture.asset(
                              ImageConstants.calender,
                              color: blue_color,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TextWidget(
                              text: DateFormat("dd MMM yyyy")
                                  .format(endDateTime!),
                              size: text_font_medium15_size,
                              weight: FontWeight.w500,
                              color: black_color,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget sourceWidget() {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: "CITY / AREA / HOTEL NAME",
              size: text_font_size_x_small,
              color: grey_gunsmoke_text_color,
              weight: FontWeight.w400,
              overflow: TextOverflow.fade,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  height: 20,
                  width: 25,
                  child: SvgPicture.asset(
                    ImageConstants.searchicon,
                    color: blue_color,
                    height: 27,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: TextWidget(
                    text: _hotelCityName != null
                        ? _hotelCityName
                        : "Search by City/Area/Hotel Name",
                    size: text_font_medium15_size,
                    color: black_color,
                    weight: FontWeight.w500,
                    overflow: TextOverflow.fade,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      onTap: () async {
        loca = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HotelDestination(),
            ));

        setState(() {
          // _hotelRequestParameter.searchText =
          destinationId = loca.destinationId.toString();
          searchType = loca.searchType.toString();
          destType = loca.destType.toString();

          _hotelCityName = loca.searchText;
          for (int i = 0; i < recentBoolList.length; i++) {
            recentBoolList[i] = false;
          }
        });
      },
    );
  }

  Future<List<PopularCityListDbModel>> getpopularCityListdb() {
    var data = HotelPopularCityListDBHelper().getpopularCityListData();

    return data;
  }

  @override
  void allErr(error) {
    // TODO: implement allErr
  }

  @override
  void autosuggestList(AutoSuggestHotelModel autoSuggestHotelModel) {
    // TODO: implement autosuggestList
  }

  @override
  void cityResponse(PopularCityHotelModel popularCityHotelModel) async {
    getpopularCityListdb();
    var length = popularCityHotelModel.values?.data?.length ?? 0;
    if (popularCityHotelModel.status == true) {
      if (length > 0) {
        getpopularCityListdb().then((value) async {
          if (value.length < 1) {
            // if nodata in db Insert vocher list data into database /
            return HotelPopularCityListDBHelper().save(PopularCityListDbModel(
                null, json.encode(popularCityHotelModel.toJson())));
          }
        });
      } else if (popularCityHotelModel.status == false) {
        if (popularCityHotelModel.message == "timeout") {
          var notresponding = await Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => TimeOut()));
          if (notresponding != null) {
          } else {
            Navigator.pop(context);
          }
        }
      }
      // // TODO: implement cityResponse
      // if (popularCityHotelModel.status == true) {
      //   getpopularCityListdb().then((value) async {
      //     if (value.length < 1) {
      //       return HotelPopularCityListDBHelper().save(PopularCityListDbModel(
      //           null, json.encode(popularCityHotelModel.toJson())));
      //     }
      //   });
    }
  }
}
