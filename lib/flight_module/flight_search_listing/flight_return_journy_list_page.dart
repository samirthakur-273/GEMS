/*
Auther Name: Animesh Banerjee
Discription : This is the Flight return journey search result Listing Page
Date : March 19,2021
*/

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/no_result_found.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/flight_search.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/flighthomereq_model.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/return_srch_modal.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:intl/intl.dart';

class SearchReturnJrnyList extends StatefulWidget {
  final FlightRequestHolder? flightRequestHolder;
  final ReturnSearchListModal? _returnSearchListModal;
  final void Function(int? onward, int? retrn)? onchanged;
  final guestData;
  final String paymentyp;
  SearchReturnJrnyList(
    this.flightRequestHolder,
    this._returnSearchListModal, {
    this.onchanged,
    required this.paymentyp,
    Key? key,
    required this.guestData,
  }) : super(key: key);
  @override
  _SearchReturnJrnyListState createState() => _SearchReturnJrnyListState();
}

class _SearchReturnJrnyListState extends State<SearchReturnJrnyList>
    with SingleTickerProviderStateMixin {
  String tripType = "2";
  FlightRequestHolder? flightRequestHolder;
  bool isLoading = false;
  TabController? _controller;

  ScrollController? scrollControllerSimple,
      scrollControllerSingleReturnDomestic;
  ReturnSearchListModal? _returnSearchListModal;
  int? _slectedIndexonward;
  int? _slectedIndexRet;
  List<FlightsDatum> _inboundData = [];
  List<FlightsDatum> _outboundData = [];
  int? _onwrd = 0;
  int? _retrn = 0;

  // String? _sidKey;
  // String? _sidRetKey;
  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    scrollControllerSimple = ScrollController();

    _returnSearchListModal = widget._returnSearchListModal;

    for (var i = 0;
        i < _returnSearchListModal!.values!.flightsData!.length;
        i++) {
      if (_returnSearchListModal?.values?.flightsData![i].flt == "D") {
        var _bnds = jsonDecode(
            _returnSearchListModal!.values!.flightsData![i].bnds![0]);
        if (_bnds["btnm"] == "InBound") {
          _inboundData.add(_returnSearchListModal!.values!.flightsData![i]);
        } else {
          _outboundData.add(_returnSearchListModal!.values!.flightsData![i]);
        }
      }
    }

    _controller?.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // setState(() {
    //   _sidKey = null;
    //   _sidRetKey = null;
    // });
  }

  _dateFormat(String date) {
    DateTime _date = DateTime.parse(date);
    final DateFormat formatter = DateFormat('EEE dd MMM');
    final String formatted = formatter.format(_date);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    Widget _fromTo(String origin, String destination) {
      return Row(
        children: <Widget>[
          TextWidget(
            text: origin,
            size: text_font_small,
            color: date_text_color,
          ),
          SizedBox(
            width: 5,
          ),
          Container(
              padding: EdgeInsets.only(top: 1),
              // alignment: Alignment.center,
             
              child: SvgPicture.asset(
                ImageConstants.flt_line_arrow_right,
                height: 7,
                width: 7,
                color: Color(0XFF787C84),
              )
              ),
          SizedBox(
            width: 5,
          ),
          TextWidget(
            text: destination,
            color: text_color,
            size: 13,
          )
        ],
      );
    }

    List<Widget> createLine(stops) {
      List<Widget> comps = [];
      comps.add(SizedBox(
        width: 2,
      ));
      for (int i = 0; i < stops; i++) {
        comps.add(Expanded(
            child: Container(
          height: 1,
          color: grey600_color,
        )));
        if (stops > 1 && (stops - 1) != i) {
          comps.add(Container(
            height: 5,
            width: 5,
            decoration: BoxDecoration(
                color: grey600_color,
                border: Border.all(
                  width: 0.1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ));
        }
      }
      comps.add(SizedBox(
        width: 2,
      ));

      return comps;
    }

    List<Widget> createLineDomestic(stops) {
      List<Widget> comps = [];
      comps.add(SizedBox(
        width: 2,
      ));
      for (int i = 0; i < stops; i++) {
        comps.add(Expanded(
            child: Container(
          height: 3,
          color: stops == 1 ? green_color : deepdark_orange_color,
        )));
        if (stops > 1 && (stops - 1) != i) {
          comps.add(Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
                color: white_text_color,
                border: Border.all(
                  width: 0.1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ));
        }
      }
      comps.add(SizedBox(
        width: 2,
      ));

      return comps;
    }

    Widget _nonStopLineDomestic(stops) {
      stops = stops + 1;
      return Container(
          width: 60, child: Row(children: createLineDomestic(stops)));
    }

    Widget _nonStopLineInternational(stops) {
      stops = stops + 1;
      return Container(width: 75, child: Row(children: createLine(stops)));
    }

    Widget _card(
        FlightsDatum _flightsData, String flow, int index, slectedIndex) {
      var _depBnds = jsonDecode(_flightsData.bnds![0]);
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Card(
            elevation: 0.1,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: slectedIndex == index
                      ? off_white_color
                      : white_text_color,
                  border: Border.all(
                    width: 0.8,
                    color: slectedIndex == index
                        ? grey200_color
                        : white_text_color,
                  )),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 35,
                            width: 35,
                            color: bg_color,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: FadeInImage.assetNetwork(
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                        ImageConstants.flt_no_image_flight,
                                        height: 20,
                                        width: 20,
                                        fit: BoxFit.fill,
                                      );
                                    },
                                    placeholder:
                                        ImageConstants.flt_no_image_flight,
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.fill,
                                    image: "${_depBnds["lgs"][0]["arnimg"]}")),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TextWidget(
                            text: "${_depBnds["anm"]}",
                            size: 15,
                            color: text_color,
                          ),
                          TextWidget(
                            text: " (${_depBnds["lgs"][0]["acd"] ?? ""} - "
                                "${_depBnds["lgs"][0]["fno"] ?? ""})",
                            size: 15,
                            color: text_color,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          TextWidget(
                             text: "${_depBnds["ddt"].toString().substring(11)}",
                            size: text_font_medium15_size,
                            weight: FontWeight.w600,
                            color: flight_text_black_color,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          _nonStopLineDomestic(_depBnds["stp"]),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          TextWidget(
                            text: "${_depBnds["adt"].toString().substring(11)}",
                            size: 19,
                            weight: FontWeight.bold,
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          TextWidget(
                            text: "${_depBnds["jtym"]}",
                            size: 14,
                            color: grey600_color,
                          ),
                          SizedBox(
                            width: 70,
                            child: Container(
                              alignment: Alignment.center,
                              child: TextWidget(
                                text: _depBnds["stp"] == 0
                                    ? ""
                                    : "via ${_depBnds["lgs"][0]["dcty"]}",
                                color: _depBnds["stp"] == 0
                                    ? text_color
                                    : red_color,
                                size: 10,
                              ),
                            ),
                          ),
                          TextWidget(
                            text: _depBnds["stp"] == 0
                                ? "Non Stop"
                                : "${_depBnds["stp"]} Stops",
                            size: 14,
                            color:
                                _depBnds["stp"] == 0 ? green_color : red_color,
                          )
                        ],
                      )
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TextWidget(
                        text: widget.paymentyp == "cash"
                            ? "AED ${gemsPointsFormatter(_flightsData.totalPrice ?? 0)}"
                            : "Need ${gemsPointsFormatter(_flightsData.bnzReddemPnts![0])}\nGEMS Points",
                         size: text_font_medium14_size,
                        weight: FontWeight.w500,
                        alignment: TextAlign.center,
                        color: purchase_text_color,
                      ),
                      _flightsData.bnzAccrPnts![0] == 0
                          ? SizedBox(
                              height: 0,
                            )
                          : widget.paymentyp == "cash"
                              ? TextWidget(
                                  text: "Earn Upto",
                                  size: 11,
                                  weight: FontWeight.w600,
                                  color: blue_color,
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                      _flightsData.bnzAccrPnts![0] == 0
                          ? SizedBox(
                              height: 0,
                            )
                          : widget.paymentyp == "cash"
                              ? TextWidget(
                                  text:
                                      "${gemsPointsFormatter(_flightsData.bnzAccrPnts![0])} GEMS Points",
                                  size: 11,
                                  weight: FontWeight.w600,
                                  color: blue_color,
                                )
                              : SizedBox(
                                  height: 0,
                                )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget _originJourneyList() {
      return ListView.separated(
          controller: scrollControllerSimple,
          itemCount: _outboundData.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                setState(() {
                  _onwrd = widget.paymentyp == "cash"
                      ? _outboundData[index].totalPrice
                      : _outboundData[index].bnzReddemPnts![0];
                  widget.onchanged!(_onwrd, _retrn);
                  SidKey.sid = _outboundData[index].sid ?? "";
                  SidKey.isDomestic = "true";
                  // _sidKey = _outboundData[index].sid ?? "";
                  _slectedIndexonward = index;
                  _controller?.index = 1;
                  SidKey.selectedfno = _outboundData[index].fno.toString();
                  SidKey.selectedFLTref = _outboundData[index].ref;

                  SidKey.fltTYp = _outboundData[index].flt;
                });
              },
              child: _card(
                  _outboundData[index], "onward", index, _slectedIndexonward),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Container(
                height: 0,
                color: Colors.grey[350],
              ));
    }

    Widget _returnJourneyList() {
      return ListView.separated(
          controller: scrollControllerSimple,
          itemCount: _inboundData.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                setState(() {
                  _retrn = widget.paymentyp == "cash"
                      ? _inboundData[index].totalPrice
                      : _inboundData[index].bnzReddemPnts![0];
                  widget.onchanged!(_onwrd, _retrn);
                  // _sidRetKey = _inboundData[index].sid ?? "";
                  SidKey.sidReturn = _inboundData[index].sid ?? "";
                  SidKey.isDomestic = "true";
                  _slectedIndexRet = index;
                  SidKey.selectedfno = _inboundData[index].fno.toString();
                  SidKey.selectedFLTref = _inboundData[index].ref;

                  SidKey.fltTYp = _inboundData[index].flt;
                });
              },
              child:
                  _card(_inboundData[index], "return", index, _slectedIndexRet),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Container(
                height: 0,
                color: Colors.grey[350],
              ));
    }

    Widget _body() {
      var _depData =
          _outboundData.length > 0 ? jsonDecode(_outboundData[0].bnds![0]) : "";
      var _retData =
          _inboundData.length > 0 ? jsonDecode(_inboundData[0].bnds![0]) : "";
      try {
        return Container(
          color: bg_color,
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: <Widget>[
              Container(
                color: black_color,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                alignment: Alignment.center,
                child: TextWidget(
                  text:
                      "Showing ${_returnSearchListModal?.values?.flightsData!.length ?? 0} results. Fare is per traveller",
                  size: 13,
                  color: white_text_color,
                ),
              ),
              Container(
                height: 50,
                color: white_text_color,
                child: AppBar(
                  backgroundColor: white_text_color,
                  bottom: TabBar(
                    isScrollable: true,
                    indicator: UnderlineTabIndicator(
                        insets: EdgeInsets.only(left: 10, right: 10),
                        borderSide: BorderSide(color: blue_color, width: 3)),
                    tabs: [
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: <Widget>[
                            TextWidget(
                              text: "Departure",
                              color: _controller!.index == 0
                                  ? text_color
                                  : grey_gunsmoke_text_color,
                              size: 13,
                              weight: FontWeight.bold,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            _controller!.index == 0
                                ? _fromTo(
                                    _returnSearchListModal
                                            ?.values?.flightsData![0].src ??
                                        "",
                                    _returnSearchListModal
                                            ?.values?.flightsData![0].dest ??
                                        "")
                                : Container(
                                    height: 0,
                                  ),
                            SizedBox(
                              width: 10,
                            ),
                            TextWidget(
                              text: _depData != ""
                                  ? "${_dateFormat(_depData["ddt"])}"
                                  : "",
                              color: text_color,
                              size: 13,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: <Widget>[
                            TextWidget(
                              text: "Return",
                              color: _controller!.index == 1
                                  ? text_color
                                  : grey_gunsmoke_text_color,
                              size: 13,
                              weight: FontWeight.bold,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            _controller!.index == 1
                                ? _fromTo(
                                    _returnSearchListModal
                                            ?.values?.flightsData![0].dest ??
                                        "",
                                    _returnSearchListModal
                                            ?.values?.flightsData![0].src ??
                                        "")
                                : Container(
                                    height: 0,
                                  ),
                            SizedBox(
                              width: 10,
                            ),
                            TextWidget(
                              text: _retData != ""
                                  ? "${_dateFormat(_retData["ddt"])}"
                                  : "",
                              color: text_color,
                              size: 13,
                            ),
                          ],
                        ),
                      ),
                    ],
                    controller: _controller,
                    indicatorColor: Colors.white,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                  bottomOpacity: 1,
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 336,
                child: TabBarView(
                  controller: _controller,
                  children: [
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: _outboundData.length > 0
                            ? _originJourneyList()
                            : NoResultFoundNew()
                        //     Container(
                        //   alignment: Alignment.center,
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: <Widget>[
                        //       Image.asset(ImageConstants.notFoundimg),
                        //       SizedBox(height: 30,),
                        //       TextWidget(
                        //         text: "Sorry! No result found:(",
                        //         size: text_font_large20_size,
                        //         weight: FontWeight.w500,
                        //         alignment: TextAlign.center,
                        //       ),
                        //       TextWidget(
                        //         text:
                        //             "We're sorry what you were looking for.\n Please try another way",
                        //         size: text_font_medium16_size,
                        //         alignment: TextAlign.center,
                        //         color: grey600_color,
                        //       ),
                        //       SizedBox(
                        //         height: 50,
                        //       ),
                        //       Container(
                        //         decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(12),
                        //             gradient: const LinearGradient(
                        //               begin: Alignment.topRight,
                        //               end: Alignment.bottomLeft,
                        //               colors: [
                        //                 bluishgradient,
                        //                 blue_color,
                        //               ],
                        //             )),
                        //         width: MediaQuery.of(context).size.width / 2.2,
                        //         height: 50,
                        //         child: TextButton(
                        //           child: TextWidget(
                        //             text: "Try Again",
                        //             color: white_text_color,
                        //             size: 20,
                        //           ),
                        //           onPressed: () async {
                        //             Internetconnectivity()
                        //                 .isConnected()
                        //                 .then((result) {
                        //               if (result) {
                        //                 Navigator.pop(context, "1");
                        //               }
                        //             });
                        //           },
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        ),
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: _inboundData.length > 0
                            ? _returnJourneyList()
                            : NoResultFoundNew()
                        //     Container(
                        //   alignment: Alignment.center,
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     children: <Widget>[
                        //       Image.asset(ImageConstants.notFoundimg),
                        //       SizedBox(height: 30,),
                        //       TextWidget(
                        //         text: "Sorry! No result found:(",
                        //         size: text_font_large20_size,
                        //         weight: FontWeight.w500,
                        //         alignment: TextAlign.center,
                        //       ),
                        //       TextWidget(
                        //         text:
                        //             "We're sorry what you were looking for.\n Please try another way",
                        //         size: text_font_medium16_size,
                        //         alignment: TextAlign.center,
                        //         color: grey600_color,
                        //       ),
                        //       SizedBox(
                        //         height: 50,
                        //       ),
                        //       Container(
                        //         decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(12),
                        //             gradient: const LinearGradient(
                        //               begin: Alignment.topRight,
                        //               end: Alignment.bottomLeft,
                        //               colors: [
                        //                 bluishgradient,
                        //                 blue_color,
                        //               ],
                        //             )),
                        //         width: MediaQuery.of(context).size.width / 2.2,
                        //         height: 50,
                        //         child: TextButton(
                        //           child: TextWidget(
                        //             text: "Try Again",
                        //             color: white_text_color,
                        //             size: 20,
                        //           ),
                        //           onPressed: () async {
                        //             Internetconnectivity()
                        //                 .isConnected()
                        //                 .then((result) {
                        //               if (result) {
                        //                 Navigator.pop(context, "1");
                        //               }
                        //             });
                        //           },
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        );
      } catch (e, s) {
 return Container();
      }
    }

    Widget _cardInterNation(
        FlightsDatum _flightsData, int index, slectedIndex) {
      var _outBoundBnds = jsonDecode(_flightsData.bnds![0]);
      var _inBOundBnds = jsonDecode(_flightsData.bnds![1]);

      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Card(
            elevation: 0.1,
            clipBehavior: Clip.antiAlias,
            child: Container(
                color: slectedIndex == index ? grey200_color : white_text_color,
                padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: TextWidget(
                        text: "${_outBoundBnds["anm"]}",
                        size: 15,
                        color: text_color,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 35,
                                width: 35,
                                color: bg_color,
                                margin: EdgeInsets.only(top: 10),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: FadeInImage.assetNetwork(
                                        placeholder:
                                            "images/flight/no_image_flight.jpg",
                                        height: 20,
                                        width: 20,
                                        fit: BoxFit.fill,
                                        image:
                                            "${_outBoundBnds["lgs"][0]["arnimg"]}")),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: TextWidget(
                                  text: "${_outBoundBnds["lgs"][0]["acd"]}" +
                                      " - " +
                                      "${_outBoundBnds["lgs"][0]["fno"]}",
                                  size: 15,
                                  color: text_color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  TextWidget(
                                    text: "${_outBoundBnds["dtym"]}",
                                    size: 19,
                                    color: text_color,
                                    weight: FontWeight.bold,
                                  ),
                                  TextWidget(
                                    text: "${_outBoundBnds["ogcd"]}",
                                    size: 15,
                                    color: text_color.withOpacity(0.6),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                children: <Widget>[
                                  TextWidget(
                                    text: "${_outBoundBnds["jtym"]}",
                                    size: 15,
                                    color: text_color.withOpacity(0.6),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Image.asset(
                                        ImageConstants.flt_path ,
                                        height: 8,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      _nonStopLineInternational(
                                          _outBoundBnds["stp"]),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      // Image.asset(
                                      //   "images/flt_icons/placeholder (2)@2x.png",
                                      //   height: 10,
                                      // ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextWidget(
                                    text: _outBoundBnds["stp"] == 0
                                        ? "Non Stop"
                                        : "${_outBoundBnds["stp"]} Stop Via ",
                                    size: 14,
                                    color: _outBoundBnds["stp"] == 0
                                        ? green_color
                                        : red_color,
                                  ),
                                  _outBoundBnds["stp"] == 0
                                      ? SizedBox(
                                          height: 0,
                                        )
                                      : TextWidget(
                                          text:
                                              "${_outBoundBnds["lgs"][0]["dcty"]}",
                                          size: 14,
                                          color: _outBoundBnds["stp"] == 0
                                              ? green_color
                                              : red_color,
                                        ),
                                ],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                children: <Widget>[
                                  TextWidget(
                                    text: "${_outBoundBnds["atym"]}",
                                    size: 19,
                                    color: text_color,
                                    weight: FontWeight.bold,
                                  ),
                                  TextWidget(
                                    text: "${_outBoundBnds["dscd"]}",
                                    size: 15,
                                    color: text_color.withOpacity(0.6),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 0.1,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: TextWidget(
                        text: "${_inBOundBnds["anm"]}",
                        size: 15,
                        color: text_color,
                      ),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                height: 35,
                                width: 35,
                                color: bg_color,
                                margin: EdgeInsets.only(top: 10),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: FadeInImage.assetNetwork(
                                        placeholder:
                                            ImageConstants.flt_no_image_flight ,
                                        height: 20,
                                        width: 20,
                                        fit: BoxFit.fill,
                                        image:
                                            "${_inBOundBnds["lgs"][0]["arnimg"]}")),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: TextWidget(
                                  text: "${_inBOundBnds["lgs"][0]["acd"]}" +
                                      " - " +
                                      "${_inBOundBnds["lgs"][0]["fno"]}",
                                  size: 15,
                                  color: text_color,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    TextWidget(
                                      text: "${_inBOundBnds["dtym"]}",
                                      size: 19,
                                      color: text_color,
                                      weight: FontWeight.bold,
                                    ),
                                    TextWidget(
                                      text: "${_inBOundBnds["ogcd"]}",
                                      size: 15,
                                      color: text_color.withOpacity(0.6),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  children: <Widget>[
                                    TextWidget(
                                      text: "${_inBOundBnds["jtym"]}",
                                      size: 15,
                                      color: text_color,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Image.asset(
                                         ImageConstants.flt_path,
                                          height: 8,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        _nonStopLineInternational(
                                            _inBOundBnds["stp"]),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        // Image.asset(
                                        //   "images/flt_icons/placeholder (2)@2x.png",
                                        //   height: 10,
                                        // ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextWidget(
                                      text: _inBOundBnds["stp"] == 0
                                          ? "Non Stop"
                                          : "${_inBOundBnds["stp"]} Stop Via",
                                      size: 14,
                                      color: _inBOundBnds["stp"] == 0
                                          ? green_color
                                          : red_color,
                                    ),
                                    _inBOundBnds["stp"] == 0
                                        ? SizedBox(
                                            height: 0,
                                          )
                                        : TextWidget(
                                            text:
                                                "${_inBOundBnds["lgs"][0]["dcty"]}",
                                            size: 14,
                                            color: _inBOundBnds["stp"] == 0
                                                ? green_color
                                                : red_color,
                                          ),
                                  ],
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  children: <Widget>[
                                    TextWidget(
                                      text: "${_inBOundBnds["atym"]}",
                                      size: 19,
                                      color: text_color,
                                      weight: FontWeight.bold,
                                    ),
                                    TextWidget(
                                      text: "${_inBOundBnds["dscd"]}",
                                      size: 15,
                                      color: text_color.withOpacity(0.6),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      color: Colors.grey[400],
                      height: 0.1,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: <Widget>[
                        _flightsData.bnzAccrPnts![0] == 0
                            ? SizedBox(
                                height: 0,
                              )
                            : widget.paymentyp == "cash"
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: TextWidget(
                                      text: "Earn upto ".toUpperCase(),
                                      size: 15,
                                      weight: FontWeight.w600,
                                      color: flight_blue_text_color,
                                    ),
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                        _flightsData.bnzAccrPnts![0] == 0
                            ? SizedBox(
                                height: 0,
                              )
                            : widget.paymentyp == "cash"
                                ? TextWidget(
                                    text:
                                        "${gemsPointsFormatter(_flightsData.bnzAccrPnts![0])} GEMS Points",
                                    size: 15,
                                    weight: FontWeight.w600,
                                    color: flight_blue_text_color,
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: TextWidget(
                            text: widget.paymentyp == "cash"
                                ? "AED ${gemsPointsFormatter(_flightsData.totalPrice ?? 0)}"
                                : "${gemsPointsFormatter(_flightsData.bnzReddemPnts![0])} GEMS Points",
                            size: 19,
                            weight: FontWeight.bold,
                            color: text_color,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )),
          ),
        ),
      );
    }

    Widget _journyList() {
      return ListView.separated(
          padding: EdgeInsets.only(top: 5),
          controller: scrollControllerSimple,
          itemCount: _returnSearchListModal?.values?.flightsData!.length ?? 0,
          itemBuilder: (context, index) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  if (widget.paymentyp == "cash") {
                    _onwrd = _returnSearchListModal
                            ?.values?.flightsData![index].totalPrice ??
                        0;
                  } else {
                    _onwrd = _returnSearchListModal
                            ?.values?.flightsData![index].bnzReddemPnts![0] ??
                        0;
                  }

                  widget.onchanged!(_onwrd, _retrn);
                  SidKey.sid =
                      _returnSearchListModal?.values?.flightsData![index].sid ??
                          "";
                  SidKey.isDomestic = "false";

                  _slectedIndexonward = index;
                  SidKey.selectedfno = _returnSearchListModal
                      ?.values?.flightsData![index].fno
                      .toString();
                  SidKey.selectedFLTref =
                      _returnSearchListModal?.values?.flightsData![index].ref;

                  SidKey.fltTYp =
                      _returnSearchListModal?.values?.flightsData![index].flt;
                });
              },
              child: _cardInterNation(
                  _returnSearchListModal!.values!.flightsData![index],
                  index,
                  _slectedIndexonward),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Container(
                height: 0,
                color: Colors.grey[350],
              ));
    }

    Widget _internationalBody() {
      return Container(
        color: bg_color,
        child: Column(
          children: <Widget>[
            Container(
              color: black_color,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              alignment: Alignment.center,
              child: TextWidget(
                text:
                    "Showing ${_returnSearchListModal?.values?.flightsData!.length ?? 0} results. Fare is per traveller",
                size: 14,
                color: white_text_color,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 288,
              child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: _journyList()),
            ),
          ],
        ),
      );
    }

    return Container(
      child: isLoading != true
          ? _returnSearchListModal?.values?.flightsData![0].flt
                      ?.toUpperCase() ==
                  "I"
              ? _internationalBody()
              : _body()
          : Center(
              child: SpinKitCircle(),
            ),
    );
  }
}
