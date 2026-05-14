import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/family_and_friends/family_friends_master_list/master_list_model.dart';
import 'package:gems_revamp/family_and_friends/family_friends_master_list/master_list_presenter.dart';
import 'package:gems_revamp/flight_module/database.dart';
import 'package:gems_revamp/flight_module/flight_calender.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/flight_search.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/flighthomereq_model.dart';
import 'package:gems_revamp/flight_module/flight_source_destination/flight_popular_searh_city_db/popular_city_list_db_model.dart';
import 'package:gems_revamp/flight_module/flight_source_destination/flight_popular_searh_city_db/popular_city_list_dbhelper.dart';
import 'package:gems_revamp/flight_module/flight_source_destination/flight_search_city.dart';
import 'package:gems_revamp/flight_module/flight_source_destination/flight_search_city_model.dart'
    as flightCityData;
import 'package:gems_revamp/flight_module/flight_source_destination/flight_search_city_presenter.dart';
import 'package:gems_revamp/flight_module/flight_source_destination/flight_search_list_view.dart';
import 'package:gems_revamp/flight_module/passenger_class.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:http/http.dart' as http;
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:string_validator/string_validator.dart';

import '../common_widget/bottombar.dart';
import '../utils/constants_files/text_constants.dart';

class FlightHomePage extends StatefulWidget {
  final int tabIndex;
  final data;
  final sourceCity;
  final destinationCity;
  final route;
  final srcCode;
  final destiCode;
  final srcCity;
  final destiCity;
  FlightHomePage({
    required this.tabIndex,
    this.data,
    this.sourceCity,
    this.destinationCity,
    this.srcCode,
    this.destiCode,
    this.srcCity,
    this.destiCity,
    Key? key,
    this.route,
  }) : super(key: key);

  @override
  _FlightHomePageState createState() => _FlightHomePageState();
}

