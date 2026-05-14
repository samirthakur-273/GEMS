/*/###############################################
Author: Jyoti Gite
Description: Hotel Review Page
Date:2-05-2022 

###############################################*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/checkinternet.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/giftcard_module/Paymentpage_webview/paymentpage.dart';
import 'package:gems_revamp/hotel_module/hotel_review/presenter_hotelreview.dart';
import 'package:gems_revamp/hotel_module/hotel_review/view_hotelreview.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_details/hotel_purchase_details_page.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/dialogAlert.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:gems_revamp/utils/time_out.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ReviewHotels extends StatefulWidget {
  final email,
      additionalInfo,
      roomdata,
      earnpoints,
      phoneNumber,
      nationality,
      redempoints,
      title,
      firstname,
      lastname,
      hotelname,
      hoteladd,
      checkin,
      checkout,
      roomno,
      roomid,
      uniqueid,
      cost,
      checkinTime,
      checkoutTime,
      roomdetails,
      specialreq,
      roomtype,
      redeemrate;

  ReviewHotels(
      {Key? key,
      this.email,
      this.phoneNumber,
      this.nationality,
      this.title,
      this.firstname,
      this.lastname,
      this.hotelname,
      this.checkin,
      this.checkout,
      this.roomtype,
      this.roomno,
      this.uniqueid,
      this.roomid,
      this.hoteladd,
      this.earnpoints,
      this.redempoints,
      this.cost,
      this.roomdata,
      this.checkinTime,
      this.checkoutTime,
      this.roomdetails,
      this.specialreq,
      this.additionalInfo,
      this.redeemrate})
      : super(key: key);
  @override
  _ReviewHotelsState createState() => _ReviewHotelsState();
}

class _ReviewHotelsState extends State<ReviewHotels>
    implements ReviewDetailView {
  var redempoints = 12000, noofroom, noofguest;
  var redeemrate = 10;
  var _pointController = TextEditingController();
  var _redemptionRate;
  var payableGemsPoints;
  var details;
  var _payWithBounz;
  var chekRadio = 0;
  bool checkAED = false;
  // String bounz = "0";
  bool _showadditionalinfo = false;
  bool checkTerms = false, _isloading = false;
  bool _checkLimit = false;
  bool _onchange = false;
  String roomname = '';
  String additionalinfo = '';
  String tobereplaced = '';
  bool _payWithAED = false;
  bool _payWithPoint = true;
  int _points = 0;
  int aedAmt = 0;
  ReviewPresenter? reviewPresenter;

  _calculationToAed(redeemPoints) {
    if (redeemPoints < payableGemsPoints) {
      if (redeemPoints < GemsGLobals.pointbalance) {
        aedAmt = ((payableGemsPoints - redeemPoints) / _redemptionRate).ceil();
      } else {
        aedAmt =
            ((payableGemsPoints - GemsGLobals.pointbalance) / _redemptionRate)
                .ceil();
      }
    } else if (this.widget.redempoints < GemsGLobals.pointbalance) {
      aedAmt = this.widget.cost;
    }

    return aedAmt;
  }

  _calculateAEDwithPoints(redeemPoints) {
    if (_pointController.text.isNotEmpty && redeemPoints <= payableGemsPoints) {
      if (redeemPoints <= GemsGLobals.pointbalance) {
        _points = redeemPoints;
      } else {
        _points = GemsGLobals.pointbalance;
      }
    } else {
      if (payableGemsPoints <= GemsGLobals.pointbalance) {
        _points = payableGemsPoints;
      } else {
        _points = GemsGLobals.pointbalance;
      }
    }

    int _calculatAed = ((redeemPoints - _points) * _redemptionRate).ceil();

    return _calculatAed;
  }

  void changechildtag(children) {
    setState(() {
      for (final node in children) {
        if (node.localName.toString() == 'ul') {
          String data = '<li>' + node.text + '</li>';
          String info = tobereplaced.replaceAll(node.text, data);

          tobereplaced = info;
        } else if (node.localName.toString() == 'li') {
          String data = '<li>' + node.text + '</li>';
          String info = tobereplaced.replaceAll(node.text, data);

          tobereplaced = info;
        } else {
          tobereplaced = tobereplaced + node.text;
        }
      }
    });
  }

  void checkAdditionalInfo() {
    final document = html_parser.parseFragment("this.widget.additionalInfo");
    /* check html string is valid */

    setState(() {
      additionalinfo = '';
      tobereplaced = '';
      if (document != null) {
        additionalinfo =
            "Hotel Occupancy Policy \n All rooms,booked for single occupancy(i.e.1 adult)";
        for (final node in document.children) {
          var tag = node.localName.toString();

          if (tag == 'ul') {
            tobereplaced = '';
            tobereplaced = tobereplaced + '<ul>' + node.text + '</ul>';

            changechildtag(node.children);
            tobereplaced = tobereplaced + '</ul>';

            additionalinfo = additionalinfo.replaceAll(node.text, tobereplaced);
          } else if (tag == 'li') {
            tobereplaced = '';

            tobereplaced = tobereplaced + '<ul>' + node.text;

            changechildtag(node.children);
            tobereplaced = tobereplaced + '</ul>';
            additionalinfo = additionalinfo.replaceAll(node.text, tobereplaced);
          } else {
            tobereplaced = '';

            tobereplaced = tobereplaced + node.text;
            additionalinfo = additionalinfo.replaceAll(node.text, tobereplaced);
          }
        }
      }
    });
  }

  void _internet() async {
    CheckInternet().apiCall().then((value) => {
          if (value == true)
            {
              setState(() {}),
              reviewPresenter!.reviewdetail(details),
            }
          else
            {
              setState(() {
                _isloading = false;
              }),
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => NoInternet()))
                  .then((value) {
                // setState(() {
                //   _isloading = true;
                // });
                // reviewPresenter.reviewdetail(details);
              }),
            }
        });
  }

  @override
  void initState() {
    super.initState();
    _redemptionRate = widget.redeemrate;
    setState(() {
      //  bounz = GemsGLobals.pointbalance ?? "0";
      _isloading = false;
    });
    reviewPresenter = ReviewPresenter(this);
    // if(GemsGLobals.mop != 'cash'){
    if (this.widget.redempoints <= GemsGLobals.pointbalance) {
      _pointController.text = this.widget.cost.toString();
      payableGemsPoints = this.widget.cost;
    } else {
      _pointController.text = GemsGLobals.pointbalance.toString();
      payableGemsPoints = this.widget.cost;
    }
    // }
    // else{
    //   _pointController.text = '0';
    // }

    _addRoomName();
    checkAdditionalInfo();
  }

