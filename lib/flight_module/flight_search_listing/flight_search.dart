// /*
// Auther Name: Animesh Banerjee
// Discription : This is the flight search result listing page
// Date: March 22, 2021
// */

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gems_revamp/common_widget/Gradient_button.dart';
// import 'package:gems_revamp/common_widget/checkinternet.dart';
// import 'package:gems_revamp/common_widget/colors_widget.dart';
// import 'package:gems_revamp/common_widget/font_size.dart';
// import 'package:gems_revamp/common_widget/text_widget.dart';
// import 'package:gems_revamp/flight_module/common_widget/nodatafound.dart';
// import 'package:gems_revamp/flight_module/flight_details/flight_details_page.dart';

/*
Auther Name: Jyoti Gite
Discription : This is the flight search result listing page
Date: May 17, 2022
*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/checkinternet.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/flight_module/common_widget/nodatafound.dart';
import 'package:gems_revamp/flight_module/flight_details/flight_details_page.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/flight_return_journy_list_page.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/flight_search_listing_page.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/flight_sort_filter.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/flighthomereq_model.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/return_srch_modal.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/return_srch_presenter.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/return_srch_view.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/search_list_model.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_search_found.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'filter_module/filter_presenter.dart';
import 'filter_module/filter_view.dart';
import 'search_list_presenter.dart';
import 'search_list_view.dart';

class SearchResult extends StatefulWidget {
  final FlightRequestHolder flightRequestHolder;
  final String tripType;
  final guestData;
  final String paymentTyp;
  final bool showNonStp;
  SearchResult(
    this.flightRequestHolder,
    this.tripType, {
    required this.guestData,
    required this.paymentTyp,
    required this.showNonStp,
    Key? key,
  }) : super(key: key);
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult>
    implements ReturnSearchListView, SearchListView, FilterView {
  FlightRequestHolder? flightRequestHolder;
  ReturnSearchListModal? _returnSearchListModal;
  FlightSearchListModel? _flightSearchListModel;
  FlightSearchListModel? _flightSearchListModelforFilter;
  ReturnSearchListModal? _returnSearchListModalforFilter;
  late String tripType;
  bool isLoading = true;
  int _totalCost = 0;
  dynamic _value;
  bool _isrefresh = false;
  @override
  void initState() {
    SidKey.sid = null;
    SidKey.sidReturn = null;
    SidKey.isDomestic = null;
    SidKey.selectedfno = null;
    SidKey.selectedFLTref = null;
    SidKey.fltTYp = null;
    flightRequestHolder = widget.flightRequestHolder;
    tripType = this.widget.tripType;
    tripType == "2" ? _apicall() : _apicallSingleJrny();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _apicall() {
    CheckInternet().apiCall().then((value) {
      setState(() {
        isLoading = true;
      });
      if (value) {
        var req = {
          "origin": flightRequestHolder?.airportOriginCode,
          "destination": flightRequestHolder?.airportDestinationCode,
          "triptype": 2,
          "cabinclass": widget.guestData != null
              ? widget.guestData.cabinClassName == "Economy"
                  ? 1
                  : widget.guestData.cabinClassName == "Premium Economy"
                      ? 4
                      : widget.guestData.cabinClassName == "Business"
                          ? 2
                          : widget.guestData.cabinClassName == "First Class"
                              ? 3
                              : 1
              : 1,
          "noofadults":
              widget.guestData != null ? widget.guestData.adultNumber : 1,
          "noofchilds":
              widget.guestData != null ? widget.guestData.childNumber : 0,
          "noofinfants":
              widget.guestData != null ? widget.guestData.infentNumber : 0,
          "onwarddate": flightRequestHolder?.departureDate,
          "returndate": flightRequestHolder?.returnDate,
          "airlines": {"outbnd": [], "inbnd": []},
          "startindex": "0",
          "resultcount": "1000",
          "mop": widget.paymentTyp,
          "isnonstp": this.widget.showNonStp
        };

        ReturnSearchListPresenter().getList(this, req);
      } else {
        _apicall();
      }
    });
  }

  refresh() {
    setState(() {
      _isrefresh = true;
      if (widget.paymentTyp != "cash") {
        GemsGLobals.flightRevisedTotal = GemsGLobals.flightRevisedTotal * 10;
      }

      _apicall();
    });
  }

  void _apicallSingleJrny() {
    CheckInternet().apiCall().then((value) {
      setState(() {
        isLoading = true;
      });
      if (value) {
        var req = {
          "origin": flightRequestHolder?.airportOriginCode,
          "destination": flightRequestHolder?.airportDestinationCode,
          "triptype": int.parse(tripType),
          "cabinclass": widget.guestData != null
              ? widget.guestData.cabinClassName == "Economy"
                  ? 1
                  : widget.guestData.cabinClassName == "Premium Economy"
                      ? 4
                      : widget.guestData.cabinClassName == "Business"
                          ? 2
                          : widget.guestData.cabinClassName == "First Class"
                              ? 3
                              : 1
              : 1,
          "noofadults":
              widget.guestData != null ? widget.guestData.adultNumber : 1,
          "noofchilds":
              widget.guestData != null ? widget.guestData.childNumber : 0,
          "noofinfants":
              widget.guestData != null ? widget.guestData.infentNumber : 0,
          "onwarddate": flightRequestHolder?.departureDate,
          "returndate": flightRequestHolder?.returnDate,
          "airlines": {"outbnd": [], "inbnd": []},
          "startindex": "0",
          "resultcount": "1000",
          "mop": widget.paymentTyp,
          "isnonstp": this.widget.showNonStp
        };
        SearchListPresenter().getList(this, req);
      } else {
        _apicall();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String stringToDateAndDateToStringFormatter() {
      DateFormat journeyDateFormate = DateFormat("dd MMM");
      if (tripType == "1") {
        DateTime simpleSingleJourneyDate =
            DateTime.parse(flightRequestHolder!.departureDate);
        flightRequestHolder?.formattedDepartureDate =
            journeyDateFormate.format(simpleSingleJourneyDate);

        return "${flightRequestHolder?.formattedDepartureDate}";
      } else if (tripType == "2") {
        DateTime singleJourneyDate =
            DateTime.parse(flightRequestHolder!.departureDate);

        DateTime returnJourneyDate =
            DateTime.parse(flightRequestHolder!.returnDate);

        flightRequestHolder?.formattedDepartureDate =
            journeyDateFormate.format(singleJourneyDate);
        flightRequestHolder?.formattedReturnDate =
            journeyDateFormate.format(returnJourneyDate);

        return "${flightRequestHolder?.formattedDepartureDate} - ${flightRequestHolder?.formattedReturnDate}";
      }
      return "";
    }

    Widget _filterSort() {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Filter(
                        flightsMenuSingle: _flightSearchListModelforFilter
                            ?.values?.flightsMenu,
                        flightsMenuRetrn: _returnSearchListModalforFilter
                            ?.values?.flightsMenu,
                        tripTyp: widget.tripType,
                        callBackData: _value,
                        nonStpFLT: widget.showNonStp,
                      ))).then((value) {
            if (value != null) {
              _value = value;
              isLoading = true;
              setState(() {});
              if (tripType == "1") {
                FilterPresenter().getList(this, value);
              } else {
                FilterReturnPresenter().getList(this, value);
              }
            }
          });
        },
        child: Container(
          height: 52,
          decoration: BoxDecoration(
              color: Color(0xFFf4f4f4),
              borderRadius: BorderRadius.circular(30),
              border:
                  Border.all(width: 0.8, color: black_color.withOpacity(0.2))
              // boxShadow: [
              //   BoxShadow(
              //       color: black_color.withOpacity(0.1),
              //       offset: new Offset(0, 10.0),
              //       blurRadius: 10.0,
              //       spreadRadius: 2.0),
              // ]
              ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                ImageConstants.flt_filter,
                height: 24,
              ),
              SizedBox(
                width: 10,
              ),
              TextWidget(
                text: "Sort & Filter",
                size: 18,
                color: text_color,
              )
            ],
          ),
        ),
      );
    }

//439 = 336, 6261= 344- 680
    String _totalCostText() {
      return widget.paymentTyp == "cash"
          ? _isrefresh == true
              ? "AED ${gemsPointsFormatter(GemsGLobals.flightRevisedTotal)}"
              : "AED ${gemsPointsFormatter(_totalCost)}"
          : _isrefresh == true
              ? "${gemsPointsFormatter(GemsGLobals.flightRevisedTotal)} GEMS Points"
              : "${gemsPointsFormatter(_totalCost)} GEMS Points";
    }

    Widget _bottomData() {
      return Container(
        height: isLoading ? 0 : 150,
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(11), topRight: Radius.circular(11))),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                //  DialogAlert.fltRestrictionDialog(context);
              },
              child: Container(
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: off_white_color,
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: <Widget>[
                    TextWidget(
                      text: "This route is open, with some restrictions",
                      color: flight_text_black_color,
                      size: text_font_size_x_small,
                      weight: FontWeight.w400,
                    ),
                    Spacer(),
                    Image.asset(
                      ImageConstants.flt_exclamation,
                      height: 15,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextWidget(
                    text: "Total ",
                    size: text_font_medium18_size,
                    color: flight_text_black_color,
                    weight: FontWeight.w400,
                  ),
                  TextWidget(
                    text: _totalCostText(),
                    size: text_font_medium19_size,
                    color: flight_text_black_color,
                    weight: FontWeight.bold,
                  )
                ],
              ),
            ),
            MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
              child: Container(
                height: 60,
                color: white_text_color,
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        if (widget.tripType == "1") {
                          if (SidKey.sid != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailsPage(
                                          widget.flightRequestHolder,
                                          tripType,
                                          sidKey: SidKey.sid,
                                          sidReturnKey: null,
                                          guestData: widget.guestData,
                                          paymentTyp: widget.paymentTyp,
                                          oldtotalAmt: _totalCost,
                                          refresh: refresh,
                                        )));
                          }
                        } else {
                          if (SidKey.sid != null &&
                              SidKey.isDomestic == "false") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailsPage(
                                        widget.flightRequestHolder, tripType,
                                        sidKey: SidKey.sid,
                                        sidReturnKey: null,
                                        guestData: widget.guestData,
                                        tripSubTyp: "I",
                                        paymentTyp: widget.paymentTyp,
                                        oldtotalAmt: _totalCost,
                                        refresh: refresh)));
                          } else if (SidKey.sid != null &&
                              SidKey.sidReturn != null &&
                              SidKey.isDomestic == "true") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailsPage(
                                        widget.flightRequestHolder, tripType,
                                        sidKey: SidKey.sid,
                                        sidReturnKey: SidKey.sidReturn,
                                        guestData: widget.guestData,
                                        tripSubTyp: "D",
                                        paymentTyp: widget.paymentTyp,
                                        oldtotalAmt: _totalCost,
                                        refresh: refresh)));
                          }
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10),
                        width: 160,
                        height: 60,
                        decoration: BoxDecoration(
                            gradient:
                                widget.tripType == "1" && SidKey.sid != null
                                    ? gradient_theme_color
                                    : widget.tripType == "2" &&
                                            SidKey.isDomestic == "false" &&
                                            SidKey.sid != null
                                        ? gradient_theme_color
                                        : widget.tripType == "2" &&
                                                SidKey.isDomestic == "true" &&
                                                SidKey.sid != null &&
                                                SidKey.sidReturn != null
                                            ? gradient_theme_color
                                            : gradient_grey_theme_color,
                            borderRadius: BorderRadius.circular(24)),
                        child: Center(
                            child: TextWidget(
                          text: "Book Now",
                          size: text_font_medium17_size,
                          color: white_text_color,
                          weight: FontWeight.w600,
                        )),
                      ),
                    ),

                    _filterSort()
                    // Expanded(child: _filterSort())
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Widget _sortFilter() {
    //   return Container(
    //     height: isLoading ? 0 : 50,
    //     color: transColor,
    //     child: InkWell(
    //       onTap: () {
    //         Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //                 builder: (context) => Filter(
    //                       flightsMenuSingle: _flightSearchListModelforFilter
    //                           ?.data?.values?.flightsMenu,
    //                       flightsMenuRetrn: _returnSearchListModalforFilter
    //                           ?.data?.values?.flightsMenu,
    //                       tripTyp: widget.tripType,
    //                       callBackData: _value,
    //                       nonStpFLT: widget.showNonStp,
    //                     ))).then((value) {
    //           if (value != null) {
    //             _value = value;
    //             isLoading = true;
    //             setState(() {});
    //             if (tripType == "1") {
    //               FilterPresenter().getList(this, value);
    //             } else {
    //               FilterReturnPresenter().getList(this, value);
    //             }
    //           }
    //         });
    //       },
    //       child: Container(
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(5),
    //           color: grey200_color,
    //         ),
    //         child: Row(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           children: <Widget>[
    //             Container(
    //                 child: Center(
    //                     child: Row(
    //               children: <Widget>[
    //                 SvgPicture.asset(
    //                   "images/hotels/sort_icon.svg",
    //                   height: 22,
    //                 ),
    //                 TextWidget(
    //                   text: 'Sort',
    //                   size: 20,
    //                   weight: FontWeight.w500,
    //                 ),
    //               ],
    //             ))),
    //             Container(
    //                 child: Center(
    //                     child: Row(
    //               children: <Widget>[
    //                 SvgPicture.asset(
    //                   "images/hotels/filter_icon.svg",
    //                   height: 22,
    //                 ),
    //                 TextWidget(
    //                   text: 'Filter',
    //                   size: 20,
    //                   weight: FontWeight.w500,
    //                 ),
    //               ],
    //             ))),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // }

    String _titleText() {
      return "${widget.guestData != null ? this.widget.guestData.adultNumber : 1}"
          "${this.widget.guestData.adultNumber > 1 ? " Adults" : " Adult"} "
          "${widget.guestData != null ? widget.guestData.childNumber > 0 ? widget.guestData.childNumber : "" : ""}"
          "${widget.guestData != null ? widget.guestData.childNumber > 1 ? " Children " : widget.guestData.childNumber == 1 ? " Child " : "" : ""}"
          "${widget.guestData != null ? widget.guestData.infentNumber > 0 ? widget.guestData.infentNumber : "" : ""}"
          "${widget.guestData != null ? widget.guestData.infentNumber > 1 ? " Infants " : widget.guestData.infentNumber == 1 ? " Infant " : "" : ""}"
          "|"
          " ${widget.guestData != null ? widget.guestData.cabinClassName : "Economy"}";
    }

    PreferredSizeWidget _appbar() {
      return PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            decoration: BoxDecoration(gradient: gradient_theme_color),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            height: Platform.isIOS ? 100 : 110,
            alignment: Alignment.centerLeft,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.maybePop(context);
                    },
                    child: Container(
                      height: 50,
                      width: 40,
                      margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                      decoration: BoxDecoration(
                          color: blue_color,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 7),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 25,
                          color: white_text_color,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    // color: black_color,
                    // padding: EdgeInsets.only(right: 10),
                    width: MediaQuery.of(context).size.width - 80,
                    // margin: EdgeInsets.only(: 4),
                    // alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextWidget(
                                text: flightRequestHolder?.originCity ?? '',
                                weight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,
                                size: 17,
                                color: white_text_color,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              new Container(
                                child: LimitedBox(
                                  child: widget.tripType == "1"
                                      ? Container(
                                          padding: EdgeInsets.only(top: 3),
                                          child: SvgPicture.asset(
                                            ImageConstants.flt_line_arrow_right,
                                            height: 8,
                                            color: white_text_color,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        )
                                      : Image.asset(
                                          ImageConstants.flt_arrowswitch,
                                          height: 10,
                                          color: white_text_color,
                                          fit: BoxFit.fitWidth,
                                        ),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              TextWidget(
                                text:
                                    flightRequestHolder?.destinationCity ?? '',
                                weight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,
                                size: 17,
                                color: white_text_color,
                              )
                            ]),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          alignment: Alignment.center,
                          child: FittedBox(
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: TextWidget(
                                    text:
                                        "${stringToDateAndDateToStringFormatter()}",
                                    color: white_text_color,
                                    size: 13,
                                  ),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                TextWidget(
                                  text: "|",
                                  size: 13,
                                  color: white_text_color,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                TextWidget(
                                  text: _titleText(),
                                  /**This function return text shows searched parameters */
                                  color: white_text_color,
                                  size: 13,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
          ));
    }

    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            appBar: _appbar(),
            body: isLoading == false
                ? (tripType == "2")
                    ? SearchReturnJrnyList(
                        /**THis class shows the return journy list of flights */
                        widget.flightRequestHolder,
                        _returnSearchListModal,
                        onchanged: (onward, retrn) {
                          _isrefresh = false;
                          _totalCost = onward! + retrn!;
                          setState(() {});
                        },
                        guestData: widget.guestData,
                        paymentyp: widget.paymentTyp,
                      )
                    : SearchListingPage(
                        /**THis class shows the single journy list of flights */
                        widget.flightRequestHolder,
                        "",
                        null,
                        _flightSearchListModel,
                        guestData: widget.guestData,
                        onchanged: (onward) {
                          _isrefresh = false;
                          _totalCost = onward;
                          setState(() {});
                        },
                        paymentTyp: widget.paymentTyp,
                      )
                : Center(
                    child: SpinKitCircle(
                      color: blue_color,
                    ),
                  ),
            bottomNavigationBar: isLoading
                ? SizedBox(
                    height: 0,
                  )
                : _bottomData(),
          )),
    );
  }

  @override
  Future<void> allErr(error) async {
    if (error.toString().toUpperCase().contains("TIMEOUT")) {
      var notresponding = await Navigator.of(context).pushNamed('/timeoutpage');
      if (notresponding != null) {
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
    } else {
      await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NoResultFound(error.toString())))
          .then((value) {
        Navigator.pop(context);
      });
    }
  }

  @override
  void response(ReturnSearchListModal returnSearchListModal) {
    if (returnSearchListModal.status == false) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoSearchResult()
              // NoResultFound(returnSearchListModal.message ?? "")
              )).then((value) {
        Navigator.pop(context);
      });
    }

    setState(() {
      _returnSearchListModal = returnSearchListModal;
      _returnSearchListModalforFilter = returnSearchListModal;
      isLoading = false;
    });
  }

  @override
  void responseSingleJrny(FlightSearchListModel flightSearchListModel) {
    if (flightSearchListModel.status == false) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoSearchResult()
              // NoResultFound(flightSearchListModel.message ?? "")
              )).then((value) {
        Navigator.pop(context);
      });
    }
    setState(() {
      _flightSearchListModel = flightSearchListModel;
      _flightSearchListModelforFilter = flightSearchListModel;
      isLoading = false;
    });
  }

  @override
  Future<void> singleJrnyErr(error) async {
    if (error.toString().toUpperCase().contains("TIMEOUT")) {
      var notresponding = await Navigator.of(context).pushNamed('/timeoutpage');
      if (notresponding != null) {
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
    } else {
      await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NoResultFound(error.toString())))
          .then((value) {
        Navigator.pop(context);
      });
    }
  }

  @override
  void filterResponse(FlightSearchListModel flightSearchListModel) {
    setState(() {
      _flightSearchListModel = flightSearchListModel;
      isLoading = false;
    });
    if (flightSearchListModel.status == false) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoSearchResult()
              // NoResultFound(flightSearchListModel.message ?? "")
              )).then((value) {
        Navigator.pop(context);
      });
    }
  }

  @override
  void filterRetrnResponse(ReturnSearchListModal returnSearchListModal) {
    if (returnSearchListModal.status == false) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoSearchResult()
              // NoResultFound(returnSearchListModal.message ?? "")
              )).then((value) {
        Navigator.pop(context);
      });
    }
    setState(() {
      _returnSearchListModal = returnSearchListModal;
      isLoading = false;
    });
  }
}

class SidKey {
  static String? sid;
  static String? sidReturn;
  static int? totalONward;
  static int? totalRetrn;
  static String? isDomestic;
  static String? selectedfno;
  static String? selectedflcode;
  static String? selectedFLTref;
  static String? fltTYp;
}
