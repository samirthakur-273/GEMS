/* Author : Sanjana Shetty
 Date created : 13-April-2022
 Discription : Thank You Page */

import 'package:barcode_widgets/barcode_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/offer_module/offer_receipt/model_offerfeedback.dart';
import 'package:gems_revamp/offer_module/offer_receipt/presenter_offerfeedback.dart';
import 'package:gems_revamp/offer_module/offer_receipt/view_offerfeedback.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:gems_revamp/utils/time_out.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../../common_widget/bottombar.dart';
import '../../common_widget/font_size.dart';

class Thankyou extends StatefulWidget {
  final voucherCode;
  final mandatoryPin;
  final transactionId;
  final brandcode;
  final outletcode;
  final offercode;

  const Thankyou(
      {Key? key,
      this.brandcode,
      this.outletcode,
      this.offercode,
      this.transactionId,
      this.mandatoryPin,
      this.voucherCode})
      : super(key: key);
  @override
  _ThankyouState createState() => _ThankyouState();
}

class _ThankyouState extends State<Thankyou> implements OfferFeedbackView {
  var _rating = 0.0;
  var _controller = TextEditingController();
  bool _submitloader = false;
  OfferFeedBack offerfeedbackdata = OfferFeedBack();
  OfferFeedbackPresenter? _offerpresenter;
  var offerfeedbackresponse;

  @override
  void initState() {
    super.initState();
    _offerpresenter = OfferFeedbackPresenter(this);
  }