class _FlightHomePageState extends State<FlightHomePage>
    with SingleTickerProviderStateMixin
    implements FlightSearchCityView {
  TabController? _controller;
  int previousIndex = 0, tripTypeValue = 1;
  String? departureStr, returnStr, departureDate, returnDate;
  bool? _nonStopFlight = false;
  bool? _isoneway = true;
  bool? _swapValue = false;
  bool? checkedNonStp = false;
  bool? checkedValue = false;
  DateTime? startDateTime, endDateTime, firstDate;
  String? fromStr = "Select City/Airport Code",
      toStr = "Select City/Airport Code";
  flightCityData.Value? fromData, toData;
  flightCityData.Value? cityDataFrom, cityDataTo;
  String? fromCityCode = "BOM";
  String? toCityCode = "DXB";
  String? _countPassenger = "1";
  String? classStr = "Economy";
  String? site_token = "111elevate";
  String? traveltype = "oneway";
  int? _type = 1;
  int? adultcount = 1;
  int? childcount = 0, infantcount = 0;
  bool? _isLoading = true;

  int passengerCount = 1;
  int _tabselectindex = 0;
  int _tripTypetabIndex = 0;

  var cabinclass = "Economy";
  CabinClassModel? cabinClassModel;
  PassengerModel passengerData = PassengerModel();
  List<dynamic>? recentSearchList;

  MasterListPresenter? _masterListPresenter;
  MasterListModel? _masterListModel;

  final dbHelper = DatabaseHelper.instance;

  FlightSearchCityPresenter? flightSearchPresenter;
  var _cabin;
  var _passenger;
  ValueNotifier<DateTime?> _departureDateTimeNotifier =
      ValueNotifier<DateTime?>(DateTime.now());
  ValueNotifier<DateTime?> _returnDateTimeNotifier =
      ValueNotifier<DateTime?>(DateTime.now());

  ScrollController? scrollController;

  String travellersDisplayFunctn() {
    return "$adultcount ${adultcount! > 1 ? "Adults" : "Adult"}"
        "${childcount! > 0 ? ", " : ""}"
        "${childcount! > 0 ? childcount : ""}"
        "${childcount! > 1 ? " Children" : childcount == 1 ? " Child" : ""}"
        "${infantcount! > 0 ? "," : ""} ${infantcount! > 0 ? infantcount : ""} ${infantcount! > 1 ? "Infants" : infantcount == 1 ? "Infant" : ""}";
  }

  var guestdata;
  void _onRememberMeChanged(bool? newValue) => setState(() {
        _nonStopFlight = newValue;

        if (_nonStopFlight!) {
        } else {}
      });

  @override
  void initState() {
    // TODO: implement initState
    // _masterListPresenter = MasterListPresenter(this);
    // masterListResponse();

    scrollController = new ScrollController();
    FltPopularCityListDBHelper().truncateTable();
    flightSearchPresenter = FlightSearchCityPresenter(this);
    flightSearchPresenter?.popularCityFn(this);

    _controller = new TabController(length: 2, vsync: this, initialIndex: 0);
    _controller!.addListener(() {
      setState(() {});
    });

    firstDate = DateTime.now();
    startDateTime = DateTime.now();
    endDateTime = DateTime.now().add(Duration(days: 2));
    departureDate = DateFormat("dd MMM yyyy").format(startDateTime!);
    returnDate = DateFormat("dd MMM yyyy").format(endDateTime!);
    departureStr = DateFormat("yyyy MM dd").format(startDateTime!);
    returnStr = DateFormat("yyyy MM dd").format(endDateTime!);
    cabinClassModel = CabinClassModel("Economy", "0", passengerData, 1, 0, 0);
    guestdata = cabinClassModel;

    if (widget.route == "notification" || widget.route == GemsGLobals.pushNotificationRouteType) {
      this.cityDataFrom = new flightCityData.Value();
      this.cityDataTo = new flightCityData.Value();
      this.cityDataFrom?.cityName = widget.srcCity ?? "";
      this.cityDataFrom?.cityCode = widget.srcCode ?? "";
      this.cityDataFrom?.airportCode = widget.srcCode ?? "";
      this.cityDataFrom?.airportName = widget.sourceCity ?? "";
      this.cityDataTo?.cityName = widget.destiCity ?? "";
      this.cityDataTo?.cityCode = widget.destiCode ?? "";
      this.cityDataTo?.airportCode = widget.destiCode ?? "";
      this.cityDataTo?.airportName = widget.destinationCity ?? "";

      fromStr = cityDataFrom?.cityName!;
      fromCityCode = cityDataFrom!.cityCode!;
      toStr = cityDataTo?.cityName!;
      toCityCode = cityDataTo!.cityCode!;
    }
    getAllRecentSearchFromDB();

    super.initState();
  }

  void getAllRecentSearchFromDB() async {
    List allRows = await dbHelper.getFlightRecentSearch();

    setState(() {
      // _isLoading = false;
      recentSearchList = allRows;

      if (recentSearchList!.length > 0) {}
    });
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

  Widget _tripTypeTabs() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width,
      height: 35,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                _tripTypetabIndex = 0;
                _isoneway = true;

                tripTypeValue = 1;

                traveltype = "oneway";
              });
            },
            child: Column(
              children: <Widget>[
                TextWidget(
                  text: "One Way",
                  size: text_font_medium14_size,
                  weight: FontWeight.bold,
                  color: _tripTypetabIndex == 0 ? appbar_color : black_color,
                ),
                SizedBox(
                  height: 7,
                ),
                Container(
                  width: 80,
                  height: 2,
                  decoration: BoxDecoration(
                      color: _tripTypetabIndex == 0 ? appbar_color : null),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _tripTypetabIndex = 1;
                  _isoneway = false;

                  tripTypeValue = 2;
                  traveltype = "twoway";
                });
              },
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextWidget(
                        text: "  Round Trip",
                        size: text_font_medium14_size,
                        weight: FontWeight.bold,
                        color:
                            _tripTypetabIndex == 1 ? appbar_color : black_color,
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      width: 80,
                      height: 2,
                      margin: const EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                          color: _tripTypetabIndex == 1 ? appbar_color : null),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget earnburnWidget() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
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
    child: SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
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
                          margin: EdgeInsets.only(right: 40),
                          child: TextWidget(
                            text: "Flights",
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
          color: white_text_color,
          child:
              _body(),
        ),
        bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
      ),
    ),
    );
  }

  Widget _body() {
    try {
      return SingleChildScrollView(
        controller: scrollController,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              (GemsGLobals.referralRelationType != GemsGLobals.spouseValue &&
                      GemsGLobals.referralRelationType !=
                          GemsGLobals.childValue)
                  ? earnburnWidget()
                  : Container(),
              SizedBox(
                height: 15,
              ),
              _tripTypeTabs(),
              // _tripsTabs(),
              _sourceDestination(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Divider(
                  color: grey_background,
                  height: 0.5,
                  indent: 15,
                  endIndent: 15,
                ),
              ),
              _dateWid(),
              // tripTypeValue == 1
              //     ? Padding(
              //         padding: const EdgeInsets.symmetric(vertical: 5),
              //         child: Divider(
              //           color: grey_background,
              //           height: 0.5,
              //           indent: 15,
              //           endIndent: 15,
              //         ),
              //       )
              //     : Container(
              //         height: 0,
              //       ),
              passengerWidget(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Divider(
                  color: grey_background,
                  height: 0.5,
                  indent: 15,
                  endIndent: 15,
                ),
              ),
              cabinType(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Divider(
                  color: grey_background,
                  height: 0.5,
                  indent: 15,
                  endIndent: 15,
                ),
              ),
              Row(
                children: <Widget>[
                  _nerby(),
                  _nonStpFlt(),
                ],
              ),
              searchFlightButton(),
              SizedBox(
                height: 30,
              ),
              _recentSearch(),
              SizedBox(
                height: 70,
              ),
              /* This widget shows the recent data list cards */
            ],
          ),
        ),
      );
    } catch (e) {
      return Container();
    }
  }

  String _fromCityText() {
    return cityDataFrom == null ? "From" : fromStr!.toUpperCase();
  }

  String? _airportCodeText() {
    if (widget.data != null) {
      return widget.data["source_airportcode_inapp"] ?? "";
    } else {
      return cityDataFrom == null ? "Select City/Airport Code" : fromCityCode;
    }
  }

  // String _airportCodeTextNotify() {
  //   return widget.data == null
  //       ? "Select City/Airport Code"
  //       : widget.data["source_airportcode_inapp"];
  // }

  String? _airportNameText() {
    if (widget.data != null) {
      return widget.data["source_cityname_inapp"] ?? "";
    } else {
      return cityDataFrom == null ? "" : cityDataFrom!.airportName!;
    }
  }

  String? _toCityText() {
    return cityDataTo == null ? "To " : toStr!.toUpperCase();
  }

  String? _toAirportNameText() {
    if (widget.data != null) {
      return widget.data["dest_airportcode_inapp"] ?? "";
    } else {
      return cityDataTo == null ? "Select City/Airport Code" : toCityCode;
    }
  }

  String? _toAirportcodeText() {
    if (widget.data != null) {
      return widget.data["dest_cityname_inapp"] ?? "";
    } else {
      return cityDataTo == null ? "" : cityDataTo!.airportName!;
    }
  }

  Widget _sourceDestination() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: InkWell(
            onTap: () async {
              flightCityData.Value cityDataFrom = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FlightSearchCity("From Where?")));
              setState(() {
                if (cityDataFrom != null) {
                  this.cityDataFrom = cityDataFrom;
                  fromStr = cityDataFrom.cityName;
                  fromCityCode = cityDataFrom.airportCode;
                }
              });
            },
            child: Container(
              color: transColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextWidget(
                    text: _fromCityText(),
                    size: text_font_small,
                    color: flight_text_black_color,
                    weight: FontWeight.w300,
                  ),
                  TextWidget(
                    text: _airportCodeText(),
                    size: cityDataFrom == null
                        ? widget.data == null
                            ? 14
                            : 30
                        : 30,
                    weight: FontWeight.w500,
                    color: flight_text_black_color,
                  ),
                  TextWidget(
                    text: _airportNameText(),
                    size: text_font_small,
                    color: flight_text_black_color,
                    weight: FontWeight.w300,
                    maxLines: 2,
                  )
                ],
              ),
            ),
          )),
          SizedBox(
            width: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: InkWell(
                onTap: () {
                  setState(() {
                    var cityCodeChange;
                    var airportNameChange;
                    var cityNameChange;
                    if (cityDataFrom != null && cityDataTo != null) {
                      if (_swapValue = true) {
                        setState(() {
                          cityNameChange = fromStr;
                          fromStr = toStr;
                          toStr = cityNameChange;

                          cityCodeChange = fromCityCode;
                          fromCityCode = toCityCode;
                          toCityCode = cityCodeChange;

                          airportNameChange = cityDataFrom!.airportName;
                          cityDataFrom!.airportName = cityDataTo!.airportName;
                          cityDataTo!.airportName = airportNameChange;

                          cityDataFrom!.cityName = fromStr;
                          cityDataFrom!.airportCode = fromCityCode;

                          cityDataTo!.cityName = toStr;
                          cityDataTo!.airportCode = toCityCode;
                        });
                      } else {}
                    }
                  });
                },
                child: _isoneway!
                    ? Image.asset(
                        ImageConstants.flt_singleswitch,
                        height: 35,
                        width: 35,
                      )
                    : Image.asset(
                        ImageConstants.flt_roundswitch,
                        height: 35,
                        width: 35,
                      )),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
              child: InkWell(
            onTap: () async {
              flightCityData.Value cityDataTo = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FlightSearchCity("Where to?")));

              setState(() {
                if (cityDataTo != null) {
                  this.cityDataTo = cityDataTo;
                  toStr = cityDataTo.cityName!;
                  toCityCode = cityDataTo.airportCode!;
                }
              });
            },
            child: Container(
              color: transColor,
              padding: EdgeInsets.only(left: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextWidget(
                    text: _toCityText(),
                    size: text_font_small,
                    color: flight_text_black_color,
                    weight: FontWeight.w300,
                  ),
                  TextWidget(
                    text: _toAirportNameText(),
                    size: cityDataTo == null
                        ? widget.data == null
                            ? 15
                            : 30
                        : 30,
                    weight: FontWeight.w500,
                    color: flight_text_black_color,
                  ),
                  TextWidget(
                    text: _toAirportcodeText(), //_toAirportNameText,
                    size: text_font_small,
                    color: flight_text_black_color,
                    weight: FontWeight.w300,
                    maxLines: 2,
                    alignment: TextAlign.end,
                  )
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget dividerLine() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      height: 6,
      width: MediaQuery.of(context).size.width,
      child: SvgPicture.asset(ImageConstants.flt_divider_line),
    );
  }

  void showDialogMessage(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          buttonPadding: EdgeInsets.zero,
          content: Padding(
            padding: const EdgeInsets.only(top: 15.0, right: 25, left: 25),
            child: Text(msg),
          ),
          actions: [
            MaterialButton(
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: TextWidget(
                  text: "OK",
                  color: blue_color,
                ),
              )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _recentSearch() {
    return recentSearchList != null
        ? recentSearchList!.length > 0
            ? Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      text: "Recent Search",
                      size: text_font_medium_size,
                      weight: FontWeight.w600,
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 80.0,
                        child: new ListView(
                          scrollDirection: Axis.horizontal,
                          children: _continueSearchCard(),
                        ))
                  ],
                ),
              )
            : SizedBox(
                width: 0,
              )
        : SizedBox(
            width: 0,
          );
  }

  List<Widget> _continueSearchCard() {
    List<Widget> data = [];

    for (int i = 0; i < recentSearchList!.length; i++) {
      try {
        DateTime startDate = recentSearchList?[i]["startdate"] == null
            ? DateTime.now()
            : DateTime.parse(recentSearchList?[i]["startdate"]);
        DateTime endDate = recentSearchList?[i]["enddate"] == null
            ? DateTime.now().add(Duration(days: 1))
            : DateTime.parse(recentSearchList?[i]["enddate"]);
        int _totalGuest = int.parse(recentSearchList?[i]["guests"]) +
            int.parse(recentSearchList?[i]["child"]) +
            int.parse(recentSearchList?[i]["infant"]);
        data.add(GestureDetector(
            onTap: () {
              setState(() {
                adultcount = int.parse(recentSearchList?[i]["guests"]);
                childcount = int.parse(recentSearchList?[i]["child"]);
                infantcount = int.parse(recentSearchList?[i]["infant"]);
                cabinclass = recentSearchList?[i]["cabinclass"];
                tripTypeValue = int.parse(recentSearchList?[i]["triptype"]);
                if (recentSearchList?[i]["triptype"] == "1") {
                  _isoneway = true;
                } else {
                  _isoneway = false;
                }
                this.cityDataFrom = new flightCityData.Value();
                this.cityDataTo = new flightCityData.Value();
                this.cityDataFrom?.cityName = recentSearchList?[i]["source"];
                this.cityDataFrom?.cityCode =
                    recentSearchList?[i]["source_code"];
                this.cityDataFrom?.airportCode =
                    recentSearchList?[i]["source_code"];
                this.cityDataFrom?.airportName =
                    recentSearchList?[i]["source_airport"];

                this.cityDataTo?.cityName = recentSearchList![i]["destination"];
                this.cityDataTo?.cityCode =
                    recentSearchList?[i]["destination_code"];
                this.cityDataTo?.airportCode =
                    recentSearchList?[i]["destination_code"];
                this.cityDataTo?.airportName =
                    recentSearchList?[i]["destination_airport"];

                fromStr = cityDataFrom?.cityName!;
                fromCityCode = cityDataFrom!.cityCode!;
                toStr = cityDataTo?.cityName!;
                toCityCode = cityDataTo!.cityCode!;
                startDateTime = startDate.isBefore(DateTime.now())
                    ? startDateTime
                    : startDate;
                endDateTime =
                    endDate.isBefore(DateTime.now().add(Duration(days: 1)))
                        ? endDateTime
                        : endDate;
                guestdata = CabinClassModel(
                    recentSearchList?[i]["cabinclass"],
                    "",
                    passengerData,
                    int.parse(recentSearchList?[i]["guests"]),
                    int.parse(recentSearchList?[i]["child"]),
                    int.parse(recentSearchList?[i]["infant"]));
                checkedNonStp = toBoolean(recentSearchList?[i]["showNonStp"]);

                scrollController?.animateTo(
                    scrollController!.position.minScrollExtent,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn);
              });              
            },
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          ImageConstants.flt_path,
                          color: black_color,
                          height: 8,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        TextWidget(
                          text: recentSearchList?[i]["source_code"] +
                              " - " +
                              recentSearchList?[i]["destination_code"],
                          size: text_font_medium_size,
                          weight: FontWeight.w500,
                          color: flight_text_black_color,
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          ImageConstants.flt_users,
                          height: 10,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        TextWidget(
                          text: (adultcount! > 1 && childcount! > 1)
                              ? "$adultcount Adult's, $childcount Child's"
                              : '$adultcount Adult, $childcount Child',
                          // "$_totalGuest ${_totalGuest > 1 ? "Travellers" : "Traveller"}",
                          size: text_font_size_x_small,
                          weight: FontWeight.w400,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )));
      } catch (e) {}
    }
    return data;
  }

  void checkValidate() {
    this.cabinClassModel?.passengerModel = passengerData;

    if (cityDataFrom != null && cityDataTo != null) {
      Map<String, dynamic> row = {
        "source": cityDataFrom?.cityName,
        "destination": cityDataTo?.cityName,
        "source_code": cityDataFrom?.airportCode,
        "destination_code": cityDataTo?.airportCode,
        "source_airport": cityDataFrom?.airportName,
        "destination_airport": cityDataTo?.airportName,
        "triptype": tripTypeValue.toString(),
        "startdate": DateFormat("yyyy-MM-dd").format(startDateTime!),
        "enddate": DateFormat("yyyy-MM-dd").format(endDateTime!),
        "cabinclass": cabinclass,
        "guests": "${adultcount.toString()}",
        "child": "${childcount.toString()}",
        "infant": "${infantcount.toString()}",
        "showNonStp": checkedNonStp.toString()
      };

      final dbHelper = DatabaseHelper.instance;
      dbHelper.insertFlightRecentSearch(row);

      FlightRequestHolder frh = FlightRequestHolder(
        tripTypeValue,
        cityDataFrom?.cityName,
        cityDataTo?.cityName,
        cityDataFrom?.cityCode,
        cityDataTo?.cityCode,
        DateFormat("yyyy-MM-dd").format(startDateTime!),
        tripTypeValue == 2 ? DateFormat("yyyy-MM-dd").format(endDateTime!) : "",
        null,
        "0",
      );

      frh.airportOriginCode = cityDataFrom?.airportCode;
      frh.airportDestinationCode = cityDataTo?.airportCode;

      if (cityDataFrom?.cityName == cityDataTo?.cityName) {
        showDialogMessage("Source and destination should not be the same.");
      } else {
        Internetconnectivity().isConnected().then((result) async {
          if (result) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchResult(
                          frh,
                          tripTypeValue.toString(),
                          guestData: guestdata,
                          paymentTyp: (GemsGLobals.referralRelationType !=
                                      GemsGLobals.spouseValue &&
                                  GemsGLobals.referralRelationType !=
                                      GemsGLobals.childValue)
                              ? _tabselectindex == 0
                                  ? "cash"
                                  : "redemption"
                              : "cash",
                          showNonStp: checkedNonStp ?? false,
                        ))).then((value) {
              getAllRecentSearchFromDB();
            });
          } else {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => NoInternet(
                        // tabIndex: this.widget.tabIndex,
                        )));
          }
        });
      }
    } else if (widget.data != null) {
      Map<String, dynamic> row = {
        "source": widget.data["source_cityname_inapp"],
        "destination": widget.data["dest_cityname_inapp"],
        "source_code": widget.data["source_airportcode_inapp"],
        "destination_code": widget.data["dest_airportcode_inapp"],
        "source_airport": widget.data["source_airportname_inapp"],
        "destination_airport": widget.data["dest_airportname_inapp"],
        "triptype": tripTypeValue.toString(),
        "startdate": DateFormat("yyyy-MM-dd").format(startDateTime!),
        "enddate": DateFormat("yyyy-MM-dd").format(endDateTime!),
        "cabinclass": cabinclass,
        "guests": "${adultcount.toString()}",
        "child": "${childcount.toString()}",
        "infant": "${infantcount.toString()}",
        "showNonStp": checkedNonStp.toString()
      };

      final dbHelper = DatabaseHelper.instance;
      dbHelper.insertFlightRecentSearch(row);

      FlightRequestHolder frh = FlightRequestHolder(
        tripTypeValue,
        widget.data["source_cityname_inapp"],
        widget.data["dest_cityname_inapp"],
        widget.data["source_airportcode_inapp"],
        widget.data["dest_airportcode_inapp"],
        DateFormat("yyyy-MM-dd").format(startDateTime!),
        tripTypeValue == 2 ? DateFormat("yyyy-MM-dd").format(endDateTime!) : "",
        null,
        "0",
      );

      frh.airportOriginCode = widget.data["source_airportcode_inapp"];
      frh.airportDestinationCode = widget.data["dest_airportcode_inapp"];

      Internetconnectivity().isConnected().then((result) async {
        if (result) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchResult(
                        frh,
                        tripTypeValue.toString(),
                        guestData: guestdata,
                        paymentTyp:
                            _controller!.index == 0 ? "cash" : "redemption",
                        showNonStp: checkedNonStp ?? false,
                      ))).then((value) {
            getAllRecentSearchFromDB();
          });
        } else {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => NoInternet(
                      // tabIndex: this.widget.tabIndex,
                      )));
        }
      });
    } else {
      Fluttertoast.showToast(
        msg: "Please select source destination",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Widget searchFlightButton() {
    return GestureDetector(
      onTap:
          (widget.data != null) || (cityDataFrom != null && cityDataTo != null)
              ? () {
                  if (passengerCount <= 9) {
                    checkValidate();
                  } else {
                    showDialogMessage("Only 9 passengers are allowed!");
                  }
                }
              : () {
                  Fluttertoast.showToast(
                      msg: "Please select Source and Destination!",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      textColor: grey_background,
                      fontSize: 14);
                },
      child: Container(
          color: white_color,
          height: 55,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Container(
              decoration: BoxDecoration(
                  gradient: (widget.data != null) ||
                          (cityDataFrom != null && cityDataTo != null)
                      ? gradient_theme_color
                      : gradient_grey_theme_color,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Align(
                alignment: Alignment.center,
                child: TextWidget(
                  text: "Show Flights",
                  color: white_text_color,
                  weight: FontWeight.w600,
                  size: text_font_medium17_size,
                ),
              ))),
    );
  }

  Widget _tripsTabs() {
    /*This tabs gives the selection options for journey to be single or return */
    return Container(
        height: 35,
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: flight_search_color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    _isoneway = true;

                    tripTypeValue = 1;

                    traveltype = "oneway";
                  });
                },
                child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 2.3,
                    decoration: BoxDecoration(
                      gradient:
                          _isoneway! ? gradient_theme_color : grey_theme_color,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: TextWidget(
                        text: "One Way",
                        color: _isoneway! ? white_color : black_color,
                        weight: FontWeight.w600,
                        size: text_font_medium15_size,
                      ),
                    )),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _isoneway = false;

                    tripTypeValue = 2;
                    traveltype = "twoway";
                  });
                },
                child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 2.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient:
                          _isoneway! ? grey_theme_color : gradient_theme_color,
                    ),
                    child: Center(
                      child: TextWidget(
                        text: "Round Trip",
                        color: _isoneway! ? black_color : white_color,
                        weight: FontWeight.w600,
                        size: text_font_medium15_size,
                      ),
                    )),
              )
            ]));
  }

  Widget cabinType() {
    return GestureDetector(
      onTap: () async {
        _cabin = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FlightGuestPage(
                      guestData: guestdata,
                    )));

        if (_cabin != null) {
          setState(() {
            guestdata = _cabin;

            if (guestdata != null) {
              adultcount = guestdata.adultNumber;
              childcount = guestdata.childNumber;
              infantcount = guestdata.infentNumber;
              cabinclass = guestdata.cabinClassName;
            } else {}
          });
        }
      },
      child: Container(
        color: white_color,
        alignment: Alignment.bottomLeft,
        margin: EdgeInsets.only(left: 20, top: 10),
        height: 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              text: 'CLASS',
              color: flight_text_black_color,
              weight: FontWeight.w400,
              size: text_font_medium14_size,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextWidget(
                text: cabinclass,
                color: flight_text_black_color,
                weight: FontWeight.w600,
                size: text_font_medium16_size,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nerby() {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 14, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                checkedValue = !checkedValue!;
              });
            },
            child: new Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 1.0, 6.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    checkedValue!
                        ? Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color: flight_text_black_color,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                size: 20,
                                color: appbar_color,
                              ),
                            ),
                          )
                        : Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color: flight_text_black_color,
                              ),
                            ),
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    TextWidget(
                      text: "View Nearby Airports",
                      color: flight_text_black_color,
                      size: text_font_size_small,
                      weight: FontWeight.w400,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _nonStpFlt() {
    return Container(
      margin: EdgeInsets.only(left: 20, top: 14, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                checkedNonStp = !checkedNonStp!;
              });
            },
            child: new Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 1.0, 6.0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    checkedNonStp!
                        ? Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color: flight_text_black_color,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.check,
                                size: 20,
                                color: appbar_color,
                              ),
                            ),
                          )
                        : Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 2,
                                color: flight_text_black_color,
                              ),
                            ),
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    TextWidget(
                      text: "Non Stop",
                      color: flight_text_black_color,
                      size: text_font_size_small,
                      weight: FontWeight.w400,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget passengerWidget() {
    return GestureDetector(
      onTap: () async {
        _cabin = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FlightGuestPage(
                      guestData: guestdata,
                    )));

        if (_cabin != null) {
          setState(() {
            guestdata = _cabin;

            if (guestdata != null) {
              adultcount = guestdata.adultNumber;
              childcount = guestdata.childNumber;
              infantcount = guestdata.infentNumber;
              cabinclass = guestdata.cabinClassName;
            } else {}

            _countPassenger = (adultcount! + childcount!).toString();
          });
        }
      },
      child: Container(
        color: white_color,
        height: 65,
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: adultcount! > 1
                        ? "TRAVELLERS"
                        : (adultcount! > 1 && childcount! > 1)
                            ? "TRAVELLERS"
                            : "TRAVELLER",
                    color: flight_text_black_color,
                    weight: FontWeight.w300,
                    size: text_font_medium14_size,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      TextWidget(
                        text: travellersDisplayFunctn(),
                        color: flight_text_black_color,
                        weight: FontWeight.w600,
                        size: text_font_medium16_size,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _dateWid() {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CalenderPageFlight(
                        selectedStartDate: startDateTime,
                        checkSingleorReturn: "$tripTypeValue",
                        returnDate: endDateTime,
                      ))).then((value) {
            if (value != null) {
              var dateSelection = value;
              setState(() {
                startDateTime = dateSelection.selectedStartDate;

                startDateTime =
                    dateSelection.selectedStartDate ?? startDateTime;
                _departureDateTimeNotifier.value =
                    dateSelection.selectedStartDate ?? startDateTime;
                departureDate = DateFormat("dd MMM yyyy")
                    .format(_departureDateTimeNotifier.value!);
                endDateTime =
                    _departureDateTimeNotifier.value!.add(Duration(days: 2));
                _returnDateTimeNotifier.value = endDateTime;
                returnDate = DateFormat("dd MMM yyyy").format(endDateTime!);
                if (tripTypeValue == 2) {
                  setState(() {
                    startDateTime = dateSelection.selectedStartDate;
                    endDateTime = dateSelection.returnDate;

                    endDateTime = dateSelection.returnDate ?? endDateTime;
                    _returnDateTimeNotifier.value =
                        dateSelection.returnDate ?? endDateTime;
                    returnDate = DateFormat("dd MMM yyyy").format(
                        dateSelection.returnDate ??
                            _returnDateTimeNotifier.value!);
                  });
                }
              });
            }
          });
        },
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: tripTypeValue == 1
                          ? MediaQuery.of(context).size.width - 30
                          : MediaQuery.of(context).size.width / 2.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 0.0),
                              child: TextWidget(
                                text: 'Depart'.toUpperCase(),
                                color: flight_text_black_color,
                                weight: FontWeight.w300,
                                size: text_font_medium14_size,
                              )),
                          Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 0.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    // border: Border(
                                    //   bottom:
                                    //       BorderSide(width: 0.5, color: grey_color_300),
                                    // ),
                                    ),
                                width: tripTypeValue == 1
                                    ? MediaQuery.of(context).size.width
                                    : MediaQuery.of(context).size.width / 2.4,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      1.0, 6.0, 6.0, 6.0),
                                  child: Row(
                                    children: <Widget>[
                                      SvgPicture.asset(
                                        ImageConstants.flt_calender,
                                        height: 20,
                                        color: flight_blue_text_color,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      TextWidget(
                                        text: DateFormat("dd MMM yyyy")
                                            .format(startDateTime!),
                                        size: text_font_medium16_size,
                                        weight: FontWeight.w600,
                                        color: flight_text_black_color,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          tripTypeValue != 1
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.4,
                                    child: Divider(
                                      color: grey_background,
                                      height: 0.5,
                                      indent: 5,
                                      endIndent: 5,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 0,
                                )
                        ],
                      ),
                    ),
                    Spacer(),
                    tripTypeValue != 1
                        ? Container(
                            width: MediaQuery.of(context).size.width / 2.4,
                            color: transColor,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        4.0, 3.0, 8.0, 0.0),
                                    child: TextWidget(
                                      text: 'Return'.toUpperCase(),
                                      color: flight_text_black_color,
                                      weight: FontWeight.w300,
                                      size: text_font_medium14_size,
                                    )),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        3.0, 0.0, 8.0, 0.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          // border: Border(
                                          //   bottom: BorderSide(
                                          //       width: 0.5, color: grey_color_300),
                                          // ),
                                          ),
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            1.0, 6.0, 6.0, 6.0),
                                        child: Row(
                                          children: <Widget>[
                                            SvgPicture.asset(
                                              ImageConstants.flt_calender,
                                              height: 20,
                                              color: flight_blue_text_color,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            TextWidget(
                                              text: DateFormat("dd MMM yyyy")
                                                  .format(endDateTime!),
                                              size: text_font_medium16_size,
                                              weight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                tripTypeValue != 1
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.4,
                                          child: Divider(
                                            color: grey_background,
                                            height: 0.5,
                                            indent: 5,
                                            endIndent: 5,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 0,
                                      )
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              tripTypeValue == 1
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Divider(
                        color: grey_background,
                        height: 0.5,
                        indent: 15,
                        endIndent: 15,
                      ),
                    )
                  : Container(
                      height: 0,
                    )
            ],
          ),
        ));
  }

  Widget swapCity() {
    return Container(
      color: white_color,
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Divider(
                height: 1,
                color: grey_color_300,
              ),
            ),
            Container(
                width: 25,
                height: 25,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      var sourcetoStr = toStr;
                      var sourcetoCityCode = toCityCode;
                      var desStr = fromStr;
                      var destCityCode = fromCityCode;
                      fromStr = sourcetoStr;
                      fromCityCode = sourcetoCityCode;
                      toStr = desStr;
                      toCityCode = destCityCode;
                    });
                  },
                  child: Container(
                    child: SvgPicture.asset(
                      "images/flight/swipe.svg",
                      color: Color(0xffff256380),
                      width: 25,
                      height: 25,
                    ),
                  ),
                )),
            Container(
              width: 30,
              child: Divider(
                height: 1,
                color: grey_color_300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sourceWidget() {
    return GestureDetector(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Container(
                margin: EdgeInsets.only(right: 10),
                height: 30,
                width: 35,
                child: SvgPicture.asset(
                  "images/flight/Icons-22.svg",
                  color: const Color(0xffb4bec8),
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextWidget(
                  text: fromStr,
                  size: text_font_medium15_size,
                  color: Color(0xffff256380),
                  weight: FontWeight.w600,
                ),
                fromCityCode == ""
                    ? Container(
                        height: 0,
                      )
                    : Container(
                        padding: EdgeInsets.only(right: 20),
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: TextWidget(
                          text: fromCityCode,
                          size: text_font_medium15_size,
                          color: black_color,
                          weight: FontWeight.w400,
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
      onTap: () async {
        // var cityDataFrom = await Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => FlightSearchCity()));

        // setState(() {
        //   if (cityDataFrom != null) {
        //     fromStr = cityDataFrom.airportCode;
        //     fromCityCode = cityDataFrom.airportName;
        //   }
        // });
      },
    );
  }

  Widget tripTypeSelection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                tripTypeValue = 1;
              });
            },
            child: Container(
              height: 37,
              width: MediaQuery.of(context).size.width / 2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
                color: const Color(0xffc4cbd4),
              ),
              child: Center(
                  child: TextWidget(
                text: "ONE WAY",
                color: tripTypeValue == 1 ? Color(0xffff256380) : white_color,
                weight: tripTypeValue == 1 ? FontWeight.w700 : FontWeight.w400,
                size: text_font_medium15_size,
              )),
            ),
          ),
          Container(
            height: 15,
            width: 1,
            color: grey_color_300,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                tripTypeValue = 2;
              });
            },
            child: Container(
              height: 37,
              width: MediaQuery.of(context).size.width / 2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                ),
                color: const Color(0xffc4cbd4),
              ),
              child: Center(
                  child: TextWidget(
                text: "ROUND TRIP",
                color: tripTypeValue == 2 ? Color(0xffff256380) : white_color,
                weight: tripTypeValue == 2 ? FontWeight.w700 : FontWeight.w400,
                size: text_font_medium15_size,
              )),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<PopularCityListDbModel>> getFLTPopularListData() {
    var data = FltPopularCityListDBHelper().getFltPopularCityListData();
    return data;
  }

  @override
  void flightSearchCiyResponse(flightCityData.FlightSearchCityModel response) {}

  @override
  void flightpopularCityResponse(
      flightCityData.FlightSearchCityModel response) {
    if (response.status == true) {
      // setState(() {
      //   _isLoading = false;
      // });
      getFLTPopularListData().then((value) async {
        if (value.length < 1) {
          return FltPopularCityListDBHelper().save(
              PopularCityListDbModel(null, json.encode(response.toJson())));
        }
      });
    } else {}
  }

  @override
  void networkError(err) {}
}
