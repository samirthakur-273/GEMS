/*Author:Jyoti Gite
Description:Gift Card Detail Page


date: 25 apr 2022
*/
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/giftcard_module/Paymentpage_webview/paymentpage.dart';
import 'package:gems_revamp/giftcard_module/giftcard_detailspage/giftcard_deatails_model.dart';
import 'package:gems_revamp/giftcard_module/giftcard_detailspage/giftcard_deatails_presenter.dart';
import 'package:gems_revamp/giftcard_module/giftcard_detailspage/giftcard_deatails_view.dart';
import 'package:gems_revamp/giftcard_module/giftcard_detailspage/giftcard_editdetails.dart';
import 'package:gems_revamp/giftcard_module/giftcard_thankupage/giftcard_thankupage.dart';
import 'package:gems_revamp/giftcard_module/pg_module/pg_presenter.dart';
import 'package:gems_revamp/giftcard_module/pg_module/pg_view.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/dialogAlert.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:http/http.dart' as http;

import '../../common_widget/bottombar.dart';

class GiftCardDetailsPage extends StatefulWidget {
  final int brandId;
  final String supplierCode, paymentTyp;
  final String? minValue, maxValue, categoryName, productType, giftCardName;
  GiftCardDetailsPage({
    required this.brandId,
    required this.supplierCode,
    required this.paymentTyp,
    this.minValue,
    this.maxValue,
    this.categoryName,
    this.productType,
    this.giftCardName,
    Key? key,
  }) : super(key: key);

  @override
  State<GiftCardDetailsPage> createState() => _GiftCardDetailsPageState();
}