  void offerfeedbackapi() {
    var request = {
      // "customer_id": "2719373804",
      "customer_id": GemsGLobals.membershipNo,
      "brand_code": widget.brandcode,
      "outlet_code": widget.outletcode,
      "offer_code": widget.offercode,
      "rating": _rating,
      "comment": _controller.text,
      "transaction_id": widget.transactionId.toString()
    };
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _offerpresenter!.callOfferFeedbackAPI(request);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          setState(() {});
          _offerpresenter!.callOfferFeedbackAPI(request);
        }
      }
    });
  }

  Widget _thankyou() {
    return Container(
        child: Center(
      child: TextWidget(
        text: "Thank you",
        size: text_font_large26_size,
        weight: FontWeight.bold,
      ),
    ));
  }

  Widget _offerdetail() {
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: Center(
          child: TextWidget(
            text: "You have successfully availed the offer",
            size: text_font_medium15_size,
            color: grey_lightdark,
          ),
        ));
  }

  Widget _barcodemessage() {
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: Center(
          child: TextWidget(
            alignment: TextAlign.center,
            text:
                "Please present the below bar code to the \nmerchant to scan and complete the transaction",
            size: text_font_medium15_size,
            color: grey_lightdark,
          ),
        ));
  }

  Widget _barcode() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 0),
      child: Center(
          child: Container(
        alignment: Alignment.center,
        child: BarCodeImage(
          params: Code39BarCodeParams(
            '${this.widget.voucherCode}',
            lineWidth: 1.3,
            barHeight: 50.0,
            withText: false,
          ),
          onError: (error) {},
        ),
        //  new BarCodeImage(
        //   data: "${this.widget.voucherCode}", // Code string. (required)
        //   codeType: BarCodeType.Code39, // Code type (required)
        //   lineWidth: 1.3,
        //   barHeight: 50.0,
        //   hasText: false,
        //   onError: (error) {},
        // ),
      )),
    );
  }

  Widget _barcodeShow() {
    return Container(
      child: Center(
          child: TextWidget(
        text: "Barcode No: "+ this.widget.voucherCode,
        color: grey_gunsmoke_text_color,
      )),
    );
  }

  Widget _transid() {
    return Container(
        child: Center(
      child: TextWidget(
        text: "Your Transaction ID is",
        size: text_font_medium15_size,
        color: grey_lightdark,
      ),
    ));
  }

  Widget _id() {
    return Container(
        margin: EdgeInsets.only(top: 5),
        child: Center(
          child: TextWidget(
            text: widget.transactionId,
            size: text_font_large28_size,
            weight: FontWeight.w600,
          ),
        ));
  }

  Widget _ratethisoutlet() {
    return Container(
        child: Center(
      child: TextWidget(
        text: "Rate this outlet",
        size: text_font_medium15_size,
        color: dark_grey,
      ),
    ));
  }

  Widget _starating() {
    return Container(
      margin: EdgeInsets.only(right: 0),
      child: SmoothStarRating(
          allowHalfRating: false,
          rating: _rating,
          onRatingChanged: (rating) {
            setState(() {
              _rating = rating;
            });
          },
          starCount: 5,
          //  isReadOnly: false,
          size: text_font_large30_size,
          color: star_yellow_color,
          borderColor: star_yellow_color,
          spacing: 4.0),
    );
  }

  Widget _comment() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: TextWidget(
              text: "Please add comments, if any",
              color: Colors.grey[600],
              size: 15,
            ),
          ),
          Container(
            height: 80,
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: light_bluish,
              border: Border.all(width: 1, color: grey_color),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              maxLines: 2,
              maxLength: 250,
              controller: _controller,
              style: TextStyle(
                  color: black_color,
                  fontSize: text_font_small,
                  fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  counterText: "",
                  hintText: "Type message here",
                  hintStyle: TextStyle(
                      color: light_grey, fontWeight: FontWeight.w500)),
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> feedabckemptyRatingsalert(message, BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Container(
            margin: EdgeInsets.only(top: 25, left: 15, right: 15),
            height: 120,
            child: Column(
              children: <Widget>[
                Container(
                  child: TextWidget(
                    text: message,
                    size: text_font_medium_x_size,
                    weight: FontWeight.w600,
                    color: blackk,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        color: boxgreencolor,
                        borderRadius: BorderRadius.circular(10)),
                    child: new TextButton(
                      child: TextWidget(
                        text: GemsGLobals.ok,
                        textAlign: TextAlign.center,
                        color: white_color,
                        size: text_font_medium_x_size,
                        weight: FontWeight.bold,
                      ),
                      onPressed: () {
                        _rating = 0.0;
                        setState(() {});
                        if (message == GemsGLobals.noRatingsMessage) {
                          Navigator.pop(context);
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TabsScreen(
                                        initialIndex: 0,
                                      )));
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _submit() {
    return _submitloader
        ? Center(
            child: SpinKitCircle(
              color: btn_bg_color,
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  if (_rating == 0.0) {
                    feedabckemptyRatingsalert(
                        "You haven't entered any ratings.", context);
                  } else {
                    setState(() {
                      _submitloader = true;
                    });

                    offerfeedbackapi();
                  }
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  textStyle: MaterialStateProperty.all(
                      TextStyle(color: Color(0xffffffff))),
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor:
                      MaterialStateProperty.all(button_bgpdf_color),
                  minimumSize: MaterialStateProperty.all(Size(0, 0)),
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15, top: 13, bottom: 13),
                  child: TextWidget(
                    text: "Submit",
                    color: white_color,
                    size: text_font_medium18_size,
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
  }

  Widget _returnToHome() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () async {
            
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TabsScreen(
                          initialIndex: 0,
                        )));
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            textStyle:
                MaterialStateProperty.all(TextStyle(color: Color(0xffffffff))),
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(button_bgpdf_color),
            minimumSize: MaterialStateProperty.all(Size(0, 0)),
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15, top: 13, bottom: 13),
            child: TextWidget(
              text: "Go To Home",
              color: white_color,
              size: text_font_medium18_size,
              weight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _image() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
          child: SvgPicture.asset(
        ImageConstants.thankyou,
        fit: BoxFit.fill,
        height: 210,
      )),
    );
  }

  Widget _body() {
    return Container(
        color: white_color,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            _image(),
            _thankyou(),
            _offerdetail(),
            SizedBox(height: 8),
            _transid(),
            _id(),
            this.widget.mandatoryPin == 1
                ? this.widget.voucherCode != ""
                    ? _barcodemessage()
                    : Container(height: 0)
                : Container(
                    height: 0,
                  ),
            SizedBox(
              height: 20,
            ),
            this.widget.mandatoryPin == 1
                ? this.widget.voucherCode != ""
                    ? _barcode()
                    : Container(
                        height: 0,
                      )
                : Container(
                    height: 0,
                  ),
            SizedBox(
              height: 5,
            ),
            this.widget.mandatoryPin == 1
                ? this.widget.voucherCode != ""
                    ? _barcodeShow()
                    : Container(
                        height: 0,
                      )
                : Container(
                    height: 0,
                  ),
            SizedBox(height: 15),
            _ratethisoutlet(),
            SizedBox(height: 5),
            _starating(),
            SizedBox(height: 12),
            _comment(),
            SizedBox(height: 25),
            _submit(),
            SizedBox(height: 20),
            _returnToHome(),
            SizedBox(height: 120),
          ]),
        ));
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
    return PopScope(
          canPop: false,
          onPopInvoked: (canPop) async {
             Future.value(false);
          },
      child: Container(
        decoration: BoxDecoration(gradient: gradient_theme_color),
        child: SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            extendBody: true,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(90.0),
              child: Container(
                  decoration: BoxDecoration(gradient: gradient_theme_color),
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(
                    top: 25,
                  ),
                  height: 90,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            // margin: EdgeInsets.only(right: 30),
                            child: TextWidget(
                              text: "Receipt",
                              color: white_text_color,
                              size: text_font_medium18_size,
                              weight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
            body: _body(),
            bottomNavigationBar:  SizedBox(height: 95, child: _tabbar()),
          ),
        ),
      ),
    );
  }

  @override
  void getofferfeedbackFailure(error) {
    if (error == "timeout") {
      setState(() {
        _submitloader = false;
      });
    }
  }

  @override
  void getofferfeedbackResponseSuccess(OfferFeedBack offerfeedbackModel) {
    offerfeedbackresponse = offerfeedbackModel;
    setState(() {
      if (offerfeedbackresponse.status == true) {
        _submitloader = false;
        feedabckemptyRatingsalert(offerfeedbackresponse.message, context);
      } else {
        _submitloader = false;
      }
    });
  }

  @override
  void timeOutError(String error) async {
    if (error == "timeout") {
      setState(() {
        _submitloader = false;
      });
      bool isRetry = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => TimeOut()));
      if (isRetry && isRetry != null) {
        offerfeedbackapi();
      }
    }
  }
}
