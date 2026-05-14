/*
Auther Name: Jyoti Gite
Discription : This is the  flight REVIEW ITERNARY PAGE, final overview of flight booking details
*/

import 'dart:convert';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/Gradient_button.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/flight_module/flightBookingConfirmation/flight_confirmation.dart';
import 'package:gems_revamp/flight_module/flight_details/copy_details.dart';
import 'package:gems_revamp/flight_module/flight_details/details_modal.dart';
import 'package:gems_revamp/flight_module/flight_details/return_jr_details_modal.dart';
import 'package:gems_revamp/flight_module/flight_review_iternery/create_ord_modal.dart';
import 'package:gems_revamp/flight_module/flight_review_iternery/create_ord_presenter.dart';
import 'package:gems_revamp/flight_module/flight_review_iternery/create_ord_view.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/flighthomereq_model.dart';
import 'package:gems_revamp/giftcard_module/Paymentpage_webview/paymentpage.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/constants_files/text_constants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/dialogAlert.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ReviewItenirary extends StatefulWidget {
  final DetailsFlightModel? flightDetailsModel;
  final ReturnJrnyDetailsFlightModel? returnJrnyDetailsFlightModel;
  final String tripTyp;
  final String? tripSubTyp;
  final String paymentTyp;
  final List guestInfo;
  final guestData;
  final FlightRequestHolder flightRequestHolder;
  final int? timer;
  final totatPrice;
  final baseprice;
  final taxprice;
  //  final pgConvFee;
  // final totalPayableAmount;
  // var commissionratio;
  ReviewItenirary(
      {Key? key,
      required this.flightRequestHolder,
      required this.flightDetailsModel,
      required this.returnJrnyDetailsFlightModel,
      required this.tripTyp,
      required this.paymentTyp,
      required this.guestInfo,
      required this.guestData,
      this.baseprice,
      this.taxprice,
      this.totatPrice,
      this.tripSubTyp,
      this.timer
      // this.pgConvFee,
      // this.totalPayableAmount,
      // this.commissionratio
      })
      : super(key: key);

  @override
  _ReviewIteniraryState createState() => _ReviewIteniraryState();
}

