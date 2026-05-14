import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/flight_search.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/flighthomereq_model.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/search_list_model.dart';
import 'package:gems_revamp/flight_module/passenger_class.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:intl/intl.dart';

class SearchListingPage extends StatefulWidget {
  final FlightRequestHolder flightRequestHolder;
  final void Function(int onward)? onchanged;
  final userdata;
  final PassengerModel? passengerModel;
  final FlightSearchListModel? flightSearchModel;
  final guestData;
  final String paymentTyp;
  SearchListingPage(
    this.flightRequestHolder,
    this.userdata,
    this.passengerModel,
    this.flightSearchModel, {
    this.onchanged,
    required this.paymentTyp,
    Key? key,
    required this.guestData,
  }) : super(key: key);
  @override
  _SearchListingPageState createState() => _SearchListingPageState();
}

class _SearchListingPageState extends State<SearchListingPage> {
  FlightRequestHolder? flightRequestHolder;
  String tripType = "1";
  PassengerModel? passengerModel;
  ScrollController? scrollControllerSimple,
      scrollControllerSingleReturnDomestic;
  FlightSearchListModel? _flightSearchListModel;
  int? _selectedFlight;
  int _onwrd = 0;
  @override
  void initState() {
    _flightSearchListModel = widget.flightSearchModel;
    flightRequestHolder = widget.flightRequestHolder;
    passengerModel = widget.passengerModel;
    scrollControllerSimple = ScrollController();

    super.initState();
  }