class _GiftCardDetailsPageState extends State<GiftCardDetailsPage>
    with SingleTickerProviderStateMixin
    implements GiftCardDetailsView, GiftPGInitView {
  // var _pointController = TextEditingController();
  late GiftcardDetailsModal _giftDetailsModal;
  var _pointController = TextEditingController();

  var _payType;
  var chekRadio = 0;
  var noConnection;
  var _earnPoint;
  var _payWithBounz;
  var _currencyconvRate;
  var _currency;
  var _redemptionRate;
  var paywithAmount;
  var checkAmt;
  var bnz_total_amt;
  String _amount = '0';
  bool _selectOption = false;
  bool _payWithAED = false;
  bool cashdata = false;

  bool _isLoading = true;
  bool _noData = false;
  bool _pgLoader = false;
  bool _payWithPoint = false;
  bool _isgiftcard = true;
  bool _isdescription = false;
  bool _isuse = false;
  var _editDetailsResponse;
  late int numberLength;
  var _redeemBounzPoints = 0;
  int _quantityCounter = 1;
  var _earnCalPoints;
  int _redeemCalPoints = 0;

  int _calculatAedAmt = 0;
  bool _checkBNZLimit = false;
  var aedincash = 0;

  @override
  void initState() {
    apiCall();
    _payType = widget.paymentTyp;
    super.initState();
  }

  void apiCall() {
    setState(() {
      Internetconnectivity().isConnected().then((result) async {
        if (result) {
          /*Gift card details Api Call*/
          GiftDetailsPresenter()
              .getGiftcardDetails(this, widget.brandId, widget.supplierCode);
        } else {
          noConnection = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => NoInternet()));
          if (noConnection != null) {
            apiCall();
          } else {
            Navigator.of(context).pop();
          }
        }
      });
    });
  }

  _makesenseEventCall(req, keyName) {
    MakesenseApiClass.makesenseEventsApi(http.Client(), req, keyName);
  }

  _calculationToAed(redeemPoints) {
    int aedAmt = 0;
    if (redeemPoints <= checkAmt) {
      if (redeemPoints <= GemsGLobals.pointbalance) {
        aedAmt = ((checkAmt - redeemPoints) * _redemptionRate).ceil();
      } else {
        aedAmt = redeemPoints * _redemptionRate;

        // ((checkAmt - GemsGLobals.pointbalance) * _redemptionRate).ceil();
      }
    }
    _calculatAedAmt =
        ((_giftDetailsModal.objects!.offerPloughbackFactor / 100) *
                (aedAmt * _giftDetailsModal.objects?.rpm))
            .floor();
    setState(() {});

    return _calculatAedAmt;
  }

  _calculateAEDwithPoints() {
    int _points = 0;
    if (_pointController.text.isNotEmpty &&
        int.parse(_pointController.text) <= checkAmt) {
      if (int.parse(_pointController.text) <= GemsGLobals.pointbalance) {
        _points = int.parse(_pointController.text);
      } else {
        _points = GemsGLobals.pointbalance;
      }
    } else {
      if (checkAmt <= GemsGLobals.pointbalance) {
        _points = checkAmt;
      } else {
        _points = GemsGLobals.pointbalance;
      }
    }

    int _calculatAed = _quantityCounter < 1
        ? ((bnz_total_amt - _points) * _redemptionRate).ceil()
        : (((int.parse(_payWithBounz[chekRadio]) * _quantityCounter) -
                    _points) *
                _redemptionRate)
            .ceil();
    aedincash = _calculatAed;
    return _calculatAed;
  }

  _calculateAEDnopoints() {
    int _calculatAed =
        (((int.parse(_payWithBounz[chekRadio]) * _quantityCounter)) *
                _redemptionRate)
            .round();

    var totalamount =
        ((int.tryParse(_amount)! * _currencyconvRate) * _quantityCounter)
            .ceil();

    _calculatAedAmt =
        ((_giftDetailsModal.objects!.offerPloughbackFactor / 100) *
                (totalamount * _giftDetailsModal.objects?.rpm))
            .floor();

    _earnCalPoints = pointsFormatter(
        ((int.tryParse(_earnPoint[chekRadio]) ?? 0) * _quantityCounter));
    _redeemCalPoints = int.parse(_payWithBounz[chekRadio]) * _quantityCounter;

    return (_payWithPoint && !_payWithAED) ? 0 : _calculatAed;
  }

  /*Payment select base on points & collect - redeem flow */
  _selectPayment() {
    setState(() {
      if (GemsGLobals.referralRelationType != GemsGLobals.spouseValue &&
          GemsGLobals.referralRelationType != GemsGLobals.childValue) {
        if (widget.paymentTyp == 'accrual') {
          _payWithAED = true;
          _payWithPoint = false;
          cashdata = false;
        } else if (GemsGLobals.pointbalance != 0) {
          if (_calculateRedempoints() > (GemsGLobals.pointbalance)) {
            _payWithPoint = true;
            _payWithAED = true;
            _redeemBounzPoints = GemsGLobals.pointbalance;
            cashdata = false;
          }
          //come
          // else if(_calculateAEDwithPoints()>0){
          else if (aedincash > 0) {
            _payWithPoint = true;
            _payWithAED = true;
            cashdata = true;
            _redeemBounzPoints = int.parse(_pointController.text);
          } else {
            _redeemBounzPoints = int.parse(_payWithBounz[chekRadio]);
            _payWithPoint = true;
            _payWithAED = false;
            cashdata = false;
          }
        } else {
          _payWithAED = true;
          _payWithPoint = false;
          cashdata = false;
          Fluttertoast.showToast(
            msg:
                "You don't have sufficient gems points, please continue with cash payment.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
    });
  }

/* calculate points & AED base on card values changes*/
  void _changesCardValueQuantity() {
    if (_payWithPoint == true &&
        _payWithAED == false &&
        int.parse(_payWithBounz[chekRadio]) > (GemsGLobals.pointbalance)) {
      _selectPayment();
    } else if (_payWithPoint == true &&
        _payWithAED == true &&
        int.parse(_payWithBounz[chekRadio]) < (GemsGLobals.pointbalance)) {
      _payWithPoint = true;
      _payWithAED = false;
    }
  }

/* Card value */
  Widget cardValue(String value) {
    var _value;
    _value = value.split(',');

    return Container(
      height: MediaQuery.of(context).size.height / 13,
      child: ListView.builder(
          itemCount: _value != null ? _value.length : 0,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        var segmentReq = {
                          "GC": 'Card value',
                          "Description": _giftDetailsModal.objects?.name ?? '',
                          "How to use": _giftDetailsModal.objects?.name ?? '',
                          "Card value": '${_currency ?? 'AED'} '
                              '${pointsFormatter(int.parse(_value[index]))}',
                          "Quantity": '$_quantityCounter',
                          "GEMS point": '',
                          "Pay now": '',
                          "baCK": "BAck",
                          'int_source': GemsGLobals.lastVisitPageName
                        };
                        String keyName = GemsGLobals.eventGiftcardDetailPage;
                        _makesenseEventCall(segmentReq, keyName);
                        setState(() {
                          chekRadio = index;
                          _amount = _value[index];
                        });

                        paywithAmount =
                            '${(((int.parse(_amount) * _currencyconvRate) * _quantityCounter).round() / _redemptionRate).round()}';
                        if (int.parse(paywithAmount) >
                            GemsGLobals.pointbalance) {
                          _pointController.text =
                              GemsGLobals.pointbalance.toString();
                        } else {
                          _pointController.text = paywithAmount;
                        }

                        // _pointController.text =
                        //     '${(((int.parse(_amount) * _currencyconvRate) * _quantityCounter).round() / _redemptionRate).round()}';
                        checkAmt = int.parse(_pointController.text);
                        bnz_total_amt = int.parse(_pointController.text);
                        _calculationToAed(checkAmt);

                        if (index == chekRadio) {
                          setState(() {
                            _selectOption = true;
                          });
                        } else {
                          setState(() {
                            _selectOption = false;
                            chekRadio = index;
                          });
                        }
                        _changesCardValueQuantity();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.23,
                        height: 42,
                        margin: EdgeInsets.only(right: 20),
                        padding: EdgeInsets.fromLTRB(2, 10, 0, 12),
                        alignment: Alignment.center,
                        decoration: chekRadio == index
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: gradient_theme_color)
                            : BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: grey600_color, width: 0.8)),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: TextWidget(
                            text: '${_currency ?? 'AED'} '
                                '${pointsFormatter(int.parse(_value[index]))}',
                            color: chekRadio == index
                                ? white_text_color
                                : black_color,
                            size: text_font_medium_x_size,
                            weight: FontWeight.w600,
                          ),
                        ),
                      )),
                ],
              ),
            );
          }),
    );
  }

  _deliveredToEmail() {
    if (_editDetailsResponse == null) {
      return GemsGLobals.useremail;
    } else {
      return _editDetailsResponse['email'] ?? '';
    }
  }

  _calculatePayByPonits(redeemPoints) {
    if ((int.parse(_payWithBounz[chekRadio]) * _quantityCounter) >
        (GemsGLobals.pointbalance)) {
      return _payWithPoint == true ? GemsGLobals.pointbalance : 0;
    } else if (_payWithPoint == false) {
      return (((int.parse(_amount) * _currencyconvRate) * _quantityCounter)
                  .ceil() /
              _redemptionRate)
          .ceil();
    } else if (_payWithPoint == true) {
      return (((int.parse(_amount) * _currencyconvRate) * _quantityCounter)
                  .ceil() /
              _redemptionRate)
          .ceil();
    } else {
      return _payWithPoint == true
          ? (((int.parse(_amount) * _currencyconvRate) * _quantityCounter)
                      .ceil() /
                  _redemptionRate)
              .ceil()
          : 0;
    }
  }

  /*payment flow Api Call*/
  void initPGapiCall() {
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        if (GemsGLobals.userType == 'Staff') {
          _payWithPoint = false;
          _payWithAED = true;
        }

        _checkBNZLimit = false;
        setState(() {});
        var _req = {
          'giftcard_id': widget.brandId,
          'denomination_amount': int.parse(_amount), //AEDamount
          'purchase_type': _payType, //_payType,
          'amount': num.parse(
                  (int.parse(_amount) * _currencyconvRate * _quantityCounter)
                      .toStringAsFixed(4))
              .ceil(), // total amount
          'pay_by_points': widget.paymentTyp == "accrual"
              ? 0
              : ((int.parse(_payWithBounz[chekRadio]) * _quantityCounter) >
                          GemsGLobals.pointbalance &&
                      GemsGLobals.pointbalance <
                          int.parse(_pointController.text))
                  ? GemsGLobals.pointbalance
                  : _pointController.text,

          'pay_by_cash': _payType == "accrual"
              ? _calculateAEDnopoints()
              : _calculateAEDwithPoints(),
          // cashdata == true
          //     ? aedincash
          //     : _payWithPoint == true && _payWithAED == true
          //         ? _payableAmount()
          //         : _calculateAEDnopoints(),

          'quantity': _quantityCounter,
          'promocode': '',
          'supplier_code': _giftDetailsModal.objects?.supplierCode ?? '',
          'mode_of_delivery': 'BOTH',
          'gv_url': 'dummyURLhere',
          'customer_first_name': '${GemsGLobals.userFirstName}',
          'customer_last_name': '${GemsGLobals.userLastName}',
          'customer_email': '${GemsGLobals.useremail}',
          'customer_mobile': '${GemsGLobals.mobilenumber ?? 8806836299}',
          'cusomter_country_code': '${GemsGLobals.countryCode ?? 91}',
          'title': 'Mr',
          'receiver_first_name': _editDetailsResponse != null
              ? _editDetailsResponse['firstname']
              : '${GemsGLobals.userFirstName}',
          'receiver_last_name': _editDetailsResponse != null
              ? _editDetailsResponse['lastname']
              : '${GemsGLobals.userLastName}',
          'receiver_email': _editDetailsResponse != null
              ? _editDetailsResponse['email']
              : '${GemsGLobals.useremail}',
          'receiver_mobile': _editDetailsResponse != null
              ? _editDetailsResponse['contactnumber']
              : '${GemsGLobals.mobilenumber ?? 9545633775}',
          'receiver_country_code': _editDetailsResponse != null
              ? _editDetailsResponse['countryCode']
              : '${GemsGLobals.countryCode ?? '91'}',
          'receiver_country': 'India',
          'receiver_pincode': '400001',
          'receiver_designation': 'HR',
          'gv_name': _giftDetailsModal.objects?.name ?? '',
          'logged_in': 1,
          'channel': 'mobile',
          'membership_no': GemsGLobals.membershipNo
          // '8051296889'
        };
        await DialogAlert.proceedTrnxAlert(context).then((value) {
          if (value == 'yes') {
            setState(() {
              _pgLoader = true;
            });

            GiftPGInitPresenter().getList(this, _req);
          }
        });
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          initPGapiCall();
        }
      }
    });
  }

  _payableAmount() {
    var redeempoints =
        (((int.parse(_amount) * _currencyconvRate) * _quantityCounter).ceil() /
                _redemptionRate)
            .ceil();

    var paybleAmount = (redeempoints - GemsGLobals.pointbalance).ceil();
    var aedAmount = paybleAmount / 10;

    _calculatAedAmt =
        ((_giftDetailsModal.objects!.offerPloughbackFactor / 100) *
                (aedAmount.ceil() / _giftDetailsModal.objects?.rpm))
            .floor();
    return aedAmount.ceil();
  }

  _calculateRedempoints() {
    var redeempoints =
        (((int.parse(_amount) * _currencyconvRate) * _quantityCounter).ceil() /
                _redemptionRate)
            .ceil();
    return redeempoints;
  }

  Widget _paybycashandpoints() {
    return Container(
      margin: EdgeInsets.only(left: 0, right: 5),
      child: Column(
        children: [
          Container(
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
                _payWithPoint
                    ? TextWidget(
                        text: "AED ${_calculateAEDwithPoints()}",
                        weight: FontWeight.bold,
                        // text: '${_payableAmount()}',
                      )
                    : TextWidget(
                        text: "AED ${pointsFormatter(_payableAmount())}",
                        weight: FontWeight.bold,
                        // text: '${_payableAmount()}',
                      )
              ],
            ),
          )
        ],
      ),
    );
  }

