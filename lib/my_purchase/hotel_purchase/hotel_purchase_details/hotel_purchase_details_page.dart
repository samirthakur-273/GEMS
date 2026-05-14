import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/checkinternet.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/numberformat.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/hotel_module/send_email_mvp/share_email_model.dart';
import 'package:gems_revamp/hotel_module/send_email_mvp/share_email_presenter.dart';
import 'package:gems_revamp/hotel_module/send_email_mvp/share_email_view.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hlt_db/hlt_dbhelper.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_details/purchaseOrder_model.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_details/purchaseOrder_presenter.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_details/purchaseOrder_view.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_list/hotel_purchase_list_presenter.dart';
import 'package:gems_revamp/offer_module/offer_detail/offer_detail.dart';
import 'package:gems_revamp/payment_failed/payment_failed.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:gems_revamp/utils/time_out.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../common_widget/bottombar.dart';

class HotelPurchaseDetailsPage extends StatefulWidget {
  final brf_no, country, checkinDate, checkoutDate, bookingBrfNo, type;
  final String? orderUrl;
  const HotelPurchaseDetailsPage(
      {Key? key,
      this.brf_no,
      this.country,
      this.checkinDate,
      this.checkoutDate,
      this.bookingBrfNo,
      this.orderUrl,
      this.type})
      : super(key: key);

  @override
  _HotelPurchaseDetailsPageState createState() =>
      _HotelPurchaseDetailsPageState();
}

class _HotelPurchaseDetailsPageState extends State<HotelPurchaseDetailsPage>
    implements ShareViaEmailView, PurchaseOrderView {
  bool isExpandedPrice = false;
  bool _emailLoader = false;
  PurchasePresenter? purchasePresenter;
  HotelPurchaseListPresenter? _hotelPurchaseListPresenter;

  var noOfRooms = 0,
      noOfNights = '',
      noOfGuest = 0,
      roomType = '',
      checkintime = '',
      checkouttime = '',
      hotelName = '',
      htlAddress = '',
      htlImage = '',
      name = '',
      image,
      contact = '',
      imageUrl = '',
      bounzPoint,
      totalCost;
  DateTime? checkin, checkout;
  List htlDetils = List.empty(growable: true);
  List paxdata = List.empty(growable: true);
  // var paxdata;
  String url = "", email = 'example@gmail.com';
  String? urlPdfPath, progress;
  bool isLoading = true, isstatus = false;
  String transactionType = 'PG';
  var partialamount = 0, redeempoint = 0;
  String errmsg = '';
  bool _nodataFound = false;
  var bookingId = '';
  @override
  void initState() {
    super.initState();
    purchasePresenter = PurchasePresenter(this);

    if (widget.type != "transactionList") {
      HotelPurchaseListDBHelper().truncateTable();
    } 

    internet();
  }

  void hotellistdataupdate() {
    setState(() {
      _hotelPurchaseListPresenter
          ?.hotelPurchaseListResApi(GemsGLobals.membershipNo);
    });
  }

  void internet() async {
    CheckInternet().apiCall().then((value) => {
          if (value == true)
            {            
        setState(() {
                if (widget.type == "transactionList") {
                  purchasePresenter!
                      .hotelPurchaseDetailsapicall(this.widget.brf_no);
                } else {
                  var req = {"brf_no": this.widget.brf_no,'pg_redirection_url':widget.orderUrl};

                  purchasePresenter!.getOrderDetails(req);
                }
              }),
            }
          else
            {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => NoInternet()))
                  .then((value) {
                if (value != null) {
                  setState(() {
                    if (widget.type == "transactionList") {
                      purchasePresenter!
                          .hotelPurchaseDetailsapicall(this.widget.brf_no);
                    } else {
                      var req = {"brf_no": this.widget.brf_no,'pg_redirection_url':widget.orderUrl};

                      purchasePresenter!.getOrderDetails(req);
                    }
                  });
                } else {
                  Navigator.pop(context);
                }
              }),
            }
        });
  }