  _dateFormat(String date) {
    DateTime _date = DateTime.parse(date);
    final DateFormat formatter = DateFormat('EEE dd MMM');
    final String formatted = formatter.format(_date);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> createLine(stops) {
      List<Widget> comps = [];
      comps.add(SizedBox(
        width: 2,
      ));
      for (int i = 0; i < stops; i++) {
        comps.add(Expanded(
            child: Container(
          height: 3,
          color: stops == 1 ? create_line_green : create_line_golden,
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

    Widget _nonStopLine(stops) {
      stops = stops + 1;
      return Container(width: 60, child: Row(children: createLine(stops)));
    }

    Widget _fromTo(String origin, String destination) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
              )),
          SizedBox(
            width: 5,
          ),
          TextWidget(
            text: destination,
            size: text_font_small,
            color: date_text_color,
          )
        ],
      );
    }

    Widget _card(FlightsDatum _flightsData, int index, slectedIndex) {
      var _depBnds = jsonDecode(_flightsData.bnds![0]);
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 0.1,
            clipBehavior: Clip.antiAlias,
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
                                  placeholder:
                                      ImageConstants.flt_no_image_flight,
                                  height: 20,
                                  width: 20,
                                  fit: BoxFit.fill,
                                  image: "${_depBnds["lgs"][0]["arnimg"]}",
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                      ImageConstants.flt_no_image_flight,
                                      height: 20,
                                      width: 20,
                                      fit: BoxFit.fill,
                                    );
                                  },
                                )),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width/2,
                            child: TextWidget(
                              text: "${_depBnds["anm"]}"+" (${_depBnds["lgs"][0]["acd"] ?? ""} - "
                                  "${_depBnds["lgs"][0]["fno"] ?? ""})",
                              size: text_font_medium14_size,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              color: flight_text_black_color,
                              weight: FontWeight.w500,
                            ),
                          ),
                          // TextWidget(
                          //   text: " (${_depBnds["lgs"][0]["acd"] ?? ""} - "
                          //       "${_depBnds["lgs"][0]["fno"] ?? ""})",
                          //   size: text_font_medium15_size,
                          //   color: flight_text_black_color,
                          //   weight: FontWeight.w500,
                          // )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: <Widget>[
                          TextWidget(
                            text: "${_depBnds["ddt"].toString().substring(11)}",
                            size: text_font_medium17_size,
                            weight: FontWeight.w600,
                            color: flight_text_black_color,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          _nonStopLine(_depBnds["stp"]),
                          SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          TextWidget(
                            text: "${_depBnds["adt"].toString().substring(11)}",
                            size: text_font_medium17_size,
                            weight: FontWeight.w600,
                            color: flight_text_black_color,
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          TextWidget(
                            text: "${_depBnds["jtym"]}",
                            size: text_font_size_x_small,
                            color: date_text_color,
                            weight: FontWeight.w400,
                          ),
                          SizedBox(
                            width: 70,
                            child: Container(
                              alignment: Alignment.center,
                              child: TextWidget(
                                text: _depBnds["stp"] == 0
                                    ? ""
                                    : "via ${_depBnds["lgs"][0]["dcty"]}",
                                color: date_text_color,
                                // _depBnds["stp"] == 0
                                //     ? transColor
                                //     : red_color,
                                size: text_font_small_10_size,
                              ),
                            ),
                          ),
                          TextWidget(
                              text: _depBnds["stp"] == 0
                                  ? "Non Stop"
                                  : " ${_depBnds["stp"]} Stops",
                              size: text_font_size_x_small,
                              color: date_text_color
                              // _depBnds["stp"] == 0 ? green_color : red_color,
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
                        text: widget.paymentTyp == "cash"
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
                          : widget.paymentTyp == "cash"
                              ? TextWidget(
                                  text: "Earn upto",
                                  size: text_font_x_small,
                                  weight: FontWeight.w600,
                                  color: flight_blue_text_color,
                                )
                              : SizedBox(
                                  height: 0,
                                ),
                      _flightsData.bnzAccrPnts![0] == 0
                          ? SizedBox(
                              height: 0,
                            )
                          : widget.paymentTyp == "cash"
                              ? TextWidget(
                                  text:
                                      "${gemsPointsFormatter(_flightsData.bnzAccrPnts![0])} GEMS Points",
                                  size: text_font_x_small,
                                  weight: FontWeight.w600,
                                  color: flight_blue_text_color,
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
          padding: EdgeInsets.only(top: 10),
          controller: scrollControllerSimple,
          itemCount: _flightSearchListModel?.values?.flightsData!.length ?? 0,
          itemBuilder: (context, index) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _selectedFlight = index;

                setState(() {
                  SidKey.sid =
                      _flightSearchListModel?.values?.flightsData![index].sid ??
                          "";
                  _onwrd = widget.paymentTyp == "cash"
                      ? _flightSearchListModel!
                              .values?.flightsData![index].totalPrice ??
                          0
                      : _flightSearchListModel
                              ?.values?.flightsData![index].bnzReddemPnts![0] ??
                          0;
                  widget.onchanged!(_onwrd);
                  SidKey.selectedfno = _flightSearchListModel
                      ?.values?.flightsData![index].fno
                      .toString();

                  var flighdecode = jsonDecode(_flightSearchListModel
                          ?.values?.flightsData![0].bnds![0] ??
                      "");

                  SidKey.selectedflcode =
                      flighdecode["lgs"][0]["acd"].toString();

                 
                  SidKey.selectedFLTref =
                      _flightSearchListModel?.values?.flightsData![index].ref;
                  SidKey.fltTYp =
                      _flightSearchListModel?.values?.flightsData![index].flt;
                });
              },
              child: _card(_flightSearchListModel!.values!.flightsData![index],
                  index, _selectedFlight),
            );
          },
          separatorBuilder: (BuildContext context, int index) => Container(
                height: 0,
                color: Colors.grey[350],
              ));
    }

    Widget _body() {
      try {
        var _depData = jsonDecode(
            _flightSearchListModel?.values?.flightsData![0].bnds![0] ?? "");
        return Container(
          decoration: BoxDecoration(gradient: gradient_white_color),
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: <Widget>[
              Container(
                color: black_color,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                alignment: Alignment.center,
                child: TextWidget(
                  text:
                      "Showing ${_flightSearchListModel?.values?.flightsData!.length ?? 0} results. Fare is per traveller",
                  size: 13,
                  color: white_text_color,
                ),
              ),
              Container(
                height: 45,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: white_text_color,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: <Widget>[
                      TextWidget(
                        text: "Departure",
                        color: purchase_text_color,
                        size: text_font_size_x_small,
                        weight: FontWeight.bold,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      _fromTo(
                          _flightSearchListModel?.values?.flightsData![0].src ??
                              "",
                          _flightSearchListModel
                                  ?.values?.flightsData![0].dest ??
                              ""),
                      SizedBox(
                        width: 10,
                      ),
                      TextWidget(
                        text: "${_dateFormat(_depData["ddt"])}",
                        color: flight_text_black_color,
                        size: text_font_size_x_small,
                        weight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 2,
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(gradient: gradient_theme_color),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 334,
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: _originJourneyList()),
              ),
            ],
          ),
        );
      } catch (e) {
        return Container();
      }
    }

    return SingleChildScrollView(child: _body());
  }
}
