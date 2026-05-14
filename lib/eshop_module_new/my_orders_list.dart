import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/cart_details/model/cart_details_model.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/appbar_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/internetconnectingbox.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/my_profile_model.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/presenter/my_profile_pesenter.dart';
import 'package:gems_revamp/eshop_module_new/service_unavailable/service_unavailable.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_page.dart';
import 'package:gems_revamp/eshop_module_new/utils/shimmer/my_orderpage_shimmer.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MyOrderList extends StatefulWidget {
  List<OrderList>? model;
  final List<OrderList>? orderHistory;
  final String? route;
  MyOrderList({Key? key, this.model, this.route, this.orderHistory})
      : super(key: key);
  @override
  _MyOrderListState createState() => _MyOrderListState();
}

class _MyOrderListState extends State<MyOrderList>
    implements MyProfileViewContract {
  bool _isLoading = true;
  late MyProfilePresenter? _presenter;
  late MyProfileModel? _model;
  late List<OrderList>? orderHistory;
  _MyOrderListState() {
    _presenter = MyProfilePresenter(this);
  }
  TextEditingController _searchContoller = new TextEditingController();
  int listType = 1;
  CartDetailsModel? cartDetailsModel;
  @override
  void initState() {
    if (widget.model!.isEmpty) {
      internetCall(context, () => _presenter?.getMyProfileData());
    } else {
      _isLoading = false;
    }

    orderHistory = widget.orderHistory;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> _orderImageList(List<Item> items) {
      List<Widget> _list = [];
      for (var i = 0; i < items.length; i++) {
        _list.add(
          Container(
            margin: EdgeInsets.only(right: 5),
            height: 115,
            width: 80,
            child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: items[i].imageUrl ?? "",
                placeholder: (context, url) => SvgPicture.asset(
                    "assets/shop_assets/Group 9551.svg",
                    color: Colors.grey.withOpacity(0.1))),
          ),
        );
      }
      return _list;
    }

    List<Widget> _orderList() {
      List<Widget> _list = [];
      for (var i = 0; i < (widget.model?.length ?? 0); i++) {
        for (var j = 0; j < (widget.model![i].items?.length ?? 0); j++) {
          _isLoading = false;
          _list.add(Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, top: 5, bottom: 5),
              child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  child: Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    // width: 190,

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        widget.model?[i].items?[j].brand ==
                                                    "" ||
                                                widget.model?[i].items?[j]
                                                        .brand ==
                                                    null
                                            ? Container()
                                            : Container(
                                                // width: 190,
                                                alignment: Alignment.centerLeft,
                                                margin: EdgeInsets.only(
                                                    left: 14, top: 2),
                                                child: TextWidget(
                                                  //overflow: TextOverflow.ellipsis,
                                                  text: widget.model?[i]
                                                          .items?[j].brand ??
                                                      '',
                                                  size: text_font_medium_x_size,
                                                  softwrap: true,
                                                  color: theme_color,
                                                  weight: FontWeight.w500,
                                                ),
                                              ),
                                        Container(
                                          // width: 200,
                                          alignment: Alignment.centerLeft,
                                          margin:
                                              EdgeInsets.only(left: 14, top: 0),
                                          child: TextWidget(
                                            //overflow: TextOverflow.ellipsis,
                                            text: widget
                                                    .model?[i].items?[j].name ??
                                                '',
                                            size: text_font_small,
                                            softwrap: true,
                                            weight: FontWeight.w500,
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          margin:
                                              EdgeInsets.only(left: 15, top: 5),
                                          child: TextWidget(
                                            //overflow: TextOverflow.ellipsis,
                                            text: widget.model?[i].items?[j]
                                                    .price ??
                                                '',
                                            size: text_font_medium_x_size,
                                            color: black_color,
                                            softwrap: true,
                                            weight: FontWeight.w500,
                                          ),
                                        ),
                                        widget.model?[i].items?[j].earnPoint ==
                                                    null ||
                                                widget.model?[i].items?[j]
                                                        .earnPoint ==
                                                    "0.0000" ||
                                                widget.model?[i].items?[j]
                                                        .earnPoint ==
                                                    "0"
                                            ? Container()
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 14, top: 5),
                                                    child: TextWidget(
                                                      //overflow: TextOverflow.ellipsis,
                                                      text: "Earn upto",
                                                      size:
                                                          text_font_size_small,
                                                      color: blue_color,
                                                      softwrap: true,
                                                      weight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    margin: EdgeInsets.only(
                                                        left: 5, top: 5),
                                                    child: TextWidget(
                                                      //overflow: TextOverflow.ellipsis,
                                                      text: widget
                                                              .model?[i]
                                                              .items?[j]
                                                              .earnPoint ??
                                                          "",
                                                      size: text_font_small,
                                                      color: theme_color,
                                                      softwrap: true,
                                                      weight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  // color: red_color,
                                  height: 80,
                                  width: 120,
                                  child: CachedNetworkImage(
                                      fit: BoxFit.contain,
                                      imageUrl:
                                          widget.model?[i].items?[j].imageUrl ??
                                              "",
                                      placeholder: (context, url) =>
                                          Image.asset(
                                            ImageConstants.noimages,
                                          )),
                                ),
                              ]),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 200,
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(left: 14, top: 5),
                                child: TextWidget(
                                  //overflow: TextOverflow.ellipsis,
                                  text: widget.model?[i].status ?? '',
                                  size: text_font_small,
                                  color: deepdark_orange_color,
                                  softwrap: true,
                                  weight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(top: 8, right: 35),
                                child: TextWidget(
                                  //overflow: TextOverflow.ellipsis,
                                  text:
                                      "Qty: ${int.parse(widget.model?[i].items?[j].qty ?? "0")}",
                                  size: text_font_medium_x_size,
                                  color: black_color,
                                  softwrap: true,
                                  weight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        ],
                      )))));
        }
      }
      return _list;
    }

    List<Widget> _orderHistory() {
      List<Widget> _list = [];
      for (var i = 0; i < (orderHistory?.length ?? 0); i++) {
        for (var j = 0; j < (orderHistory?[i].items?.length ?? 0); j++) {
          _isLoading = false;
          _list.add(Container(
              padding: EdgeInsets.only(bottom: 5),
              //height: 200,
              child: Container(
                  color: Color(0xfffefbea),
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child: Column(children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 6,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            orderHistory?[i].items?[j].brand ==
                                                        "" ||
                                                    orderHistory?[i]
                                                            .items?[j]
                                                            .brand ==
                                                        null
                                                ? Container()
                                                : Container(
                                                    width: 200,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    margin: EdgeInsets.only(
                                                        left: 14, top: 5),
                                                    child: TextWidget(
                                                      //overflow: TextOverflow.ellipsis,
                                                      text: orderHistory?[i]
                                                              .items?[j]
                                                              .brand ??
                                                          '',
                                                      size: text_font_small,
                                                      softwrap: true,
                                                      weight: FontWeight.w500,
                                                    ),
                                                  ),
                                            Container(
                                              width: 200,
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.only(
                                                  left: 14, top: 0),
                                              child: TextWidget(
                                                //overflow: TextOverflow.ellipsis,
                                                text: orderHistory?[i]
                                                        .items?[j]
                                                        .name ??
                                                    '',
                                                size: text_font_small,
                                                softwrap: true,
                                                weight: FontWeight.w500,
                                              ),
                                            ),
                                            Container(
                                              width: 200,
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.only(
                                                  left: 14, top: 5),
                                              child: TextWidget(
                                                //overflow: TextOverflow.ellipsis,
                                                text: orderHistory?[i]
                                                        .items?[j]
                                                        .price ??
                                                    '',
                                                size: text_font_small,
                                                softwrap: true,
                                                weight: FontWeight.w500,
                                              ),
                                            ),
                                            orderHistory?[i]
                                                            .items?[j]
                                                            .earnPoint ==
                                                        null ||
                                                    orderHistory?[i]
                                                            .items?[j]
                                                            .earnPoint ==
                                                        "0.0000" ||
                                                    orderHistory?[i]
                                                            .items?[j]
                                                            .earnPoint ==
                                                        "0"
                                                ? Container()
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 14, top: 5),
                                                        child: TextWidget(
                                                          //overflow: TextOverflow.ellipsis,
                                                          text: "Earn upto",
                                                          size:
                                                              text_font_size_small,
                                                          color: theme_color,
                                                          softwrap: true,
                                                          weight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        margin: EdgeInsets.only(
                                                            left: 5, top: 5),
                                                        child: TextWidget(
                                                          //overflow: TextOverflow.ellipsis,
                                                          text: orderHistory?[i]
                                                                  .items?[j]
                                                                  .earnPoint ??
                                                              "",
                                                          size: text_font_small,
                                                          color: theme_color,
                                                          softwrap: true,
                                                          weight:
                                                              FontWeight.w500,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                            // Container(
                                            //   width: 200,
                                            //   alignment: Alignment.centerLeft,
                                            //   margin: EdgeInsets.only(
                                            //       left: 14, top: 10),
                                            //   child: TextWidget(
                                            //     //overflow: TextOverflow.ellipsis,
                                            //     text: "Order Details:",
                                            //     size: text_font_medium_x_size,
                                            //     color: black_color,
                                            //     softwrap: true,
                                            //     weight: FontWeight.w500,
                                            //   ),
                                            // ),
                                            Container(
                                              width: 200,
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.only(
                                                  left: 14, top: 0),
                                              child: TextWidget(
                                                //overflow: TextOverflow.ellipsis,
                                                text: "Order Reference Number:",
                                                size: text_font_small,
                                                color: black_color,
                                                softwrap: true,
                                                weight: FontWeight.w500,
                                              ),
                                            ),
                                            Container(
                                              width: 200,
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.only(
                                                  left: 14, top: 0),
                                              child: TextWidget(
                                                //overflow: TextOverflow.ellipsis,
                                                text:
                                                    orderHistory?[i].orderId ??
                                                        '',
                                                size: text_font_small,
                                                color: black_color,
                                                softwrap: true,
                                                weight: FontWeight.w500,
                                              ),
                                            ),
                                            orderHistory?[i].items?[j].soldBy ==
                                                        null ||
                                                    orderHistory?[i]
                                                            .items?[j]
                                                            .soldBy ==
                                                        'null'
                                                ? Container(
                                                    height: 0,
                                                  )
                                                : Container(
                                                    width: 200,
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    margin: EdgeInsets.only(
                                                        left: 14, top: 0),
                                                    child: TextWidget(
                                                      //overflow: TextOverflow.ellipsis,
                                                      text:
                                                          "Sold By: ${orderHistory?[i].items?[j].soldBy}",
                                                      size: text_font_small,
                                                      color: black_color,
                                                      softwrap: true,
                                                      weight: FontWeight.w500,
                                                    ),
                                                  )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              // color: red_color,
                                              height: 80,
                                              width: 120,
                                              child: CachedNetworkImage(
                                                  fit: BoxFit.contain,
                                                  imageUrl: orderHistory?[i]
                                                          .items?[j]
                                                          .imageUrl ??
                                                      "",
                                                  placeholder: (context, url) =>
                                                      SvgPicture.asset(
                                                        "assets/shop_assets/Group 9551.svg",
                                                        color: Colors.grey
                                                            .withOpacity(0.1),
                                                      )),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              margin: EdgeInsets.only(top: 8),
                                              child: TextWidget(
                                                //overflow: TextOverflow.ellipsis,
                                                text:
                                                    "Qty: ${int.parse(orderHistory![i].items![j].qty!.replaceAll(".", "").replaceAll("0000", ""))}",
                                                size: text_font_medium_x_size,
                                                color: black_color,
                                                softwrap: true,
                                                weight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          alignment: Alignment.centerRight,
                                          margin:
                                              EdgeInsets.only(left: 14, top: 5),
                                          child: TextWidget(
                                            //overflow: TextOverflow.ellipsis,
                                            text: orderHistory?[i].status ?? '',
                                            size: text_font_medium_size,
                                            color: theme_color,
                                            softwrap: true,
                                            weight: FontWeight.w500,
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 20,
                                        // ),
                                        // Container(
                                        //   height: 30,
                                        //   width: 100,
                                        //   alignment: Alignment.center,
                                        //   decoration: BoxDecoration(
                                        //       color: white_color,
                                        //       border: Border.all(color:Colors.grey,width:0.3),
                                        //       borderRadius:
                                        //           BorderRadius.circular(20)),
                                        //   child: GestureDetector(
                                        //     onTap: () {
                                        //       Navigator.push(
                                        //           context,
                                        //           MaterialPageRoute(
                                        //               builder: (context) =>
                                        //                   ChangeNotifierProvider(
                                        //                       create: (context) =>
                                        //                           WishListCartCount(),
                                        //                       child:
                                        //                           ProductDetailNew(
                                        //                         productcode:
                                        //                             orderHistory?[
                                        //                                     i]
                                        //                                 .items?[j]
                                        //                                 .sku,
                                        //                       ))));
                                        //       // Navigator.push(
                                        //       //     context,
                                        //       //     MaterialPageRoute(
                                        //       //         builder: (context) =>
                                        //       //             ProductDetailNew(
                                        //       //               productcode:
                                        //       //                   orderHistory?[i]
                                        //       //                       .items?[j]
                                        //       //                       .sku,
                                        //       //             )));
                                        //     },
                                        //     child: AbsorbPointer(
                                        //       child: TextWidget(
                                        //         text: "Buy Again",
                                        //         color: theme_color,
                                        //         weight: FontWeight.w500,
                                        //         size: text_font_small,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ])
                  ]))));
        }
      }
      return _list;
    }

    Widget _body() {
      return Stack(
        children: [
          Container(
            color: grey200_color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10, top: 20, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            gradient: gradient_white_color,
                            border: Border.all(color: Colors.grey, width: 0.3),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      gradient: listType == 1
                                          ? gradient_theme_color
                                          : gradient_white_color,
                                      borderRadius: listType == 1
                                          ? BorderRadius.circular(10.0)
                                          : BorderRadius.only(
                                              bottomLeft:
                                                  const Radius.circular(10.0),
                                              topLeft:
                                                  const Radius.circular(10.0),
                                            )),
                                  child: GestureDetector(
                                    onTap: () {
                                      listType = 1;
                                      setState(() {});
                                    },
                                    child: AbsorbPointer(
                                      child: TextWidget(
                                        text: "Current Orders",
                                        color: listType == 1
                                            ? white_color
                                            : black_color,
                                        weight: FontWeight.w500,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      gradient: listType == 2
                                          ? gradient_theme_color
                                          : gradient_white_color,
                                      borderRadius: listType == 2
                                          ? BorderRadius.circular(10.0)
                                          : BorderRadius.only(
                                              bottomRight:
                                                  const Radius.circular(10.0),
                                              topRight:
                                                  const Radius.circular(10.0),
                                            )),
                                  child: GestureDetector(
                                    onTap: () {
                                      listType = 2;
                                      setState(() {});
                                    },
                                    child: AbsorbPointer(
                                      child: TextWidget(
                                        text: "Order History",
                                        color: listType == 2
                                            ? white_color
                                            : black_color,
                                        weight: FontWeight.w500,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                listType == 2 && orderHistory?.length == 0
                    ? noDatafoundinHistory()
                    : (widget.model?.length ?? 0) > 0
                        ? Expanded(
                            child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.only(bottom: 80),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: listType == 2
                                    ? _orderHistory()
                                    : _orderList(),
                              ),
                            ),
                          ))
                        : _nodatafound(),
              ],
            ),
          ),
          orderHistory?.length == 0 || listType == 2
              ? Container(
                  height: 0,
                )
              : Positioned(
                  bottom: 20,
                  // right: 70,
                  left: 15,
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (cxt) => ShopTabBarPage(
                                      index: 0,
                                      tabIndex: 0,
                                    )));
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 1.1,
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: new_gradient_color,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            borderRadius: BorderRadius.circular(7)),
                        child: AbsorbPointer(
                          child: TextWidget(
                            text: "Go to Home",
                            color: white_color,
                            weight: FontWeight.w500,
                            size: text_font_medium_size,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
        ],
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
          backgroundColor: bg_color,
          // body: WillPopScope(
          //     child: _isLoading ? MyOrderPageShimmer() : _body(),
          //     onWillPop: () async {
          //       if (widget.route == "confirm") {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (cxt) => ShopTabBarPage(
          //                       index: 4,
          //                     )));
          //       } else {
          //         Navigator.pop(context);
          //       }
          //       return false;
          //     }),
          body: _isLoading ? MyOrderPageShimmer() : _body(),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(90.0),
            child: ShopGradientAppBar(
              title: "My Orders",
              color: white_text_color,
              size: 18,
              weight: FontWeight.w500,
              centerTitle: true,
            ),
          ),
        ),
      ),
    );
  }

  dateformate(format) {
    var abc = 2 / 19 / 2021;
    format = abc.toString();
    var finalDate = format.replaceAll('/', '-');
    var now = DateTime.parse(finalDate);
    var formatter = new DateFormat('MMM dd,yyyy');
    var formated = formatter.format(now);

    return formated;
  }

  SizedBox _nodatafound() {
    return SizedBox(
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset(
                ImageConstants.notFoundimg,
                height: 200,
                width: 200,
              ),
            ),
            Container(
                alignment: Alignment.center,
                child: TextWidget(
                  text: "Not yet bought an item?\n Click here to buy an item.",
                  size: text_font_medium_size,
                  weight: FontWeight.w500,
                  alignment: TextAlign.center,
                )),
            new SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (contex) => ShopTabBarPage(
                              tabIndex: 0,
                            )));
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                      colors: new_gradient_color,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
                width: MediaQuery.of(context).size.width / 2,
                child: TextWidget(
                  alignment: TextAlign.center,
                  text: "Continue Shopping",
                  size: 17,
                  color: white_text_color,
                  weight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ));
  }

  noDatafoundinHistory() {
    return Card(
      elevation: 0,
      color: white_text_color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height / 1.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset(
                ImageConstants.notFoundimg,
                height: 200,
                width: 200,
              ),
            ),
            TextWidget(
              text: 'NO ORDER FOUND',
              size: text_size_20,
              weight: FontWeight.w500,
            ),
            SizedBox(
              height: 10,
            ),
            TextWidget(
              text: "Looks like you haven't made\n your order yet",
              size: text_size_16,
              alignment: TextAlign.center,
            ),
            SizedBox(
              height: 60,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (cxt) => ShopTabBarPage(
                              index: 0,
                              tabIndex: 0,
                            )));
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 1.4,
                padding: EdgeInsets.all(1),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: gradient_theme_color,
                    border: Border.all(color: Colors.grey, width: 0.3),
                    borderRadius: BorderRadius.circular(10)),
                child: AbsorbPointer(
                  child: Center(
                    child: TextWidget(
                      text: "Go to Home",
                      color: white_color,
                      weight: FontWeight.w500,
                      size: text_font_medium_size,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

  @override
  void onMyProfileViewError(error) {
    // TODO: implement onMyProfileViewError
    _isLoading = false;
    setState(() {});
  }

  void onMyProfileViewSuccess(MyProfileModel response) {
    setState(() {
      if (response.success == 'true') {
        setState(() {
          _model = response;
          _isLoading = false;

          widget.model = _model?.orderList;
          orderHistory = _model?.orderHistory;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  String getformat(string) {
    if (string != null) {
      var dates = string.substring(0, 10);
      DateTime dt = DateTime.parse(dates);
      return DateFormat("MMMM d, yyyy ").format(dt);
    } else {
      return 'Invalid Date';
    }
  }

  @override
  void onProfileTimeout() {
    if (mounted)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cxt) => ServiceUnavailable(
                  onRetry: () => MyProfilePresenter(this).getMyProfileData())));
  }
}
