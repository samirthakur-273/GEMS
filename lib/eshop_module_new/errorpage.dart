import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/address_save.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/review_page/review_page_model.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_page.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';

class ErrorPage extends StatefulWidget {
  final orderId;
  final orderstatus;
  final String? userFirstName;
  final String? userLastName;
  final AddressSave? addressSave;
  final Address? defaultaddress;
  final String? pointsEarned;

  ErrorPage(
      {Key? key,
      this.orderId,
      this.orderstatus,
      this.userFirstName,
      this.userLastName,
      this.addressSave,
      this.defaultaddress,
      this.pointsEarned})
      : super(key: key);
  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  AddressSave? addressSave;
  Address? defaultaddress;
  @override
  void initState() {
    super.initState();
    makesenseEventCall();
    GemsGLobals.lastVisitPageName = GemsGLobals.eventOrderFailed;
    addressSave = widget.addressSave;
    defaultaddress = widget.defaultaddress;
    Timer(Duration(seconds: 3), () {
      if (widget.orderstatus == "false") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShopTabBarPage(
                    index: 0,
                    tabIndex: 0,
                  )),
        );
      }
    });
  }

  makesenseEventCall() {
    String keyName = GemsGLobals.eventOrderFailed;
    var segmentReq = {
      'int_source': GemsGLobals.lastVisitPageName,
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  @override
  Widget build(BuildContext context) {
    Widget _body() {
      return Container(
          height: 225,
          decoration: BoxDecoration(color: white_color, boxShadow: [
            BoxShadow(color: Colors.grey.shade400, blurRadius: 5.0)
          ]),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              TextWidget(
                alignment: TextAlign.center,
                text: "OOPS!\nWe've encountered a problem",
                size: text_font_medium_size,
                weight: FontWeight.bold,
                color: Colors.black,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      TextWidget(
                        text: "Order Id : ${widget.orderId}",
                        size: text_font_small,
                        weight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextWidget(
                        text: "Deliver to Gregory McGraw",
                        size: text_font_small,
                        weight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextWidget(
                        text:
                            "Bahar 7 - P.O. box 500551, Jumeriah Beach\nResidence-Dubai-United Arab Emirates",
                        size: text_font_size_x_small,
                        weight: FontWeight.bold,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey[100],
                    child: Image.asset(
                      "assets/shop_assets/[CITYPNG.COM]HD Apple Gold iPhone 12 Pro & Pro Max PNG - 940x1112.png",
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextWidget(
                text: "Friday, 2 April",
                size: text_font_size_x_small,
                weight: FontWeight.bold,
                color: theme_color,
              ),
              TextWidget(
                text: "Estimated delivery",
                size: text_font_size_x_small,
                weight: FontWeight.w600,
                color: Colors.grey[400],
              ),
            ],
          ));
    }

    return Container(
      color: theme_color,
      child: SafeArea(
        bottom: false,
        top: true,
        child: Scaffold(
          backgroundColor: white_color,
          body: PopScope(
          canPop: false,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration:
                        BoxDecoration(color: theme_color.withOpacity(0.8)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 210,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                      "assets/shop_assets/success screen bg.png",
                                    )),
                              ),
                            ),
                            Container(
                              height: 210,
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                    theme_color,
                                    theme_color.withOpacity(0.6),
                                  ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter)),
                              child: TextWidget(
                                alignment: TextAlign.center,
                                text: "OOPS!\nWe've encountered a problem",
                                color: white_color,
                                size: 20,
                                weight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                            child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: white_color,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                        ))
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    left: 0,
                    top: MediaQuery.of(context).size.height / 3.3,
                    child: TextWidget(
                      alignment: TextAlign.center,
                      text:
                          GemsGLobals.transactionErrorMessage,
                      color: black_color,
                      size: text_size_16,
                      weight: FontWeight.w600,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    left: 0,
                    top: MediaQuery.of(context).size.height / 2.8,
                    child: Image.asset(
                      "assets/shop_assets/oops img.png",
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                      right: 0,
                      left: 0,
                      top: MediaQuery.of(context).size.height / 1.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                            alignment: TextAlign.center,
                            text:
                                GemsGLobals.eshopPaymentErrorMessage,
                            color: theme_color,
                            size: text_size_16,
                            weight: FontWeight.normal,
                          ),
                        ],
                      )),
                  Positioned(
                      right: 0,
                      left: 0,
                      bottom: 20,
                      child: Column(
                        children: [
                          Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 45,
                              width: 300,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [white_color, white_color],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 5.0)
                                  ],
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextButton(
                                child: TextWidget(
                                  text: "Contact Support",
                                  color: black_color,
                                  weight: FontWeight.bold,
                                  size: text_font_medium_size,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TabsScreen(
                                              initialIndex: 2,
                                            )),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              height: 45,
                              width: 300,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: new_gradient_color,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 5.0)
                                  ],
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextButton(
                                child: TextWidget(
                                  text: "Go Home",
                                  color: white_color,
                                  weight: FontWeight.bold,
                                  size: text_font_medium_size,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (cxt) => ShopTabBarPage(
                                                index: 0,
                                              )));
                                },
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
             onPopInvoked: (canPop) async {
              }),
        ),
      ),
    );
  }
}
