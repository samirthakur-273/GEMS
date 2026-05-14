/*
Auther Name: Animesh Banerjee
Discription : This is the copy of flight details page just an overview
*/

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/flight_module/flight_details/details_modal.dart';
import 'package:gems_revamp/flight_module/flight_details/return_jr_details_modal.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/flighthomereq_model.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:intl/intl.dart';

import 'details_view.dart';
import 'package:http/http.dart' as http;

class DetailsCopyPage extends StatefulWidget {
  final DetailsFlightModel? flightDetailsModel;
  final ReturnJrnyDetailsFlightModel? returnJrnyDetailsFlightModel;
  final String tripTyp;
  final guestData;
  final FlightRequestHolder? flightRequestHolder;
  final String? tripSubTyp;
  final String paymentTyp;
  final totatPrice;
  final baseprice;
  final taxprice;
  DetailsCopyPage(
    this.flightRequestHolder,
    this.tripTyp, {
    required this.guestData,
    required this.paymentTyp,
    this.tripSubTyp,
    required this.flightDetailsModel,
    required this.returnJrnyDetailsFlightModel,
    this.baseprice,
    this.taxprice,
    this.totatPrice,
    Key? key,
  }) : super(key: key);
  @override
  _DetailsCopyPageState createState() => _DetailsCopyPageState();
}