// {"message":"Order generated","code":"trnx_0010","objects":{"status":"OK","code":200,"message":"Giftcards created successfully","error_message":[],"values":[{"voucher_code":"W7BH0V6MBZ","giftcard_url":"http://test.meritincentives.com/giftcards/preview/key_32c2114a8ab8f8b296","expiration_date":"2023-05-30"}]},"transaction_type":"RD","product_name":"5asec","mobile_image":"https://apitypuatgems22.clubclass.io/app/api/giftcard/images/5asec_GC.png","payment_type":"Online","denomination_amount":50,"quantity":1,"total_amount":50,"amount_paid":0,"earn_points":0,"points_redeemed":4167,"receiver_email":"pratik.gholap@vernost.in","receiver_mobile":"+971 undefined","status":true}
/* Delivered to details */
  Widget _deliverdTo() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 35,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: TextWidget(
                    text: 'Gift Card will be sent to',
                    color: black_color,
                    weight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: () async {
                    var editDetails = {
                      "countryId": 2,
                      "code": "",
                      "nationality": "", //"United Arab Emirates",
                      "countryCode": GemsGLobals.countryCode,
                      "numberlength": 9,
                      "flagimage": "",
                      // "http://50.19.99.228:4002/uploads/images/countries/AE.jpg",
                      "firstname": GemsGLobals.userFirstName,
                      "lastname": GemsGLobals.userLastName,
                      "email": GemsGLobals.useremail,
                      "contactnumber": GemsGLobals.mobilenumber
                    };

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => EditGiftcardReciverDetails(
                    //               editDetails: editDetails,
                    //             )));
                    _editDetailsResponse = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditGiftcardReciverDetails(
                                  editDetails: _editDetailsResponse,
                                )));
                    setState(() {});
                  },
                  child: Container(
                    height: 25,
                    width: 25,
                    child: SvgPicture.asset(
                      ImageConstants.editicon,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 0,
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: FittedBox(
                    alignment: Alignment.topLeft,
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: <Widget>[
                        TextWidget(
                          text: _deliveredToEmail(),
                          weight: FontWeight.w600,
                        ),
                        // CityGLobals.emailVerified == 'YES'
                        //     ?
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 5),
                          child: TextWidget(
                            text: 'Verified',
                            color: blue_color,
                            textAlign: TextAlign.center,
                            weight: FontWeight.w500,
                            size: text_font_size_x_small,
                            maxLines: 3,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                        //    : Container()
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          widget.paymentTyp == 'accrual'
              ? Container(
                  height: 0,
                )
              : Container(
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
                              _payWithAED = true;
                            } else {
                              _payWithPoint = true;
                              _payWithAED = false;

                              paywithAmount =
                                  '${(((int.parse(_amount) * _currencyconvRate) * _quantityCounter).round() / _redemptionRate).round()}';
                              if (int.parse(paywithAmount) >
                                  GemsGLobals.pointbalance) {
                                _pointController.text =
                                    GemsGLobals.pointbalance.toString();
                              } else {
                                _pointController.text = paywithAmount;
                              }

                              // _pointController.text =
                              //           '${(((int.parse(_amount) * _currencyconvRate) * _quantityCounter).round() / _redemptionRate).round()}';
                            }
                          });
                        },
                        child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(width: 1, color: black_color),
                                color: transColor),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: SvgPicture.asset(
                                ImageConstants.select,
                                color: _payWithPoint ? blue_color : transColor,
                              ),
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
                                    fontSize: text_font_medium15_size,
                                    fontWeight: FontWeight.bold),
                                onChanged: (text) {
                                  if (_pointController.text.isNotEmpty &&
                                      int.parse(_pointController.text) <=
                                          checkAmt) {
                                    _calculationToAed(
                                        int.parse(_pointController.text));
                                    _checkBNZLimit = false;
                                    _calculateAEDwithPoints();
                                    _selectPayment();
                                  } else {
                                    _checkBNZLimit = false;
                                    setState(() {});
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
                ),

          _checkBNZLimit
              ? Container(
                  alignment: Alignment.center,
                  margin:
                      EdgeInsets.only(left: 50, right: 20, top: 8, bottom: 8),
                  child: TextWidget(
                    text:
                        'The entered GEMS Points must be within your available balance and required total amount',
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
                  _checkBNZLimit == false &&
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

          // (_pointController.text.isNotEmpty && _payType == 'miles_cash') ||
          //         (_payWithPoint &&
          //             _pointController.text.isNotEmpty &&
          //             checkAmt > int.parse(_pointController.text))
          //     ? Container(
          //         alignment: Alignment.center,
          //         child: TextWidget(
          //           text: '& AED ${_calculateAEDwithPoints()} in Cash',
          //           color: black_color,
          //           weight: FontWeight.w600,
          //           size: text_font_medium15_size,
          //         ),
          //       )
          //     : SizedBox(
          //         height: 0,
          //       ),
          SizedBox(
            height: 5,
          ),
          (widget.paymentTyp != 'accrual' &&
                  (((int.parse(_payWithBounz[chekRadio]) * _quantityCounter) >
                      (GemsGLobals.pointbalance))))
              ? _paybycashandpoints()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: widget.paymentTyp == 'accrual'
                              ? "Amount payable "
                              : 'GEMS debited',
                          size: text_font_medium15_size,
                          color: text_color,
                        ),
                        TextWidget(
                          text: widget.paymentTyp == 'accrual'
                              ? "AED ${pointsFormatter(_calculateAEDnopoints())}"
                              // :_pointController.text,
                              : (_payWithPoint &&
                                      _pointController.text.isNotEmpty &&
                                      checkAmt >
                                          int.parse(_pointController.text))
                                  ? (_pointController.text)
                                  : "\t${pointsFormatter(_calculatePayByPonits(_redeemBounzPoints))}",
                          size: text_font_medium17_size,
                          color: black_color,
                          weight: FontWeight.w600,
                        )
                      ],
                    ),
                    (_pointController.text.isNotEmpty &&
                                _payType == 'miles_cash') ||
                            (_payWithPoint &&
                                _pointController.text.isNotEmpty &&
                                checkAmt > int.parse(_pointController.text))
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
                                  text: "AED ${_calculateAEDwithPoints()}",
                                  size: text_font_medium17_size,
                                  color: black_color,
                                  weight: FontWeight.w600,
                                )
                              ],
                            ),
                          )
                        : SizedBox(
                            height: 0,
                          ),
                  ],
                ),

          //: Container(height: 5)
        ],
      ),
    );
  }

  Widget _payNow() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _pgLoader
                ? Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: 50,
                    child: Center(
                        child: SpinKitCircle(
                      color: btn_bg_color,
                    )))
                : InkWell(
                    // GemsGLobals.userType == 'staff' || GemsGLobals.userType == 'parent'
                    onTap:
                        // GemsGLobals.userType == 'staff' ||
                        //         GemsGLobals.userType == 'parent'
                        //     ? _amount == '0'
                        //         ? () {}
                        //         :
                        () {
                      if (_pointController.text.isNotEmpty &&
                          widget.paymentTyp == "redemption") {
                        _payType = int.parse(_pointController.text) <
                                    GemsGLobals.pointbalance &&
                                int.parse(_pointController.text) >= checkAmt
                            ? 'redemption'
                            : 'miles_cash'; // Pay by Bounz Points
                        setState(() {});
                      } else {
                        _payType = 'accrual'; //Pay By Cash
                        setState(() {});
                      }

                      if (!_payWithPoint) {
                        initPGapiCall();
                      } else {
                        if (int.parse(_pointController.text) >
                                GemsGLobals.pointbalance ||
                            int.parse(_pointController.text) > bnz_total_amt) {
                          _checkBNZLimit = true;
                          setState(() {});
                        } else {
                          initPGapiCall();
                        }
                      }
                      var segmentReq = {
                        'giftcard_name': _giftDetailsModal.objects?.name ?? '',
                        'category': widget.categoryName,
                        'giftcard_type': widget.productType,
                        'min_value': widget.minValue,
                        'max_value': widget.maxValue,
                        "value": int.parse(_amount),
                        "qty": '$_quantityCounter',
                        'int_source': GemsGLobals.lastVisitPageName
                      };
                      String keyName = GemsGLobals.eventGiftcardCheckout;
                      _makesenseEventCall(segmentReq, keyName);
                    },

                    child: Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      height: 45,
                      padding: EdgeInsets.fromLTRB(2, 14, 2, 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        gradient: gradient_theme_color,
                      ),
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: TextWidget(
                          text: 'Pay Now',
                          color: white_text_color,
                          size: text_font_medium_size,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
          ],
        ),
        (widget.paymentTyp == 'accrual' ||
                ((_redeemCalPoints > (GemsGLobals.pointbalance))))
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextWidget(
                      text: _calculatAedAmt > 0 && _payWithPoint
                          ? 'Earn upto $_calculatAedAmt GEMS Points'
                          : 'Earn upto ${_earnCalPoints ?? 0} GEMS Points',
                      color: blue_color,
                      size: text_font_medium15_size,
                      weight: FontWeight.w500,
                    )
                  ],
                ),
              )
            : Container(),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      color: grey_color_300,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
    );
  }

