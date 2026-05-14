/* Author : Sanjana Shetty
 Date created : 18 April
 Discription : Offer Pin page*/

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/account/profile/profile_utils/user_apiconfig.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/offer_module/offer_pin/model_offerredeem.dart';
import 'package:gems_revamp/offer_module/offer_pin/new_offerredeem_model.dart';
import 'package:gems_revamp/offer_module/offer_pin/presenter_offerredeem.dart';
import 'package:gems_revamp/offer_module/offer_pin/view_offerredeem.dart';
import 'package:gems_revamp/offer_module/offer_receipt/thankyou.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/constants_files/text_constants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widget/bottombar.dart';
import '../../common_widget/font_size.dart';

class OfferPin extends StatefulWidget {
  final offerCode;
  final offerdetail;
  final offerTitle;
  final offerExpiryDate;
  final offerLimit;
  final offerdealdata;
  final partnerbrandid;
  final transactionId;
  const OfferPin(
      {Key? key,
      this.offerdetail,
      this.offerCode,
      this.offerTitle,
      this.offerExpiryDate,
      this.offerLimit,
      this.offerdealdata,
      this.partnerbrandid,
      this.transactionId})
      : super(key: key);
  @override
  _OfferPinState createState() => _OfferPinState();
}

class _OfferPinState extends State<OfferPin> implements OfferRedeemView {
  var _aedController = TextEditingController();
  final TextEditingController _firstotp = TextEditingController();
  final TextEditingController _secondotp = TextEditingController();
  final TextEditingController _thirdotp = TextEditingController();
  final TextEditingController _fourthotp = TextEditingController();
  var _otp;
  String errortext = "";
  String amounterror = "";
  bool _isenterAED = false;
  FocusNode fp1 = FocusNode();
  FocusNode fp2 = FocusNode();
  FocusNode fp3 = FocusNode();
  FocusNode fp4 = FocusNode();
  OfferRedeemModel offereddemdata = new OfferRedeemModel();
  OfferRedeemPresenter? _redeempresenter;
  var offereddemresponse;
  bool _isoffereddemloader = false;
  final formKey = GlobalKey<FormState>();
  var aedTextError = "";

  @override
  void initState() {
    super.initState();
    _redeempresenter = OfferRedeemPresenter(this);
    makesenseEventCall();
    GemsGLobals.lastVisitPageName = GemsGLobals.offerPinEnterPageName;
  }