class _ReviewIteniraryState extends State<ReviewItenirary>
    implements FlightCreateOrdView {
  GlobalKey<ScaffoldState> _tabscaffoldKey = new GlobalKey<ScaffoldState>();
  bool isExpanded = false;
  DetailsFlightModel? _flightDetailsModel;
  late ReturnJrnyDetailsFlightModel? _returnJrnyDetailsFlightModel;
  bool _refundable = false;
  bool _baggageShow = false;
  var noConnection;
  bool _pgLoader = false;
  List _userDataAdult = [];
  int guestindex = 0;
  int _guestCount = 0;
  int _adlCount = 0;
  int _chlcount = 0;
  int _infcont = 0;
  var _points;
  var _reqPnts;
  var _finalAedValue;

  double? _flightEarnRate = 0.2;
  int? _flightBurnRate = 10;
  // var totalafterfeevadded;
  var _pointController = TextEditingController();
  bool _payWithPoint = true;
  bool enteramount = false;
  bool redeemorethanpoints = false;
  var msg = "Please Enter Amount";
  int? textpoints;
  bool _ispriceChange = false;
  // double? calculatedconfee;

  @override
  void initState() {
    _flightDetailsModel = this.widget.flightDetailsModel;
    _returnJrnyDetailsFlightModel = this.widget.returnJrnyDetailsFlightModel;
    _points = GemsGLobals.pointbalance;
    _reqPnts = widget.tripTyp == "1" || widget.tripSubTyp != "D"
        ? _flightDetailsModel?.values!.flightDetail![0].bnzReddemPnts![0]
        : (_returnJrnyDetailsFlightModel!
                .values!.flightDetail!.bnzReddemPnts![0] +
            _returnJrnyDetailsFlightModel!
                .values!.flightDetailReturn![0].bnzReddemPnts![0]);

    _flightEarnRate = widget.tripTyp == "1" || widget.tripSubTyp != "D"
        ? _flightDetailsModel!.values!.earnRate
        : _returnJrnyDetailsFlightModel!.values!.earnRate;
    _flightBurnRate = widget.tripTyp == "1" || widget.tripSubTyp != "D"
        ? _flightDetailsModel!.values!.redeemRate
        : _returnJrnyDetailsFlightModel!.values!.redeemRate;
    if (GemsGLobals.pointbalance >= _reqPnts) {
      _pointController.text = _reqPnts.toString();
    } else {
      _pointController.text = GemsGLobals.pointbalance.toString();
    }

    textpoints = int.parse(_pointController.text);
    calculatePointcash(
        _reqPnts,
        GemsGLobals.pointbalance >= _reqPnts
            ? _reqPnts
            : GemsGLobals.pointbalance,
        "false");
//     if(widget.pgConvFee!=null && widget.pgConvFee!=""){
//  calculatedconfee=widget.pgConvFee*1.0;
//     }

    if (widget.guestInfo[0]["adult_list"].length >=
        widget.guestInfo[0]["child_list"].length) {
      _guestCount = widget.guestInfo[0]["adult_list"].length;
    } else {
      _guestCount = widget.guestInfo[0]["child_list"].length;
    }
    _adlCount = widget.guestInfo[0]["adult_list"].length;
    _chlcount = widget.guestInfo[0]["child_list"].length;
    _infcont = widget.guestInfo[0]["infant_list"].length;
    for (var i = 0; i < _guestCount; i++) {
      if (i < _infcont && i < _chlcount && i < _adlCount) {
        _userDataAdult.add({
          "adult": [
            {
              "title": "${widget.guestInfo[0]["adult_list"][i]["title"]}",
              "fname": "${widget.guestInfo[0]["adult_list"][i]["first_name"]}",
              "mname": "",
              "lname": "${widget.guestInfo[0]["adult_list"][i]["last_name"]}",
              "psprt_nmbr":
                  "${widget.guestInfo[0]["adult_list"][i]["passport_no"]}",
              "dob": "${widget.guestInfo[0]["adult_list"][i]["dob"]}",
              "is_lead_guest": i == 0 ? true : false,
              "passport_exp_date":
                  "${widget.guestInfo[0]["adult_list"][i]["passport_exp_date"]}",
              "passport_issue_date":
                  "${widget.guestInfo[0]["adult_list"][i]["passport_issue_date"]}",
              "nationality":
                  "${widget.guestInfo[0]["adult_list"][i]["nationality"]}",
              "passport_issue_country":
                  "${widget.guestInfo[0]["adult_list"][i]["passport_issue_country"]}",
            }
          ],
          "child": [
            {
              "title": "${widget.guestInfo[0]["child_list"][i]["title"]}",
              "fname": "${widget.guestInfo[0]["child_list"][i]["first_name"]}",
              "mname": "",
              "lname": "${widget.guestInfo[0]["child_list"][i]["last_name"]}",
              "psprt_nmbr":
                  "${widget.guestInfo[0]["child_list"][i]["passport_no"]}",
              "dob": "${widget.guestInfo[0]["child_list"][i]["dob"]}",
              "is_lead_guest": false,
              "passport_exp_date":
                  "${widget.guestInfo[0]["child_list"][i]["passport_exp_date"]}",
              "passport_issue_date":
                  "${widget.guestInfo[0]["child_list"][i]["passport_issue_date"]}",
              "nationality":
                  "${widget.guestInfo[0]["child_list"][i]["nationality"]}",
              "passport_issue_country":
                  "${widget.guestInfo[0]["child_list"][i]["passport_issue_country"]}",
            }
          ],
          "infant": [
            {
              "title": "${widget.guestInfo[0]["infant_list"][i]["title"]}",
              "fname": "${widget.guestInfo[0]["infant_list"][i]["first_name"]}",
              "mname": "",
              "lname": "${widget.guestInfo[0]["infant_list"][i]["last_name"]}",
              "psprt_nmbr":
                  "${widget.guestInfo[0]["infant_list"][i]["passport_no"]}",
              "dob": "${widget.guestInfo[0]["infant_list"][i]["dob"]}",
              "is_lead_guest": false,
              "passport_exp_date":
                  "${widget.guestInfo[0]["infant_list"][i]["passport_exp_date"]}",
              "passport_issue_date":
                  "${widget.guestInfo[0]["infant_list"][i]["passport_issue_date"]}",
              "passport_issue_country":
                  "${widget.guestInfo[0]["infant_list"][i]["passport_issue_country"]}",
              "nationality":
                  "${widget.guestInfo[0]["infant_list"][i]["nationality"]}"
            }
          ]
        });
      } else if (i >= _infcont && i < _chlcount && i < _adlCount) {
        _userDataAdult.add({
          "adult": [
            {
              "title": "${widget.guestInfo[0]["adult_list"][i]["title"]}",
              "fname": "${widget.guestInfo[0]["adult_list"][i]["first_name"]}",
              "mname": "",
              "lname": "${widget.guestInfo[0]["adult_list"][i]["last_name"]}",
              "psprt_nmbr":
                  "${widget.guestInfo[0]["adult_list"][i]["passport_no"]}",
              "dob": "${widget.guestInfo[0]["adult_list"][i]["dob"]}",
              "is_lead_guest": i == 0 ? true : false,
              "passport_exp_date":
                  "${widget.guestInfo[0]["adult_list"][i]["passport_exp_date"]}",
              "passport_issue_date":
                  "${widget.guestInfo[0]["adult_list"][i]["passport_issue_date"]}",
              "passport_issue_country":
                  "${widget.guestInfo[0]["adult_list"][i]["passport_issue_country"]}",
              "nationality":
                  "${widget.guestInfo[0]["adult_list"][i]["nationality"]}"
            }
          ],
          "child": [
            {
              "title": "${widget.guestInfo[0]["child_list"][i]["title"]}",
              "fname": "${widget.guestInfo[0]["child_list"][i]["first_name"]}",
              "mname": "",
              "lname": "${widget.guestInfo[0]["child_list"][i]["last_name"]}",
              "psprt_nmbr":
                  "${widget.guestInfo[0]["child_list"][i]["passport_no"]}",
              "dob": "${widget.guestInfo[0]["child_list"][i]["dob"]}",
              "is_lead_guest": false,
              "passport_exp_date":
                  "${widget.guestInfo[0]["child_list"][i]["passport_exp_date"]}",
              "passport_issue_date":
                  "${widget.guestInfo[0]["child_list"][i]["passport_issue_date"]}",
              "passport_issue_country":
                  "${widget.guestInfo[0]["child_list"][i]["passport_issue_country"]}",
              "nationality":
                  "${widget.guestInfo[0]["child_list"][i]["nationality"]}"
            }
          ]
        });
      } else if (i < _infcont && i >= _chlcount && i < _adlCount) {
        _userDataAdult.add({
          "adult": [
            {
              "title": "${widget.guestInfo[0]["adult_list"][i]["title"]}",
              "fname": "${widget.guestInfo[0]["adult_list"][i]["first_name"]}",
              "mname": "",
              "lname": "${widget.guestInfo[0]["adult_list"][i]["last_name"]}",
              "psprt_nmbr":
                  "${widget.guestInfo[0]["adult_list"][i]["passport_no"]}",
              "dob": "${widget.guestInfo[0]["adult_list"][i]["dob"]}",
              "is_lead_guest": i == 0 ? true : false,
              "passport_exp_date":
                  "${widget.guestInfo[0]["adult_list"][i]["passport_exp_date"]}",
              "passport_issue_date":
                  "${widget.guestInfo[0]["adult_list"][i]["passport_issue_date"]}",
              "passport_issue_country":
                  "${widget.guestInfo[0]["adult_list"][i]["passport_issue_country"]}",
              "nationality":
                  "${widget.guestInfo[0]["adult_list"][i]["nationality"]}"
            }
          ],
          "infant": [
            {
              "title": "${widget.guestInfo[0]["infant_list"][i]["title"]}",
              "fname": "${widget.guestInfo[0]["infant_list"][i]["first_name"]}",
              "mname": "",
              "lname": "${widget.guestInfo[0]["infant_list"][i]["last_name"]}",
              "psprt_nmbr":
                  "${widget.guestInfo[0]["infant_list"][i]["passport_no"]}",
              "dob": "${widget.guestInfo[0]["infant_list"][i]["dob"]}",
              "is_lead_guest": false,
              "passport_exp_date":
                  "${widget.guestInfo[0]["infant_list"][i]["passport_exp_date"]}",
              "passport_issue_date":
                  "${widget.guestInfo[0]["infant_list"][i]["passport_issue_date"]}",
              "passport_issue_country":
                  "${widget.guestInfo[0]["infant_list"][i]["passport_issue_country"]}",
              "nationality":
                  "${widget.guestInfo[0]["infant_list"][i]["nationality"]}"
            }
          ]
        });
      } else if (i >= _infcont && i >= _chlcount && i < _adlCount) {
        _userDataAdult.add({
          "adult": [
            {
              "title": "${widget.guestInfo[0]["adult_list"][i]["title"]}",
              "fname": "${widget.guestInfo[0]["adult_list"][i]["first_name"]}",
              "mname": "",
              "lname": "${widget.guestInfo[0]["adult_list"][i]["last_name"]}",
              "psprt_nmbr":
                  "${widget.guestInfo[0]["adult_list"][i]["passport_no"]}",
              "dob": "${widget.guestInfo[0]["adult_list"][i]["dob"]}",
              "is_lead_guest": i == 0 ? true : false,
              "passport_exp_date":
                  "${widget.guestInfo[0]["adult_list"][i]["passport_exp_date"]}",
              "passport_issue_date":
                  "${widget.guestInfo[0]["adult_list"][i]["passport_issue_date"]}",
              "passport_issue_country":
                  "${widget.guestInfo[0]["adult_list"][i]["passport_issue_country"]}",
              "nationality":
                  "${widget.guestInfo[0]["adult_list"][i]["nationality"]}",
            }
          ]
        });
      } else if (i >= _infcont && i < _chlcount && i >= _adlCount) {
        _userDataAdult.add({
          "child": [
            {
              "title": "${widget.guestInfo[0]["child_list"][i]["title"]}",
              "fname": "${widget.guestInfo[0]["child_list"][i]["first_name"]}",
              "mname": "",
              "lname": "${widget.guestInfo[0]["child_list"][i]["last_name"]}",
              "psprt_nmbr":
                  "${widget.guestInfo[0]["child_list"][i]["passport_no"]}",
              "dob": "${widget.guestInfo[0]["child_list"][i]["dob"]}",
              "is_lead_guest": false,
              "passport_exp_date":
                  "${widget.guestInfo[0]["child_list"][i]["passport_exp_date"]}",
              "passport_issue_date":
                  "${widget.guestInfo[0]["child_list"][i]["passport_issue_date"]}",
              "passport_issue_country":
                  "${widget.guestInfo[0]["child_list"][i]["passport_issue_country"]}",
              "nationality":
                  "${widget.guestInfo[0]["child_list"][i]["nationality"]}"
            }
          ]
        });
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _dateFormat(String date) {
    DateTime _date = DateTime.parse(date);
    final DateFormat formatter = DateFormat('EEE, dd MMM');
    final String formatted = formatter.format(_date);
    return formatted;
  }

  void initPGapiCall() {
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        if (widget.paymentTyp != "cash") {
          setState(() {
            if (_pointController.text != "") {
              _points = _pointController.text;
            } else {
              if (_points >= _reqPnts) {
                _points = _reqPnts;
              }
            }
          });
        }
        var _req = {
          "sid": widget.tripTyp == "1"
              ? "${_flightDetailsModel?.values?.flightDetail![0].sid}"
              : widget.tripSubTyp == "I"
                  ? "${_flightDetailsModel?.values?.flightDetail![0].sid}"
                  : "${_returnJrnyDetailsFlightModel?.values?.flightDetail?.sid}",
          "sid_return": widget.tripTyp == "2" && widget.tripSubTyp == "D"
              ? "${_returnJrnyDetailsFlightModel?.values?.flightDetailReturn![0].sid}"
              : null,
          "ccod": GemsGLobals.membershipNo,
          "email": '${widget.guestInfo[0]["email_id"]}',
          "phn_nmbr": '${widget.guestInfo[0]["contact_no"]}',
          "country_code": '${widget.guestInfo[0]["country_code"]}',
          "rdm_pnt": widget.paymentTyp == "cash" ? 0 : _points,
          "user_info": _userDataAdult,
          "uid": widget.flightDetailsModel?.values?.uid,
        };

        if (widget.paymentTyp != "cash") {
          if (_points != null && _points != "") {
            if (int.parse(_points) <= 40) {
              _pgLoader = false;
              setState(() {});
              Fluttertoast.showToast(
                  msg: "Insufficient GEMS Points",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: grey_background);
            } else {
              GiftPGInitPresenter().getList(this, _req);
            }
          } else {
            GiftPGInitPresenter().getList(this, _req);
          }
        } else {
          GiftPGInitPresenter().getList(this, _req);
        }
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          initPGapiCall();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(gradient: gradient_theme_color),
        child: SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
              backgroundColor: Color(0xFFf4f4f4),
              key: _tabscaffoldKey,
              extendBody: true,
              appBar: PreferredSize(
                child: Container(
                  decoration: BoxDecoration(gradient: gradient_theme_color),
                ),
                preferredSize: Size.fromHeight(0),
              ),
              body: _body(),
            )));
  }

  String _amountPartial() {
    if (widget.tripTyp == AppTexts.tripType || widget.tripSubTyp != AppTexts.flightTypeDomestic) {
      return "${gemsPointsFormatter(_flightDetailsModel?.values?.flightDetail![0].bnzReddemPnts![0])} ${AppTexts.gemsPointsText} ";
    } else {
      return "${gemsPointsFormatter(_returnJrnyDetailsFlightModel!.values!.flightDetail!.bnzReddemPnts![0] + _returnJrnyDetailsFlightModel!.values!.flightDetailReturn![0].bnzReddemPnts![0])} ${AppTexts.gemsPointsText} ";
    }
  }

  Widget _paybycashandpoints() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          // ignore: unrelated_type_equality_checks
          _flightDetailsModel?.values?.flightDetail![0].bnzReddemPnts![0] != 0
              ? Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: AppTexts.totalPointsText,
                        size: text_font_medium14_size,
                        weight: FontWeight.w600,
                        color: grey600_color,
                      ),
                      TextWidget(
                        text: _amountPartial(),
                        size: text_font_medium14_size,
                        weight: FontWeight.w600,
                        color: flight_text_black_color,
                      )
                    ],
                  ),
                )
              : Container(
                  height: 0,
                ),
          new SizedBox(
            height: 10,
          ),
          GemsGLobals.pointbalance != 0
              ? Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: "Redeemable Points: ",
                        size: text_font_medium14_size,
                        weight: FontWeight.w600,
                        color: grey600_color,
                      ),
                      // Flexible(
                      //   child:
                      TextWidget(
                        text: textpoints != null && textpoints != ""
                            ? textpoints.toString() + " GEMS Points"
                            : "${pointsFormatter(GemsGLobals.pointbalance)} GEMS Points",
                        size: text_font_medium14_size,
                        weight: FontWeight.w600,
                        color: flight_text_black_color,
                      ),
                      // )
                    ],
                  ),
                )
              : Container(
                  height: 0,
                ),

          new SizedBox(
            height: 10,
          ),
          (_pointController.text.isNotEmpty &&
                      int.parse(_pointController.text) >
                          GemsGLobals.pointbalance.toInt()) ||
                  redeemorethanpoints == true
              ? Container()
              : Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: "Total Payable Amount: ",
                        size: text_font_medium14_size,
                        weight: FontWeight.w600,
                        color: grey600_color,
                      ),
                      TextWidget(
                        // text: "AED ${widget.totatPrice}",
                        text: "AED $_finalAedValue",
                        size: text_font_medium14_size,
                        weight: FontWeight.w600,
                        color: flight_text_black_color,
                      )
                    ],
                  ),
                ),
          //           if(widget.pgConvFee.toString()!="null")
          //          new SizedBox(
          //           height: 10,
          //         ),
          //       (_pointController.text.isNotEmpty && int.parse(_pointController.text)>GemsGLobals.pointbalance.toInt()) || redeemorethanpoints==true
          //       // || GemsGLobals.pointbalance>=_reqPnts?
          //       || textpoints!>=_reqPnts?
          //         Container():
          //         // widget.pgConvFee.toString()!="null"?
          //         Container(
          //           child: Row(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               TextWidget(
          //                 text: "Convenience Fee: ",
          //                 size: text_font_medium14_size,
          //                 weight: FontWeight.w600,
          //                 color: grey600_color,
          //               ),
          //               TextWidget(
          //                 // text: "AED ${widget.totatPrice}",
          //                 text:
          //                 textpoints!=null && textpoints!=""?
          //                 "AED "+calculatedconfee!.ceil().toInt().toString()
          //                 :
          //                 widget.pgConvFee.toString()!="null"?
          //                 "AED  ${widget.pgConvFee}":"0",
          //                 size: text_font_medium14_size,
          //                 weight: FontWeight.w600,
          //                 color: flight_text_black_color,
          //               )
          //             ],
          //           ),
          //         ),
          //         // :Container(),
          //         if(totalafterfeevadded.toString()!="null")
          //          new SizedBox(
          //           height: 10,
          //         ),
          //       (_pointController.text.isNotEmpty && int.parse(_pointController.text)>GemsGLobals.pointbalance.toInt() )|| redeemorethanpoints==true
          // // || GemsGLobals.pointbalance>=_reqPnts?
          // || textpoints!>=_reqPnts?
          //         Container():
          //         totalafterfeevadded.toString()!="null"?
          //         Container(
          //           child: Row(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               TextWidget(
          //                 text: "Total Payable Amount: ",
          //                 size: text_font_medium14_size,
          //                 weight: FontWeight.w600,
          //                 color: grey600_color,
          //               ),
          //               TextWidget(
          //                 // text: "AED ${widget.totalPayableAmount}",
          //                 text: "AED ${totalafterfeevadded.toInt()}",

          //                 // text: "AED  ${totalafterfeevadded}",

          //                 size: text_font_medium14_size,
          //                 weight: FontWeight.w600,
          //                 color: flight_text_black_color,
          //               )
          //             ],
          //           ),
          //         ):Container(),
          SizedBox(height: 10),
          Container(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (_payWithPoint) {
                        _payWithPoint = false;
                        enteramount = false;

                        if (GemsGLobals.pointbalance >= _reqPnts) {
                          _pointController.text = _reqPnts.toString();
                        } else {
                          _pointController.text =
                              GemsGLobals.pointbalance.toString();
                        }
                        // _pointController.text=GemsGLobals.pointbalance.toString();
                        textpoints = int.parse(_pointController.text);

                        calculatePointcash(
                            _reqPnts,
                            GemsGLobals.pointbalance >= _reqPnts
                                ? _reqPnts
                                : GemsGLobals.pointbalance,
                            false);
                        // _payWithAED = true;
                      } else {
                        _payWithPoint = true;
                        enteramount = false;
                        // _payWithAED = false;
                        // _pointController.text =
                        //     '${(((int.parse(_amount) * _currencyconvRate) * _quantityCounter).round() / _redemptionRate).round()}';
                      }
                    });
                  },
                  child: Container(
                      height: 23,
                      width: 23,
                      child: _payWithPoint
                          ? SvgPicture.asset(
                              ImageConstants.select,
                            )
                          : SvgPicture.asset(
                              ImageConstants.unselect,
                            )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 7),
                  child: TextWidget(
                    text: 'Pay with ',
                    color: _payWithPoint
                        ? black_color.withOpacity(0.7)
                        : shadow_color,
                    size: text_font_medium15_size,
                  ),
                ),
                Container(
                  width: 120,
                  height: 45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                          color: _payWithPoint
                              ? grey600_color.withOpacity(0.5)
                              : shadow_color,
                          width: 0.8)),
                  child: _payWithPoint
                      ? TextFormField(
                          controller: _pointController,
                          autofocus: false,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter(RegExp('[0-9]'),
                                allow: true)
                          ],
                          cursorColor: deepdark_orange_color,
                          textAlign: TextAlign.center,
                          cursorWidth: 1.0,
                          maxLength: 15,
                          style: TextStyle(
                              color: black_color,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          onChanged: (text) {
                            if (_pointController.text.isNotEmpty &&
                                    _pointController.text.length >= 1
                                // int.parse(_pointController.text)
                                //  <=
                                // checkAmt
                                ) {
                              textpoints = int.parse(_pointController.text);
                              calculatePointcash("", textpoints, true);
                              if (int.parse(_pointController.text) > _reqPnts) {
                                setState(() {
                                  redeemorethanpoints = true;
                                });
                              } else {
                                setState(() {
                                  redeemorethanpoints = false;
                                });
                              }
                            } else {
                              setState(() {
                                // textpoints=GemsGLobals.pointbalance;

                                if (GemsGLobals.pointbalance >= _reqPnts) {
                                  //  _pointController.text=_reqPnts.toString();
                                  var data = _amountPartial()
                                      .replaceAll(",", "")
                                      .replaceAll("Points", "")
                                      .replaceAll("GEMS", "");

                                  textpoints = int.parse(data);
                                } else {
                                  textpoints = GemsGLobals.pointbalance;
                                }
                                calculatePointcash(
                                    _reqPnts,
                                    GemsGLobals.pointbalance >= _reqPnts
                                        ? _reqPnts
                                        : GemsGLobals.pointbalance,
                                    false);
                              });
                            }
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            alignLabelWithHint: true,
                            counterText: '',
                            errorMaxLines: 2,
                            border: InputBorder.none,
                          ))
                      : Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: TextWidget(
                            text: _pointController.text,
                            color: shadow_color,
                            weight: FontWeight.bold,
                            size: text_font_medium15_size,
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: TextWidget(
                    text: 'GEMS',
                    color: _payWithPoint
                        ? black_color.withOpacity(0.7)
                        : shadow_color,
                    // weight: FontWeight.bold,
                    size: text_font_medium15_size,
                  ),
                ),
              ],
            ),
          ),
          if (enteramount)
            Container(
              // alignment: Alignment.center,
              margin: EdgeInsets.only(left: 50, right: 20),
              child: TextWidget(
                text: msg,
                color: red_color,
                size: 13,
                softwrap: true,
                maxLines: 4,
                weight: FontWeight.w600,
              ),
            ),

          _pointController.text.isNotEmpty &&
                  int.parse(_pointController.text) >
                      GemsGLobals.pointbalance.toInt()
              ? Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 50, right: 20),
                  child: TextWidget(
                    text:
                        'The entered GEMS must be within your available GEMS balance and required total amount',
                    color: red_color,
                    size: 13,
                    softwrap: true,
                    maxLines: 4,
                    weight: FontWeight.w600,
                  ),
                )
              : redeemorethanpoints && enteramount == false
                  ? Container(
                      // alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 50, right: 20),
                      child: TextWidget(
                        text:
                            "Redeemable Points cannot be greater than Total Points",
                        color: red_color,
                        size: 13,
                        softwrap: true,
                        maxLines: 4,
                        weight: FontWeight.w600,
                      ),
                    )
                  : SizedBox(
                      height: 0,
                    ),
        ],
      ),
    );
  }

  void calculatePointcash(_conversionPoints, _selectedpoints, cf) {
    // if (GemsGLobals.pointbalance <= _conversionPoints) {
    var calucaltedGemsPoints = _reqPnts - _selectedpoints;

    _finalAedValue = (calucaltedGemsPoints / _flightBurnRate).ceil();
  }

  Widget _appBar(DetailsFlightModel? onward,
      ReturnJrnyDetailsFlightModel? returnData, String? _bonds) {
    var _bnds = jsonDecode(widget.tripTyp == "1" || widget.tripSubTyp == "I"
        ? onward!.values!.flightDetail![0].bnds![0]
        : returnData!.values!.flightDetail!.bnds![0]);
    var _bndsDomRet = widget.tripTyp == "2" && widget.tripSubTyp == "D"
        ? jsonDecode(returnData!.values!.flightDetailReturn![0].bnds![0])
        : "";
    var _bndsRet = widget.tripTyp == "2" && widget.tripSubTyp == "I"
        ? jsonDecode(onward!.values!.flightDetail![0].bnds![1])
        : "";
    var _bndsdata = jsonDecode(_bonds!);
    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).maybePop();
            },
            child: Container(
              margin: EdgeInsets.only(left: 10),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: appbar_backarw_bg_color,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: SvgPicture.asset(
                  ImageConstants.backbutton,
                  height: 15,
                  color: white_text_color,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              // width: MediaQuery.of(context).size.width - 150,
              padding: EdgeInsets.only(right: 30),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextWidget(
                    text: "Trip to",
                    color: white_text_color,
                    size: text_font_medium14_size,
                  ),
                  new TextWidget(
                    text: "${_bndsdata["dcty"]}",
                    color: white_text_color,
                    weight: FontWeight.bold,
                    size: text_font_medium17_size,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _body() {
    try {
      return Container(
          // decoration: BoxDecoration(gradient: gradient_grey_theme_color),
          child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            _appBar(
                _flightDetailsModel,
                _returnJrnyDetailsFlightModel,
                widget.tripTyp == "1" || widget.tripSubTyp == "I"
                    ? _flightDetailsModel!.values?.flightDetail![0].bnds![0]
                    : _returnJrnyDetailsFlightModel!
                        .values?.flightDetail?.bnds![0]),
            Expanded(
              child: ListView(shrinkWrap: true, children: <Widget>[
                departureAndreturn(
                    _flightDetailsModel,
                    _returnJrnyDetailsFlightModel,
                    widget.tripTyp == "1" || widget.tripSubTyp == "I"
                        ? _flightDetailsModel!.values?.flightDetail![0].bnds![0]
                        : _returnJrnyDetailsFlightModel!
                            .values?.flightDetail?.bnds![0]),
                new Container(
                    width: MediaQuery.of(context).size.width,
                    color: white_text_color,
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(children: <Widget>[
                          travellerdetails(widget.guestInfo),
                          baggagePolicy(
                              widget.tripTyp == "1" || widget.tripSubTyp == "I"
                                  ? _flightDetailsModel!
                                      .values?.flightDetail![0].bnds![0]
                                  : _returnJrnyDetailsFlightModel!
                                      .values?.flightDetail?.bnds![0]),
                          refundPolicy(),
                          // _paybycashandpoints(),
                          (GemsGLobals.referralRelationType !=
                                          GemsGLobals.spouseValue &&
                                      GemsGLobals.referralRelationType !=
                                          GemsGLobals.childValue) &&
                                  // GemsGLobals.pointbalance <= _reqPnts &&
                                  widget.paymentTyp != "cash"
                              ? _paybycashandpoints()
                              : Container(
                                  height: 100,
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (context) {
                                            return _fareBrkup(
                                                widget.tripTyp == "1" || widget.tripSubTyp != "D"
                                                    ? _flightDetailsModel!
                                                        .values
                                                        ?.flightDetail![0]
                                                        .convFee
                                                    : _returnJrnyDetailsFlightModel!
                                                        .values
                                                        ?.flightDetail
                                                        ?.convFee,
                                                widget.tripTyp == "2" && widget.tripSubTyp == "D"
                                                    ? _returnJrnyDetailsFlightModel!
                                                        .values
                                                        ?.flightDetailReturn![0]
                                                        .convFee
                                                    : 0,
                                                widget.tripTyp == "1" || widget.tripSubTyp != "D"
                                                    ? _flightDetailsModel!
                                                        .values
                                                        ?.flightDetail![0]
                                                        .bfr
                                                    : _returnJrnyDetailsFlightModel!
                                                        .values
                                                        ?.flightDetail
                                                        ?.bfr,
                                                widget.tripTyp == "2" && widget.tripSubTyp == "D"
                                                    ? _returnJrnyDetailsFlightModel!
                                                        .values
                                                        ?.flightDetailReturn![0]
                                                        .bfr
                                                    : 0,
                                                widget.tripTyp == "1" || widget.tripSubTyp != "D"
                                                    ? _flightDetailsModel!
                                                        .values
                                                        ?.flightDetail![0]
                                                        .ttx
                                                    : _returnJrnyDetailsFlightModel!
                                                        .values
                                                        ?.flightDetail
                                                        ?.ttx,
                                                widget.tripTyp == "2" && widget.tripSubTyp == "D"
                                                    ? _returnJrnyDetailsFlightModel!
                                                        .values
                                                        ?.flightDetailReturn![0]
                                                        .ttx
                                                    : 0,
                                                widget.tripTyp == "1" || widget.tripSubTyp != "D"
                                                    ? _flightDetailsModel!
                                                        .values
                                                        ?.flightDetail![0]
                                                        .totalPrice
                                                    : _returnJrnyDetailsFlightModel!.values?.flightDetail?.totalPrice,
                                                widget.tripTyp == "2" && widget.tripSubTyp == "D" ? _returnJrnyDetailsFlightModel?.values?.flightDetailReturn![0].totalPrice : 0);
                                          });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Spacer(),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 3),
                                                child: TextWidget(
                                                  text: 'Total ',
                                                  size: text_font_small,
                                                  color: text_color,
                                                ),
                                              ),
                                              TextWidget(
                                                text: _amtText(),
                                                size: 18,
                                                weight: FontWeight.w700,
                                                color: text_color,
                                              ),
                                              new Image.asset(
                                                ImageConstants.flt_exclamation,
                                                width: 15,
                                                color: black_color,
                                              ),
                                            ],
                                          ),
                                          TextWidget(
                                            text: _travellercountText(),
                                            size: text_font_size_x_small,
                                            color: text_color,
                                          ),
                                          widget.guestData.infentNumber > 0
                                              ? Container(
                                                  child: TextWidget(
                                                    text:
                                                        "${widget.guestData.infentNumber > 0 ? widget.guestData.infentNumber : ""}"
                                                        "${widget.guestData.infentNumber > 1 ? " Infants" : widget.guestData.infentNumber == 1 ? " Infant" : ""}",
                                                    size:
                                                        text_font_size_x_small,
                                                    color: text_color,
                                                  ),
                                                )
                                              : SizedBox(
                                                  height: 0,
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          bookNow(),
                          earnBounz(),
                        ])))
              ]),
            ),
          ],
        ),
      ));
    } catch (e) {
      //Print(e);
      return Container();
    }
  }

  Widget departureAndreturn(DetailsFlightModel? onward,
      ReturnJrnyDetailsFlightModel? returnData, String? _bonds) {
    var _bnds = jsonDecode(widget.tripTyp == "1" || widget.tripSubTyp == "I"
        ? onward!.values!.flightDetail![0].bnds![0]
        : returnData!.values!.flightDetail!.bnds![0]);
    var _bndsDomRet = widget.tripTyp == "2" && widget.tripSubTyp == "D"
        ? jsonDecode(returnData!.values!.flightDetailReturn![0].bnds![0])
        : "";
    var _bndsRet = widget.tripTyp == "2" && widget.tripSubTyp == "I"
        ? jsonDecode(onward!.values!.flightDetail![0].bnds![1])
        : "";
    var _bndsdata = jsonDecode(_bonds!);
    return new Container(
      width: MediaQuery.of(context).size.width,
      // decoration: BoxDecoration(gradient: gradient_theme_color),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              color: black_color,
              child: Center(
                child: widget.paymentTyp == "cash"
                    ? TextWidget(
                        text: "You Can Earn up to " +
                            "${widget.tripTyp == "1" || widget.tripSubTyp == "I" ? "${gemsPointsFormatter(_flightDetailsModel?.values?.flightDetail![0].bnzAccrPnts![0])} Gems Points" : "${gemsPointsFormatter((_returnJrnyDetailsFlightModel!.values!.flightDetail!.bnzAccrPnts![0]) + _returnJrnyDetailsFlightModel!.values!.flightDetailReturn![0].bnzAccrPnts![0])} GEMS Points"}",
                        size: text_font_medium15_size,
                        color: white_text_color,
                        weight: FontWeight.w500,
                      )
                    : GemsGLobals.pointbalance != 0
                        ? TextWidget(
                            text: "You Can redeem up to " +
                                "${GemsGLobals.pointbalance} GEMS Points",
                            size: text_font_medium15_size,
                            color: white_text_color,
                            weight: FontWeight.w500,
                          )
                        : Container(
                            height: 0,
                          ),
              ),
            ),
            Container(
              color: white_text_color,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 3),
                      height: 35,
                      width: 35,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: FadeInImage.assetNetwork(
                              placeholder: ImageConstants.flt_no_image_flight,
                              height: 20,
                              width: 20,
                              image: _bnds["lgs"][0]["arnimg"])),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 0, 8, 8),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              TextWidget(
                                text: 'Departure',
                                size: text_font_medium16_size,
                                color: black_color,
                              ),
                              TextWidget(
                                text: widget.tripTyp == "1" ||
                                        widget.tripSubTyp == "I"
                                    ? '\t\t${onward?.values?.flightDetail![0].src}\t'
                                    : '\t\t${returnData?.values?.flightDetail?.src}\t',
                                size: text_font_medium16_size,
                                weight: FontWeight.w700,
                                color: black_color,
                              ),
                              new SvgPicture.asset(
                                ImageConstants.flt_path,
                                color: black_color,
                                width: 14,
                              ),
                              TextWidget(
                                text: widget.tripTyp == "1" ||
                                        widget.tripSubTyp == "I"
                                    ? '\t${onward?.values?.flightDetail![0].dest}'
                                    : '\t\t${returnData?.values?.flightDetail?.dest}\t',
                                size: text_font_medium16_size,
                                color: black_color,
                                weight: FontWeight.w700,
                              ),
                            ],
                          ),
                          TextWidget(
                            text: widget.tripTyp == "1" ||
                                    widget.tripSubTyp == "I"
                                ? onward?.values?.flightDetail![0].stp == 0
                                    ? "${_dateFormat(_bnds["ddt"])} | ${_bnds["dtym"]} - ${_bnds["atym"]} | Non Stop"
                                    : "${_dateFormat(_bnds["ddt"])} | ${_bnds["dtym"]} - ${_bnds["atym"]} | ${widget.tripTyp == "1" || widget.tripSubTyp == "I" ? onward?.values?.flightDetail![0].stp : returnData?.values?.flightDetail?.stp} Stops"
                                : returnData?.values?.flightDetail?.stp == 0
                                    ? "${_dateFormat(_bnds["ddt"])} | ${_bnds["dtym"]} - ${_bnds["atym"]} | Non Stop"
                                    : "${_dateFormat(_bnds["ddt"])} | ${_bnds["dtym"]} - ${_bnds["atym"]} | ${widget.tripTyp == "1" || widget.tripSubTyp == "I" ? onward?.values?.flightDetail![0].stp : returnData?.values?.flightDetail?.stp} Stops",
                            size: text_font_size_x_small,
                            color: black_color,
                          ),
                          TextWidget(
                            text: widget.tripTyp == "1" ||
                                    widget.tripSubTyp == "I"
                                ? "${_bnds["lgs"][0]["cbn"]} - ${onward?.values?.flightDetail![0].ref == "false" ? "Non Refundable" : "Refundable"}"
                                : "${_bnds["lgs"][0]["cbn"]} - ${returnData?.values?.flightDetail?.ref == "false" ? "Non Refundable" : "Refundable"}",
                            size: text_font_size_x_small,
                            color: black_color,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            widget.tripTyp == "1"
                ? Container(
                    height: 0,
                  )
                : Container(
                    color: white_text_color,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 3),
                            height: 35,
                            width: 35,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: FadeInImage.assetNetwork(
                                    placeholder:
                                        ImageConstants.flt_no_image_flight,
                                    height: 20,
                                    width: 20,
                                    image: _bnds["lgs"][0]["arnimg"])),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10.0, 0, 8, 8),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    TextWidget(
                                      text: "Return",
                                      size: text_font_medium16_size,
                                      color: black_color,
                                    ),
                                    TextWidget(
                                      text: widget.tripSubTyp == "I"
                                          ? '\t\t${onward?.values?.flightDetail![0].dest}\t'
                                          : '\t\t${returnData?.values?.flightDetail?.dest}\t',
                                      size: text_font_medium16_size,
                                      weight: FontWeight.w700,
                                      color: black_color,
                                    ),
                                    new SvgPicture.asset(
                                      ImageConstants.flt_path,
                                      color: black_color,
                                      width: 14,
                                    ),
                                    TextWidget(
                                      text: widget.tripSubTyp == "I"
                                          ? '\t\t${onward?.values?.flightDetail![0].src}\t'
                                          : '\t${returnData?.values?.flightDetail?.src}',
                                      size: text_font_medium16_size,
                                      color: black_color,
                                      weight: FontWeight.w700,
                                    ),
                                  ],
                                ),
                                widget.tripSubTyp == "I"
                                    ? TextWidget(
                                        text: _bndsRet["stp"] == 0
                                            ? "${_dateFormat(_bndsRet["ddt"])} | ${_bndsRet["dtym"]} - ${_bndsRet["atym"]} | Non Stop"
                                            : "${_dateFormat(_bndsRet["ddt"])} | ${_bndsRet["dtym"]} - ${_bndsRet["atym"]} | ${_bndsRet["stp"]} Stops",
                                        size: text_font_size_x_small,
                                        color: black_color,
                                      )
                                    : TextWidget(
                                        text: returnData
                                                    ?.values
                                                    ?.flightDetailReturn![0]
                                                    .stp ==
                                                0
                                            ? "${_dateFormat(_bndsDomRet["ddt"])} | ${_bndsDomRet["dtym"]} - ${_bndsDomRet["atym"]} | Non Stop"
                                            : "${_dateFormat(_bndsDomRet["ddt"])} | ${_bndsDomRet["dtym"]} - ${_bndsDomRet["atym"]} | ${returnData?.values?.flightDetailReturn![0].stp} Stops",
                                        size: text_font_size_x_small,
                                        color: black_color,
                                      ),
                                widget.tripSubTyp == "I"
                                    ? TextWidget(
                                        text:
                                            "${_bndsRet["lgs"][0]["cbn"]} - ${onward?.values?.flightDetail![0].ref == "false" ? "Non Refundable" : "Refundable"}",
                                        size: text_font_size_x_small,
                                        color: black_color,
                                      )
                                    : TextWidget(
                                        text:
                                            "${_bndsDomRet["lgs"][0]["cbn"]} - ${returnData?.values?.flightDetailReturn![0].ref == "false" ? "Non Refundable" : "Refundable"}",
                                        size: text_font_size_x_small,
                                        color: black_color,
                                      )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsCopyPage(
                        widget.flightRequestHolder,
                        widget.tripTyp,
                        guestData: widget.guestData,
                        paymentTyp: widget.paymentTyp,
                        tripSubTyp: widget.tripSubTyp,
                        flightDetailsModel: widget.flightDetailsModel,
                        returnJrnyDetailsFlightModel:
                            widget.returnJrnyDetailsFlightModel,
                        baseprice: widget.baseprice,
                        taxprice: widget.taxprice,
                        totatPrice: widget.totatPrice,
                      ),
                    ));
              },
              child: Container(
                color: white_text_color,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: black_color),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Center(
                        child: TextWidget(
                      text: 'VIEW FLIGHT DETAILS',
                      size: text_font_medium17_size,
                      color: black_color,
                      weight: FontWeight.bold,
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget travellerdetails(List _guestInfo) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 11, 15, 11),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: TextWidget(
                              text:
                                  "Traveller - ${_guestInfo[0]["details"][0]["first_name"]} ${_guestInfo[0]["details"][0]["last_name"]}",
                              size: text_font_medium14_size,
                              softwrap: true,
                              weight: FontWeight.w500,
                              maxLines: 2,
                            ),
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: isExpanded ? 0 : 2,
                          child: new SvgPicture.asset(
                            ImageConstants.flt_uparrow,
                            color: blue_color,
                            width: 13,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
              isExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        left: 15,
                        right: 15,
                      ),
                      child: DottedLine(
                        direction: Axis.horizontal,
                        lineLength: MediaQuery.of(context).size.width / 1,
                        lineThickness: 1.0,
                        dashLength: 2.0,
                        dashColor: Colors.grey.shade300,
                        dashGapLength: 2.0,
                        dashGapColor: white_text_color,
                      ))
                  : new Container(),
              isExpanded
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 11, 15, 11),
                      child: new Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 7),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextWidget(
                                    text: "Email",
                                    size: text_font_size_x_small,
                                    color: Colors.grey[700],
                                  ),
                                  TextWidget(
                                    text: "${_guestInfo[0]["email_id"]}",
                                    size: text_font_size_x_small,
                                    weight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                  new SizedBox(
                                    height: 15,
                                  ),
                                  TextWidget(
                                    text: "Mobile",
                                    size: text_font_size_x_small,
                                    color: Colors.grey[700],
                                  ),
                                  TextWidget(
                                      text:
                                          '${_guestInfo[0]["country_code"]} ${_guestInfo[0]["contact_no"]}',
                                      size: text_font_size_x_small,
                                      weight: FontWeight.w600,
                                      color: Colors.grey[700])
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 12),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextWidget(
                                    text: 'Date of Birth',
                                    size: text_font_size_x_small,
                                    color: Colors.grey[700],
                                  ),
                                  TextWidget(
                                      text:
                                          "${_guestInfo[0]["details"][0]["dob"]}",
                                      size: text_font_size_x_small,
                                      weight: FontWeight.w600,
                                      color: Colors.grey[700]),
                                  new SizedBox(
                                    height: 15,
                                  ),
                                  TextWidget(
                                      text: 'Passport No.',
                                      size: text_font_size_x_small,
                                      color: Colors.grey[700]),
                                  TextWidget(
                                      text:
                                          "${_guestInfo[0]["details"][0]["passport_no"]}",
                                      size: text_font_size_x_small,
                                      weight: FontWeight.w600,
                                      color: Colors.grey[700]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : new Container(),
              isExpanded
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 7, 15, 11),
                      child: TextWidget(
                        text:
                            'Booking details will be sent to the mentioned email ID and mobile number.',
                        size: text_font_size_x_small,
                        color: Color(0XFF47453C),
                      ),
                    )
                  : new Container(),
            ],
          )),
    );
  }

  Widget baggagePolicy(String? bnds) {
    var _details = jsonDecode(bnds!);
    return InkWell(
      onTap: () {
        setState(() {});
        if (_baggageShow == true) {
          _baggageShow = false;
        } else {
          _baggageShow = true;
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: Container(
            decoration: BoxDecoration(
              color: white_text_color,
              borderRadius: BorderRadius.circular(3),
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 11, 15, 8),
                  child: new GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextWidget(
                          text: "Baggage Policy",
                          size: text_font_medium14_size,
                          weight: FontWeight.w800,
                        ),
                        RotatedBox(
                          quarterTurns: _baggageShow ? 1 : 2,
                          child: new SvgPicture.asset(
                            ImageConstants.flt_uparrow,
                            color: blue_color,
                            width: 13,
                          ),
                        )
                      ],
                    ),
                    onTap: () {},
                  ),
                ),
                _baggageShow
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 11, 15, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: new SvgPicture.asset(
                                    ImageConstants.flt_suitcase,
                                    color: blue_color,
                                    width: 13,
                                  ),
                                ),
                                TextWidget(
                                  text: "Check in",
                                  size: text_font_size_x_small,
                                  weight: FontWeight.w800,
                                ),
                              ],
                            ),
                            TextWidget(
                              text: "${_details["lgs"][0]["bgwgt"]} "
                                  "${_details["lgs"][0]["bgut"]}",
                              size: text_font_size_x_small,
                              weight: FontWeight.bold,
                            )
                          ],
                        ),
                      )
                    : Container(
                        height: 0,
                      ),
                _baggageShow
                    ? Padding(
                        padding: const EdgeInsets.only(
                          top: 5.0,
                          left: 15,
                          right: 15,
                        ),
                        child: DottedLine(
                          direction: Axis.horizontal,
                          lineLength: MediaQuery.of(context).size.width / 1,
                          lineThickness: 1.0,
                          dashLength: 2.0,
                          dashColor: Colors.grey.shade300,
                          dashGapLength: 2.0,
                          dashGapColor: white_text_color,
                        ))
                    : Container(
                        height: 0,
                      ),
                _baggageShow
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 11, 15, 11),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: new SvgPicture.asset(
                                    ImageConstants.flt_luggage,
                                    color: blue_color,
                                    width: 17,
                                  ),
                                ),
                                TextWidget(
                                  text: "Cabin",
                                  size: text_font_size_x_small,
                                  weight: FontWeight.bold,
                                )
                              ],
                            ),
                            TextWidget(
                              text: "7 Kg",
                              size: text_font_size_x_small,
                              weight: FontWeight.bold,
                            )
                          ],
                        ),
                      )
                    : Container(
                        height: 0,
                      ),
              ],
            )),
      ),
    );
  }

  Widget refundPolicy() {
    return InkWell(
      onTap: () {
        setState(() {});
        if (_refundable == false) {
          _refundable = true;
        } else {
          _refundable = false;
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        child: Container(
            decoration: BoxDecoration(
              color: white_text_color,
              borderRadius: BorderRadius.circular(3),
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 11, 15, 8),
                  child: new GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextWidget(
                          text: "Refund Policy",
                          size: text_font_medium14_size,
                          weight: FontWeight.w800,
                        ),
                        RotatedBox(
                          quarterTurns: _refundable ? 1 : 2,
                          child: new SvgPicture.asset(
                            ImageConstants.flt_uparrow,
                            color: blue_color,
                            width: 13,
                          ),
                        )
                      ],
                    ),
                    onTap: () {},
                  ),
                ),
                _refundable
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(15.0, 11, 15, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: blue_color,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              // width: 97,
                              height: 25,
                              child: Center(
                                  child: TextWidget(
                                text: widget.tripTyp == "1" ||
                                        widget.tripSubTyp == "I"
                                    ? _flightDetailsModel?.values
                                                ?.flightDetail![0].ref ==
                                            "false"
                                        ? "Non Refundable"
                                        : "Refundable"
                                    : _returnJrnyDetailsFlightModel
                                                ?.values?.flightDetail?.ref ==
                                            "false"
                                        ? "Non Refundable"
                                        : "Refundable",
                                size: text_font_size_x_small,
                                color: white_text_color,
                                weight: FontWeight.w600,
                              )),
                            )
                          ],
                        ),
                      )
                    : Container(
                        height: 0,
                      ),
              ],
            )),
      ),
    );
  }

  Widget earnBounz() {
    return widget.paymentTyp == "cash"
        ? Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Container(
                decoration: BoxDecoration(
                  color: white_shade,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 5, 10, 15),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextWidget(
                        text: "Earn ",
                        size: text_font_medium16_size,
                        color: grey_color,
                        weight: FontWeight.w600,
                      ),
                      TextWidget(
                        text: widget.tripTyp == "1" || widget.tripSubTyp == "I"
                            ? "${gemsPointsFormatter(_flightDetailsModel?.values?.flightDetail![0].bnzAccrPnts![0])} GEMS Points"
                            : "${gemsPointsFormatter((_returnJrnyDetailsFlightModel!.values!.flightDetail!.bnzAccrPnts![0]) + _returnJrnyDetailsFlightModel!.values!.flightDetailReturn![0].bnzAccrPnts![0])} GEMS Points",
                        size: text_font_medium16_size,
                        color: blue_color,
                        weight: FontWeight.w700,
                      )
                    ],
                  ),
                )),
          )
        : SizedBox(
            height: 0,
          );
  }

  Widget _fareBrkup(int? conFeeOnwrd, int? conFeeRtn, int? onbfr, int? retbfr,
      int? ontax, int? rettax, int? onttl, int? retttl) {
    var _totalConFee = conFeeOnwrd! + conFeeRtn!;
    var _totalBP = onbfr! + retbfr!;
    var _totalTax = ontax! + rettax!;
    var _totalTP = onttl! + retttl!;
    return Container(
      height: 250,
      color: white_text_color,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                color: grey600_color.withOpacity(0.6),
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
                color: grey600_color.withOpacity(0.6),
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
                color: grey600_color.withOpacity(0.6),
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
                color: grey600_color.withOpacity(0.6),
                size: text_font_medium16_size,
              ),
              TextWidget(
                text: widget.paymentTyp == "cash"
                    ? "AED ${gemsPointsFormatter(_totalTP)}"
                    : widget.tripTyp == "1" || widget.tripSubTyp != "D"
                        ? "${gemsPointsFormatter(_flightDetailsModel?.values?.flightDetail![0].bnzReddemPnts![0])} GEMS Points"
                        : "${gemsPointsFormatter(_returnJrnyDetailsFlightModel!.values!.flightDetail!.bnzReddemPnts![0] + _returnJrnyDetailsFlightModel!.values!.flightDetailReturn![0].bnzReddemPnts![0])} Gems Points",
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
                      color: grey600_color.withOpacity(0.6),
                      size: text_font_medium16_size,
                    ),
                    TextWidget(
                      text: widget.tripTyp == "1" || widget.tripSubTyp != "D"
                          ? "${gemsPointsFormatter(_flightDetailsModel?.values?.flightDetail![0].bnzAccrPnts![0])} GEMS Points"
                          : "${gemsPointsFormatter(_returnJrnyDetailsFlightModel!.values!.flightDetail!.bnzAccrPnts![0] + _returnJrnyDetailsFlightModel!.values!.flightDetailReturn![0].bnzAccrPnts![0])} GEMS Points",
                      weight: FontWeight.bold,
                      color: blue,
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

  String _amtText() {
    return widget.paymentTyp == "cash"
        ? 'AED ${this.widget.tripTyp == "1" || widget.tripSubTyp == "I" ? gemsPointsFormatter(_flightDetailsModel?.values?.flightDetail![0].totalPrice) : gemsPointsFormatter((_returnJrnyDetailsFlightModel?.values?.flightDetail?.totalPrice ?? 0) + (_returnJrnyDetailsFlightModel?.values?.flightDetailReturn![0].totalPrice ?? 0))} '
        : widget.tripTyp == "1" || widget.tripSubTyp != "D"
            ? "${gemsPointsFormatter(_flightDetailsModel?.values?.flightDetail![0].bnzReddemPnts![0])} GEMS Points "
            : "${gemsPointsFormatter(_returnJrnyDetailsFlightModel!.values!.flightDetail!.bnzReddemPnts![0] + _returnJrnyDetailsFlightModel!.values!.flightDetailReturn![0].bnzReddemPnts![0])} GEMS Points ";
  }

  String _travellercountText() {
    return "For "
        "${this.widget.guestData.adultNumber} "
        "${this.widget.guestData.adultNumber > 1 ? "Adults " : "Adult "}"
        "${widget.guestData.childNumber > 0 ? widget.guestData.childNumber : ""}"
        "${widget.guestData.childNumber > 1 ? " Children " : widget.guestData.childNumber == 1 ? " Child " : ""}";
  }

  Widget bookNow() {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: _pgLoader
            ? Center(
                child: SpinKitCircle(
                color: blue_color,
              ))
            : GradientButtonWidget(
                height: 50,
                onTap: () async {
                  // _pgLoader = true;
                  if (_payWithPoint == true && _pointController.text == "") {
                    setState(() {
                      enteramount = true;
                    });
                  } else if (redeemorethanpoints == true) {
                  } else {
                    if (_ispriceChange == true) {
                      setState(() {
                        _pgLoader = true;
                        initPGapiCall();
                      });
                    } else {
                      await DialogAlert.proceedTrnxAlert(context).then((value) {
                        if (value == 'yes') {
                          setState(() {
                            _pgLoader = true;
                          });
// else{
                          setState(() {
                            enteramount = false;
                            redeemorethanpoints = false;
                          });
                          // initPGapiCall();
// }
                          setState(() {
                            initPGapiCall();
                          });
                        }
                      });
                    }
                    // setState(() {});
                  }
                },
                // shadowColor: BoxShadow(
                //     color: text_color.withOpacity(0.1),
                //     offset: new Offset(0, 10.0),
                //     blurRadius: 10.0,
                //     spreadRadius: 2.0),
                child: TextWidget(
                  text: 'Book Now',
                  size: text_font_medium17_size,
                  color: white_text_color,
                  weight: FontWeight.w600,
                ),
              ));
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
    }
    _pgLoader = false;
    setState(() {});
  }

  showPricepopUp(oldAmount, flightCreateOrderModal, transactionType) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return PopScope(
          canPop: false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Container(
                  margin: EdgeInsets.only(top: 20, left: 15, right: 15),
                  height: 180,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextWidget(
                            text: "Previous Price :",
                            size: text_font_medium16_size,
                            weight: FontWeight.w600,
                          ),
                          TextWidget(
                            text:
                                // paymentTyp == "cash" ?
                                "AED ${(oldAmount)}",
                            // : "$previousPrice BOUNZ",
                            size: text_font_medium16_size,
                            weight: FontWeight.w600,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextWidget(
                            text: "Revised Price :",
                            size: text_font_medium16_size,
                            weight: FontWeight.w600,
                          ),
                          TextWidget(
                            text: //paymentTyp == "cash"?

                                "AED ${gemsPointsFormatter(flightCreateOrderModal.values?.newamount)}",
                            // : "$revisedPrice BOUNZ",
                            size: text_font_medium16_size,
                            weight: FontWeight.w600,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextWidget(
                        text:
                            "Do you still wish to continue with your booking?",
                        size: text_font_medium16_size,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                                gradient: gradient_theme_color,
                                borderRadius: BorderRadius.circular(30)),
                            child: MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                  Navigator.pop(context, true);
                                  Navigator.pop(context, true);
                                  Navigator.pop(context, true);
                                  Navigator.pop(context, true);
                                },
                                child: TextWidget(
                                  text: "No",
                                  color: white_text_color,
                                  size: text_font_medium14_size,
                                  weight: FontWeight.bold,
                                )),
                          ),
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                                gradient: gradient_theme_color,
                                borderRadius: BorderRadius.circular(30)),
                            child: MaterialButton(
                                onPressed: () {
                                  // Navigator.pop(context, true);
                                  if (transactionType == "RD") {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FlightBookingConfirmationPage(
                                                  brfNo: flightCreateOrderModal
                                                      .values?.brfNo,
                                                  flightRequestHolder: widget
                                                      .flightRequestHolder,
                                                  guestData: widget.guestData,
                                                  flightDetailsModel:
                                                      widget.flightDetailsModel,
                                                )));
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PaymentPage(
                                            finalURL: flightCreateOrderModal
                                                .values?.successUrl,
                                            flowTyp: "FLIGHT",
                                            brf_no: flightCreateOrderModal
                                                .values?.brfNo,
                                            flightRequestHolder:
                                                widget.flightRequestHolder,
                                            guestData: widget.guestData,
                                            flightDetailsModel:
                                                widget.flightDetailsModel,
                                          ),
                                        ));
                                  }
                                },
                                child: TextWidget(
                                  text: "Yes",
                                  color: white_text_color,
                                  size: text_font_medium14_size,
                                  weight: FontWeight.bold,
                                )),
                          )
                        ],
                      )
                    ],
                  )),
            ),
            onPopInvoked: (canPop) async {
              return Future.value(false);
            });
      },
    );
  }

  @override
  Future<void> pgResp(FlightCreateOrderModal flightCreateOrderModal) async {
    if (flightCreateOrderModal.message == "timeout") {
      await Navigator.of(context).pushNamed('/timeoutpage');
    } else {
      setState(() {
        _pgLoader = false;
      });
      if (flightCreateOrderModal.status == true) {
        var oldAmount = this.widget.tripTyp == "1" || widget.tripSubTyp == "I"
            ? gemsPointsFormatter(
                _flightDetailsModel?.values?.flightDetail![0].totalPrice ?? 0)
            : gemsPointsFormatter((_returnJrnyDetailsFlightModel
                        ?.values?.flightDetail?.totalPrice ??
                    0) +
                (_returnJrnyDetailsFlightModel
                        ?.values?.flightDetailReturn![0].totalPrice ??
                    0));
        print(flightCreateOrderModal.values?.priceChanged);

        if (flightCreateOrderModal.values?.transactionType == "RD") {
          if (flightCreateOrderModal.values?.priceChanged == "true") {
            _ispriceChange = true;
            showPricepopUp(oldAmount, flightCreateOrderModal, "RD");
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FlightBookingConfirmationPage(
                          brfNo: flightCreateOrderModal.values?.brfNo,
                          flightRequestHolder: widget.flightRequestHolder,
                          guestData: widget.guestData,
                          flightDetailsModel: widget.flightDetailsModel,
                        )));
          }
        } else {
          if (flightCreateOrderModal.values?.priceChanged == "true") {
            _ispriceChange = true;
            showPricepopUp(oldAmount, flightCreateOrderModal, "");
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(
                    finalURL: flightCreateOrderModal.values?.successUrl,
                    flowTyp: "FLIGHT",
                    brf_no: flightCreateOrderModal.values?.brfNo,
                    flightRequestHolder: widget.flightRequestHolder,
                    guestData: widget.guestData,
                    flightDetailsModel: widget.flightDetailsModel,
                  ),
                ));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg:
                "${flightCreateOrderModal.error!.message ?? "Something went wrong!"}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: grey_background);
      }
    }
  }
}
