/*Author:Jyoti Gite
Description:Gift Card Home Page


date: 19 apr 2022
*/

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gems_revamp/common_widget/Gradient_button.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/giftcard_module/giftcard_thankupage/gfitcard_confirm_model.dart';
import 'package:gems_revamp/giftcard_module/giftcard_thankupage/gfitcard_confirm_presenter.dart';
import 'package:gems_revamp/giftcard_module/giftcard_thankupage/gfitcard_confirm_view.dart';
import 'package:gems_revamp/giftcard_module/giftcard_thankupage/giftcard_failed.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gc_db/gc_list_dbhelper.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../common_widget/bottombar.dart';

class GiftCardThankuPage extends StatefulWidget {
  final String? tranxId;
  final purchaseData;
  final type;
  final String? bgimg;
  final String? orderUrl;
  final String? minValue,
      maxValue,
      categoryName,
      productType,
      giftCardName,
      quantity,
      amount;
  GiftCardThankuPage({
    this.tranxId,
    this.purchaseData,
    this.type,
    this.bgimg,
    this.orderUrl,
    this.minValue,
    this.maxValue,
    this.categoryName,
    this.productType,
    this.giftCardName,
    this.quantity,
    this.amount,
    Key? key,
  }) : super(key: key);

  @override
  State<GiftCardThankuPage> createState() => _GiftCardThankuPageState();
}

class _GiftCardThankuPageState extends State<GiftCardThankuPage>
    implements GiftCnfrmView {
  bool _isLoading = true;
  GiftConfrmModal? _giftConfrmModal;
  var _confirmationPageData;
  var noConnection;
  @override
  void initState() {
    // apiCall();

    if (widget.type == "redemption" && widget.purchaseData != null) {
      _isLoading = false;

      _confirmationPageData = widget.purchaseData;
    } else {
      apiCall();
    }

    GiftCardPurchaseListDBHelper().truncateTable();

    super.initState();
  }

  void apiCall() {
    setState(() {
      _isLoading = true;
    });
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        var _req = {
          "transaction_id": "${this.widget.tranxId}",
          'pg_redirection_url': widget.orderUrl
        };
        GiftCnfrmPresenter().getList(this, _req);
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          apiCall();
        }
      }
    });
  }

  Widget _imageData() {
    return Stack(
      children: [
        Center(
          child: Container(
              height: 160,
              width: MediaQuery.of(context).size.width / 1.2,
              decoration: BoxDecoration(
                  color: grey200_color,
                  border: Border.all(width: 0.4, color: grey200_color),
                  borderRadius: BorderRadius.circular(12)),
              // alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: // 'https://giftoneapiuat.bounz.io/uploads/gvimages/product/14/1623811604264mobweb-img-14.png'
                      _confirmationPageData?.mobileImage != null
                          ? _confirmationPageData?.mobileImage
                          : "",
                  placeholder: (context, url) {
                    return Image.asset(
                      ImageConstants.noimages,
                      fit: BoxFit.fill,
                    );
                  },
                  fit: BoxFit.fill,
                  errorWidget: (context, url, error) {
                    return Image.asset(
                      ImageConstants.noimages,
                      fit: BoxFit.fill,
                    );
                  },
                ),
              )),
        ),
        // Positioned(
        //     left: 5,
        //     top: 5,
        //     child: TextWidget(
        //       text: "AED 500",
        //       weight: FontWeight.w600,
        //       size: text_font_small,
        //     ))
      ],
    );
  }

/* background shadow image */
  Widget _upperWidget() {
    return Stack(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(gradient: gradient_theme_color),
            height: Platform.isIOS ? 200 : 210,
            padding: EdgeInsets.only(top: 50),
            alignment: Alignment.topCenter,
            child: TextWidget(
              text: "Gift Cards Details",
              color: white_text_color,
              size: 18,
              weight: FontWeight.w500,
              // centerTitle: true,
            )),
        Positioned(top: 120, left: 20, right: 20, child: _imageData())
      ],
    );
  }

  Widget _cardNumberView(_data) {
    return Container(
      child: TextWidget(
        text: _data + " " ?? "",
        size: text_font_small,
        weight: FontWeight.bold,
      ),
    );
  }

  List<Widget> _cardNumberWidget(_data) {
    List<Widget> list = [];
    for (var i = 0; i < (_data?.length ?? 0); i++) {
      list.add(_cardNumberView(
        _data[i].voucherCode,
      ));
    }
    return list;
  }

