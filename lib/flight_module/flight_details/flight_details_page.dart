// ignore_for_file: unnecessary_null_comparison
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/checkinternet.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/flight_module/flight_details/details_modal.dart';
import 'package:gems_revamp/flight_module/flight_details/details_presenter.dart';
import 'package:gems_revamp/flight_module/flight_details/details_view.dart';
import 'package:gems_revamp/flight_module/flight_details/return_jr_details_modal.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/flighthomereq_model.dart';
import 'package:gems_revamp/flight_module/traveller_details/traveller_details.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/dialogAlert.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../utils/constants_files/text_constants.dart';

class DetailsPage extends StatefulWidget {
  final String? sidKey;
  final String? sidReturnKey;
  final String tripType;
  final guestData;
  final FlightRequestHolder? flightRequestHolder;
  final String? tripSubTyp;
  final String paymentTyp;
  final int oldtotalAmt;
  final Function refresh;
  DetailsPage(
    this.flightRequestHolder,
    this.tripType, {
    required this.sidKey,
    required this.sidReturnKey,
    required this.guestData,
    required this.paymentTyp,
    required this.oldtotalAmt,
    this.tripSubTyp,
    required this.refresh,
    Key? key,
  }) : super(key: key);
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    implements DetailsFlightView {
  bool isLoading = false;
  DetailsFlightModel? _flightDetailsModel;
  ReturnJrnyDetailsFlightModel? _returnJrnyDetailsFlightModel;
  bool _noData = false;
  var _noConnection;
  var _totatPrice;
  var _baseprice;
  var _taxprice;
  var _baggageinfo;
  int _journeyTotalPrice = 0;
  // var pgConvFee;
  // var totalPayableAmount;
  // double commissionratio=0.0;
  @override
  void initState() {
    _apicall();
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

  void _apicall() {
    CheckInternet().apiCall().then((value) async {
      setState(() {
        isLoading = true;
      });
      if (value) {
        if (widget.tripType == "2" && widget.tripSubTyp == "D") {
          var req = {
            "sid_return": widget.sidReturnKey,
            "sid": widget.sidKey,
            "mop": widget.paymentTyp,
            "ccod": GemsGLobals.membershipNo,
            "user_type": GemsGLobals.userType
          };
          RetrnJrnyDetailsFlightPresenter().getDetails(this, req);
        } else {
          // var req = {"sid": widget.sidKey};
          var req = {
            "sid": widget.sidKey,
            "mop": widget.paymentTyp,
            "ccod": GemsGLobals.membershipNo,
            "user_type": GemsGLobals.userType
          };
          DetailsFlightPresenter().getDetails(this, req);
        }
      } else {
        value = await Navigator.of(context).pushNamed('noInternetpage');
        if (_noConnection != null) {
          isLoading = true;
          _apicall();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _fromTo(_data) {
      return Row(
        children: <Widget>[
          TextWidget(
            text: "${_data["octy"].toString().toUpperCase()}",
            size: text_font_medium14_size,
            weight: FontWeight.w400,
            color: flight_text_black_color,
          ),
          SizedBox(
            width: 8,
          ),
          Container(
            padding: EdgeInsets.only(top: 0),
            child: SvgPicture.asset(
              "images/flight/1. Icons _ Line _  arrow-right.svg",
              height: 8,
            ),
          ),
          SizedBox(
            width: 8,
          ),
          TextWidget(
            text: "${_data["dcty"].toString().toUpperCase()}",
            size: text_font_medium14_size,
            weight: FontWeight.w400,
            color: flight_text_black_color,
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
                        "${_details["dtym"].toString().length > 5 ? _details["dtym"].toString().substring(11) : _details["dtym"]}",
                    size: text_font_medium_size,
                    color: text_color,
                    weight: FontWeight.w500,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextWidget(
                      text: "${_dateFormat(_details["ddt"])}",
                      size: text_font_medium14_size,
                      color: text_color.withOpacity(0.6))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                    text: "${_details["dscd"]} "
                        "${_details["atym"].toString().length > 5 ? _details["atym"].toString().substring(11) : _details["atym"]}",
                    size: text_font_medium_size,
                    color: text_color,
                    weight: FontWeight.w500,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextWidget(
                    text: "${_dateFormat(_details["adt"])}",
                    size: text_font_medium14_size,
                    color: grey600_color.withOpacity(0.6),
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
      _baggageinfo = _details["ogcd"];
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
                  color: grey600_color,
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
                  color: grey600_color,
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
                  color: grey600_color.withOpacity(0.6),
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
                widget.tripType == "1" || widget.tripSubTyp == "I"
                    ? _flightDetailsModel?.values?.flightDetail![0].ref
                    : _returnJrnyDetailsFlightModel?.values?.flightDetail?.ref,
                pax),
            SizedBox(
              height: 20,
              child: Divider(),
            ),
          ],
        ),
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
                          placeholder: "images/flight/no_image_flight.jpg",
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
                  color: grey600_color.withOpacity(0.6),
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
                    : _returnJrnyDetailsFlightModel?.values?.flightDetail?.ref,
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
      _totatPrice = _totalTP;
      _baseprice = _totalBP;
      _taxprice = _totalTax;
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
                      : widget.tripType == "1" || widget.tripSubTyp != "D"
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
                        text: widget.tripType == "1" || widget.tripSubTyp != "D"
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

    Widget _continueBtn() {
      return Visibility(
        visible: isLoading
            ? false
            : _noData
                ? false
                : true,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
          child: GestureDetector(
            onTap: () {
              bool _isdomesticJrny;
              if (widget.tripType == "1") {
                _isdomesticJrny =
                    _flightDetailsModel?.values?.flightDetail![0].flt == "D"
                        ? true
                        : false;
                setState(() {});
              } else {
                _isdomesticJrny =
                    _returnJrnyDetailsFlightModel?.values?.flightDetail!.flt ==
                            "D"
                        ? true
                        : false;
                setState(() {});
              }

              GemsGLobals.membershipNo != null
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TravellersDetails(
                                widget.flightRequestHolder,
                                flightDetailsModel: _flightDetailsModel,
                                returnJrnyDetailsFlightModel:
                                    _returnJrnyDetailsFlightModel,
                                tripTyp: widget.tripType,
                                guestData: widget.guestData,
                                tripSubTyp: widget.tripSubTyp,
                                paymentTyp: widget.paymentTyp,
                                iSDomestic: _isdomesticJrny,
                                baseprice: _baseprice,
                                taxprice: _taxprice,
                                totatPrice: _totatPrice,
                                // pgConvFee:pgConvFee,
                                // totalPayableAmount:totalPayableAmount,
                                // commissionratio:commissionratio
                              )))
                  : DialogAlert.showLoginAlert(context);
            },
            child: Container(
              height: 55,
              margin: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 25),
              // decoration: BoxDecoration(),
              width: MediaQuery.of(context).size.width,

              //  height: 60,
              decoration: BoxDecoration(
                  gradient: gradient_theme_color,
                  // boxShadow: [
                  //   BoxShadow(
                  //       color: Colors.blue.withOpacity(0.2),
                  //       offset: Offset(2.0, 2.0),
                  //       blurRadius: 2.0,
                  //       spreadRadius: 2.0)
                  // ],
                  borderRadius: BorderRadius.circular(15)),

              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: TextWidget(
                        text: 'Continue booking',
                        size: text_font_medium_size,
                        color: white_text_color,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

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
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                    child: Divider(),
                  ),
                ],
              ),
            )
          : Container(
              height: 0,
            );
    }

    Widget _body(String? bnd, String? retBnd) {
      var bndsData = jsonDecode(bnd ?? '');
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
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: bndsData != '' ? bndsData["lgs"]?.length : 0,
                  itemBuilder: (context, j) {
                    return _flightDetailsTowards(
                        j, bndsData["lgs"][j], bndsData["pax"][0]);
                  },
                ),
              ),
              widget.tripType == "1"
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
                  widget.tripType == "1" || widget.tripSubTyp != "D"
                      ? _flightDetailsModel?.values?.flightDetail![0].convFee
                      : _returnJrnyDetailsFlightModel
                          ?.values?.flightDetail!.convFee,
                  widget.tripType == "2" && widget.tripSubTyp == "D"
                      ? _returnJrnyDetailsFlightModel
                          ?.values?.flightDetailReturn![0].convFee
                      : 0,
                  widget.tripType == "1" || widget.tripSubTyp != "D"
                      ? _flightDetailsModel?.values?.flightDetail![0].bfr
                      : _returnJrnyDetailsFlightModel
                          ?.values?.flightDetail!.bfr,
                  widget.tripType == "2" && widget.tripSubTyp == "D"
                      ? _returnJrnyDetailsFlightModel
                          ?.values?.flightDetailReturn![0].bfr
                      : 0,
                  widget.tripType == "1" || widget.tripSubTyp != "D"
                      ? _flightDetailsModel?.values?.flightDetail![0].ttx
                      : _returnJrnyDetailsFlightModel
                          ?.values?.flightDetail!.ttx,
                  widget.tripType == "2" && widget.tripSubTyp == "D"
                      ? _returnJrnyDetailsFlightModel
                          ?.values?.flightDetailReturn![0].ttx
                      : 0,
                  widget.tripType == "1" || widget.tripSubTyp != "D"
                      ? _flightDetailsModel?.values?.flightDetail![0].totalPrice
                      : _returnJrnyDetailsFlightModel
                          ?.values?.flightDetail!.totalPrice,
                  widget.tripType == "2" && widget.tripSubTyp == "D"
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

    PreferredSizeWidget _appbarUpdated() {
      return PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: GradientAppBar(
          title: "Flight Details",
          color: white_text_color,
          size: text_font_medium_size,
          weight: FontWeight.w600,
          centerTitle: true,
          height: 85,
        ),
      );
    }

    return SafeArea(
        bottom: true,
        top: false,
        child: Scaffold(
          appBar: _appbarUpdated(),
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
                              ImageConstants.commonIllustration,
                              height: 120,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Container(
                              child: TextWidget(
                                text:
                                    AppTexts.flightSoldOutText,
                                size: 22,
                                alignment: TextAlign.center,
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
                        widget.tripType == "1" || widget.tripSubTyp != "D"
                            ? _flightDetailsModel
                                ?.values?.flightDetail![0].bnds![0]
                            : _returnJrnyDetailsFlightModel
                                ?.values?.flightDetail?.bnds![0],
                        widget.tripType == "2" && widget.tripSubTyp != "D"
                            ? _flightDetailsModel
                                ?.values?.flightDetail![0].bnds![1]
                            : widget.tripType == "2" &&
                                    widget.tripSubTyp == "D"
                                ? _returnJrnyDetailsFlightModel!
                                    .values?.flightDetailReturn![0].bnds![0]
                                : "")
                : Container(
                    height: MediaQuery.of(context).size.height - 100,
                    child: Center(
                      child: SpinKitCircle(
                        color: blue_color,
                      ),
                    )),
          ),
          bottomNavigationBar: _continueBtn(),
        ));
  }

  @override
  void allErr(error) {
    try {} catch (e, s) {}

    setState(() {
      _noData = true;
    });
  }

  @override
  Future<void> response(DetailsFlightModel flightDetailsModel) async {
    isLoading = false;

    if (flightDetailsModel.message == "timeout") {
      var notresponding = await Navigator.of(context).pushNamed('/timeoutpage');
      if (notresponding != null) {
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
    } else {
      setState(() {
        flightDetailsModel.toJson();
        isLoading = false;
        this._flightDetailsModel = flightDetailsModel;

        if (_flightDetailsModel?.status == false) _noData = true;
        // pgConvFee=flightDetailsModel.values!.pgConFee??0;
        // totalPayableAmount=flightDetailsModel.values!.totalAmount??0;
        // commissionratio=flightDetailsModel.values!.flightDetail![0].commissionRatio??0.0;
      });
      setState(() {
        if (_flightDetailsModel?.values?.flightDetail![0].priceChanged ==
            "true") {
          GemsGLobals.flightRevisedTotal =
              _flightDetailsModel?.values?.flightDetail?[0].newamount ?? 0;
          DialogAlert.flightPriceChngDialog(
              context,
              widget.refresh,
              true,
              _flightDetailsModel?.values?.flightDetail?[0].newamount ?? 0,
              // _flightDetailsModel?.values?.flightDetailReturn![0]?.totalPrice,
              widget.paymentTyp,
              _flightDetailsModel?.values?.flightDetail?[0].oldamount ?? 0);
        }
      });
    }
  }

  @override
  void retunJrnyresponse(returnJrnyDetailsFlightModel) async {
    if (returnJrnyDetailsFlightModel.message == "timeout") {
      var notresponding = await Navigator.of(context).pushNamed('/timeoutpage');
      if (notresponding != null) {
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
    } else {
      setState(() {
        _returnJrnyDetailsFlightModel = returnJrnyDetailsFlightModel;
        isLoading = false;
        //  pgConvFee=_returnJrnyDetailsFlightModel!.values!.pgConFee??0;
        // totalPayableAmount=_returnJrnyDetailsFlightModel!.values!.totalAmount??0;
        // commissionratio=_returnJrnyDetailsFlightModel!.values!.flightDetail!.commissionRatio??0.0;
      });
      if (_returnJrnyDetailsFlightModel?.status == false) _noData = true;

      if (_returnJrnyDetailsFlightModel?.values?.flightDetail?.priceChanged ==
          "true") {
        GemsGLobals.flightRevisedTotal = _returnJrnyDetailsFlightModel
                ?.values?.flightDetailReturn?[0].newamount ??
            0;
        DialogAlert.flightPriceChngDialog(
            context,
            widget.refresh,
            true,
            _returnJrnyDetailsFlightModel
                    ?.values?.flightDetailReturn?[0].newamount ??
                0,
            widget.paymentTyp,
            _returnJrnyDetailsFlightModel
                    ?.values?.flightDetailReturn?[0].oldamount ??
                0);
      }

      setState(() {});
    }
  }
}
