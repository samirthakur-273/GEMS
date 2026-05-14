/*Author:Jyoti Gite
 Description:Gift Card Payment Page
  date: 20 may 2022
 */

import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/flight_module/flightBookingConfirmation/flight_confirmation.dart';
import 'package:gems_revamp/flight_module/flight_details/details_modal.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/flighthomereq_model.dart';
import 'package:gems_revamp/giftcard_module/giftcard_thankupage/giftcard_thankupage.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_details/hotel_purchase_details_page.dart';
import 'package:gems_revamp/utils/constants_files/apiconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import '../../makesense_module/makesense_apiconfig.dart';
import '../../utils/gemsGlobals.dart';

class PaymentPage extends StatefulWidget {
  final finalURL, brf_no;
  final String? flowTyp;
  final String? giftbgimg;
  final FlightRequestHolder? flightRequestHolder;
  final guestData;
  final DetailsFlightModel? flightDetailsModel;
  final String? minValue,
      maxValue,
      categoryName,
      productType,
      giftCardName,
      quantity,
      amount;

  PaymentPage(
      {Key? key,
      @required this.finalURL,
      this.brf_no,
      this.flowTyp,
      this.giftbgimg,
      this.flightRequestHolder,
      this.guestData,
      this.flightDetailsModel,
      this.minValue,
      this.maxValue,
      this.categoryName,
      this.productType,
      this.giftCardName,
      this.quantity,
      this.amount})
      : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  // final flutterWebviewPlugin = new FlutterWebviewPlugin();
  late final WebViewController controller;

  bool isloading = true;
  String? url;
  @override
  void initState() {
    super.initState();
    url = widget.finalURL;

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              isloading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains(ApiConstanst.PAYMENT_URL) ||
                request.url.contains(ApiConstanst.PAYMENT_URL_FAIL) ||
                request.url.contains("successful") ||
                request.url.contains("failure")) {
              Navigator.pop(context);
              if (widget.flowTyp == "GIFTCARD") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GiftCardThankuPage(
                        orderUrl: request.url,
                        tranxId: widget.brf_no,
                        bgimg: widget.giftbgimg ?? '',
                        giftCardName: widget.giftCardName,
                        minValue: widget.minValue,
                        maxValue: widget.maxValue,
                        categoryName: widget.categoryName,
                        productType: widget.productType,
                        amount: widget.amount,
                        quantity: widget.quantity,
                      ),
                    ));
              } else if (widget.flowTyp == "FLIGHT") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FlightBookingConfirmationPage(
                              orderUrl: request.url,
                              brfNo: widget.brf_no,
                              flightRequestHolder: widget.flightRequestHolder,
                              guestData: widget.guestData,
                              flightDetailsModel: widget.flightDetailsModel,
                            )));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HotelPurchaseDetailsPage(
                          orderUrl: request.url, brf_no: widget.brf_no),
                    ));
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url!));

    if (widget.flowTyp == GemsGLobals.giftCardText) {
      makesenseEventCall();
    }

    GemsGLobals.lastVisitPageName = GemsGLobals.eventGiftcardDetailPage;
  }

  makesenseEventCall() {
    var segmentReq = {
      'giftcard_name': widget.giftCardName ?? '',
      'category': widget.categoryName,
      'giftcard_type': widget.productType,
      'min_value': widget.minValue,
      'max_value': widget.maxValue,
      "value": widget.amount,
      "qty": widget.quantity,
      'int_source': GemsGLobals.lastVisitPageName
    };
    String keyName = GemsGLobals.eventGiftcardPaymentPage;
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: Text('Demo'),
    );
    return Container(
      child: SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(90.0),
                child: GradientAppBar(
                  title: "Pay by card",
                  color: white_text_color,
                  size: text_font_medium17_size,
                  weight: FontWeight.w500,
                  centerTitle: true,
                  height: 90,
                )),
            body: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        color: Colors.black,
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: TextWidget(
                          text:
                              "Please do not click back or close the app on this page as existing booking is in progress.",
                          size: text_font_size_x_small,
                          color: white_text_color,
                          alignment: TextAlign.center,
                        ),
                      ),
                    ],
                  )),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                          color: Colors.grey,
                          child: WebViewWidget(
                            controller: controller,
                          )),
                      isloading == true
                          ? Container(
                              child: Center(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: SpinKitCircle(
                                    color: blue_color,
                                  ),
                                ),
                              ),
                              height: MediaQuery.of(context).size.height -
                                  (appBar.preferredSize.height +
                                      MediaQuery.of(context).padding.top),
                            )
                          : SizedBox(
                              height: 0,
                            ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