/* ---- total cost--- */
  _getTotalCost() {
    if (transactionType == 'RD' || transactionType == 'PG_POINTS') {
      return '${redeempoint != null ? pointsFormatter(int.parse(redeempoint.toString())) : ''} GEMS';
    } else {
      return 'AED ${totalCost != null ? pointsFormatter(int.parse(totalCost.toString())) : ''}';
    }
  }

  _getPaidAmount() {
    if (transactionType == 'RD') {
      return '${redeempoint != null ? pointsFormatter(int.parse(redeempoint.toString())) : ''} GEMS Points';
    } else if (transactionType == 'PG_POINTS') {
      return 'AED ${partialamount != null ? pointsFormatter(int.parse(partialamount.toString())) : ''} + ${redeempoint != null ? redeempoint.toString() : ''} GEMS Points';
    } else {
      return 'AED ${totalCost != null ? pointsFormatter(int.parse(totalCost.toString())) : ''}';
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _hotelDetailInfoWidget() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  new Container(
                    height: 80,
                    width: 70,
                    child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                ImageConstants.htl_placeholder,
                                fit: BoxFit.fill,
                              ),
                            ),
                        imageUrl: imageUrl.toString() != ''
                            ? "${imageUrl.toString()}"
                            : "",
                        fit: BoxFit.fill,
                        errorWidget: (context, url, error) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              ImageConstants.htl_placeholder,
                              fit: BoxFit.fill,
                            ),
                          );
                        }),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 170,
                          alignment: Alignment.centerLeft,
                          child: TextWidget(
                            text: "${hotelName.toString()}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            size: text_font_medium15_size,
                            color: purchase_text_color,
                            weight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          width: 170,
                          alignment: Alignment.centerLeft,
                          child: TextWidget(
                            text: "${htlAddress.toString()}",
                            overflow: TextOverflow.ellipsis,
                            size: 12,
                            color: date_text_color,
                            weight: FontWeight.w400,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              // ignore: prefer_const_constructors
              child: DottedLine(
                dashGapLength: 6,
                lineThickness: 1.5,
                dashColor: dotted_line_color,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const TextWidget(
                        text: "Check-In",
                        size: text_font_small,
                        color: date_text_color,
                        weight: FontWeight.w400,
                      ),
                      // Container(
                      //   height: 5,
                      // ),
                      TextWidget(
                        text: checkin.toString() != '' && checkin != null
                            ? '${DateFormat("EEE, dd MMM yyyy").format(checkin!)}'
                            : '',
                        size: text_font_size_small,
                        weight: FontWeight.w600,
                        color: purchase_text_color,
                      ),

                      TextWidget(
                        text: '${checkintime.toString()}',
                        size: text_font_small,
                        color: date_text_color,
                        weight: FontWeight.w400,
                      ),
                    ],
                  ),
                  SizedBox(width: 5),
                  Container(
                    height: 30,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.black),
                    child: Center(
                      child: TextWidget(
                        text: '${noOfNights.toString()} nights',
                        size: text_font_size_x_small,
                        color: white_text_color,
                        weight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const TextWidget(
                        text: "Check-Out",
                        size: text_font_small,
                        color: date_text_color,
                        weight: FontWeight.w400,
                      ),
                      // Container(
                      //   height: 5,
                      // ),
                      TextWidget(
                        text: checkout.toString() != '' && checkout != null
                            ? '${DateFormat("EEE, dd MMM yyyy").format(checkout!)}'
                            : '',
                        size: text_font_size_small,
                        weight: FontWeight.w600,
                        color: purchase_text_color,
                      ),
                      TextWidget(
                        text: '${checkouttime.toString()}',
                        size: text_font_small,
                        color: date_text_color,
                        weight: FontWeight.w400,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Wrap(
                // crossAxisAlignment: WrapCrossAlignment.start,
                alignment: WrapAlignment.start,
                children: [
                  Container(
                    // width: 200,
                    child: TextWidget(
                      text: roomType.toString() == ''
                          ? ''
                          : '${roomType.toString()} x ${noOfRooms.toString()}',
                      color: date_text_color,
                      size: text_font_small,
                      weight: FontWeight.w400,
                      // maxLines: 5,
                    ),
                  ),
                  TextWidget(
                    text: noOfGuest == 0
                        ? ''
                        : ' Guests x ${noOfGuest.toString()}',
                    color: date_text_color,
                    size: text_font_small,
                    weight: FontWeight.w400,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'Total Cost',
                    size: text_font_medium15_size,
                    color: date_text_color,
                    weight: FontWeight.w400,
                  ),
                  TextWidget(
                    text: _getTotalCost(),
                    size: text_font_medium17_size,
                    color: purchase_text_color,
                    weight: FontWeight.w500,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    }

    Widget _saveandsharebuttonWidget() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                
                 LaunchUrl.openLink(url: url);
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      color: button_bgpdf_color,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: TextWidget(
                      text: 'Save as PDF',
                      color: white_text_color,
                      size: text_font_medium17_size,
                      weight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
         
          ],
        ),
      );
    }

    Widget _priceDetailsWidget() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        height: isExpandedPrice == false ? 110 : 230,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: TextWidget(
                    textAlign: TextAlign.left,
                    text: 'You Paid ',
                    size: text_font_medium16_size,
                    color: purchase_text_color,
                    weight: FontWeight.w500,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: TextWidget(
                    textAlign: TextAlign.left,
                    text: _getPaidAmount(),
                    size: transactionType == 'PG_POINTS'?text_font_medium14_size: text_font_medium16_size,
                    color: purchase_text_color,
                    weight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              // ignore: prefer_const_constructors
              child: DottedLine(
                dashGapLength: 6,
                lineThickness: 1.5,
                dashColor: dotted_line_color,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                if (isExpandedPrice == false) {
                  setState(() {
                    isExpandedPrice = true;
                  });
                } else {
                  setState(() {
                    isExpandedPrice = false;
                  });
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: TextWidget(
                      textAlign: TextAlign.left,
                      text: 'Payment Details',
                      size: text_font_medium17_size,
                      weight: FontWeight.w400,
                      color: date_text_color,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: isExpandedPrice == true
                        ? const RotatedBox(
                            quarterTurns: 1,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 25,
                              color: Color(0xff8F92A1),
                            ))
                        : const RotatedBox(
                            quarterTurns: 4,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 25,
                              color: Color(0xff8F92A1),
                            )),
                  ),
                ],
              ),
            ),
            if (isExpandedPrice == true)
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 5, top: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: new Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8.0, 6.0, 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text(
                            'Booking Reference No',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          new Text(
                            widget.type == "transactionList"
                                ? 'HTL${this.widget.bookingBrfNo ?? ""}'
                                : '${this.widget.brf_no.toString()}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            if (isExpandedPrice == true)
              transactionType == 'PG'
                  ? new Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 15.0, 5, 8.0),
                      child: new Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(255, 249, 235, 1),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10, 10.0, 10.0, 10.0),
                            child: FittedBox(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  TextWidget(
                                    text: 'Points to be earned',
                                    size: 15,
                                    color: grey_color,
                                    weight: FontWeight.w600,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  new Text(
                                    '${bounzPoint != null ? (pointsFormatter(int.parse(bounzPoint.toString())) + ' GEMS Points') : ''}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: blue_color,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                            )),
                      ),
                    )
                  : Container(
                      height: 0,
                    ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    }

    Widget _primaryGuestDetailsWidget() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        // height: 120,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextWidget(
                textAlign: TextAlign.left,
                text: 'Primary Guest Details',
                size: text_font_medium17_size,
                color: purchase_text_color,
                weight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              // ignore: prefer_const_constructors
              child: DottedLine(
                dashGapLength: 6,
                lineThickness: 1.5,
                dashColor: dotted_line_color,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextWidget(
                textAlign: TextAlign.left,
                text: name.toString() != '' ? '${name.toString()}' : "",
                size: text_font_small,
                color: purchase_text_color,
                weight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextWidget(
                textAlign: TextAlign.left,
                text: contact.toString() != '' ? '+${contact.toString()}' : "",
                size: text_font_small,
                color: date_text_color,
                weight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextWidget(
                textAlign: TextAlign.left,
                text: email.toString() != '' ? '${email.toString()}' : "",
                size: text_font_small,
                color: date_text_color,
                weight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    }

    Widget _appBar() {
      return Container(
        height: 130,
        decoration: const BoxDecoration(gradient: gradient_theme_color),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: widget.type == "transactionList"
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            widget.type == "transactionList"
                ? GestureDetector(
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
                            size: 27,
                            color: white_text_color,
                          ),
                        ),
                      ),
                    ))
                : Container(
                    height: 0,
                  ),
            Container(
              margin: isstatus
                  ? EdgeInsets.only(left: 20, top: 20)
                  : EdgeInsets.only(left: 20, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                      width: 220,
                      child: isstatus
                          ? TextWidget(
                              text: 'Thank you for booking\nyour stay with us!',
                              size: text_font_medium16_size,
                              softwrap: true,
                              maxLines: 2,
                              color: white_text_color,
                              weight: FontWeight.w600,
                            )
                          : TextWidget(
                              text: 'Please try again \nSomething went wrong!',
                              size: text_font_medium16_size,
                              softwrap: true,
                              maxLines: 2,
                              color: white_text_color,
                              weight: FontWeight.w600,
                            )),
                  if (_nodataFound == false)
                    isstatus
                        ? Container(
                            padding: EdgeInsets.only(top: 5),
                            child: TextWidget(
                              text:
                                  "BOOKING ID - ${widget.brf_no}", //'BOOKING ID - ${bookingId.toString()}',
                              size: text_font_size_x_small,
                              softwrap: true,
                              maxLines: 2,
                              color: white_text_color.withAlpha((0.7 * 255).toInt()),
                              weight: FontWeight.w500,
                            ),
                          )
                        : Container(
                            height: 0,
                          )
                ],
              ),
            ),
          ],
        ),
      );
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
          height: 45,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: gradient_theme_color ),
          child: const Center(
              child: TextWidget(
            text: 'Go to Home',
            color: white_text_color,
            size: text_font_medium17_size,
            weight: FontWeight.w500,
          )),
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

    Widget _body() {
      return Container(
        color: const Color(0xffF6F6F6),
        child: Column(
          children: [
            _appBar(),
            isstatus
                ? Expanded(
                    child: ListView(
                    children: [
                      // const SizedBox(
                      //   height: 10,
                      // ),
                      _hotelDetailInfoWidget(),
                      const SizedBox(
                        height: 20,
                      ),
                      _primaryGuestDetailsWidget(),
                      const SizedBox(
                        height: 20,
                      ),
                      _priceDetailsWidget(),
                      const SizedBox(
                        height: 20,
                      ),
                      _saveandsharebuttonWidget(),
                      const SizedBox(
                        height: 20,
                      ),
                      _gotoHomeButton(),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ))
                : Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 1.2,
                      child: ListView(
                        children: <Widget>[
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(top: 0),
                                        child: Container(
                                          child: Image.asset(
                                            ImageConstants.payment_fail,
                                            gaplessPlayback: true,
                                            fit: BoxFit.fill,
                                            height: 260,
                                            width: 250,
                                            alignment: Alignment.center,
                                          ),
                                        )),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextWidget(
                                      text: bookingId.toString() == ""? "Your Payment for Booking ID " +
                                          "${widget.brf_no}":"Your Payment for Booking ID " +
                                          "${bookingId.toString()}",
                                      weight: FontWeight.w600,
                                      size: text_font_medium_x_size,
                                    ),
                                    TextWidget(
                                      text:
                                          "has failed. Please check with your",
                                      weight: FontWeight.w600,
                                      size: text_font_medium_x_size,
                                    ),
                                    TextWidget(
                                      text: "service provider!!",
                                      weight: FontWeight.w600,
                                      size: text_font_medium_x_size,
                                    ),
                                    TextWidget(
                                      text:
                                          "Please do feel free to get in touch with GEMS",
                                      weight: FontWeight.w500,
                                    ),
                                    TextWidget(
                                      text: " Customer Support at support@gemsrewards.com",
                                      weight: FontWeight.w500,
                                    ),
                                    Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Container(
                                            child: SvgPicture.asset(
                                                ImageConstants.bluearrowdown,
                                                height: 10)),
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                    margin:
                                        EdgeInsets.only(bottom: 30, top: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                         6.0, 8.0, 6.0, 8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TabsScreen(
                                                        initialIndex: 0,
                                                      )));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                                height: 50,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.13,
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      gradient_theme_color,
                                                  borderRadius:
                                                      BorderRadius.circular(24),
                                                ),
                                                child: Center(
                                                  child: TextWidget(
                                                    text: 'Go to Home',
                                                    size: 18,
                                                    color: white_text_color,
                                                    weight: FontWeight.w600,
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop, result) async {
        if (widget.type != "transactionList") {
        return  Future.value(false);
        } else {
          Navigator.of(context).pop();
        return  Future.value(true);
        }
      },

      child: SafeArea(
        bottom: true,
        top: false,
        child: Scaffold(
          extendBody: true,
          appBar: _nodataFound == true && widget.type == "transactionList"
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(100.0),
                  child: _appBar(),
                )
              : null,
          body: isLoading == true
              ? SpinKitCircle(
                  color: btn_bg_color,
                )
              : _nodataFound == true && widget.type == "transactionList"
                  ? Center(
                      child: Container(
                      child: TextWidget(
                        text: "No Data Found",
                        size: text_font_large20_size,
                        weight: FontWeight.normal,
                      ),
                    ))
                  : _body(),
          bottomNavigationBar:  SafeArea(
          top: false, child: SizedBox(height: 95, child: _tabbar())),
        ),
      ),
    );
  }

  @override
  void allErr(error) {
    setState(() {
      isLoading = false;
      _emailLoader = false;
      _nodataFound = true;
    });
    if (error.toString().contains("TimeoutException")) {
      Navigator.push(context, MaterialPageRoute(builder: (cxt) => TimeOut()));
    }
  }

  @override
  void shareEmailResponse(ShareViaEmailModel shareViaEmailModel) {
    _emailLoader = false;
    setState(() {});
    Fluttertoast.showToast(
        msg: "${shareViaEmailModel.message}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: grey600_color);
  }

  @override
  void hotelPurchasedetailsResponse(PurchaseOrderModal purchaseOrder) {
    _callForResponseSet(purchaseOrder);
  }

  @override
  void purchaseresponse(PurchaseOrderModal purchaseOrder) {
    _callForResponseSet(purchaseOrder);
  }

  void _callForResponseSet(PurchaseOrderModal purchaseOrder) async {
    setState(() {
      isLoading = false;
      _nodataFound = false;
    });
    if (purchaseOrder.status == true) {
      setState(() {
        isstatus = true;
         var bookresult = purchaseOrder.values?.bookResult;
        var bookstatus = purchaseOrder.values?.bookStatus;

        transactionType =
            bookresult?.result?.hotelInfo?.transactionType ?? 'PG';
        partialamount = bookresult?.result?.hotelInfo?.partialAmount ?? 0;
        redeempoint = bookresult?.result?.hotelInfo?.redeemPnts ?? 0;
        // url = purchaseOrder.values?.saveAsPdf != null
        //     ? purchaseOrder.values?.saveAsPdf
        //     : bookresult?.result?.saveAsPdf;
        if (purchaseOrder.values?.saveAsPdf != null) {
          url = purchaseOrder.values?.saveAsPdf ?? '';
        } else {
          url = bookresult?.result?.saveAsPdf ?? '';
        }
       bookingId = bookresult?.result?.bookingId ?? '';
        noOfRooms = bookstatus?.result?.noOfRooms ?? 0;
        noOfNights = bookstatus?.result?.noOfNights ?? '';
        noOfGuest = bookstatus?.result?.noOfGuest ?? 0;

        int count = bookstatus?.result?.rooms?.length ?? 0;
        for (int j = 0; j < count; j++) {
          if (j == 0) {
            roomType = bookstatus!.result!.rooms![j].roomType!;
          } else {
            roomType += ',\n${bookstatus?.result?.rooms![j].roomType}';
          }
        }

        checkin = bookresult?.result?.hotelInfo?.checkInDate;
        checkout = bookresult?.result?.hotelInfo?.checkOutDate;

        checkintime = bookresult!.result!.hotelInfo!.checkInTime!;
        checkouttime = bookresult.result!.hotelInfo!.checkOutTime!;
        hotelName = bookresult.result!.hotelInfo!.htlName!;
        htlAddress = bookresult.result!.hotelInfo!.htlAddress!;
        htlImage = bookresult.result!.hotelInfo!.htlImage!;
        if (htlImage != null) {
          image = jsonDecode(htlImage);
        }

        totalCost = bookresult.result?.hotelInfo?.totalAmount ?? 0;
        if (bookresult.result?.hotelInfo?.earnBnzPnts.toString() == 'null' ||
            bookresult.result?.hotelInfo?.earnBnzPnts == null) {
          bounzPoint = 0;
        } else {
          bounzPoint = bookresult.result?.hotelInfo?.earnBnzPnts ?? 0;
        }

        paxdata.addAll(bookresult.result!.paxData ?? []);
        for (int i = 0; i < (paxdata.length == 0 ? 1 : paxdata.length); i++) {
          if (paxdata[i].passangerType == 'Adult') {
            name =
                '${paxdata[i].title}. ${paxdata[i].firstName} ${paxdata[i].lastName}';
            email = paxdata[i].email ?? '';
            contact = paxdata[i].phoneNo ?? '';
            break;
          }
        }
        imageUrl = image[0]["image_url"];
      });
      // _makesenseApiCall();
    } else {
      // _makesenseApiCall();
      setState(() {
        isLoading = false;
        // errmsg = purchaseOrder.errors!.message!;
      });
      if(purchaseOrder.code== "HTL_029"){
        Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => PaymentFailed()));
      }
      if (purchaseOrder.message == "timeout") {
        var notresponding = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => TimeOut()));
        if (notresponding != null) {
        } else {
          Navigator.pop(context, true);
        }
      }
    }
  }
}

dateformate(format) {
  var now = DateTime.parse(format);
  var formatter = DateFormat('dd MMM yyyy');
  var formated = formatter.format(now);

  return formated;
}

timeformate(format) {
  DateTime now = DateTime.parse(format);
  String formattedDate = DateFormat('hh:mm a').format(now);

  return formattedDate;
}