/* Go to home button */
  Widget _btnWidget() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.only(bottom: 10, top: 10),
      width: MediaQuery.of(context).size.width,
      child: GradientButtonWidget(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        shadowColor: BoxShadow(
            color: blue_color.withOpacity(0.2),
            offset: new Offset(0, 11),
            blurRadius: 11,
            spreadRadius: 0.0),
        child: TextWidget(
          text: "Go To Home",
          color: white_text_color,
          size: text_font_medium_size,
          weight: FontWeight.bold,
        ),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/tabbarpage');
        },
      ),
    );
  }

  _getPaidAmount() {
    if (_confirmationPageData?.transactionType == GemsGLobals.rdText) {
      return "${pointsFormatter(_confirmationPageData?.pointsRedeemed ?? 0)} GEMS Points";
    } else if (_confirmationPageData?.transactionType == "PC") {
      return "AED ${pointsFormatter(_confirmationPageData?.amountPaid ?? 0)}";
    } else {
      return "AED ${pointsFormatter(_confirmationPageData?.amountPaid ?? 0)}";
    }
  }

  _getPaidBOUNZ() {
    if (_confirmationPageData?.transactionType == "PC") {
      return "${pointsFormatter(_confirmationPageData?.pointsRedeemed ?? 0)} Gems points";
    } else {
      return "";
    }
  }

  _launchURL(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _centerWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          TextWidget(
            text:
                "AED ${pointsFormatter(_confirmationPageData?.denominationAmount ?? 0)} ${_confirmationPageData?.productName}",
            size: text_font_medium15_size,
          ),
          SizedBox(
            height: 5,
          ),
          TextWidget(
            text: "Thank you for your purchase",
            size: text_font_medium_size,
            weight: FontWeight.w600,
          ),
          SizedBox(
            height: 10,
          ),
          this.widget.tranxId != null && this.widget.tranxId != ''
              ? TextWidget(
                  text: "Transaction ID: ${this.widget.tranxId}",
                  size: text_font_medium15_size,
                )
              : Container(
                  height: 0,
                ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 7, 5, 7),
              width: 170,
              decoration: BoxDecoration(
                  color: white_text_color,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: blue_color, width: 2)),
              child: Center(
                child: TextWidget(
                  text: "My E-Gift Cards",
                  color: black_color,
                  size: text_font_medium_size,
                  weight: FontWeight.w400,
                ),
              ),
            ),
            onTap: () {
              _launchURL(_confirmationPageData.objects?.values[0].giftcardUrl);
            },
          ),
          SizedBox(
            height: 17,
          ),
          Container(
              padding: EdgeInsets.fromLTRB(15, 18, 15, 18),
              decoration: BoxDecoration(
                color: black_color,
                borderRadius: BorderRadius.circular(15),
                // border: Border.all(color: orange_color, width: 2)
              ),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'This screen cannot be presented for redemption.\n',
                  style: TextStyle(
                    fontFamily: 'Sans_Pro',
                    color: white_text_color,
                    fontSize: text_font_size_small,
                    fontWeight: FontWeight.w600,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Please click '",
                        style: TextStyle(
                          fontFamily: 'Sans_Pro',
                          color: white_text_color,
                          fontSize: text_font_size_small,
                          fontWeight: FontWeight.w600,
                        )),
                    TextSpan(
                        text: 'My E-Gift Cards',
                        style: TextStyle(
                          fontFamily: 'Sans_Pro',
                          color: Colors.orange.withOpacity(0.9),
                          fontSize: text_font_size_small,
                          fontWeight: FontWeight.w600,
                        )),
                    TextSpan(
                        text: "' to view the actual gift card & ",
                        style: TextStyle(
                          fontFamily: 'Sans_Pro',
                          color: white_text_color,
                          fontSize: text_font_size_small,
                          fontWeight: FontWeight.w600,
                        )),
                    TextSpan(
                        text:
                            "barcode to be presented at the time of redemption.",
                        style: TextStyle(
                          fontFamily: 'Sans_Pro',
                          color: white_text_color,
                          fontSize: text_font_size_small,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              )),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _lowerWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 30, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextWidget(
            text: "E-GIFT CARD",
            size: text_font_small,
            color: black_color.withOpacity(0.5),
          ),
          SizedBox(
            height: 5,
          ),
          TextWidget(
            text:
                "AED ${pointsFormatter(_confirmationPageData?.denominationAmount ?? 0)} ${_confirmationPageData?.productName ?? ""} X ${_confirmationPageData?.quantity ?? 1}",
            size: text_font_small,
            weight: FontWeight.bold,
          ),
          SizedBox(
            height: 15,
          ),
          TextWidget(
            text: GemsGLobals.giftVerificationPin,
            size: text_font_small,
            color: black_color.withOpacity(0.5),
          ),
          SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(
                      text: _confirmationPageData.transactionType ==
                              GemsGLobals.rdText
                          ? _confirmationPageData?.giftVerificationPin
                          : _confirmationPageData
                              .objects!.egiftCard!.giftVerificationPin))
                  .then((value) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    content: Text(GemsGLobals.copyClipboardText)));
              });
            },
            child: TextWidget(
              text: _confirmationPageData.transactionType == GemsGLobals.rdText
                  ? _confirmationPageData?.giftVerificationPin
                  : _confirmationPageData
                      .objects!.egiftCard!.giftVerificationPin,
              size: text_font_small,
              weight: FontWeight.bold,
            ),
          ),

          SizedBox(
            height: 15,
          ),
          TextWidget(
            text: "PAYMENT TYPE",
            size: text_font_small,
            color: black_color.withOpacity(0.5),
          ),
          SizedBox(
            height: 5,
          ),
          TextWidget(
            text:
                "${_confirmationPageData?.transactionType == "RD" ? "GEMS Points" : _confirmationPageData?.transactionType == "PC" ? "Cash + GEMS Points" : "Online"}",
            size: text_font_small,
            weight: FontWeight.bold,
          ),
          SizedBox(
            height: 15,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Expanded(
          //       child: TextWidget(
          //         text: "AMOUNT PAID",
          //         size: medium_text_size_14,
          //         color: Colors.black.withOpacity(0.5),
          //       ),
          //     ),
          //     Expanded(
          //       child: TextWidget(
          //         text: "BOUNZ REDEEMED",
          //         size: medium_text_size_14,
          //         color: Colors.black.withOpacity(0.5),
          //       ),
          //     ),
          //   ],
          // ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: "AMOUNT PAID",
                      size: text_font_small,
                      color: black_color.withOpacity(0.5),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextWidget(
                      text: _getPaidAmount(),
                      size: text_font_medium16_size,
                      weight: FontWeight.bold,
                    ),
                    _confirmationPageData?.transactionType == "ACC" ||
                            _confirmationPageData.earnPoints > 0
                        ? TextWidget(
                            text:
                                "Earned ${pointsFormatter(_confirmationPageData.earnPoints ?? 0)} Gems Points",
                            size: 13,
                            color: blue_color,
                          )
                        : Container(
                            height: 0,
                          ),
                  ],
                ),
              ),
              _confirmationPageData?.transactionType == "PC"
                  ? Container(
                      margin: EdgeInsets.only(bottom: 17, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: "GEMS Points REDEEMED  ",
                            size: text_font_small,
                            color: Colors.black.withOpacity(0.5),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          TextWidget(
                            text: _getPaidBOUNZ(),
                            size: text_font_medium16_size,
                            weight: FontWeight.bold,
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 0,
                    ),
            ],
          ),
          SizedBox(
            height: 3,
          ),
          // TextWidget(
          //   text: _getPaidAmount(),
          //   size: medium_text_size_14,
          //   weight: FontWeight.bold,
          // ),

          SizedBox(
            height: 15,
          ),
          _confirmationPageData.receiverEmail != '' &&
                  _confirmationPageData.receiverEmail != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: GemsGLobals.giftCardSentTo,
                      color: black_color.withOpacity(0.5),
                      size: text_font_small,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Wrap(
                      children: <Widget>[
                        TextWidget(
                          text: _confirmationPageData.receiverEmail,
                          size: text_font_small,
                          weight: FontWeight.bold,
                        ),
                        // TextWidget(
                        //   text: " and ",
                        //   size: medium_text_size_14,
                        // ),
                        // TextWidget(
                        //   text: "${_confirmationPageData?.receiverMobile ?? ""}",
                        //   size: medium_text_size_14,
                        //   weight: FontWeight.bold,
                        // ),
                      ],
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _body() {
    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) async {
        Future.value(false);
      },
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: Platform.isIOS ? 320 : 300,
              child: _upperWidget(),
            ),
            _centerWidget(),
            _lowerWidget(),
            SizedBox(
              height: 30,
            ),
            _btnWidget(),
            SizedBox(
              height: 100,
            ),
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
    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          extendBody: true,
          body: _isLoading
              ? Center(
                  child: SpinKitCircle(
                  color: blue_color,
                ))
              : _body(),
          bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
        ),
      ),
    );
  }

  @override
  void allErr(error) {
    _isLoading = false;
    setState(() {});
  }

  makesenseEventCall(GiftConfrmModal giftConfrmModal, keyName) {
    var segmentReq = {
      'giftcard_name': widget.giftCardName ?? '',
      'category': widget.categoryName,
      'giftcard_type': widget.productType,
      'min_value': widget.minValue,
      'max_value': widget.maxValue,
      "value": widget.amount,
      "qty": widget.quantity,
      "payment_method": giftConfrmModal.transactionType,
      "reason": giftConfrmModal.message ?? '',
      'int_source': GemsGLobals.lastVisitPageName
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  @override
  void confirmResp(GiftConfrmModal giftConfrmModal) {
    _confirmationPageData = giftConfrmModal;

    _isLoading = false;
    if(giftConfrmModal.message!.contains(GemsGLobals.paymentCapturedErrorMessage)){
       Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => GiftCardFailed()));
      String keyName = GemsGLobals.eventGiftcardPaymentFailed;
      makesenseEventCall(giftConfrmModal, keyName);
    }
    else{
    if (giftConfrmModal.message == GemsGLobals.orderGeneratedText) {
      String keyName = GemsGLobals.eventGiftcardPaymentSuccessful;

      makesenseEventCall(giftConfrmModal, keyName);
    } else {
      String keyName = GemsGLobals.eventGiftcardPaymentFailed;

      makesenseEventCall(giftConfrmModal, keyName);
    }
    }
    if (mounted) {
      setState(() {});
    }
    GemsGLobals.lastVisitPageName = GemsGLobals.giftCardSuccessPage;
}
}