/* add room names */
  void _addRoomName() {
    for (int i = 0; i < this.widget.roomdata['rooms'].length; i++) {
      if (i == 0) {
        roomname =
            '${this.widget.roomdata['rooms'][i]['roomName']} (${(this.widget.roomdata['rooms'][i]['is_refundable'] ? 'Refundable' : 'Non-refundable')})';
      } else {
        roomname = roomname +
            ',  ${this.widget.roomdata['rooms'][i]['roomName']} (${(this.widget.roomdata['rooms'][i]['is_refundable'] ? 'Refundable' : 'Non-refundable')})';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _appbar() {
      return Container(
        decoration: BoxDecoration(gradient: gradient_theme_color),
        height: Platform.isIOS ? 100 : 90,
        width: MediaQuery.of(context).size.width,
        child: GradientAppBar(
          centerTitle: true,
          title: 'Review your stay',
          size: 18.5,
          weight: FontWeight.w500,
        ),
      );
    }

/* Available bounz */
    Widget _bounzAvailable() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: white_text_color),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextWidget(
                  text: "Gems Points Available",
                  size: text_font_medium14_size,
                  color: grey_color,
                ),
                Row(
                  children: <Widget>[
                    TextWidget(
                      text: "${GemsGLobals.pointbalance}",
                      size: text_font_medium17_size,
                      weight: FontWeight.w600,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: TextWidget(
                        text: " GEMS",
                        size: text_font_medium16_size,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Spacer(),
          ],
        ),
      );
    }

/* review hotel and user details */
    Widget _reviewDetail() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: white_text_color),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextWidget(
              text: "${this.widget.hotelname}",
              size: text_font_medium15_size,
              color: black_color,
              weight: FontWeight.w600,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: TextWidget(
                text: '${this.widget.hoteladd}',
                size: text_font_medium15_size,
                color: grey_color,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextWidget(
              text:
                  "${(this.widget.title)}. ${(this.widget.firstname)} ${(this.widget.lastname)}",
              size: text_font_medium15_size,
              color: black_color,
              weight: FontWeight.w600,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: TextWidget(
                text: "+${this.widget.nationality}\t" +
                    this.widget.phoneNumber +
                    ", " +
                    this.widget.email,
                size: text_font_medium14_size,
                color: grey_color,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextWidget(
                      text: '$roomname',
                      size: text_font_medium14_size,
                      color: grey_color,
                    ),
                  ),
                  TextWidget(
                    text: 'Guests x ${GemsGLobals.guestcount}',
                    size: text_font_medium14_size,
                    color: grey_color,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      text: "Check-In",
                      size: text_font_medium15_size,
                      color: grey_color,
                      weight: FontWeight.w500,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: TextWidget(
                        text:
                            '${DateFormat("dd MMM,").format(this.widget.checkin)}${this.widget.checkinTime}',
                        size: text_font_medium15_size,
                        color: black_color,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      text: "Check-Out",
                      size: text_font_medium15_size,
                      color: grey_color,
                      weight: FontWeight.w500,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: TextWidget(
                        text:
                            '${DateFormat("dd MMM,").format(this.widget.checkout)}${this.widget.checkoutTime}',
                        size: text_font_medium15_size,
                        color: black_color,
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      );
    }

/* Additional info widget */
    Widget _additionalInfo() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: white_text_color),
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                setState(() {
                  if (!_showadditionalinfo) {
                    _showadditionalinfo = true;
                  } else {
                    _showadditionalinfo = false;
                  }
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 11, 1, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextWidget(
                          text: "Additional Information",
                          size: text_font_medium16_size,
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2, 11, 1, 8),
                    child: RotatedBox(
                      quarterTurns: _showadditionalinfo ? 4 : 3,
                      child: new SvgPicture.asset(
                        ImageConstants.downarrow,
                        color: black_color,
                        width: 15,
                      ),
                    ),
                  )
                ],
              ),
            ),
            _showadditionalinfo
                ? new Container(
                    child: new Center(
                      child: Html(
                        data: additionalinfo,
                        style: {
                          "li": Style(
                              fontFamily: 'Sans_Pro',
                              fontSize: FontSize.medium),
                          "ul": Style(
                              fontFamily: 'Sans_Pro',
                              fontSize: FontSize.medium),
                        },
                      ),
                    ),
                  )
                : new Container(),
          ],
        ),
      );
    }

    _pointConv(amount) {
      var convAmount = amount - GemsGLobals.pointbalance;
      var paybleAmount = (convAmount / widget.redeemrate).ceil();
      return paybleAmount;
    }

    Widget _paybycashandpoints() {
      return Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            GemsGLobals.pointbalance != 0
                ? Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: "Redeemable Points",
                        ),
                        TextWidget(
                          text: "${GemsGLobals.pointbalance} GEMS points",
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
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: "Payable Amount",
                  ),
                  _pointController.text.isEmpty
                      ? TextWidget(
                          text:
                              "AED ${pointsFormatter(_pointConv(this.widget.cost))}",
                          weight: FontWeight.w600,
                        )
                      : TextWidget(
                          text:
                              "AED ${_calculationToAed(int.parse(_pointController.text))}",
                          weight: FontWeight.w600,
                        )
                ],
              ),
            )
          ],
        ),
      );
    }

