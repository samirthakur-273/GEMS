import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../common_widget/bottombar.dart';

class GiftPurchaseDetailsPage extends StatefulWidget {
  final giftPurhaseDetails;
  final type;
  GiftPurchaseDetailsPage({Key? key, this.giftPurhaseDetails, this.type})
      : super(key: key);

  @override
  _GiftPurchaseDetailsPageState createState() =>
      _GiftPurchaseDetailsPageState();
}

class _GiftPurchaseDetailsPageState extends State<GiftPurchaseDetailsPage> {
  var giftPurhaseDetails = [];

  @override
  void initState() {

    super.initState();
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

  Widget _gotoHomeButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TabsScreen(
                      initialIndex: 0,
                    )));
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: gradient_theme_color),
        child: const Center(
            child: TextWidget(
          text: 'Go to Home',
          color: white_text_color,
          size: text_font_medium18_size,
          weight: FontWeight.w500,
        )),
      ),
    );
  }

  Widget _cardNumberView(_data) {
    return Container(
      child: TextWidget(
        text: _data + " " ?? "",
        size: text_font_medium14_size,
        weight: FontWeight.bold,
      ),
    );
  }

  List<Widget> _cardNumberWidget(_data) {
    List<Widget> list = [];
    for (var i = 0; i < _data.length; i++) {
      list.add(_cardNumberView(
        _data[i].voucherCode,
      ));
    }
    return list;
  }

  _getPaidAmount() {
    if (widget.giftPurhaseDetails?.transactionType == "RD") {
      return "${pointsFormatter(widget.giftPurhaseDetails?.pointsRedeemed ?? 0)} GEMS Points";
    } else if (widget.giftPurhaseDetails?.transactionType == "PC") {
      return "AED ${pointsFormatter(widget.giftPurhaseDetails?.amountPaid ?? 0)}";
    } else {
      return "AED ${pointsFormatter(widget.giftPurhaseDetails?.amountPaid ?? 0)}";
    }
  }

  _getPaidBOUNZ() {
    if (widget.giftPurhaseDetails?.transactionType == "PC") {
      return "${pointsFormatter(widget.giftPurhaseDetails?.pointsRedeemed ?? 0)} GEMS Points";
    } else {
      return "";
    }
  }

  Widget _gcPurchaseInfo() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: 'E-Gift Card',
                size: text_font_size_x_small,
                color: date_text_color,
              ),
              const SizedBox(
                height: 7,
              ),
              TextWidget(
                text:
                    "AED ${pointsFormatter(widget.giftPurhaseDetails?.denominationAmount ?? 0)} ${widget.giftPurhaseDetails?.productName ?? ""} X ${widget.giftPurhaseDetails?.quantity ?? 1}",
                size: text_font_medium15_size,
                color: purchase_text_color,
                weight: FontWeight.w600,
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: GemsGLobals.giftVerificationPin,
                size: text_font_size_x_small,
                color: date_text_color,
              ),
              const SizedBox(
                height: 7,
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(
                          text: widget.giftPurhaseDetails?.giftVerificatonPin))
                      .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        content: Text(GemsGLobals.copyClipboardText)));
                  });
                },
                child: TextWidget(
                  text: widget.giftPurhaseDetails?.giftVerificatonPin,
                  size: text_font_medium15_size,
                  color: purchase_text_color,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                text: 'Payment Type ',
                size: text_font_size_x_small,
                color: date_text_color,
              ),
              const SizedBox(
                height: 7,
              ),
              TextWidget(
                text:
                    "${widget.giftPurhaseDetails?.transactionType == "RD" ? "GEMS Points" : widget.giftPurhaseDetails.transactionType == "PC" ? "Cash + GEMS Points" : "Online"}",
                size: text_font_medium15_size,
                color: purchase_text_color,
                weight: FontWeight.w600,
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: widget.giftPurhaseDetails?.transactionType == "RD"
                        ? "Redeemed GEMS Points"
                        : "Amount Paid",
                    size: text_font_size_x_small,
                    color: date_text_color,
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  TextWidget(
                    text: _getPaidAmount(),
                    size: text_font_medium15_size,
                    color: purchase_text_color,
                    weight: FontWeight.w600,
                  ),
                  TextWidget(
                    text:
                        'Earned ${pointsFormatter(widget.giftPurhaseDetails?.earnPoints ?? 0)} GEMS Points',
                    size: text_font_size_x_small,
                    color: blue_color,
                  ),
                ],
              ),
              widget.giftPurhaseDetails?.transactionType == "PC"
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: 'GEMS Redeemed',
                          size: text_font_size_x_small,
                          color: date_text_color,
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        TextWidget(
                          text: _getPaidBOUNZ(),
                          size: text_font_medium15_size,
                          color: purchase_text_color,
                          weight: FontWeight.w600,
                        )
                      ],
                    )
                  : Container(
                      height: 0,
                    ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: GemsGLobals.giftCardSentTo,
                    size: text_font_size_x_small,
                    color: date_text_color,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextWidget(
                    text: widget.giftPurhaseDetails?.receiverEmail,
                    size: text_font_medium14_size,
                    color: purchase_text_color,
                    weight: FontWeight.w600,
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _eGiftcardWeb() {
    return Container(
        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
        padding: EdgeInsets.fromLTRB(15, 18, 15, 18),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          // border: Border.all(color: orange_color, width: 2)
        ),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'This screen cannot be presented for redemption.\n',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: white_text_color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: "Please click '",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: white_text_color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  )),
              TextSpan(
                  text: 'My E-Gift Cards',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.amber.withAlpha((0.9 * 255).toInt()),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  )),
              TextSpan(
                  text: "' to view the actual gift card & ",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: white_text_color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  )),
              TextSpan(
                  text: "barcode to be presented at the time of redemption.",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: white_text_color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ));
  }

  Widget _giftTitleWidget() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          TextWidget(
            textAlign: TextAlign.center,
            text:
                'AED ${pointsFormatter(widget.giftPurhaseDetails.denominationAmount ?? 0)} ' +
                    widget.giftPurhaseDetails.productName,
            color: purchase_text_color,
            size: text_font_medium19_size,
            weight: FontWeight.w500,
          ),
          const SizedBox(
            height: 5,
          ),
          const TextWidget(
            text: 'Thank you for your purchase',
            color: date_text_color,
            size: text_font_medium15_size,
            weight: FontWeight.normal,
          ),
          const SizedBox(
            height: 10,
          ),
          TextWidget(
            text: "Transaction ID: ${widget.giftPurhaseDetails.transactionId}",
            size: text_font_medium14_size,
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              _launchURL(widget.giftPurhaseDetails.values[0].giftcardUrl);
            },
            child: Container(
              height: 55,
              width: 160,
              decoration: BoxDecoration(
                  color: const Color(0xfffeeee5),
                  borderRadius: BorderRadius.circular(16)),
              child: const Center(
                child: TextWidget(
                  text: 'My E-Gift Cards',
                  size: text_font_medium17_size,
                  color: Color(0xfff46922),
                  weight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _gcImageWidget() {
    return Container(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 4,
            width: MediaQuery.of(context).size.width / 1,
            decoration: BoxDecoration(gradient: gradient_theme_color),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
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
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 20, top: 10),
                      alignment: Alignment.topCenter,
                      // margin: EdgeInsets.only(right: 17),
                      child: TextWidget(
                        text: "Gift Cards Details",
                        color: white_text_color,
                        size: 18,
                        weight: FontWeight.w500,
                        // centerTitle: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: 25,
                right: 25,
                top: MediaQuery.of(context).size.height / 9),
            height: 150,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: FadeInImage.assetNetwork(
                  fit: BoxFit.fill,
                  placeholder: ImageConstants.gems_placeholder,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      ImageConstants.gems_placeholder,
                      fit: BoxFit.fill,
                    );
                  },
                  image: widget.giftPurhaseDetails.mobileImage),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Container(
      child: ListView(
        children: [
          _gcImageWidget(),
          const SizedBox(
            height: 10,
          ),
          _giftTitleWidget(),
          const SizedBox(
            height: 10,
          ),
          _eGiftcardWeb(),
          const SizedBox(
            height: 15,
          ),
          _gcPurchaseInfo(),
          const SizedBox(
            height: 15,
          ),
          _gotoHomeButton(),
          const SizedBox(
            height: 30,
          )
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
        tabvalue: "myaccount",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          extendBody: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.0),
            child: Container(
              decoration: BoxDecoration(gradient: gradient_theme_color),
            ),
          ),
          body: _body(),
          bottomNavigationBar: SizedBox(
            height: 95,
            child: _tabbar(),
          ),        ),
      ),
    );
  }
}