class _DetailsCopyPageState extends State<DetailsCopyPage>
    implements DetailsFlightView {
  bool isLoading = false;
  DetailsFlightModel? _flightDetailsModel;
  ReturnJrnyDetailsFlightModel? _returnJrnyDetailsFlightModel;
  bool _noData = false;
  @override
  void initState() {
    _flightDetailsModel = widget.flightDetailsModel;
    _returnJrnyDetailsFlightModel = widget.returnJrnyDetailsFlightModel;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _dateFormat(String date) {
    DateTime _date = DateTime.parse(date);
    final DateFormat formatter = DateFormat('EEE, dd MMM yyyy');
    final String formatted = formatter.format(_date);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    String stringToDateAndDateToStringFormatter() {
      DateFormat journeyDateFormate = DateFormat("dd EEE");
      if (widget.tripTyp == "1") {
        DateTime simpleSingleJourneyDate =
            DateTime.parse(widget.flightRequestHolder!.departureDate);
        widget.flightRequestHolder?.formattedDepartureDate =
            journeyDateFormate.format(simpleSingleJourneyDate);

        return "${widget.flightRequestHolder!.formattedDepartureDate}";
      } else if (widget.tripTyp == "2") {
        DateTime singleJourneyDate =
            DateTime.parse(widget.flightRequestHolder!.departureDate);

        DateTime returnJourneyDate =
            DateTime.parse(widget.flightRequestHolder!.returnDate);

        widget.flightRequestHolder?.formattedDepartureDate =
            journeyDateFormate.format(singleJourneyDate);
        widget.flightRequestHolder?.formattedReturnDate =
            journeyDateFormate.format(returnJourneyDate);

        return "${widget.flightRequestHolder?.formattedDepartureDate} - ${widget.flightRequestHolder?.formattedReturnDate}";
      }
      return "";
    }

    Widget _fromTo(_data) {
      return Row(
        children: <Widget>[
          TextWidget(
            text: "${_data["octy"].toString().toUpperCase()}",
            size: text_font_size_x_small,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: SvgPicture.asset(
              "images/flt_icons/1. Icons _ Line _  arrow-right.svg",
              height: 8,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          TextWidget(
            text: "${_data["dcty"].toString().toUpperCase()}",
            size: text_font_size_x_small,
          )
        ],
      );
    }

    Widget _orignDet(_details) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextWidget(
                    text: "${_details["ogcd"]} "
                        "${_details["dtym"]}",
                    size: text_font_medium17_size,
                    color: text_color,
                    weight: FontWeight.w500,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextWidget(
                    text: "${_dateFormat(_details["ddt"])}",
                    size: text_font_medium14_size,
                    color: text_color,
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: gradient_theme_color,
              ),
              child: TextWidget(
                text: "${_details["dur"]}",
                size: text_font_size_x_small,
                color: white_text_color,
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  TextWidget(
                    text: "${_details["dscd"]} " "${_details["atym"]}",
                    size: text_font_medium17_size,
                    color: text_color,
                    weight: FontWeight.w500,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextWidget(
                    text: "${_dateFormat(_details["adt"])}",
                    size: text_font_medium14_size,
                    color: text_color,
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

    Widget _terminaldet(_details) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: TextWidget(
                      text: "${_details["org"]},",
                      size: text_font_medium14_size,
                      color: text_color,
                    ),
                  ),
                  TextWidget(
                    text: "${_details["octy"]}",
                    size: text_font_medium14_size,
                    color: text_color,
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    child: TextWidget(
                      alignment: TextAlign.right,
                      text: "${_details["dest"]},",
                      size: text_font_medium14_size,
                      color: text_color,
                    ),
                  ),
                  TextWidget(
                    text: "${_details["dcty"]}",
                    size: text_font_medium14_size,
                    color: text_color,
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

    Widget _baggageInfo(_details) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextWidget(
              text: "Baggage info",
              size: text_font_medium16_size,
              color: text_color,
              weight: FontWeight.w500,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                TextWidget(
                  text: "${_details["ogcd"]}",
                  size: text_font_medium14_size,
                  color: flight_text_black_color.withOpacity(0.7),
                ),
                SizedBox(
                  width: 8,
                ),
                SvgPicture.asset(
                  "images/flight/1. Icons _ Line _  arrow-right.svg",
                  height: 8,
                  // color: grey600_color.withOpacity(0.6),
                ),
                SizedBox(
                  width: 8,
                ),
                TextWidget(
                  text: "${_details["dscd"]}",
                  size: text_font_medium14_size,
                  color: flight_text_black_color.withOpacity(0.7),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                SvgPicture.asset(
                  ImageConstants.flt_suitcase,
                  height: 15,
                  color: blue_color,
                ),
                SizedBox(
                  width: 6,
                ),
                TextWidget(
                  text: "Check in ",
                  size: text_font_medium14_size,
                  weight: FontWeight.w500,
                  color: flight_text_black_color.withOpacity(0.7),
                ),
                Spacer(),
                TextWidget(
                  text: _details["bgwgt"] == "0"
                      ? "Not Allowed"
                      : "${_details["bgwgt"]} "
                          "${_details["bgut"]}",
                  size: text_font_medium14_size,
                  weight: FontWeight.w500,
                  color: flight_text_black_color.withOpacity(0.7),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                SvgPicture.asset(
                  ImageConstants.flt_luggage,
                  color: blue_color,
                  height: 15,
                ),
                SizedBox(
                  width: 6,
                ),
                TextWidget(
                  text: "Cabin",
                  weight: FontWeight.w500,
                  color: flight_text_black_color.withOpacity(0.7),
                ),
                Spacer(),
                TextWidget(
                  text: "7 kg",
                  size: text_font_medium14_size,
                  weight: FontWeight.w500,
                  color: flight_text_black_color.withOpacity(0.7),
                )
              ],
            ),
          ],
        ),
      );
    }

    Widget _nonrefund(String? ref, _pax) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextWidget(
              text: ref == false
                  ? "Non refundable".toUpperCase()
                  : "Refundable".toUpperCase(),
              size: text_font_medium16_size,
              color: flight_text_black_color.withOpacity(0.6),
            ),
            _pax["ccp"] == 0
                ? SizedBox(
                    height: 0,
                  )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: <Widget>[
                        TextWidget(
                          text: "Cancellation Price",
                          size: text_font_medium16_size,
                          color: grey600_color,
                          weight: FontWeight.w600,
                        ),
                        Spacer(),
                        TextWidget(
                          text: "AED ${_pax["ccp"]}",
                          size: text_font_medium16_size,
                          color: grey600_color,
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      );
    }

    Widget _flightDetailsTowards(int index, _lgs, pax) {
      return Container(
        child: Column(
          children: <Widget>[
            _fromTo(_lgs),
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                Container(
                  height: 30,
                  width: 30,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: FadeInImage.assetNetwork(
                          placeholder: ImageConstants.flt_no_image_flight,
                          height: 20,
                          width: 20,
                          image: _lgs["arnimg"])),
                ),
                SizedBox(
                  width: 10,
                ),
                TextWidget(
                  text: "${_lgs["acd"]}" + " - " + "${_lgs["fno"]}",
                  size: text_font_medium16_size,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _orignDet(_lgs),
            _terminaldet(_lgs),
            SizedBox(
              height: 20,
              child: Divider(),
            ),
            _baggageInfo(_lgs),
            SizedBox(
              height: 20,
              child: Divider(),
            ),
            _nonrefund(
                widget.tripTyp == "1" || widget.tripSubTyp == "I"
                    ? _flightDetailsModel?.values?.flightDetail![0].ref
                    : _returnJrnyDetailsFlightModel?.values?.flightDetail!.ref,
                pax),
            SizedBox(
              height: 20,
              child: Divider(),
            ),
          ],
        ),
      );
    }

    // Widget _payback() {
    //   return Container(
    //     alignment: Alignment.centerLeft,
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         TextWidget(
    //           text: "Payback",
    //           weight: FontWeight.bold,
    //           color: text_color,
    //           size: text_font_medium16_size,
    //         ),
    //         SizedBox(
    //           height: 15,
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             TextWidget(
    //               text: "Payback Mobile/Card no",
    //               size: text_font_medium14_size,
    //               color: text_color.withOpacity(0.6),
    //             ),
    //           ],
    //         ),
    //         SizedBox(
    //           height: 10,
    //         ),
    //         SizedBox(
    //           height: 20,
    //           child: Divider(),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    String _cancelText(cancelData) {
      return "Before " +
          "${cancelData["Cancel_Data"][0]["endhr"] > 24 ? (cancelData["Cancel_Data"][0]["endhr"] / 24).toInt() : cancelData["Cancel_Data"][0]["endhr"]}" +
          "${cancelData["Cancel_Data"][0]["endhr"] > 24 ? " days" : " hours"}" +
          " till " +
          "${cancelData["Cancel_Data"][0]["starthr"] > 24 ? (cancelData["Cancel_Data"][0]["starthr"] / 24).toInt() : cancelData["Cancel_Data"][0]["starthr"]}" +
          "${cancelData["Cancel_Data"][0]["starthr"] > 24 ? " days" : " hours"}" +
          " before departure";
    }

    Widget _cancelPolicy(bnd) {
      var cancelData = jsonDecode(bnd["farerule"]);

      return cancelData["Cancel_Data"].length > 0
          ? Container(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextWidget(
                    text: "Cancellation policy".toUpperCase(),
                    size: text_font_medium16_size,
                    color: text_color,
                    weight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextWidget(
                    text: _cancelText(cancelData),
                    size: text_font_medium14_size,
                    color: text_color,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 20,
                    child: Divider(),
                  ),
                ],
              ),
            )
          : SizedBox(
              height: 0,
            );
    }

    Widget _flightDetailsReturn(int index, _lgs, pax) {
      return Container(
        child: Column(
          children: <Widget>[
            _fromTo(_lgs),
            SizedBox(
              height: 15,
            ),
            Row(
              children: <Widget>[
                Container(
                  height: 30,
                  width: 30,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: FadeInImage.assetNetwork(
                          placeholder: ImageConstants.flt_no_image_flight,
                          height: 20,
                          width: 20,
                          image: _lgs["arnimg"])),
                ),
                SizedBox(
                  width: 10,
                ),
                TextWidget(
                  text: "${_lgs["acd"]}" + " - " + "${_lgs["fno"]}",
                  size: text_font_medium16_size,
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            _orignDet(_lgs),
            _terminaldet(_lgs),
            SizedBox(
              height: 20,
              child: Divider(),
            ),
            _baggageInfo(_lgs),
            SizedBox(
              height: 20,
              child: Divider(),
            ),
            _nonrefund(
                widget.tripSubTyp == "I"
                    ? _flightDetailsModel?.values?.flightDetail![0].ref
                    : _returnJrnyDetailsFlightModel
                        ?.values?.flightDetailReturn![0].ref,
                pax),
            SizedBox(
              height: 20,
              child: Divider(),
            ),
          ],
        ),
      );
    }

    Widget _fareBrkup(int? conFeeOnwrd, int? conFeeRtn, int? onbfr, int? retbfr,
        int? ontax, int? rettax, int? onttl, int? retttl) {
      var _totalConFee = conFeeOnwrd! + conFeeRtn!;
      var _totalBP = onbfr! + retbfr!;
      var _totalTax = ontax! + rettax!;
      var _totalTP = onttl! + retttl!;

      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextWidget(
              text: "Fare Breakup",
              size: text_font_medium16_size,
              color: black_color,
              weight: FontWeight.w600,
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextWidget(
                  text: "Convenience Fee",
                  color: flight_text_black_color.withOpacity(0.7),
                  size: text_font_medium16_size,
                ),
                TextWidget(
                  text: "AED ${gemsPointsFormatter(_totalConFee)}",
                  weight: FontWeight.bold,
                  color: black_color,
                  size: text_font_medium16_size,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextWidget(
                  text: "Base Price",
                  color: flight_text_black_color.withOpacity(0.7),
                  size: text_font_medium16_size,
                ),
                TextWidget(
                  text: "AED ${gemsPointsFormatter(_totalBP)}",
                  weight: FontWeight.bold,
                  color: black_color,
                  size: text_font_medium16_size,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextWidget(
                  text: "Taxes",
                  color: flight_text_black_color.withOpacity(0.7),
                  size: text_font_medium16_size,
                ),
                TextWidget(
                  text: "AED ${gemsPointsFormatter(_totalTax)}",
                  weight: FontWeight.bold,
                  color: black_color,
                  size: text_font_medium16_size,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextWidget(
                  text: "Total",
                  color: flight_text_black_color.withOpacity(0.7),
                  size: text_font_medium16_size,
                ),
                TextWidget(
                  text: widget.paymentTyp == "cash"
                      ? "AED ${gemsPointsFormatter(_totalTP)}"
                      : widget.tripTyp == "1" || widget.tripSubTyp != "D"
                          ? "${gemsPointsFormatter(_flightDetailsModel?.values?.flightDetail![0].bnzReddemPnts![0])} GEMS Points"
                          : "${gemsPointsFormatter(_returnJrnyDetailsFlightModel!.values!.flightDetail!.bnzReddemPnts![0] + _returnJrnyDetailsFlightModel!.values!.flightDetailReturn![0].bnzReddemPnts![0])} GEMS Points",
                  weight: FontWeight.bold,
                  color: black_color,
                  size: text_font_medium16_size,
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            widget.paymentTyp == "cash"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextWidget(
                        text: "Earn",
                        color: flight_text_black_color.withOpacity(0.7),
                        size: text_font_medium16_size,
                      ),
                      TextWidget(
                        text: widget.tripTyp == "1" || widget.tripSubTyp != "D"
                            ? "${gemsPointsFormatter(_flightDetailsModel?.values?.flightDetail![0].bnzAccrPnts![0])} GEMS Points"
                            : "${gemsPointsFormatter(_returnJrnyDetailsFlightModel!.values!.flightDetail!.bnzAccrPnts![0] + _returnJrnyDetailsFlightModel!.values!.flightDetailReturn![0].bnzAccrPnts![0])} GEMS Points",
                        weight: FontWeight.bold,
                        color: blue_color,
                        size: text_font_medium16_size,
                      ),
                    ],
                  )
                : SizedBox(
                    height: 0,
                  ),
            SizedBox(
              height: 12,
            ),
          ],
        ),
      );
    }

    Widget _body(String? bnd, String? retBnd) {
      var bndsData = jsonDecode(bnd!);
      var retbndData = retBnd != "" ? jsonDecode(retBnd!) : "";
      try {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TextWidget(
                  text: "Onward Journey Details :",
                  size: text_font_medium17_size,
                  weight: FontWeight.bold,
                ),
              ),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: bndsData["lgs"]?.length ?? 0,
                  itemBuilder: (context, j) {
                    return _flightDetailsTowards(
                        j, bndsData["lgs"][j], bndsData["pax"][0]);
                  },
                ),
              ),
              widget.tripTyp == "1"
                  ? Container(
                      height: 0,
                    )
                  : Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextWidget(
                        text: "Return Journey Details :",
                        size: text_font_medium17_size,
                        weight: FontWeight.bold,
                      ),
                    ),
              widget.tripTyp == "1"
                  ? Container(
                      height: 0,
                    )
                  : Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: retbndData["lgs"]?.length ?? 0,
                        itemBuilder: (context, j) {
                          return _flightDetailsReturn(
                              j, retbndData["lgs"][j], retbndData["pax"][0]);
                        },
                      ),
                    ),
              SizedBox(
                height: 5,
              ),
              _cancelPolicy(bndsData),
              _fareBrkup(
                  widget.tripTyp == "1" || widget.tripSubTyp != "D"
                      ? _flightDetailsModel?.values?.flightDetail![0].convFee
                      : _returnJrnyDetailsFlightModel
                          ?.values?.flightDetail!.convFee,
                  widget.tripTyp == "2" && widget.tripSubTyp == "D"
                      ? _returnJrnyDetailsFlightModel
                          ?.values?.flightDetailReturn![0].convFee
                      : 0,
                  widget.tripTyp == "1" || widget.tripSubTyp != "D"
                      ? _flightDetailsModel?.values?.flightDetail![0].bfr
                      : _returnJrnyDetailsFlightModel
                          ?.values?.flightDetail!.bfr,
                  widget.tripTyp == "2" && widget.tripSubTyp == "D"
                      ? _returnJrnyDetailsFlightModel
                          ?.values?.flightDetailReturn![0].bfr
                      : 0,
                  widget.tripTyp == "1" || widget.tripSubTyp != "D"
                      ? _flightDetailsModel?.values?.flightDetail![0].ttx
                      : _returnJrnyDetailsFlightModel
                          ?.values?.flightDetail!.ttx,
                  widget.tripTyp == "2" && widget.tripSubTyp == "D"
                      ? _returnJrnyDetailsFlightModel
                          ?.values?.flightDetailReturn![0].ttx
                      : 0,
                  widget.tripTyp == "1" || widget.tripSubTyp != "D"
                      ? _flightDetailsModel?.values?.flightDetail![0].totalPrice
                      : _returnJrnyDetailsFlightModel
                          ?.values?.flightDetail!.totalPrice,
                  widget.tripTyp == "2" && widget.tripSubTyp == "D"
                      ? _returnJrnyDetailsFlightModel
                          ?.values?.flightDetailReturn![0].totalPrice
                      : 0),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      } catch (e, s) {
        return Container();
      }
    }

    PreferredSizeWidget _appbar() {
      return PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            padding: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(gradient: gradient_theme_color),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <
                Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, true);
                  // Navigator.of(context).maybePop();
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
              Container(
                width: MediaQuery.of(context).size.width - 50,
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextWidget(
                            text: widget.flightRequestHolder?.originCity ?? '',
                            weight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                            size: text_font_medium17_size,
                            color: white_text_color,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          new Container(
                            child: LimitedBox(
                              child: widget.tripTyp == "1"
                                  ? Container(
                                      padding: EdgeInsets.only(top: 3),
                                      child: Image.asset(
                                        ImageConstants.flt_single_arrow,
                                        height: 7,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    )
                                  : Image.asset(
                                      ImageConstants.flt_arrowswitch,
                                      height: 10,
                                      fit: BoxFit.fitWidth,
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          TextWidget(
                            text: widget.flightRequestHolder?.destinationCity ??
                                '',
                            weight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                            size: text_font_medium17_size,
                            color: white_text_color,
                          )
                        ]),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: TextWidget(
                            text: "${stringToDateAndDateToStringFormatter()}",
                            color: white_text_color,
                            size: text_font_size_x_small,
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        TextWidget(
                          text: "|",
                          size: text_font_size_x_small,
                          color: white_text_color,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        TextWidget(
                          text:
                              "${widget.guestData != null ? this.widget.guestData.adultNumber : 1}"
                              "${this.widget.guestData.adultNumber > 1 ? " Adults" : " Adult"} "
                              "${widget.guestData != null ? widget.guestData.childNumber > 0 ? widget.guestData.childNumber : "" : ""}"
                              "${widget.guestData != null ? widget.guestData.childNumber > 1 ? " Children " : widget.guestData.childNumber == 1 ? " Child " : "" : ""}"
                              "${widget.guestData != null ? widget.guestData.infentNumber > 0 ? widget.guestData.infentNumber : "" : ""}"
                              "${widget.guestData != null ? widget.guestData.infentNumber > 1 ? " Infants " : widget.guestData.infentNumber == 1 ? " Infant " : "" : ""}"
                              "|"
                              " ${widget.guestData != null ? widget.guestData.cabinClassName : "Economy"}",
                          color: white_text_color,
                          size: text_font_size_x_small,
                        ),
                      ],
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
          bottom: false,
          child: Scaffold(
            appBar: _appbar(),
            body: SingleChildScrollView(
              child: isLoading != true
                  ? _noData
                      ? Container(
                          height: MediaQuery.of(context).size.height - 200,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "images/common/illustration.png",
                                height: 120,
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Container(
                                child: TextWidget(
                                  text: "No records found",
                                  size: 22,
                                  weight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        )
                      : _body(
                          widget.tripTyp == "1" || widget.tripSubTyp != "D"
                              ? _flightDetailsModel
                                  ?.values?.flightDetail![0].bnds![0]
                              : _returnJrnyDetailsFlightModel
                                  ?.values?.flightDetail!.bnds![0],
                          widget.tripTyp == "2" && widget.tripSubTyp != "D"
                              ? _flightDetailsModel
                                  ?.values?.flightDetail![0].bnds![1]
                              : widget.tripTyp == "2" &&
                                      widget.tripSubTyp == "D"
                                  ? _returnJrnyDetailsFlightModel
                                      ?.values?.flightDetailReturn![0].bnds![0]
                                  : "")
                  : Center(
                      child: SpinKitCircle(),
                    ),
            ),
          )),
    );
  }

  @override
  void allErr(error) {
    setState(() {
      _noData = true;
    });
  }

  @override
  void response(DetailsFlightModel flightDetailsModel) {
    setState(() {
      _flightDetailsModel = flightDetailsModel;
      isLoading = false;
      if (_flightDetailsModel?.status == false) _noData = true;
    });
  }

  @override
  void retunJrnyresponse(
      ReturnJrnyDetailsFlightModel returnJrnyDetailsFlightModel) {
    setState(() {
      _returnJrnyDetailsFlightModel = returnJrnyDetailsFlightModel;
      isLoading = false;
      if (_returnJrnyDetailsFlightModel?.status == false) _noData = true;
    });
  }
}
