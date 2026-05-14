import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/Gradient_button.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/flight_module/flightBookingConfirmation/flight_confirmation.dart';
import 'package:gems_revamp/flight_module/flighthomepage.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flight_purchase_list/flight_purchase_list_model.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flight_purchase_list/flight_purchase_list_presenter.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flight_purchase_list/flight_purchase_list_view.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flt_db/flt_list_db_model.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flt_db/flt_list_dbhelper.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../common_widget/bottombar.dart';
import '../../../utils/constants_files/text_constants.dart';

class FlightPurchaseListPage extends StatefulWidget {
  const FlightPurchaseListPage({Key? key}) : super(key: key);

  @override
  _FlightPurchaseListPageState createState() => _FlightPurchaseListPageState();
}

class _FlightPurchaseListPageState extends State<FlightPurchaseListPage>
    with SingleTickerProviderStateMixin
    implements FlightPurchaseListView {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    _fltPurchaseListApiCall();
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    // _tabController!.addListener(tablistner());
  }

  tablistner() {}

  
  int? _index;

  bool _isupcomingSelected = true;
  bool _iscompletedSelected = false;
  bool _iscancelledSelected = false;
  var _flightData;
  bool _isLoading = false;
  List? _upcomingData = [];
  List? _completedData = [];
  List? _cancelledData = [];
  List? _showData = [];

  Future<List<FLTPurchaseListDbModel>> getFLTCardPurchaseDataFromDb() {
    var data = FLTPurchaseListDBHelper().getFLTPurchaseListData();

    return data;
  }

  _fltPurchaseListApiCall() {
    getFLTCardPurchaseDataFromDb().then((value) async {
      if (value.length > 0) {
        FlightPurchaseListPresenter(this)
            .fltPurchaseListApiRes(GemsGLobals.membershipNo);
      } else {
        Internetconnectivity().isConnected().then((result) async {
          if (result) {
            FlightPurchaseListPresenter(this)
                .fltPurchaseListApiRes(GemsGLobals.membershipNo);
          } else {
            var connectionResult = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => NoInternet()));
            if (connectionResult != null) {
              _fltPurchaseListApiCall();
            } else {
              Navigator.pop(context);
            }
          }
        });
      }
    });
  }

  Widget _nodataFound() {
    return Container(
      margin: EdgeInsets.fromLTRB(15, 35, 15, 0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: SvgPicture.asset(
                ImageConstants.noResultFound,
                height: 160,
                width: 160,
              ),
            ),
            Container(
                alignment: Alignment.center,
                child: TextWidget(
                  text:
                      "Not yet booked a flight?\n Click here to book your destination.",
                  size: text_font_medium_size,
                  weight: FontWeight.w500,
                  alignment: TextAlign.center,
                )),
            new SizedBox(
              height: 40,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GradientButtonWidget(
                      height: 50,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (contex) => FlightHomePage(
                                      tabIndex: 0,
                                    )));
                      },
                      color: appbar_color,
                      child: TextWidget(
                        text: "Book a Flight",
                        size: text_font_medium15_size,
                        color: white_text_color,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> fligtList(flightPurchaselistArray) {
    List<Widget> _flightList = [];
    for (var i = 0; i < flightPurchaselistArray.length; i++) {
      _flightList.add(flightPurchaselistArray.length != 0
          ? Container(
              margin:
                  const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
              //height: 120,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FlightBookingConfirmationPage(
                                brfNo: flightPurchaselistArray[i].fltCpBrfNo,
                                bookingBrfNo:
                                    flightPurchaselistArray[i].fltBrfNo,
                                type: 'purchase',
                              )));
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => FlightPurchaseDetailsPage()));
                },
                child: Card(
                  semanticContainer: true,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                     side: BorderSide(width: 0.3, color: Colors.grey ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 0,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10, top: 10),
                            height: 55,
                            width: 55,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: FadeInImage.assetNetwork(
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                      ImageConstants.flt_no_image_flight,
                                      fit: BoxFit.fill,
                                    );
                                  },
                                  fit: BoxFit.fill,
                                  placeholder:
                                      ImageConstants.flt_no_image_flight,
                                  image: flightPurchaselistArray[i].fltArnImg),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                  width: 1, color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: TextWidget(
                                  text: flightPurchaselistArray[i].fltAnm,
                                  color: purchase_text_color,
                                  size: text_font_medium15_size,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              //      const SizedBox(
                              //   height: 5,
                              // ),
                              TextWidget(
                                text: flightPurchaselistArray[i].fltPnr,
                                color: Color(0xffb2b2be),
                                size: text_font_size_x_small,
                                weight: FontWeight.normal,
                                softwrap: true,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                          Spacer(),
                          Container(
                            child: TextWidget(
                              text: flightPurchaselistArray[i].fltBbokingDate,
                              // dateformate(flightPurchaselistArray[i]['date']),
                              color: const Color(0xffb2b2be),
                              weight: FontWeight.w400,
                              size: 13,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),

                          // ],)
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      _iscompletedSelected == true
                          ? Container(
                              margin:
                                  EdgeInsets.only(top: 0, left: 10, right: 10),
                              child: TextWidget(
                                text: flightPurchaselistArray[i]
                                            .transactionType !=
                                        "RD"
                                    ? "${pointsFormatter(int.parse(flightPurchaselistArray[i].bnzAccPnts ?? "0"))} GEMS points Earned"
                                    : "${pointsFormatter(flightPurchaselistArray[i].fltTotalAmt ?? 0)}GEMS points Redeemed'",
                                color: appbar_color,
                                size: text_font_medium14_size,
                                weight: FontWeight.w600,
                              ),
                            )
                          : _isupcomingSelected == true
                              ? Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: TextWidget(
                                    text: flightPurchaselistArray[i]
                                                .transactionType !=
                                            "RD"
                                        ? "${pointsFormatter(int.parse(flightPurchaselistArray[i].bnzAccPnts ?? "0"))} GEMS points will be credited"
                                        : "${pointsFormatter(flightPurchaselistArray[i].fltTotalAmt ?? 0)} GEMS points Redeemed",
                                    color: appbar_color,
                                    size: text_font_medium14_size,
                                    weight: FontWeight.w600,
                                  ),
                                )
                              : _iscancelledSelected == true
                                  ? Container(
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: TextWidget(
                                        text: flightPurchaselistArray[i]
                                                    .transactionType !=
                                                "RD"
                                            ? "No GEMS Points credited due to cancellation"
                                            : "${pointsFormatter(flightPurchaselistArray[i].fltTotalAmt ?? 0)} GEMS Points has been reversed",
                                        color: appbar_color,
                                        size: text_font_size_x_small,
                                        weight: FontWeight.w600,
                                      ),
                                    )
                                  : Container(
                                      height: 0,
                                    ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: TextWidget(
                                text: 'Transaction ID -' +
                                    flightPurchaselistArray[i].fltCpBrfNo,
                                color: const Color(0xffb2b2be),
                                weight: FontWeight.w400,
                                size: 13,
                              ),
                            ),
                            // Container(
                            //   child: TextWidget(
                            //     text: flightPurchaselistArray[i].fltBbokingDate,
                            //     // dateformate(flightPurchaselistArray[i]['date']),
                            //     color: const Color(0xffb2b2be),
                            //     weight: FontWeight.w400,
                            //     size: 13,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
            )
          : _nodataFound());
    }

    return _flightList;
  }

  Widget _flightListingWidget(flightPurchaselistArray) {
    return Expanded(
      child: ListView(
        // shrinkWrap: true,
        children: fligtList(flightPurchaselistArray),
      ),
    );
  }

  Widget _flightStatusWidget() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15),
      height: 55,
      width: MediaQuery.of(context).size.width / 1,
      decoration: BoxDecoration(
          color: white_text_color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(width: 1, color: Colors.grey.shade300)),
      child: FittedBox(
        child: Container(
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isupcomingSelected = true;
                    _iscompletedSelected = false;
                    _iscancelledSelected = false;
                    _showData = _upcomingData;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: _isupcomingSelected == true
                          ? blue_color
                          : white_text_color),
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(5, 0, 2, 0),
                  width: MediaQuery.of(context).size.width / 3.4,
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 9, bottom: 9),
                  child: FittedBox(
                    child: TextWidget(
                      maxLines: 1,
                      text: "Upcoming",
                      size: text_font_medium15_size,
                      color: _isupcomingSelected == true
                          ? white_text_color
                          : Colors.grey[400],
                      alignment: TextAlign.center,
                      weight: _isupcomingSelected == true
                          ? FontWeight.w600
                          : FontWeight.w600,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isupcomingSelected = false;
                    _iscompletedSelected = true;
                    _iscancelledSelected = false;
                    _showData = _completedData;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: _iscompletedSelected == true
                          ? blue_color
                          : white_text_color),
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(5, 0, 2, 0),
                  width: MediaQuery.of(context).size.width / 3.4,
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 9, bottom: 9),
                  child: FittedBox(
                    child: TextWidget(
                      maxLines: 1,
                      text: "Completed",
                      size: text_font_medium15_size,
                      color: _iscompletedSelected == true
                          ? white_text_color
                          : Colors.grey[400],
                      alignment: TextAlign.center,
                      weight: _iscompletedSelected == true
                          ? FontWeight.w600
                          : FontWeight.w600,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isupcomingSelected = false;
                    _iscompletedSelected = false;
                    _iscancelledSelected = true;
                    _showData = _cancelledData;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: _iscancelledSelected == true
                          ? blue_color
                          : white_text_color),
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(5, 0, 2, 0),
                  width: MediaQuery.of(context).size.width / 3.4,
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 9, bottom: 9),
                  child: FittedBox(
                    child: TextWidget(
                      maxLines: 1,
                      text: "Cancelled",
                      size: text_font_medium15_size,
                      color: _iscancelledSelected == true
                          ? white_text_color
                          : Colors.grey[400],
                      alignment: TextAlign.center,
                      weight: _iscancelledSelected == true
                          ? FontWeight.w600
                          : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        _flightStatusWidget(),
        // _flightStatusWidget(),
        _showData!.length != 0
            ? _flightListingWidget(_showData)
            : _nodataFound()
      ],
    );
  }

  Widget _appbar() {
    return AppBar(
        centerTitle: true,
        elevation: 0,
        title: Container(
          margin: const EdgeInsets.only(top: 10),
          child: const TextWidget(
            text: 'Flights',
            size: 22,
            // alignment: TextAlign.left,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context, true);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10, top: 10),
            height: 15,
            width: 15,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                shape: BoxShape.rectangle,
                color: const Color(0xff3cabea)),
            child: const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
        ),
        flexibleSpace: Image.asset(
          ImageConstants.appbarbgimage,
          fit: BoxFit.cover,
        ));
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Container(
        child: Scaffold(
           extendBody: true,
          appBar: PreferredSize(
              child: GradientAppBar(
                title: AppTexts.flightsText,
                color: white_text_color,
                size: 18,
                weight: FontWeight.w500,
                centerTitle: true,
                height: 100,
              ),
              preferredSize: Size.fromHeight(70.0)),
         
          body: _isLoading == true
              ? SpinKitCircle(
                  color: appbar_color,
                )
              : _body(),
          bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
        ),
      ),
    );
  }

  @override
  void fltPurchaseListErrorRes(Error error) {
    // TODO: implement fltPurchaseListErrorRes
  }

  @override
  void fltPurchaseListSuccessRes(
      FlightPurchaseListModel flightPurchaseListModel) async {
    setState(() {
      _isLoading = false;
    });
    if (flightPurchaseListModel.status == true) {
      setState(() {
        _flightData = flightPurchaseListModel.values;

        for (var i = 0; i < _flightData.length; i++) {
          if (_flightData[i].fltBookStatus == 1) {
            _upcomingData!.add(_flightData[i]);
          } else if (_flightData[i].fltBookStatus == 2) {
            _completedData!.add(_flightData[i]);
          } else if (_flightData[i].fltBookStatus == 6) {
            _cancelledData!.add(_flightData[i]);
          } else {}
        }

        _showData = _upcomingData;

        getFLTCardPurchaseDataFromDb().then((value) async {
          if (value.length < 1) {
            /* if nodata in db Insert puchase list data into database */
            return FLTPurchaseListDBHelper().save(FLTPurchaseListDbModel(
                null, json.encode(flightPurchaseListModel.toJson())));
          }
        });
      });
    } else {
      if (flightPurchaseListModel.message == "timeout") {
        _isLoading = true;
        _showData = [];
        var notresponding =
            await Navigator.of(context).pushNamed('/timeoutpage');
        if (notresponding != null) {
          _fltPurchaseListApiCall();
        } else {
          Navigator.pop(context);
        }
      } else {
        _showData = [];
      }
    }
  }
}

dateformate(format) {
  var now = DateTime.now();
  var formatter = DateFormat('dd MMM yyyy');
  var formated = formatter.format(now);

  return formated;
}