/* book your stay button */
    Widget _booknow() {
      return Container(
        height: MediaQuery.of(context).size.height / 2.8,
        color: white_text_color,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          children: <Widget>[
            (this.widget.redempoints <= GemsGLobals.pointbalance)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: GemsGLobals.mop == 'cash'
                                ? "Amount payable "
                                : 'GEMS debited',
                            size: text_font_medium15_size,
                            color: text_color,
                          ),
                          TextWidget(
                            text: GemsGLobals.mop == 'cash'
                                ? "AED ${pointsFormatter(this.widget.cost)}"
                                : (_onchange &&
                                        _pointController.text.isNotEmpty &&
                                        GemsGLobals.pointbalance >
                                            int.parse(_pointController.text))
                                    ? (_pointController.text)
                                    : "\t${pointsFormatter(this.widget.cost)}",
                            size: text_font_medium17_size,
                            color: black_color,
                            weight: FontWeight.w600,
                          )
                        ],
                      ),
                      GemsGLobals.mop ==
                              'cash' //&& GemsGLobals.pointbalance != 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                TextWidget(
                                  text: "Earn upto",
                                  color: black_color,
                                  size: text_font_medium15_size,
                                ),
                                TextWidget(
                                  text:
                                      "${pointsFormatter(this.widget.earnpoints)} GEMS Points",
                                  color: black_color,
                                  size: 17,
                                  weight: FontWeight.w600,
                                ),
                              ],
                            )
                          : (_pointController.text.isNotEmpty &&
                                      GemsGLobals.mop == 'redeem') ||
                                  (_pointController.text.isNotEmpty &&
                                      payableGemsPoints >
                                          int.parse(_pointController.text))
                              ? Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextWidget(
                                        text: "Payable Amount",
                                        size: text_font_medium15_size,
                                      ),
                                      TextWidget(
                                        text:
                                            "AED ${_calculationToAed(int.parse(_pointController.text))}",
                                        size: text_font_medium17_size,
                                        color: black_color,
                                        weight: FontWeight.w600,
                                      )
                                    ],
                                  ),
                                )
                              : new Container(
                                  height: 0,
                                )
                    ],
                  )
                : _paybycashandpoints(),
            (GemsGLobals.referralRelationType != GemsGLobals.spouseValue &&
                        GemsGLobals.referralRelationType !=
                            GemsGLobals.childValue) &&
                    GemsGLobals.mop != 'cash' //redeem
                ? Container(
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
                              } else {
                                _payWithPoint = true;
                              }
                            });
                          },
                          child: Container(
                              height: 25,
                              width: 25,
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5, color: black_color),
                                  shape: BoxShape.circle),
                              child: _payWithPoint
                                  ? SvgPicture.asset(
                                      ImageConstants.select,
                                    )
                                  : Container(
                                      // child: SvgPicture.asset(
                                      //   ImageConstants.unselect,
                                      //   height: 25,
                                      // ),
                                      )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 7),
                          child: TextWidget(
                            text: 'Pay with ',
                            color: _payWithPoint ? black_color : shadow_color,
                            size: text_font_medium14_size,
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
                                      ? grey600_color.withAlpha((0.5 * 255).toInt())
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
                                  style: TextStyle(
                                      color: black_color,
                                      fontSize: text_font_medium15_size,
                                      fontWeight: FontWeight.bold),
                                  onChanged: (text) {
                                    setState(() {
                                      _onchange = true;
                                    });

                                    if (_pointController.text.isNotEmpty &&
                                        int.parse(_pointController.text) <=
                                            payableGemsPoints) {
                                      _calculationToAed(
                                          int.parse(_pointController.text));
                                      _calculateAEDwithPoints(
                                          int.parse(_pointController.text));
                                      _checkLimit = false;
                                    } else {
                                      _checkLimit = false;
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
                              : TextWidget(
                                  text: _pointController.text,
                                  color: shadow_color,
                                  weight: FontWeight.bold,
                                  size: text_font_medium15_size,
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: TextWidget(
                            text: 'Gems Points',
                            color: _payWithPoint ? black_color : shadow_color,
                            weight: FontWeight.w600,
                            size: text_font_medium15_size,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            _checkLimit == true
                ? Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 50, right: 20),
                    child: TextWidget(
                      text:
                          'The entered GEMS Points must be within your available GEMS Points balance and required total amount',
                      color: red_color,
                      size: 13,
                      softwrap: true,
                      maxLines: 4,
                      weight: FontWeight.w500,
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
            _pointController.text.isEmpty &&
                    _checkLimit == false &&
                    _payWithPoint == true
                ? Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 50, right: 20),
                    child: TextWidget(
                      text: 'Please enter amount',
                      color: red_color,
                      size: 13,
                      softwrap: true,
                      maxLines: 4,
                      weight: FontWeight.w500,
                    ),
                  )
                : SizedBox(
                    height: 0,
                  ),
            // SizedBox(
            //   height: 10,
            // ),
            // (_pointController.text.isNotEmpty && GemsGLobals.mop == 'redeem') ||
            //         (payableGemsPoints > int.parse(_pointController.text))
            //     ? Container(
            //         alignment: Alignment.center,
            //         child: TextWidget(
            //           text:
            //               '& AED ${_calculationToAed(int.parse(_pointController.text))} in Cash',
            //           color: black_color,
            //           weight: FontWeight.w600,
            //           size: text_font_medium15_size,
            //         ),
            //       )
            //     : SizedBox(
            //         height: 0,
            //       ),
            _isloading == true
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Container(
                        child: SpinKitCircle(
                      color: btn_bg_color,
                    )),
                  ))
                : GestureDetector(
                    onTap: () async {
                      if (GemsGLobals.pointbalance <= 40 &&
                          GemsGLobals.mop != 'cash') {
                        Fluttertoast.showToast(
                            msg: GemsGLobals.insufficientGemsPointsMessage,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: grey_background);
                      } else {
                        setState(() {
                          checkTerms = false;
                          // _isloading = true;
                          /* create order request */
                          details = {
                            "country_code": this.widget.nationality,
                            "email": this.widget.email,
                            // "phone_number":"8806836299",
                            "phone_number": this.widget.phoneNumber,
                            "nationality": "IN",
                            "address_line": this.widget.hoteladd,
                            "city": "Mumbai",
                            "state": "Maharashtra",
                            "country": "India",
                            "zipcode": "400086",
                            "ssr_details": this.widget.specialreq ?? '',
                            "mop": '${GemsGLobals.mop}',
                            "redempoints": GemsGLobals.mop != 'cash'
                                ? _payWithPoint == true
                                    ? int.parse(_pointController.text)
                                    : this.widget.redempoints >
                                            GemsGLobals.pointbalance
                                        ? GemsGLobals.pointbalance
                                        : this.widget.redempoints
                                : 0,
                            "prod_type": "HTL",
                            "ccod": "${GemsGLobals.membershipNo}",
                            "rhtl_id": this.widget.uniqueid,
                            "optionid": this.widget.roomno,
                            "rooms": this.widget.roomdetails
                          };
                        });
                        if (GemsGLobals.mop != 'cash' &&
                                _payWithPoint == true &&
                                int.parse(_pointController.text) >
                                    GemsGLobals.pointbalance ||
                            int.parse(_pointController.text) >
                                payableGemsPoints) {
                          _checkLimit = true;
                          setState(() {});
                        } else {
                          _checkLimit = false;
                          await DialogAlert.proceedTrnxAlert(context)
                              .then((value) {
                            if (value == 'yes') {
                              setState(() {
                                _isloading = true;
                              });

                              _internet();
                            }
                          });
                        }
                        // _internet();
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (BuildContext context) =>
                        //             HotelSuccessPage()));
                      }
                    },
                    child: Container(
                      height: 55,
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          gradient: gradient_theme_color,
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: TextWidget(
                            text: "Book Your Stay",
                            color: white_text_color,
                            size: text_font_medium18_size,
                            weight: FontWeight.w500,
                          ),
                        ),
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
          height: MediaQuery.of(context).size.height / 1.4,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 8,
                ),
                if ((GemsGLobals.referralRelationType !=
                            GemsGLobals.spouseValue &&
                        GemsGLobals.referralRelationType !=
                            GemsGLobals.childValue) &&
                    GemsGLobals.mop != 'cash')
                  _bounzAvailable(),
                _reviewDetail(),
                _additionalInfo(),
              ],
            ),
          ),
        );
      } catch (e) {
        return Container();
      }
    }

    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (canPop, result) async {
          if (_isloading) {
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          backgroundColor: bg_color,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(90.0),
            child: _appbar(),
          ),
          // resizeToAvoidBottomInset: false,
          body: Container(
              child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              // _appbar(),
              _body(),
              SingleChildScrollView(child: _booknow()),
              // SizedBox(
              //   height: 200,
              // )
            ],
          )),
          // bottomNavigationBar: _booknow(),
        ));
  }

  void showDialogMessage(String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: ListView(
            shrinkWrap: true,
            children: [
              TextWidget(text: msg),
              Align(
                alignment: Alignment.bottomRight,
                child: MaterialButton(
                  child: TextWidget(
                    text: "OK",
                    color: blue_color,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showPaymentDialogMessage(String msg, brf, pgurl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: ListView(
            shrinkWrap: true,
            children: [
              TextWidget(text: msg),
              Align(
                alignment: Alignment.bottomRight,
                child: MaterialButton(
                  child: TextWidget(
                    text: "OK",
                    color: blue_color,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                            finalURL: pgurl,
                            brf_no: brf,
                          ),
                        )).then((value) {
                      setState(() {
                        _isloading = false;
                      });
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void allErr(error) {
    if (error.toString().contains("TimeoutException")) {
      Navigator.push(context, MaterialPageRoute(builder: (cxt) => TimeOut()));
    }
  }

  var pgUrl = '';
  @override
  Future<void> reviewResponse(reviewDetail) async {
    if (reviewDetail.status == true) {
      setState(() {
        _isloading = false;
      });

      if (reviewDetail.message == "Order Created Successfully.") {
        if (reviewDetail.values?.transactionType == 'RD') {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HotelPurchaseDetailsPage(
                    brf_no: reviewDetail.values?.brfNo),
              )).then((value) {
            setState(() {
              _isloading = false;
            });
          });
        } else if (reviewDetail.values?.transactionType == 'PG' ||
            reviewDetail.values?.transactionType == 'PG_POINTS') {
          pgUrl = reviewDetail.values!.successUrl!;
          if (reviewDetail.values?.transactionType == 'PG_POINTS') {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(
                    finalURL: pgUrl,
                    brf_no: reviewDetail.values?.brfNo,
                  ),
                )).then((value) {
              setState(() {
                if (value == true) {
                  showDialogMessage('Payment Failed');
                }
                _isloading = false;
              });
            });
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(
                    finalURL: pgUrl,
                    brf_no: reviewDetail.values?.brfNo,
                  ),
                )).then((value) {
              setState(() {
                if (value == true) {
                  showDialogMessage('Payment Failed');
                }
                _isloading = false;
              });
            });
          }
        }
      }
    } else if (reviewDetail.status == false) {
      setState(() {
        _isloading = false;
      });
      if (reviewDetail.message != "timeout") {
        if (reviewDetail.message == 'All Rooms are sold out.') {
          showDialogMessage('${reviewDetail.message}\n${reviewDetail.message}');
        } else {
          showDialogMessage('${reviewDetail.message}\nTry again later');
        }
      }

      if (reviewDetail.message == "timeout") {
        var notresponding = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => TimeOut()));

        if (notresponding != null) {
          setState(() {
            _isloading = true;
          });
          _internet();
        } else {
          Navigator.pop(context);
        }
      }
    }
  }
}
