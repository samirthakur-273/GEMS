// import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
// import 'package:gems_revamp/common_widget/colors_widget.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
// import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';

// class TrackOrderWebView extends StatefulWidget {
//   final urlKey;
//   TrackOrderWebView({this.urlKey});

//   @override
//   _TrackOrderWebViewState createState() => _TrackOrderWebViewState();
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/button_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/my_orders_detail/my_orders_detail_model.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackingDetails extends StatefulWidget {
  var orderid;
  final OrderTrackingModel? orderTrackingModel;
  @override
  _TrackingDetailsState createState() => _TrackingDetailsState();
  TrackingDetails({Key? key, @required this.orderid, this.orderTrackingModel})
      : super(key: key);
}

class _TrackingDetailsState extends State<TrackingDetails> {
  bool isLoading = true;
  List<Orderdatum> orderdataResult = [];
  List<Ordertracking> ordertrackingResult = [];
  var order_status;
  bool novalue = false;
  late OrderTrackingModel _orderTrackingModel;
  String url = "";

  var ordermessage;
  @override
  void initState() {
    super.initState();
    _orderTrackingModel = widget.orderTrackingModel!;
    trackingDetails();
  }

  _launchURL(url) async {
     if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      }else {
      throw 'Could not launch $url';
    }
  }

  void trackingDetails() {
    orderdataResult = _orderTrackingModel.orderdata ?? [];
    order_status = _orderTrackingModel.orderdata![0].orderStatus ?? "";
    ordertrackingResult = _orderTrackingModel.ordertracking ?? [];
    ordertrackingResult.forEach((element) {
      if (element.trackdetail!.contains("https"))
        url = element.trackdetail ?? "";
    });

    //
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: new_gradient_color,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: SafeArea(
          bottom: false,
          top: false,
          child: Scaffold(
              appBar: PreferredSize(
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: new_gradient_color,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        boxShadow: [
                          BoxShadow(color: grey_color, blurRadius: 5)
                        ]),
                    height: 90,
                    alignment: Alignment.center,
                    child: Row(children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 36, 10, 0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            "assets/shop_assets/Icon ionic-ios-arrow-dropleft-circle.svg",
                            height: 20,
                            width: 20,
                            color: white_text_color,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.only(top: 36),
                        child: TextWidget(
                          text: "Tracking Details",
                          weight: FontWeight.w600,
                          size: text_size_16,
                          color: white_color,
                        ),
                      ),
                      Spacer(),
                      // Image.asset(
                      //   "assets/shop_assets/Group 10091.png",
                      //   color: white_text_color,
                      // ),
                      SizedBox(
                        width: 25,
                      )
                    ]),
                  ),
                  preferredSize: Size.fromHeight(50)),
              body: novalue == false
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[orderData()],
                    )
                  : _noData())),
    );
  }

  Widget _noData() {
    return Container(
        height: MediaQuery.of(context).size.height / 1.3,
        child: Center(
          child: TextWidget(
            text: "$ordermessage",
            size: text_font_medium_size,
            weight: FontWeight.w600,
          ),
        ));
  }

  Widget orderData() {
    return Container(
        // padding: EdgeInsets.only(top: 5),
        height: MediaQuery.of(context).size.height / 1.2,
        child: Container(
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.fromLTRB(20, 30, 20, 30),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TextWidget(
                                      text: "Order Status:",
                                      color: black_color,
                                      size: text_font_medium_size,
                                      weight: FontWeight.bold,
                                      alignment: TextAlign.left,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextWidget(
                                      text: "Tracking Number:",
                                      color: black_color,
                                      size: text_font_medium_size,
                                      weight: FontWeight.bold,
                                      alignment: TextAlign.left,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextWidget(
                                      text: "Shipped By:",
                                      color: black_color,
                                      size: text_font_medium_size,
                                      weight: FontWeight.bold,
                                      alignment: TextAlign.left,
                                    ),
                                    // SizedBox(
                                    //   height: 20,
                                    // ),
                                    // TextWidget(
                                    //   text: "Tracking Link: ",
                                    //   color: black_color,
                                    //   size: text_font_medium_size,
                                    //   weight: FontWeight.bold,
                                    //   alignment: TextAlign.left,
                                    // ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  //mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    TextWidget(
                                      text: order_status ?? "",
                                      color: black_color,
                                      size: text_font_medium_size,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextWidget(
                                      text: ordertrackingResult[0].trackingId ??
                                          "",
                                      color: black_color,
                                      size: text_font_medium_size,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextWidget(
                                      text:
                                          ordertrackingResult[0].trackdetail ??
                                              "",
                                      color: black_color,
                                      size: text_font_medium_size,
                                    ),
                                   ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          url != null && url != ""
                              ? GestureDetector(
                                  child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 4.0,
                                            color: grey200_color)
                                      ],
                                      gradient: LinearGradient(
                                          colors: new_gradient_color,
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ButtonWidget(
                                      height: 40,
                                      buttonText: "TRACKING ORDER",
                                      textcolor: Colors.white,
                                      size: text_font_size_small,
                                      onTap: () async {
                                        _launchURL(url);
                                      }),
                                ))
                              : Container()
                        ],
                      ));
                })));
  }
}