     makesenseEventCall() {
    String keyName = GemsGLobals.eventPinbasedRedemptionInitiated;
    var segmentReq = {
    GemsGLobals.offerCategoryParam :  widget.offerdetail.outletName,
    GemsGLobals.offerSubCategoryParam: "",
    GemsGLobals.offerTypeParam:  GemsGLobals.pinBasedType,
    GemsGLobals.offerNameParam: widget.offerTitle,
    GemsGLobals.offerSummaryParam: widget.offerdetail.outletDescription,
    GemsGLobals.intSource: GemsGLobals.lastVisitPageName
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  makesenseEventRedemptionPinSubmittedCall() {
    String keyName = GemsGLobals.eventRedemptionPinSubmitted;
    var segmentReq = {
    GemsGLobals.offerCategoryParam :  widget.offerdetail.outletName,
    GemsGLobals.offerSubCategoryParam: "",
    GemsGLobals.offerTypeParam:  GemsGLobals.pinBasedType,
    GemsGLobals.offerNameParam: widget.offerTitle,
    GemsGLobals.offerSummaryParam: widget.offerdetail.outletDescription,
    GemsGLobals.clickedOnParam: "",
    GemsGLobals.intSource: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  makesenseEventPinbasedRedemptionFailedCall() {
    String keyName = GemsGLobals.eventPinbasedRedemptionFailed;
    var segmentReq = {
    GemsGLobals.offerCategoryParam :  widget.offerdetail.outletName,
    GemsGLobals.offerSubCategoryParam: "",
    GemsGLobals.offerTypeParam:  GemsGLobals.pinBasedType,
    GemsGLobals.offerNameParam: widget.offerTitle,
    GemsGLobals.offerSummaryParam: widget.offerdetail.outletDescription,
    GemsGLobals.clickedOnParam: "",
    GemsGLobals.amount: _aedController.text.toString().replaceAll(",", ""),
    GemsGLobals.discount:"",
    GemsGLobals.reason: errortext,
    GemsGLobals.intSource: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  makesenseEventPinbasedRedemptionSuccessfulCall() {
    String keyName = GemsGLobals.eventPinbasedRedemptionSuccessful;
    var segmentReq = {
    GemsGLobals.offerCategoryParam :  widget.offerdetail.outletName,
    GemsGLobals.offerSubCategoryParam: "",
    GemsGLobals.offerTypeParam:  GemsGLobals.pinBasedType,
    GemsGLobals.offerNameParam: widget.offerTitle,
    GemsGLobals.offerSummaryParam: widget.offerdetail.outletDescription,
    GemsGLobals.clickedOnParam: "",
    GemsGLobals.amount: _aedController.text.toString().replaceAll(",", ""),
    GemsGLobals.discount:"",
    GemsGLobals.intSource: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }


  dateformate(format) {
    var now = DateTime.parse(format);
    var formatter = new DateFormat('MMM dd yyyy');
    var formated = formatter.format(now);

    return formated;
  }

  void calloffereddemapi() {
    var request = {
      "customer_id": GemsGLobals.membershipNo,
      "offer_code": widget.offerCode,
      "merchant_pin": _otp,
      "merchant_code": widget.offerdetail.merchantCode,
      "outlet_code": widget.offerdetail.outletCode,
      "total_amount": _aedController.text.toString().replaceAll(",", ""),
      "dealid": widget.offerdealdata.ofdId,
      "first_name": GemsGLobals.userFirstName,
      "last_name": GemsGLobals.userLastName,
      "email": GemsGLobals.useremail,
      "phone": GemsGLobals.mobilenumber,
      "school_code": "test",
      "ofr_pin_mandatory": widget.offerdealdata.ofrPinMandatory,
      "partner_brndid": widget.partnerbrandid,
      "partner_offerid": widget.offerdealdata.partnerOfferid,
      "offer_limit": widget.offerdealdata.offerLimit,
      "isdealveify": widget.offerdealdata.ofrSkipCode.toString() == "yes"
          ? false
          : widget.offerdealdata.ofrSkipCode.toString() == "no"
              ? widget.offerdealdata.ofrPinMandatory == "1"
                  ? true
                  : false
              : false,
    };

    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _redeempresenter!.offerRedeemAPI(request);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          setState(() {});
          _redeempresenter!.offerRedeemAPI(request);
        }
      }
    });
  }

  void callNewoffereddemapi() {
    var request = {
      "customer_id": GemsGLobals.membershipNo,
      "offer_code": widget.offerCode,
      "merchant_pin": _otp,
      "merchant_code": widget.offerdetail.merchantCode,
      "outlet_code": widget.offerdetail.outletCode,
      "total_amount": _aedController.text.toString().replaceAll(",", ""),
      "offer_limit": widget.offerdealdata.offerLimit,
      "ofr_pin_mandatory": widget.offerdealdata.ofrPinMandatory,
      "partner_brndid": widget.partnerbrandid,
      "partner_offerid": widget.offerdealdata.partnerOfferid,
      "type": "redemption",
      "transaction_id": widget.transactionId
    };

    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _redeempresenter!.newofferRedeemAPI(request);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          setState(() {});
          _redeempresenter!.newofferRedeemAPI(request);
        }
      }
    });
  }

  void getMemberSavingBalance() {
    Internetconnectivity().isConnected().then((isConnected) {
      if (isConnected) {
        UserApiConfig()
            .memberSavingPoints(http.Client(), GemsGLobals.membershipNo)
            .then((value) {
          if (value['status'] == true) {
            setState(() {
              GemsGLobals.userSavingBalance =
                  value['values']['saving_point'].toString();
            });
          }
        });
      }
    });
  }

  Widget _enterpinappbar() {
    return Positioned(
      top: 35,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
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
                      size: text_font_large20_size,
                      color: white_text_color,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 22),
                child: Container(
                    alignment: Alignment.center,
                    child: TextWidget(
                        text: "Enter PIN",
                        weight: FontWeight.w400,
                        size: text_font_large20_size,
                        color: white_color)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _bodybox() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 10.7,
              ),
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5, color: Colors.grey[400]!),
                  // boxShadow: [
                  //   BoxShadow(
                  //     blurRadius: 3.0,
                  //     color: grey_color.withOpacity(0.5),
                  //     offset: Offset(1.0, 1.0),
                  //   ),
                  // ],
                  color: white_color,
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                        top: 25,
                        left: 20,
                      ),
                      child: Row(
                        children: [
                          if (widget.offerdetail.outletImage != null)
                            Container(
                                width: 50,
                                height: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox.fromSize(
                                    size: Size.fromRadius(48),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          widget.offerdetail.outletImage ?? '',
                                      width: MediaQuery.of(context).size.width,
                                      // height: 182,
                                      fit: BoxFit.cover,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                        )),
                                      ),
                                      fadeInDuration: Duration(microseconds: 0),
                                      placeholderFadeInDuration:
                                          Duration(microseconds: 0),
                                      fadeOutDuration:
                                          Duration(microseconds: 0),
                                      placeholder: (context, url) =>
                                          Image.asset(
                                        ImageConstants.noimages,
                                        fit: BoxFit.cover,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        ImageConstants.noimages,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )),
                          if (widget.offerdetail.outletName != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, bottom: 10),
                              child: Container(
                                width: 180,
                                child: TextWidget(
                                  text: widget.offerdetail.outletName ?? '',
                                  // weight: FontWeight.bold,
                                  size: text_font_medium17_size,
                                  color: black_color,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                        ],
                      )),
                  if (widget.offerTitle != null)
                    Container(
                        padding: EdgeInsets.only(top: 15, left: 20, right: 20),
                        child: TextWidget(
                          text: widget.offerTitle!.trim() == 'Multiple Offers'
                              ? 'Multiple Offers'
                              : widget.offerTitle.toString(),
                          size: text_font_medium15_size,
                          // weight: FontWeight.bold,
                        )),
                  if (widget.offerdealdata?.offerexpiry != null &&
                      widget.offerdealdata?.offerexpiry != "")
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 20),
                      child: Row(
                        children: [
                          Container(
                              child: TextWidget(
                            text: "Valid - ",
                            // text:"Valid",
                            size: text_font_size_small,
                            color: grey_color,
                            weight: FontWeight.bold,
                          )),
                          Container(
                              child: TextWidget(
                            // text: " - June 30, 2021",
                            text:
                                "${dateformate(widget.offerdealdata.offerexpiry.toString()) ?? ''}",
                            size: text_font_size_small,
                            color: grey_color,
                            weight: FontWeight.bold,
                          )),
                        ],
                      ),
                    ),
                  SizedBox(height: 20),
                  _aedBox(),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: DottedLine(
                      lineThickness: 1.0,
                      dashLength: 5.0,
                      dashColor: black_color,
                      dashRadius: 0.0,
                      dashGapLength: 5.0,
                    ),
                  ),
                  SizedBox(height: 25),
                  _enterpinbox(),
                  SizedBox(height: 20),
                  _submit(),
                  SizedBox(height: 20),
                ],
              )),
        ],
      ),
    );
  }

  Widget _aedBox() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              color: light_bluish,
              border: Border.all(color: const Color(0xffecf0f5)),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2),
            child: Row(
              children: <Widget>[
                Container(
                    margin:
                        EdgeInsets.only(top: 7, right: 8, left: 15, bottom: 7),
                    child: TextWidget(
                      text: "AED",
                      size: text_font_large25_size,
                      weight: FontWeight.w500,
                      color: greyshadesnew,
                    )),
                Container(
                    width: 220,
                    alignment: Alignment.center,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          amounterror = "";
                        });
                      },
                      autofocus: true,
                      focusNode: fp1,
                      textInputAction: TextInputAction.done,
                      controller: _aedController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(15),
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        widget.offerTitle.toString().contains(GemsGLobals.free)
                            ? FilteringTextInputFormatter.allow(RegExp(r'^0'))
                            : FilteringTextInputFormatter.deny(RegExp(r'^0')),
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,4}'))
                      ],
                      keyboardType: Platform.isIOS
                          ? TextInputType.numberWithOptions(decimal: true)
                          : TextInputType.phone,
                      // maxLength: 6,
                      decoration: InputDecoration(
                          isDense: true,
                          counterText: "",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 0),
                          hintText: "0.00",
                          hintStyle: TextStyle(
                              fontSize: text_font_large25_size,
                              fontFamily: "Poppins",
                              color: greyshadesnew,
                              fontWeight: FontWeight.w500)),
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: text_font_large25_size,
                          color: black_color,
                          fontWeight: FontWeight.w500),
                    ))
              ],
            ),
          ),
        ),
        amounterror != "" || _isenterAED == true
            ? Container(
                // color: orange,
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: TextWidget(
                  text: _aedController.text == "." || _aedController.text == "0"
                      ? "Amount should be greater than 0"
                      : aedTextError,
                  color: Colors.red[700],
                  size: 15,
                ),
              )
            : Container(height: 0)
      ],
    );
  }

  Widget _pinviewbox() {
    //This is function used to entered the OTP text.
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Form(
            key: formKey,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  obscureText: true,
                  obscuringCharacter: '*',
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(15),
                      fieldOuterPadding: EdgeInsets.only(bottom: 20),
                      fieldHeight: 65,
                      fieldWidth: 55,
                      selectedFillColor: pinbox,
                      inactiveFillColor: pinbox,
                      activeFillColor: pinbox,
                      inactiveColor: Color(0xffedf0f4),
                      activeColor: Color(0xffedf0f4),
                      selectedColor: white_text_color),
                  focusNode: FocusNode(),
                  cursorColor: black_color,
                  animationDuration: Duration(milliseconds: 300),
                  textStyle:
                      TextStyle(fontSize: 20, height: 1.6, color: black_color),
                  enableActiveFill: true,
                  controller: _firstotp,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      errortext = "";
                    });
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget _enterpinbox() {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: TextWidget(
            text: "Enter PIN here",
            color: darkgrey,
          ),
        ),
        SizedBox(height: 20),
        _pinviewbox(),
        errortext != ""
            ? Container(
                margin: EdgeInsets.only(top: 10, bottom: 0),
                child: TextWidget(
                  text: errortext,
                  color: Colors.red[700],
                  size: 14,
                ))
            : Container(),
      ],
    );
  }

  Widget _submit() {
    return _isoffereddemloader
        ? Center(
            child: SpinKitCircle(
            color: btn_bg_color,
          ))
        : Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _otp = _firstotp.text;
                    if (!widget.offerTitle.toString().contains(GemsGLobals.free)) {
                      if (_aedController.text.length < 1 ||
                          _aedController.text == "0") {
                        amounterror = GemsGLobals.value;
                        aedTextError = GemsGLobals.pleaseEnterAEDValue;
                      } else {
                        amounterror = "";
                      }
                    }
                    if (_otp.length < 4) {
                      errortext = GemsGLobals.pleaseEnterValidPin;
                    } else {
                      errortext = "";
                    }
                  });

                  if (errortext == "" && amounterror == "") {                    
                        makesenseEventRedemptionPinSubmittedCall();

                    setState(() {
                      _isoffereddemloader = true;
                      // calloffereddemapi();
                      callNewoffereddemapi();
                    });
                  }
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  textStyle: WidgetStateProperty.all(
                      TextStyle(color: Color(0xffffffff))),
                  backgroundColor: WidgetStateProperty.all(boxgreencolor),
                  minimumSize: WidgetStateProperty.all(Size(0, 0)),
                  elevation: WidgetStateProperty.all(0),
                  padding:
                      WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15, top: 15, bottom: 15),
                  child: TextWidget(
                    text: "Submit",
                    color: white_color,
                    size: text_font_large20_size,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
  }

  void whatsappBottomModalold(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            bottom: true,
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 45,
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.only(bottom: 3, top: 15),
                        child: Center(
                          child: SvgPicture.asset(
                            ImageConstants.whatsapp,
                            height: 40,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          right: 5,
                          bottom: 0,
                        ),
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          child: SvgPicture.asset(
                            ImageConstants.cross,
                            height: 35,
                            width: 35,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: TextWidget(
                        text: AppTexts.connectingText,
                        textAlign: TextAlign.center,
                        size: appbar_text_size,
                        weight: FontWeight.bold),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 5),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextWidget(
                        text: AppTexts.connectingMessageText,
                        textAlign: TextAlign.center,
                        size: text_font_medium15_size,
                        color: Colors.black),
                  ),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: aqua_blue,
                      ),
                      child: Center(
                        child: TextWidget(
                            text:AppTexts.proceedText,
                            textAlign: TextAlign.center,
                            color: Colors.white,
                            size: text_font_large20_size),
                      ),
                    ),
                    onTap: () {
                      whatsappcallnew(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  static void whatsappcallnew(BuildContext context) async {
    var whatsappUrl;
    Navigator.of(context).pop();
    var whatsappstore = Platform.isAndroid
        ? "https://play.google.com/store/apps/details?id=com.whatsapp&hl=en_IN"
        : "https://apps.apple.com/in/app/whatsapp-messenger/id310633997";

    whatsappUrl =
        "whatsapp://send?phone=+971504350673&text=Hello,I%20am%20facing%20some%20issues";

    whatsappUrl = whatsappUrl.replaceAll(" ", "%20");

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      await launchUrl(Uri.parse(whatsappstore));
    }
  }

  Widget _needhelp() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            whatsappBottomModalold(context);
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 65,
                decoration: BoxDecoration(
                    color: common_gray_color,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: SvgPicture.asset(ImageConstants.whatsapp,
                            height: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 5),
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: TextWidget(
                              text: "Need Help?",
                              weight: FontWeight.w500,
                              size: text_font_medium_x_size,
                            )),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      child: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              PreferredSize(
                preferredSize: Size.fromHeight(90.0),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(gradient: gradient_theme_color),
                ),
              ),
              _enterpinappbar(),
              _bodybox(),
            ],
          ),
          SizedBox(height: 20),
          _needhelp(),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _tabbar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // color: black_color,
      child: BottomBar(
        initialIndex: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top:false,
      bottom: true,
      child: Scaffold(
        extendBody: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: Container(
            decoration: BoxDecoration(gradient: gradient_theme_color),
            height: 0,
          ),
        ),
        body: _body(),
        bottomNavigationBar:  SizedBox(height: 95, child: _tabbar()),
      ),
    );
  }

  @override
  void offeredeemResponseSuccess(OfferRedeemModel offeredeemModel) {
    offereddemresponse = offeredeemModel;
    setState(() {
      if (offereddemresponse.status == true) {
        _isoffereddemloader = false;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Thankyou(
                    mandatoryPin: widget.offerdealdata.ofrPinMandatory ?? "",
                    voucherCode: offereddemresponse.values.voucherCode ?? "",
                    transactionId:
                        offereddemresponse.values.transactionId ?? "",
                    brandcode: widget.offerdetail.brandCode,
                    outletcode: widget.offerdetail.outletCode,
                    offercode: widget.offerCode)));
        getMemberSavingBalance();
      } else {
        setState(() {
          _isoffereddemloader = false;
          errortext = "Please enter valid PIN";
        });
      }
    });
  }

  @override
  void newOfferedeemResponseSuccess(NewOfferRedeemModel newOfferRedeemModel) {
    offereddemresponse = newOfferRedeemModel;
    setState(() {
      if (offereddemresponse.status == true) {
        _isoffereddemloader = false;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Thankyou(
                    mandatoryPin: widget.offerdealdata.ofrPinMandatory ?? "",
                    voucherCode: offereddemresponse.values.voucherCode ?? "",
                    transactionId:
                        offereddemresponse.values!.transactionId ?? "",
                    brandcode: widget.offerdetail.brandCode,
                    outletcode: widget.offerdetail.outletCode,
                    offercode: widget.offerCode)));
        getMemberSavingBalance();
                makesenseEventPinbasedRedemptionSuccessfulCall();
      }
      if (offereddemresponse.status == false) {
        setState(() {
          _isenterAED = true;
          _isoffereddemloader = false;
          if (offereddemresponse.message.contains("Amount")) {
            aedTextError = offereddemresponse.message;
          } else {
            errortext = offereddemresponse.message;
          }
        });
           makesenseEventPinbasedRedemptionFailedCall();
      } else {
        setState(() {
          _isoffereddemloader = false;
          // errortext = "Please enter valid PIN";
        });
      }
    });
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 6 && !newValue.text.contains('.')) {
      final StringBuffer newText = StringBuffer();
      newText.write(neatCost(newValue.text.replaceAll('.', '')));
      return TextEditingValue(
        text: newText.toString(),
        selection: TextSelection.collapsed(
            offset: neatCost(newValue.text.replaceAll('.', '')).length),
      );
    } else if (newValue.text.length > 6 && newValue.text.endsWith('.')) {
      String text = newValue.text.replaceAll('.', '');
      return TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(
            offset: neatCost(text.replaceAll('.', '')).length),
      );
    } else {
      final regEx = RegExp(r'^\d+\.?\d{0,2}');
      // RegExp(r'^\d*\.?\d*');
      // ignore: prefer_single_quotes
      String newString = regEx.stringMatch(newValue.text) ?? "";
      return newString == newValue.text ? newValue : oldValue;
    }
  }
}

String neatCost(String cost) {
  String res = cost;
  if (cost != null) {
    // for (int i = 3; i < res.length; i += 4) {
    //   res = res.replaceRange(res.length - i, res.length - i, ',');
    // }
    for (int i = 6; i < res.length; i += 6) {
      if (res.length != 8) {
        res = res.replaceRange(res.length - 1, res.length - 1, '.');
      } else {
        res = res.replaceRange(res.length - 2, res.length - 2, '.');
      }
    }
    return res;
  } else {
    return '';
  }
}

class NeatCostFilterFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final StringBuffer newText = StringBuffer();
    newText.write(neatCost(newValue.text.replaceAll('.', '')));
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(
          offset: neatCost(newValue.text.replaceAll('.', '')).length),
    );
  }
}