/*Gift card details widget */
  Widget _giftCardDetails() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          TextWidget(
            text: 'Card Value',
            color: black_color,
            weight: FontWeight.w500,
          ),
          SizedBox(
            height: 10,
          ),
          cardValue(
            _giftDetailsModal.objects!.fixedDenominationAmount.toString(),
          ),
          SizedBox(
            height: 10,
          ),
          _deliverdTo(),
          SizedBox(
            height: 20,
          ),
          _payNow(),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

/*Gift card description widget */
  Widget _desc() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15, bottom: 5),
          child: TextWidget(
            text: _giftDetailsModal.objects?.description.toString() ?? '',
          ),
        ),
        SizedBox(
          height: 80,
        )
      ],
    );
  }
/*Gift card redeem info widget */

  Widget _howToUse() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15, bottom: 5),
          child: TextWidget(
            text: _giftDetailsModal.objects?.howToRedeem.toString() ?? '',
          ),
        ),
        SizedBox(
          height: 80,
        )
      ],
    );
  }
/*Gift card tabs */

  Widget _giftcardDescrAnduse() {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isgiftcard = true;
                    _isdescription = false;
                    _isuse = false;
                  });
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: _isgiftcard == true
                            ? blue_color
                            : grey_color.withOpacity(0.24),
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Center(
                    child: TextWidget(
                      text: 'Gift Card',
                      weight: FontWeight.w600,
                      color: _isgiftcard == true ? black_color : grey_color,
                      size: Platform.isIOS ? 13 : 15,
                    ),
                  ),
                ),
              )),
              SizedBox(width: 5),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isgiftcard = false;
                    _isdescription = true;
                    _isuse = false;
                    var segmentReq = {
                      "GC": 'Description',
                      "Description": _giftDetailsModal.objects?.name ?? '',
                      // '${_giftDetailsModal.objects?.description.toString()}',
                      "How to use": _giftDetailsModal.objects?.name ?? '',
                      "Card value": '',
                      "Quantity": '$_quantityCounter',
                      "GEMS point": '',
                      "Pay now": '',
                      "baCK": "BAck",
                      'int_source': GemsGLobals.lastVisitPageName
                    };
                    String keyName = GemsGLobals.eventGiftcardDetailPage;
                    _makesenseEventCall(segmentReq, keyName);
                  });
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: _isdescription == true
                            ? blue_color
                            : grey_color.withOpacity(0.24),
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Center(
                    child: TextWidget(
                      text: 'Description',
                      weight: FontWeight.w600,
                      color: _isdescription == true ? black_color : grey_color,
                      size: Platform.isIOS ? 13 : 15,
                    ),
                  ),
                ),
              )),
              SizedBox(width: 5),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isgiftcard = false;
                    _isdescription = false;
                    _isuse = true;
                    var segmentReq = {
                      "GC": 'How to use',
                      "Description": _giftDetailsModal.objects?.name ?? '',
                      "How to use": _giftDetailsModal.objects?.name ?? '',
                      'int_source': GemsGLobals.lastVisitPageName,
                      "Card value": '',
                      "Quantity": '$_quantityCounter',
                      "GEMS point": '',
                      "Pay now": '',
                      "baCK": "BAck"
                    };
                    String keyName = GemsGLobals.eventGiftcardDetailPage;
                    _makesenseEventCall(segmentReq, keyName);
                  });
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: _isuse == true
                            ? blue_color
                            : grey_color.withOpacity(0.24),
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Center(
                    child: TextWidget(
                      text: 'How to use',
                      weight: FontWeight.w600,
                      color: _isuse == true ? black_color : grey_color,
                      size: Platform.isIOS ? 13 : 15,
                    ),
                  ),
                ),
              ))
            ],
          ),
          _isgiftcard
              ? _giftCardDetails()
              : (_isdescription ? _desc() : _howToUse()),
        ],
      ),
    );
  }

  Widget _nodataFound() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextWidget(
              text: 'Whoops!',
              size: 25,
              weight: FontWeight.bold,
            ),
            TextWidget(
              text:
                  "We can't find your Gift card here. Do check if its a typo!!!", //'The voucher is currently\n    unavailable 🙂!!!',
              weight: FontWeight.w500,
              size: text_font_medium18_size,
            ),
          ],
        ));
  }

  Widget _reedemtext() {
    return Container(
      color: blue_color,
      height: 45,
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextWidget(
            text: 'You can redeem up to ',
            color: white_text_color,
            size: text_font_medium14_size,
            weight: FontWeight.w600,
          ),
          TextWidget(
            text: "${pointsFormatter(GemsGLobals.pointbalance)} Gems Points",
            color: white_text_color,
            size: text_font_medium14_size,
            weight: FontWeight.w600,
          ),
        ],
      )),
    );
  }

  Widget _imageData() {
    return Stack(
      children: [
        // Container(
        //   height: 160,
        //   decoration: BoxDecoration(
        //       color: grey200_color,
        //       border: Border.all(width: 0.4, color: grey200_color),
        //       borderRadius: BorderRadius.circular(12)),
        //   alignment: Alignment.center,
        //   child: SvgPicture.asset(
        //     ImageConstants.giftcard_dummy,
        //     height: 160,
        //     width: MediaQuery.of(context).size.width,
        //     fit: BoxFit.fill,
        //   ),
        // ),

        Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.transparent),
            height: 160,
            // width: MediaQuery.of(context).size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: _giftDetailsModal.objects?.mobileImage != null
                    ? _giftDetailsModal.objects!.mobileImage.toString()
                    : '',
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
                placeholder: (context, url) {
                  return Image.asset(
                    ImageConstants.noimages,
                    fit: BoxFit.contain,
                  );
                },
                errorWidget: (context, url, error) {
                  return Image.asset(
                    ImageConstants.noimages,
                    fit: BoxFit.fill,
                  );
                },
              ),
            )),
      ],
    );
  }

  Widget _upperWidget() {
    return Stack(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(gradient: gradient_theme_color),
            alignment: Alignment.topLeft,
            height: Platform.isIOS ? 175 : 190,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      var segmentReq = {
                        "GC": 'Back',
                        "Description": _giftDetailsModal.objects?.name ?? '',
                        "How to use": _giftDetailsModal.objects?.name ?? '',
                        "Card value": '',
                        "Quantity": '$_quantityCounter',
                        "GEMS point": '',
                        "Pay now": '',
                        "baCK": "BAck",
                        'int_source': GemsGLobals.lastVisitPageName
                      };
                      String keyName = GemsGLobals.eventGiftcardDetailPage;
                      _makesenseEventCall(segmentReq, keyName);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 15, top: 15),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.blue[400],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 27,
                          color: white_text_color,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 20),
                      alignment: Alignment.topCenter,
                      margin: EdgeInsets.only(right: 17, top: 25),
                      child: TextWidget(
                        text: "Gift Card Details",
                        size: text_font_medium_size,
                        weight: FontWeight.w500,
                        color: white_text_color,
                      ),
                    ),
                  ),
                ],
              ),
            )),
        Positioned(top: 90, left: 30, right: 30, child: _imageData())
      ],
    );
  }

  Widget _body() {
    return Container(
      color: white_text_color,
      child: _noData
          ? _nodataFound()
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 280,
                    // Platform.isIOS ? 280 : 280,
                    child: _upperWidget(),
                  ),
                  GemsGLobals.pointbalance != 0
                      ? _reedemtext()
                      : Container(
                          height: 0,
                        ),
                  _giftcardDescrAnduse(),
                ],
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
        tabvalue: "home",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /* banner image*/

    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: SafeArea(
        top: false,
        bottom: true,
        child: PopScope(
          canPop: true,
          onPopInvoked: (canPop) async {
            var segmentReq = {
              "GC": 'Back',
              "Description": '',
              "How to use": '',
              "Card value": '',
              "Quantity": '$_quantityCounter',
              "GEMS point": '',
              "Pay now": '',
              "baCK": "BAck",
              'int_source': GemsGLobals.lastVisitPageName
            };
            String keyName = GemsGLobals.eventGiftcardDetailPage;
            _makesenseEventCall(segmentReq, keyName);
            return Future.value(true);
          },
          child: Scaffold(
            extendBody: true,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(0.0),
              child: Container(
                decoration: BoxDecoration(gradient: gradient_theme_color),
              ),
            ),
            body: _isLoading == true
                ? Center(
                    child: SpinKitCircle(
                      color: btn_bg_color,
                    ),
                  )
                : _body(),
           bottomNavigationBar: SizedBox(
             height: 95,
             child: _tabbar(),
           ),
          ),
        ),
      ),
    );
  }

  @override
  void giftdeatailsresponse(GiftcardDetailsModal giftDetailsModal) async {
    // TODO: implement giftdeatailsresponse
    _isLoading = false;
    if (giftDetailsModal.status == true) {
      _giftDetailsModal = giftDetailsModal;
      _isLoading = false;

      setState(() {
        _noData = false;
        if (_giftDetailsModal.objects?.fixedDenominationAmount != null) {
          var _amnt =
              _giftDetailsModal.objects?.fixedDenominationAmount?.split(',');

          _amount = _amnt![0];
        }
        if (_giftDetailsModal.objects?.currency != null) {
          _currency = _giftDetailsModal.objects?.currency ?? '';
        }

        if (_giftDetailsModal.objects?.currConvRate != null) {
          _currencyconvRate = _giftDetailsModal.objects?.currConvRate ?? 0.0;
        }
        _redemptionRate = _giftDetailsModal.objects?.redemptionRate != null
            ? _giftDetailsModal.objects?.redemptionRate
            : 0;

        _earnPoint = _giftDetailsModal.objects?.earnPoints != null
            ? _giftDetailsModal.objects?.earnPoints?.split(',')
            : '';

        _payWithBounz = _giftDetailsModal.objects?.payWithPoints != null
            ? _giftDetailsModal.objects?.payWithPoints?.split(',')
            : '';

        _selectPayment();

        paywithAmount =
            '${(((int.parse(_amount) * _currencyconvRate) * _quantityCounter).round() / _redemptionRate).round()}';
        if (int.parse(paywithAmount) > GemsGLobals.pointbalance) {
          _pointController.text = GemsGLobals.pointbalance.toString();
        } else {
          _pointController.text = paywithAmount;
        }
        checkAmt = int.parse(_pointController.text);
        bnz_total_amt = int.parse(_pointController.text);
        _calculationToAed(checkAmt);
      });
    } else {
      setState(() async {
        _noData = true;

        _isLoading = false;
        if (_giftDetailsModal.message == 'timeout') {
          _isLoading = true;
          var notresponding =
              await Navigator.of(context).pushNamed('/timeoutpage');
          if (notresponding != null) {
            apiCall();
          } else {
            Navigator.pop(context, true);
          }
        }
      });
    }
    var segmentReq = {
      'giftcard_name': _giftDetailsModal.objects?.name ?? '',
      'category': widget.categoryName,
      'giftcard_type': widget.productType,
      'min_value': widget.minValue,
      'max_value': widget.maxValue,
      'int_source': GemsGLobals.lastVisitPageName
    };
    String keyName = GemsGLobals.eventGiftcardDetailPage;
    _makesenseEventCall(segmentReq, keyName);
    GemsGLobals.lastVisitPageName = GemsGLobals.eventGiftcardDetailPage;
    setState(() {});
  }

  @override
  void giftdetailserr(error) {
    // TODO: implement giftdetailserr
  }

  @override
  void allErr(error) {}

  @override
  void pgResp(giftPgModal) {
    setState(() {
      _pgLoader = false;
    });
    if (giftPgModal.status == true &&
        giftPgModal.objects?.pgOrder?.url != null &&
        _payType != 'redemption') {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentPage(
              finalURL: giftPgModal.objects?.pgOrder?.url,
              flowTyp: 'GIFTCARD',
              brf_no: giftPgModal.objects?.transactionId,
              giftbgimg: _giftDetailsModal.objects?.mobileImage != null
                  ? _giftDetailsModal.objects?.mobileImage
                  : '',
              giftCardName: widget.giftCardName,
              minValue: widget.minValue,
              maxValue: widget.maxValue,
              categoryName: widget.categoryName,
              productType: widget.productType,
              amount: _amount,
              quantity: '$_quantityCounter',
            ),
          ));
    } else if (giftPgModal.status == true && _payType == 'redemption') {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => GiftCardThankuPage(
                // tranxId: giftPgModal.objects?.transactionId,
                purchaseData: giftPgModal,
                type: 'redemption',
                giftCardName: widget.giftCardName,
                minValue: widget.minValue,
                maxValue: widget.maxValue,
                categoryName: widget.categoryName,
                productType: widget.productType,
                amount: _amount,
                quantity: '$_quantityCounter',
              )));
    } else {
      Fluttertoast.showToast(
        msg: giftPgModal.message ?? 'Something went wrong!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
