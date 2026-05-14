import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/model/cart_details_model.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/address_save.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/eshop_module_new/my_orders_list.dart';
import 'package:gems_revamp/eshop_module_new/review_page/review_page_model.dart';
import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_page.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'product_list_module/Model/product_wishlisht_count_provider.dart';

class ConfirmationPage extends StatefulWidget {
  final orderId;
  final orderstatus;
  final String? userFirstName;
  final String? userLastName;
  final AddressSave? addressSave;
  final Address? defaultaddress;
  final String? pointsEarned;
  final bool? showAddress;
  final CartDetailsModel? cartDetailsModel;
  final paymentmethod;

  ConfirmationPage(
      {Key? key,
      this.orderId,
      this.orderstatus,
      this.userFirstName,
      this.userLastName,
      this.addressSave,
      this.defaultaddress,
      this.pointsEarned,
      this.showAddress,
      this.cartDetailsModel,
      this.paymentmethod})
      : super(key: key);
  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  AddressSave? addressSave;
  Address? defaultaddress;
  CartDetailsModel? cartDetailsModel;

  @override
  void initState() {
    super.initState();
    addressSave = widget.addressSave;
    defaultaddress = widget.defaultaddress;
    makesenseEventCall("");
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

  makesenseEventCall(checkoutClick) {
    String keyName = GemsGLobals.orderConfirmationEvent;

    var segmentReq = {
      'int_source': GemsGLobals.lastVisitPageName,
      'total_cart_value': widget.cartDetailsModel?.grandTotal ?? "",
      'add_address': defaultaddress != null || addressSave != null
          ? GemsGLobals.yesText
          : GemsGLobals.noText,
      'items': [
        for (final item in (widget.cartDetailsModel?.items ?? []))
          {
            'Quantity': item.qty ?? "",
            'product_name': item.name,
            'category_type': item.categoryType,
            'sub_category': item.subCategory,
            'brand_name': item.brandName,
            'Stock': item.isAvailable == 0
                ? GemsGLobals.productOutOfStock
                : GemsGLobals.productInStock,
            'sku': item.sku.toString(),
          }
      ],
      "payment_type": widget.paymentmethod ?? "",
      "payment_status": widget.orderstatus == "false"
          ? GemsGLobals.failureText
          : GemsGLobals.successText,
      "checkout_click": checkoutClick,
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
                text: "Thank you for shopping with us.",
                size: text_font_medium_size,
                weight: FontWeight.w600,
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
              child: widget.orderstatus == "false"
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [                         
                          SizedBox(
                            height: 10,
                          ),
                          widget.orderstatus == "false"
                              ? Container()
                              : TextWidget(
                                  text: "Order Id : ${widget.orderId}",
                                  size: text_font_small,
                                  weight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                          TextWidget(
                            text:
                                //widget?.orderstatus == "false"
                                "Order failed",
                            //  : "Thank You for your order!",
                            color: black_color,
                            weight: FontWeight.bold,
                            size: appbar_text_size,
                          )
                        ])
                  : Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            gradient: gradient_theme_color,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 170,
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
                                      text: "Thank you for\nshopping with us!",
                                      color: white_color,
                                      size: 18,
                                      weight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Flexible(
                                  child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: white_color,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 140,
                                      // decoration: BoxDecoration(
                                      //     image: DecorationImage(
                                      //         image: AssetImage(
                                      //             ImageConstants))),
                                      child: SvgPicture.asset(
                                        ImageConstants.eshop_Thankyou,
                                        height: 120,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        widget.pointsEarned == "0"
                                            ? Container()
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  TextWidget(
                                                    alignment: TextAlign.center,
                                                    text: "You have earned ",
                                                    color: theme_color,
                                                    size:
                                                        text_font_medium_x_size,
                                                    weight: FontWeight.normal,
                                                  ),
                                                  TextWidget(
                                                    alignment: TextAlign.center,
                                                    text:
                                                        "${widget.pointsEarned} GEMS",
                                                    color: theme_color,
                                                    size:
                                                        text_font_medium_x_size,
                                                    weight: FontWeight.w500,
                                                  ),
                                                ],
                                              ),
                                        widget.pointsEarned == "0"
                                            ? Container()
                                            : TextWidget(
                                                alignment: TextAlign.center,
                                                text:
                                                    "and it will be credited soon",
                                                color: theme_color,
                                                size: text_size_16,
                                                weight: FontWeight.normal,
                                              ),
                                        widget.pointsEarned == "0"
                                            ? Container()
                                            : SizedBox(
                                                height: 20,
                                              ),
                                        widget.pointsEarned == "0"
                                            ? Container()
                                            : widget.showAddress == true
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Divider(
                                                      height: 1,
                                                      color:
                                                          Colors.grey.shade300,
                                                      thickness: 1,
                                                    ),
                                                  )
                                                : Container(),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        widget.showAddress == true
                                            ? TextWidget(
                                                alignment: TextAlign.center,
                                                text: addressSave?.address !=
                                                            null &&
                                                        addressSave?.address !=
                                                            ""
                                                    ? "Deliver to ${widget.userFirstName} ${widget.userLastName}"
                                                    : defaultaddress != null
                                                        ? "Deliver to ${defaultaddress?.firstname} ${defaultaddress?.lastname}"
                                                        : "Deliver to ${widget.userFirstName} ${widget.userLastName}",
                                                color: black_color,
                                                size: 15,
                                                weight: FontWeight.w500,
                                              )
                                            : Container(),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        widget.showAddress == true
                                            ? Container(
                                                width: 280,
                                                child: TextWidget(
                                                    alignment: TextAlign.center,
                                                    softwrap: true,
                                                    color:
                                                       Color(0xff9393A1),
                                                    size: 13,
                                                    weight: FontWeight.normal,
                                                    text: addressSave
                                                                    ?.address !=
                                                                null &&
                                                            addressSave
                                                                    ?.address !=
                                                                ""
                                                        ? "${addressSave?.streetAddress} ${addressSave?.address} ${addressSave?.area} ${addressSave?.city}\nM:- ${addressSave?.countryCode}  ${addressSave?.number}"
                                                        : "${defaultaddress?.address}  ${defaultaddress?.city} ${defaultaddress?.area}\nM:- ${defaultaddress?.telephone}"),
                                              )
                                            : Container(),
                                      ],
                                    )
                                  ],
                                ),
                              ))
                            ],
                          ),
                        ),
                        Positioned(
                            right: 0,
                            left: 0,
                            bottom: 20,
                            child: Container(
                              margin: EdgeInsets.only(left: 15,right: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                
                                children: [
                                  Expanded(
                                    child: Material(
                                      elevation: 2,
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        height: 50,
                                        // width: 300,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [
                                                  white_color,
                                                  white_color
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey.shade300,
                                                  blurRadius: 5.0)
                                            ],
                                            border: Border.all(
                                                color: Colors.grey.shade500),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: MaterialButton(
                                          child: TextWidget(
                                            text: "My Orders",
                                            color: black_color,
                                            weight: FontWeight.w600,
                                            size: 15,
                                          ),
                                          onPressed: () {
                                            makesenseEventCall(
                                                GemsGLobals.myOrdersText);
                                            GemsGLobals.lastVisitPageName =
                                                GemsGLobals
                                                    .eShopOrderSuccessPage;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChangeNotifierProvider(
                                                          create: (context) =>
                                                              WishListCartCount(),
                                                          child: MyOrderList(
                                                            model: [],
                                                            route: "confirm",
                                                          ))),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Material(
                                      elevation: 2,
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        height: 50,
                                        // width: 300,
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
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: MaterialButton(
                                          child: TextWidget(
                                            text: "Go to Home",
                                            color: white_color,
                                            weight: FontWeight.w600,
                                            size: text_size_16,
                                          ),
                                          onPressed: () {
                                            makesenseEventCall(
                                                GemsGLobals.goToHomeText);
                                            GemsGLobals.lastVisitPageName =
                                                GemsGLobals
                                                    .eShopOrderSuccessPage;
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (cxt) =>
                                                        ShopTabBarPage(
                                                          index: 0,
                                                        )));
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
              onPopInvoked: (canPop) async {}),
        ),
      ),
    );
  }
}
