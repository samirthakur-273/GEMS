import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/internetconnectingbox.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/loader_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/eshop_module_new/my_orders_detail/my_orders_detail_model.dart';
import 'package:gems_revamp/eshop_module_new/my_orders_detail/my_orders_detail_presenter.dart';
import 'package:gems_revamp/eshop_module_new/my_orders_detail/my_orders_detail_view.dart';
import 'package:gems_revamp/eshop_module_new/my_orders_detail/trackorder.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Database/my_profile_db_helper.dart';
import 'package:gems_revamp/eshop_module_new/service_unavailable/service_unavailable.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_page.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/time_out.dart';
import 'package:intl/intl.dart';

class MyOrdersDetail extends StatefulWidget {
  final orderid;

  const MyOrdersDetail({Key? key, this.orderid}) : super(key: key);
  @override
  _MyOrdersDetailState createState() => _MyOrdersDetailState();
}

class _MyOrdersDetailState extends State<MyOrdersDetail>
    implements MyOrdersDetailView {
  TextEditingController orderNumberController = new TextEditingController();
  TextEditingController _aboutmeController = new TextEditingController();
  late OrderDetailsModels orderDetailResponse;
  late OrderTrackingModel _orderTrackingModel;
  bool isloading = true;
  bool showOrderTracking = false;
  @override
  void initState() {
    super.initState();
    orderNumberController.text = widget.orderid;
    var body = {
      "orderid": widget.orderid,
      "email": GemsGLobals.useremail,
      "shopuserid": GemsGLobals.custEncryptedId,
    };
    internetCall(context,
        () => MyOrderDetailpresenter(this).myOrderDetailResponse(body));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> orderedItem() {
      List<Widget> _item = [];
      List<Item> data = orderDetailResponse.orderDetails?.items ?? [];
      for (var i = 0; i < data.length; i++) {
        _item.add(Container(
          margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                        height: MediaQuery.of(context).size.height / 4.5,
                        width: MediaQuery.of(context).size.width / 4,
                        child: CachedNetworkImage(
                          imageUrl: data[i].imageUrl ?? "",
                          fit: BoxFit.contain,
                          placeholder: (context, url) => SvgPicture.asset(
                              "assets/shop_assets/Group 9551.svg",
                              color: Colors.grey.withOpacity(0.1)),
                        )),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: TextWidget(
                        softwrap: true,
                        text: orderDetailResponse.orderDetails?.status ?? "",
                        color: Colors.green,
                        weight: FontWeight.bold,
                        size: text_font_medium_x_size,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 160,
                      child: TextWidget(
                        softwrap: true,
                        text: data[i].name ?? "",
                        color: Colors.black,
                        weight: FontWeight.bold,
                        size: text_font_small,
                      ),
                    ),
                    data[i].value == null
                        ? SizedBox(
                            height: 0,
                          )
                        : SizedBox(
                            height: 12,
                          ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: data[i].value == null ? "" : "Size: ",
                          color: Colors.black,
                          weight: FontWeight.bold,
                          size: text_font_size_x_small,
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        TextWidget(
                          text: data[i].value ?? "",
                          color: Colors.black,
                          weight: FontWeight.w600,
                          size: text_font_size_x_small,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: "Price",
                          color: Colors.black,
                          weight: FontWeight.bold,
                          size: text_font_size_x_small,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        TextWidget(
                          text: "AED ${data[i].originalPrice}",
                          color: Colors.black,
                          weight: FontWeight.w600,
                          size: text_font_size_x_small,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    /*Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: "Paid Price",
                          color: Colors.black,
                          weight: FontWeight.bold,
                          size: text_font_size_x_small,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        TextWidget(
                          text: "AED ${data[i]?.price}",
                          color: Colors.black,
                          weight: FontWeight.w600,
                          size: text_font_size_x_small,
                        ),
                      ],
                    ),*/
                  ],
                ),
              )
            ],
          ),
        ));
      }
      return _item;
    }

    String getformat(string) {
      if (string != null) {
        // var dates = string.substring(0, 10);
        DateTime dt = DateTime.parse(string);
        return DateFormat("MMMM d, yyyy hh:mm a").format(dt);
      } else {
        return 'Invalid Date';
      }
    }

    Widget _orderDetails() {
      return Card(
        elevation: 1,
        color: white_text_color,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
        child: Container(
            margin: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TextWidget(
                                text: "Order# ",
                                color: Colors.black,
                                size: text_font_small,
                                weight: FontWeight.w800,
                              ),
                              TextWidget(
                                text:
                                    " ${orderDetailResponse.orderDetails?.incrementId ?? ""}",
                                color: Colors.black,
                                size: text_font_small,
                                weight: FontWeight.w800,
                              ),
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text:
                                          " ${orderDetailResponse.orderDetails?.incrementId ?? ""}"));
                                },
                                child: Container(
                                    padding: EdgeInsets.only(left: 5),
                                    // decoration: BoxDecoration(
                                    //   border: Border.all(color: Colors.black),
                                    //   shape: BoxShape.rectangle,
                                    // ),
                                    child: Icon(Icons.copy, size: 15)),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              TextWidget(
                                text: "Ordered on: ",
                                color: Colors.black,
                                size: text_font_size_x_small,
                                weight: FontWeight.w500,
                              ),
                              TextWidget(
                                text: getformat(orderDetailResponse
                                    .orderDetails?.createAt
                                    ?.toIso8601String()),
                                color: Colors.black,
                                size: text_font_size_x_small,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        /*Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextWidget(
                              text: "Track Order: ",
                              color: Colors.black,
                              size: text_font_small,
                              weight: FontWeight.w800,
                            ),
                            TextWidget(
                              text: orderDetailResponse
                                      ?.orderDetails?.incrementId
                                      .toString() ??
                                  "",
                              color: Colors.black,
                              size: text_font_small,
                              weight: FontWeight.normal,
                            )
                          ],
                        ),*/
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextWidget(
                              text: "Order Value: ",
                              color: Colors.black,
                              size: text_font_small,
                              weight: FontWeight.w800,
                            ),
                            TextWidget(
                              text: orderDetailResponse.orderDetails?.grandTotal
                                      .toString() ??
                                  "",
                              color: Colors.black,
                              size: text_font_small,
                              weight: FontWeight.normal,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        orderDetailResponse.orderDetails?.earnPoint ==
                                "AED 0.00"
                            ? Container()
                            : Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      TextWidget(
                                        text: "Bounz: ",
                                        color: Colors.black,
                                        size: text_font_small,
                                        weight: FontWeight.w800,
                                      ),
                                      TextWidget(
                                        text: orderDetailResponse
                                                .orderDetails?.earnPoint ??
                                            "",
                                        color: Colors.black,
                                        size: text_font_small,
                                        weight: FontWeight.normal,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            showOrderTracking
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TrackingDetails(
                                                    orderid: orderDetailResponse
                                                        .orderDetails?.orderId,
                                                    orderTrackingModel:
                                                        _orderTrackingModel,
                                                  )));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 3.0,
                                                color: grey200_color)
                                          ],
                                          gradient: LinearGradient(
                                              colors: new_gradient_color,
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
                                      child: TextWidget(
                                        text: "Track Order",
                                        color: white_color,
                                        size: text_font_small,
                                        weight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                : Container(),
                            // new SizedBox(
                            //   width: 10,
                            // ),
                            // orderDetailResponse?.orderDetails?.status ==
                            //         "processing"
                            //     ? GestureDetector(
                            //         onTap: () {
                            //           showDialog(
                            //             barrierDismissible: false,
                            //             context: context,
                            //             builder: (BuildContext context) {
                            //               // return object of type Dialog
                            //               return Dialog(
                            //                 shape: RoundedRectangleBorder(
                            //                     borderRadius: BorderRadius.all(
                            //                         Radius.circular(5.0))),
                            //                 child: Container(
                            //                   margin: EdgeInsets.only(
                            //                       top: 25, left: 15, right: 15),
                            //                   height: 120,
                            //                   child: Column(
                            //                     children: <Widget>[
                            //                       Container(
                            //                         //margin: EdgeInsets.only(top: 5),
                            //                         child: TextWidget(
                            //                           text: "Are you sure you",
                            //                           size:
                            //                               text_font_size_small,
                            //                           weight: FontWeight.bold,
                            //                           color: Colors.grey[700],
                            //                         ),
                            //                       ),
                            //                       new SizedBox(
                            //                         height: 10,
                            //                       ),
                            //                       Container(
                            //                         child: TextWidget(
                            //                           text:
                            //                               "want to cancel your order?",
                            //                           size:
                            //                               text_font_size_small,
                            //                           weight: FontWeight.bold,
                            //                           color: Colors.grey[700],
                            //                         ),
                            //                       ),
                            //                       Container(
                            //                         margin: EdgeInsets.only(
                            //                             top: 22),
                            //                         child: Row(
                            //                           crossAxisAlignment:
                            //                               CrossAxisAlignment
                            //                                   .center,
                            //                           mainAxisAlignment:
                            //                               MainAxisAlignment
                            //                                   .spaceEvenly,
                            //                           children: <Widget>[
                            //                             Container(
                            //                               height: 30,
                            //                               // width: 60,
                            //                               decoration:
                            //                                   BoxDecoration(
                            //                                       border: Border
                            //                                           .all(
                            //                                         width: 1.0,
                            //                                         color:
                            //                                             theme_color,
                            //                                       ),
                            //                                       borderRadius:
                            //                                           BorderRadius
                            //                                               .circular(
                            //                                                   3)),
                            //                               child: new FlatButton(
                            //                                 child: TextWidget(
                            //                                   text: "No",
                            //                                   color:
                            //                                       theme_color,
                            //                                   textAlign:
                            //                                       TextAlign
                            //                                           .center,
                            //                                   size:
                            //                                       text_font_size_small,
                            //                                   weight: FontWeight
                            //                                       .bold,
                            //                                 ),
                            //                                 onPressed: () {
                            //                                   Navigator.of(
                            //                                           context)
                            //                                       .pop(false);
                            //                                 },
                            //                               ),
                            //                             ),
                            //                             Container(
                            //                               height: 30,
                            //                               decoration:
                            //                                   BoxDecoration(
                            //                                       border: Border
                            //                                           .all(
                            //                                         width: 1.0,
                            //                                         color:
                            //                                             theme_color,
                            //                                       ),
                            //                                       borderRadius:
                            //                                           BorderRadius
                            //                                               .circular(
                            //                                                   3)),
                            //                               child: new FlatButton(
                            //                                 child: TextWidget(
                            //                                   text: "Yes",
                            //                                   textAlign:
                            //                                       TextAlign
                            //                                           .center,
                            //                                   color:
                            //                                       theme_color,
                            //                                   size:
                            //                                       text_font_size_small,
                            //                                   weight: FontWeight
                            //                                       .bold,
                            //                                 ),
                            //                                 onPressed:
                            //                                     () async {
                            //                                   isloading = true;
                            //                                   var body = {
                            //                                     "action":
                            //                                         "cancel",
                            //                                     "order_id":
                            //                                         widget
                            //                                             .orderid,
                            //                                     "brandcode":
                            //                                         Constants
                            //                                             .brandCode,
                            //                                     "country_code":
                            //                                         Constants
                            //                                             .countryCode,
                            //                                     "lang_code":
                            //                                         Constants
                            //                                             .langCode
                            //                                   };
                            //                                   MyOrderDetailpresenter(
                            //                                           this)
                            //                                       .cancelOrder(
                            //                                           body);
                            //                                   setState(() {});
                            //                                   Navigator.of(
                            //                                           context)
                            //                                       .pop(true);
                            //                                 },
                            //                               ),
                            //                             ),
                            //                           ],
                            //                         ),
                            //                       )
                            //                     ],
                            //                   ),
                            //                 ),
                            //                 // actions: <Widget>[],
                            //               );
                            //             },
                            //           );
                            //         },
                            //         child: Container(
                            //           padding: EdgeInsets.all(10),
                            //           alignment: Alignment.center,
                            //           decoration: BoxDecoration(
                            //               border: Border.all(
                            //                   color: Colors.black, width: 1),
                            //               borderRadius: BorderRadius.all(
                            //                   Radius.circular(5.0))),
                            //           child: TextWidget(
                            //             text: "cancelorder",
                            //             color: Colors.black,
                            //             size: text_font_small,
                            //             weight: FontWeight.w700,
                            //           ),
                            //         ),
                            //       )
                            //   : Container(height: 0)
                            // GestureDetector(
                            //   onTap: () {},
                            //   child: Container(
                            //     padding: EdgeInsets.all(10),
                            //     alignment: Alignment.center,
                            //     decoration: BoxDecoration(
                            //         border: Border.all(
                            //             color: Colors.black, width: 1),
                            //         borderRadius: BorderRadius.all(
                            //             Radius.circular(5.0))),
                            //     child: TextWidget(
                            //       text: "View Invoice(s)",
                            //       color: Colors.black,
                            //       size: text_font_small,
                            //       weight: FontWeight.w700,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        new SizedBox(
                          height: 15,
                        )
                      ],
                    ),
                  ),
                ),
                /*Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: TextWidget(
                    text: "youcanviewr&bcredit",
                    color: Colors.black,
                    size: text_font_small,
                    weight: FontWeight.w800,
                    alignment: TextAlign.center,
                  ),
                )*/
              ],
            )),
      );
    }

    Widget _shippingPaymentMethod() {
      return Card(
          elevation: 1,
          color: white_text_color,
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Container(
            margin: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      text: "Shipping:",
                      color: Colors.black,
                      size: text_font_small,
                      weight: FontWeight.bold,
                    ),
                    TextWidget(
                      text: orderDetailResponse.orderDetails?.shipping
                              .toString() ??
                          "",
                      color: Colors.black,
                      size: text_font_small,
                      weight: FontWeight.w800,
                    )
                  ],
                ),
                SizedBox(
                  height: 11,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      text: "Ordered on: ",
                      color: Colors.black,
                      size: text_font_small,
                      weight: FontWeight.bold,
                    ),
                    TextWidget(
                      text: getformat(orderDetailResponse.orderDetails?.createAt
                          ?.toIso8601String()),
                      color: Colors.black,
                      size: text_font_small,
                      weight: FontWeight.bold,
                    )
                  ],
                ),
                SizedBox(
                  height: 11,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget(
                      text: "Payment Method:",
                      color: Colors.black,
                      size: text_font_small,
                      weight: FontWeight.bold,
                    ),
                    TextWidget(
                      text: orderDetailResponse.orderDetails?.paymentMethod
                              .toString() ??
                          "",
                      color: Colors.black,
                      size: text_font_small,
                      weight: FontWeight.bold,
                    )
                  ],
                ),
                new SizedBox(
                  height: 8,
                )
              ],
            ),
          ));
    }

    Widget _address() {
      return Card(
          elevation: 1,
          color: white_text_color,
          margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(8),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: TextWidget(
                      text: "shippingaddress",
                      color: Colors.black,
                      size: text_font_small,
                      weight: FontWeight.bold,
                    )),
                    new SizedBox(
                      height: 8,
                    ),
                    Container(
                        child: TextWidget(
                      text:
                          "${orderDetailResponse.orderDetails?.address?.shipping?.firstname} ${orderDetailResponse.orderDetails?.address?.shipping?.lastname}\n+${orderDetailResponse.orderDetails?.address?.shipping?.telephone}\n${orderDetailResponse.orderDetails?.address?.shipping?.street}\n${orderDetailResponse.orderDetails?.address?.shipping?.area ?? ""} ${orderDetailResponse.orderDetails?.address?.shipping?.city}",
                      color: Colors.black,
                      size: text_font_small,
                      weight: FontWeight.w500,
                    )),
                    new SizedBox(
                      height: 8,
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 3,
                    ),
                    new SizedBox(
                      height: 8,
                    ),
                    Container(
                        child: TextWidget(
                      text: "billing_address",
                      color: Colors.black,
                      size: text_font_small,
                      weight: FontWeight.bold,
                    )),
                    new SizedBox(
                      height: 8,
                    ),
                    Container(
                        child: TextWidget(
                      text:
                          "${orderDetailResponse.orderDetails?.address?.billing?.firstname} ${orderDetailResponse.orderDetails?.address?.billing?.lastname}\n+${orderDetailResponse.orderDetails?.address?.billing?.telephone}\n${orderDetailResponse.orderDetails?.address?.billing?.street}\n${orderDetailResponse.orderDetails?.address?.billing?.area ?? ""} ${orderDetailResponse.orderDetails?.address?.billing?.city}",
                      color: Colors.black,
                      size: text_font_small,
                      weight: FontWeight.w500,
                    )),
                  ])));
    }

    Widget _body() {
      return SingleChildScrollView(
        child: Container(
          color: bg_color,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _orderDetails(),
                _shippingPaymentMethod(),
                _address(),
                Card(
                    elevation: 1,
                    color: white_text_color,
                    margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: orderedItem(),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      );
    }

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
                  boxShadow: [BoxShadow(color: theme_color, blurRadius: 3)]),
              height: 90,
              alignment: Alignment.center,
              child: Row(
                children: [
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
                      text: "Order Detail",
                      weight: FontWeight.w600,
                      size: text_font_medium_x_size,
                      color: white_color,
                    ),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 25,
                  )
                ],
              ),
            ),
            preferredSize: Size.fromHeight(50),
          ),
          body: isloading
              ? Container(
                  child: Loader(),
                )
              : _body(),
        ),
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      child: Container(
        height: 600,
        child: ListView(
          children: [
            Row(
              children: [
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, right: 8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          shape: BoxShape.rectangle,
                        ),
                        child: Icon(Icons.close, size: 26)),
                  ),
                )
              ],
            ),
            Center(
              child: Image.asset("assets/shop_assets/cart.png"),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: TextWidget(
                text: "Are you sure to cancel selected order?",
              ),
            ),
            Center(
              child: TextWidget(
                text: "ORDER#",
                size: 18,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            _orderNumberTextfield(),
            SizedBox(
              height: 20,
            ),
            _cancelOrderReason(),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      margin: EdgeInsets.only(left: 25.0, right: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.only(top: 18, bottom: 18),
                            textStyle: TextStyle(
                              color: Colors.white,
                            )),
                        // textColor: Colors.white,
                        // color: Colors.black,
                        child: TextWidget(
                          text: "Yes",
                          size: text_font_small,
                        ),
                        onPressed: () {
                          var body = {
                            "action": "cancel",
                            "order_id": orderNumberController.text,
                            "brandcode": Constants.brandCode,
                            "country_code": Constants.countryCode,
                            "lang_code": Constants.langCode
                          };
                          MyOrderDetailpresenter(this).cancelOrder(body);
                          setState(() {});
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      margin: EdgeInsets.only(left: 5, right: 25),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.only(top: 18, bottom: 18),
                            textStyle: TextStyle(
                              color: Colors.black,
                            )),
                        // color: Colors.white,
                        // textColor: Colors.black,
                        // padding: EdgeInsets.only(top: 18, bottom: 18),
                        child: TextWidget(
                          text: "No",
                          size: text_font_small,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _orderNumberTextfield() {
    return Container(
      margin: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
      child: TextFormField(
        textAlign: TextAlign.left,
        autofocus: false,
        style: TextStyle(
            color: Colors.black,
            fontSize: text_font_small,
            fontWeight: FontWeight.normal),
        controller: orderNumberController,
        enabled: true,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(15, 15, 0, 0),
          hintText: "",
          hintStyle: TextStyle(
              color: grey_color,
              fontSize: text_font_small,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget _cancelOrderReason() {
    return Container(
      margin: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
      child: TextFormField(
        textAlign: TextAlign.left,
        maxLines: 8,
        enabled: true,
        autofocus: true,
        maxLength: 500,
        style: TextStyle(
            color: Colors.black,
            fontSize: text_font_small,
            fontWeight: FontWeight.normal),
        controller: _aboutmeController,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
          disabledBorder: InputBorder.none,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.fromLTRB(15, 15, 0, 0),
          counterText: "",
          hintText: "Why do you want to cancel this order?",
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          hintStyle: TextStyle(
              color: grey_color,
              fontSize: text_font_small,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  @override
  void cancelOrderResponse(List<CancelOrderModels> cancelorderModel) {
    if (cancelorderModel[0].success == "true") {
      setState(() {
        Fluttertoast.showToast(
            msg: cancelorderModel[0].message ?? "",
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xAA000000),
            textColor: white_text_color,
            toastLength: Toast.LENGTH_LONG);
        MyProfileDBHelper().truncateMyProfileData().then((value) {
          // Navigator.of(context).pop();
          // Navigator.of(context).pop();
        });
        isloading = false;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShopTabBarPage(
                    index: 4,
                  )),
        );
      });
    } else {
      setState(() {
        Fluttertoast.showToast(
            msg: cancelorderModel[0].message ?? 'Something Went Wrong!',
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xAA000000),
            textColor: white_text_color,
            toastLength: Toast.LENGTH_LONG);
      });
    }
  }

  @override
  void responseFailure(error) {}

  @override
  void myOrderdetailResponse(List<OrderDetailsModels> orderDetailModel) {
    if (orderDetailModel[0].success == "true") {
      orderDetailResponse = orderDetailModel[0];

      var request = {
        "orderid": orderDetailModel[0].orderDetails?.orderId,
        "email": GemsGLobals.useremail,
        "shopuserid": GemsGLobals.custEncryptedId,
      };
      internetCall(
          context, () => MyOrderDetailpresenter(this).trackOrder(request));
      setState(() {});
    } else {
      isloading = false;
      setState(() {});
    }
  }

  @override
  void onTimeout() {
    var body = {
      "order_id": widget.orderid,
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode,
    };
    if (mounted)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cxt) => ServiceUnavailable(
                  onRetry: () => MyOrderDetailpresenter(this)
                      .myOrderDetailResponse(body))));
  }

  @override
  void onOrderTrackingTimeout() {
    Navigator.push(context, MaterialPageRoute(builder: (cxt) => TimeOut()))
        .then((value) {
      var request = {
        "orderid": orderDetailResponse.orderDetails?.orderId,
        "email": GemsGLobals.useremail,
        "shopuserid": GemsGLobals.custEncryptedId,
      };
      internetCall(
          context, () => MyOrderDetailpresenter(this).trackOrder(request));
    });
  }

  @override
  void orderTrackingResponse(List<OrderTrackingModel> orderTrackingModel) {
    if (orderTrackingModel[0].success == "true") {
      _orderTrackingModel = orderTrackingModel[0];
      isloading = false;
      showOrderTracking = true;
    } else {
      isloading = false;
      showOrderTracking = false;
    }

    setState(() {});
  }
}
