/*
Auther Name: Jyoti Gite
Discription : This is the  flight booking confirmation page and my purchase details Page
Date: May 20,2022
*/

import 'package:barcode_widgets/barcode_flutter.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/extension.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/flight_module/flightBookingConfirmation/flight_booking_confimr_model.dart';
import 'package:gems_revamp/flight_module/flightBookingConfirmation/send_email_mvp/share_email_model.dart';
import 'package:gems_revamp/flight_module/flightBookingConfirmation/send_email_mvp/share_email_presenter.dart';
import 'package:gems_revamp/flight_module/flight_details/details_modal.dart';
import 'package:gems_revamp/flight_module/flight_pendingpageui.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/flighthomereq_model.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flt_db/flt_list_dbhelper.dart';
import 'package:gems_revamp/offer_module/offer_detail/offer_detail.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:gems_revamp/utils/payment_fail.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../common_widget/bottombar.dart';
import '../../utils/constants_files/text_constants.dart';
import 'flight_booking_confirm_presenter.dart';
import 'flight_booking_confirm_view.dart';
import 'flight_fail.dart';
import 'send_email_mvp/share_email_view.dart';

class FlightBookingConfirmationPage extends StatefulWidget {
  final type;
  final brfNo;
  final bookingBrfNo;
  final String? orderUrl;
  final FlightRequestHolder? flightRequestHolder;
  final guestData;
  final DetailsFlightModel? flightDetailsModel;

  FlightBookingConfirmationPage(
      {Key? key,
      this.brfNo,
      this.type,
      this.bookingBrfNo,
      this.flightRequestHolder,
      this.guestData,
      this.flightDetailsModel,
      this.orderUrl})
      : super(key: key);
  @override
  _FlightBookingConfirmationPageState createState() =>
      _FlightBookingConfirmationPageState();
}

_dateFormat(String? date) {
  if (date == null) return '';
  DateTime _date = DateTime.parse(date);
  final DateFormat formatter = DateFormat('EEE, dd MMM yyyy');
  final String formatted = formatter.format(_date);
  return formatted;
}

class _FlightBookingConfirmationPageState
    extends State<FlightBookingConfirmationPage>
    implements FlightPurchaseOrdView, ShareViaEmailView {
  FlightPurchaseOrderModel? _flightPurchaseOrdModal;
  GlobalKey<ScaffoldState> _tabscaffoldKey = new GlobalKey<ScaffoldState>();

  var checkintime = '', checkouttime = '', name = '', image, contact = '';
  bool? _nodataFound = false;
  var noConnection;
  bool? _isloading = true;
  bool? _emailLoader = false;
  bool? isExpandedPrice = false;
  @override
  void initState() {
    apiCall();
    
    if (widget.type != 'purchase') {
      FLTPurchaseListDBHelper().truncateTable();
    }

    super.initState();
  }

  void apiCall() {
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        if (widget.type == 'purchase') {
          FlightPurchaseOrderPresenter()
              .flightPurchaseDetailsApiCall(this, widget.brfNo);
        } else {
          var _req = {
            "brf_no": "${widget.brfNo}",
            'pg_redirection_url': widget.orderUrl == null ? "" : widget.orderUrl
          };
          FlightPurchaseOrderPresenter().getList(this, _req);
        }
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          apiCall();
        } else {
          Navigator.of(context).pop();
        }
      }
    });
  }

  Widget _tabbar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // color: black_color,
      child: BottomBar(
        initialIndex: 2,
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
            key: _tabscaffoldKey,
            extendBody: true,
            appBar: PreferredSize(
                child: _appbar(), preferredSize: Size.fromHeight(105)),
            body: PopScope(
                canPop: true,
              child: _isloading == true
                  ? Container(
                      alignment: Alignment.center,
                      child: SpinKitCircle(
                        color: blue_color,
                      ))
                  : _nodataFound == false
                      ? _body()
                      : Center(
                          child: TextWidget(
                            text: "No Data Found",
                            size: text_font_large20_size,
                            weight: FontWeight.normal,
                          ),
                        ),
             onPopInvoked: (canPop) async {
                if (widget.type != "purchase") {
                   return Future.value(false);
                  } else {
                    Navigator.of(context).pop();
                   return Future.value(false);
                  }
           }),
          bottomNavigationBar: SizedBox(
            height: 95,
            child: _tabbar(),
          ),

          )),
    );
  }

  Widget appBar() {
    return AppBar(
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: white_text_color,
            size: 0,
          ),
          onPressed: () {}),
      title: new Text('Thank you for Booking \n your flight with us!',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          )),
      bottom: PreferredSize(
          preferredSize: Size(0.0, 0.8),
          child: Container(
            margin: const EdgeInsets.only(left: 70.0, bottom: 12),
            child: new Align(
                alignment: Alignment.topLeft,
                child: _isloading == true
                    ? SizedBox(
                        height: 0,
                      )
                    : TextWidget(
                        text:
                            "BOOKING ID - ${_flightPurchaseOrdModal?.values?.bookSid?.result?.bookData?.transactionId ?? ""}",
                        weight: FontWeight.w700,
                        color: white_text_color,
                      )),
          )),
    );
  }

  Widget _appbar() {
    return
        // widget.type != "purchase"?
        _isloading == true
            ? SizedBox(
                height: 0,
              )
            : Container(
                height: 130,
                decoration: BoxDecoration(
                  gradient: gradient_theme_color,
                ),
                padding: EdgeInsets.only(top: 40, left: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.bookingBrfNo != null
                        ? GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 10, top: 5),
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
                        : SizedBox(
                            width: 50,
                          ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: TextWidget(
                            text: "Thank you for Booking\nyour flight with us!",
                            size: text_font_medium17_size,
                            softwrap: true,
                            maxLines: 2,
                            color: white_text_color,
                            weight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          // margin: EdgeInsets.only(right: 30),
                          child: TextWidget(
                            text: widget.bookingBrfNo != null
                                ? "BOOKING ID - FLT${widget.bookingBrfNo}"
                                : "BOOKING ID - ${widget.brfNo}",
                            size: text_font_size_x_small,
                            softwrap: true,
                            maxLines: 2,
                            color: white_text_color.withOpacity(0.7),
                            weight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                // )
                // : Container(
                //     width: MediaQuery.of(context).size.width,
                //     child: GradientAppBar(
                //       title: "Flight Transaction Details",
                //       size: 19,
                //       weight: FontWeight.w500,
                //       color: white_text_color,
                //       height: 90,
                //       centerTitle: true,
                //     ),
              );
  }

  Widget _fltSegmentsInfo(int index, Segment _segment) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            // color: Colors.white,
            child: Container(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 60,
                    width: 60,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: FadeInImage.assetNetwork(
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              ImageConstants.flt_no_image_flight,
                              fit: BoxFit.fill,
                            );
                          },
                          placeholder: ImageConstants.flt_no_image_flight,
                          height: 20,
                          width: 20,
                          fit: BoxFit.fill,
                          image: _segment.fltImage ?? "",
                        )),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    // width: MediaQuery.of(context).size.width / 2.6,
                    margin: EdgeInsets.only(top: 4, right: 5),
                    child: TextWidget(
                      text: "${_segment.anm ?? ""}",
                      size: text_font_medium17_size,
                      color: purchase_text_color,
                      weight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 4),
                    child: TextWidget(
                      text: '(${_segment.acd ?? ""} - ${_segment.fno ?? ""})',
                      size: text_font_medium17_size,
                      color: purchase_text_color,
                      weight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
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
          Container(
            //color: star_yellow_color,
            width: MediaQuery.of(context).size.width,
            // color: white_text_color,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: <Widget>[
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextWidget(
                            text: '${_segment.origin} ${_segment.dptim}',
                            size: text_font_medium15_size,
                            color: purchase_text_color,
                            weight: FontWeight.w600,
                          ),
                          TextWidget(
                            text: '${_dateFormat(_segment.dptdt)}',
                            size: text_font_size_x_small,
                            color: common_grey_text_color,
                            weight: FontWeight.w400,
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 23,
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          color: Color(0XFF3E3E3E),
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: TextWidget(
                          text: '${_segment.jtym}',
                          color: white_text_color,
                          weight: FontWeight.w600,
                          size: text_font_size_small,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            TextWidget(
                              text: '${_segment.arvltm} ${_segment.dept}',
                              size: text_font_medium15_size,
                              color: purchase_text_color,
                              weight: FontWeight.w600,
                            ),
                            TextWidget(
                              text: '${_dateFormat(_segment.arrvldt)}',
                              size: text_font_size_x_small,
                              color: common_grey_text_color,
                              weight: FontWeight.w400,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextWidget(
                            text: '${_segment.deptteminal},',
                            color: common_grey_text_color,
                            size: text_font_x_small,
                            weight: FontWeight.w500,
                          ),
                          TextWidget(
                            text: "${_segment.ogct}",
                            size: text_font_x_small,
                            color: common_grey_text_color,
                            weight: FontWeight.w500,
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width / 2.5,
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          TextWidget(
                            text: '${_segment.arrvlterminal},',
                            color: common_grey_text_color,
                            size: text_font_x_small,
                            weight: FontWeight.w500,
                            alignment: TextAlign.right,
                          ),
                          TextWidget(
                            text: "${_segment.dpct}",
                            size: text_font_x_small,
                            color: common_grey_text_color,
                            weight: FontWeight.w500,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryGuestDetailsWidget() {
    return Container(
      // margin: EdgeInsets.only(left: 20, right: 20),
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
          Padding(
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
              text:
                  '${_flightPurchaseOrdModal?.values?.fltInfo?.guest!.firstOrNull?.name ?? ""}',
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
              text:
                  '${_flightPurchaseOrdModal?.values?.fltInfo?.guest!.firstOrNull?.phone ?? ""}',
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
              text:
                  '${_flightPurchaseOrdModal?.values?.fltInfo?.guest!.firstOrNull?.email ?? ""}',
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

  Widget _saveandsharebuttonWidget() {
    return Container(
      // margin: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_flightPurchaseOrdModal!.values!.saveAsPdf != null ||
                    _flightPurchaseOrdModal!.values!.saveAsPdf == '') {
                  LaunchUrl.openLink(
                      url: _flightPurchaseOrdModal!.values!.saveAsPdf);
                }
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
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                _emailLoader = true;
                setState(() {});
                ShareViaEmailPresenter().getList(
                    this,
                    widget.type != "purchase"
                        ? widget.brfNo
                        : "FLT${widget.bookingBrfNo}",
                    "flights",
                    "flt_booking");
              },
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                    color: button_bgemail_color,
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: TextWidget(
                    text: 'Share via Email',
                    color: white_text_color,
                    size: text_font_medium17_size,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _gotoHomeButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/tabbarpage');
      },
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xff6646b2),
                Colors.blue,
              ],
            )),
        child: const Center(
            child: TextWidget(
          text: 'Go to Home',
          color: white_text_color,
          size: text_font_medium18_size,
          weight: FontWeight.w600,
        )),
      ),
    );
  }

  Widget priceDetails(String titletext, String? amount) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextWidget(
            text: titletext,
            color: date_text_color,
            weight: FontWeight.w500,
            size: text_font_medium15_size,
          ),
          TextWidget(
            text: 'AED $amount',
            color: purchase_text_color,
            weight: FontWeight.w600,
            size: text_font_medium15_size,
          )
        ],
      ),
    );
  }

  priceshow() {
    if (_flightPurchaseOrdModal?.values?.fltInfo?.transactionType == "RD") {
      return '${_flightPurchaseOrdModal?.values?.fltInfo?.redeemPnts!} GEMS Points';
    } else if (_flightPurchaseOrdModal?.values?.fltInfo?.transactionType ==
        "PG_POINTS") {
      return 'AED ${gemsPointsFormatter(_flightPurchaseOrdModal?.values?.fltInfo?.partialAmt != null ? _flightPurchaseOrdModal?.values?.fltInfo?.partialAmt! : '')} + ${_flightPurchaseOrdModal?.values?.fltInfo?.redeemPnts ?? 0} GEMS Points';
    } else {
      return 'AED ${gemsPointsFormatter(_flightPurchaseOrdModal?.values?.fltInfo?.totalAmt ?? 0)}';
    }
  }

  Widget _priceDetailsWidget() {
    return Container(
      // margin: const EdgeInsets.only(left: 20, right: 20),
      height: isExpandedPrice == false ? 160 : 300,
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
                  text: 'You Paid',
                  size: text_font_medium16_size,
                  color: purchase_text_color,
                  weight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: TextWidget(
                  textAlign: TextAlign.left,
                  text: priceshow(),
                  // _flightPurchaseOrdModal
                  //             ?.values?.fltInfo?.transactionType ==
                  //         "RD"
                  //     ? '${_flightPurchaseOrdModal?.values?.fltInfo?.redeemPnts!}GEMS Points'
                  //     : _flightPurchaseOrdModal
                  //                 ?.values?.fltInfo?.transactionType ==
                  //             "PG_POINTS"
                  //         ? 'AED ${gemsPointsFormatter(_flightPurchaseOrdModal?.values?.fltInfo?.partialAmt != null ? _flightPurchaseOrdModal?.values?.fltInfo?.partialAmt! : '')}  ${_flightPurchaseOrdModal?.values?.fltInfo?.redeemPnts ?? 0} GEMS Points'
                  //         : _flightPurchaseOrdModal
                  //                     ?.values?.fltInfo?.transactionType ==
                  //                 "PG"
                  //             ? 'AED ${gemsPointsFormatter(_flightPurchaseOrdModal?.values?.fltInfo?.totalAmt ?? 0)}'
                  //             : 'AED ${gemsPointsFormatter(_flightPurchaseOrdModal?.values?.fltInfo?.totalAmt ?? 0)}',

                  size: text_font_medium16_size,
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
          FittedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: TextWidget(
                    textAlign: TextAlign.left,
                    text: 'American Express (*****43249)',
                    size: text_font_medium15_size,
                    color: date_text_color,
                    weight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: TextWidget(
                    textAlign: TextAlign.left,
                    text:
                        'AED ${gemsPointsFormatter(_flightPurchaseOrdModal?.values?.fltInfo?.totalAmt ?? 0)}',
                    size: text_font_medium15_size,
                    color: date_text_color,
                    weight: FontWeight.w400,
                  ),
                ),
              ],
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
            child: Column(
              children: [
                Row(
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
                                size: 20,
                                color: date_text_color,
                              ))
                          : const RotatedBox(
                              quarterTurns: 4,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: date_text_color,
                              )),
                    )
                  ],
                ),
                isExpandedPrice == true
                    ? Container(
                        child: Column(
                          children: [
                            priceDetails(
                                'Base Fare',
                                _flightPurchaseOrdModal?.values?.fltInfo?.bfr
                                    .toString()),
                            priceDetails(
                                'Convenience Fee',
                                _flightPurchaseOrdModal
                                    ?.values?.fltInfo?.convFees
                                    .toString()),
                            priceDetails(
                                'Taxes',
                                _flightPurchaseOrdModal?.values?.fltInfo?.ttx
                                    .toString()),
                            priceDetails(
                                'Total',
                                _flightPurchaseOrdModal
                                    ?.values?.fltInfo?.totalAmt
                                    .toString())
                          ],
                        ),
                      )
                    : Container(
                        height: 0,
                      )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _barcode() {
    return Container(
      // width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 10, right: 10, top: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BarCodeImage(
            params: Code39BarCodeParams(
              "${widget.brfNo}",
              lineWidth: 1.6,
              barHeight: 50.0,
              withText: false,
            ),
            onError: (error) {},
          ),
        ],
      ),
    );
  }

  Widget _body() {
    try {
      final _earnBnzPnts = (int.tryParse(
              _flightPurchaseOrdModal?.values?.earnBnzPnts.toString() ?? '') ??
          0);
      final _segments =
          _flightPurchaseOrdModal?.values?.fltInfo?.segments ?? [];
      return SingleChildScrollView(
        child: Container(
          color: const Color(0xffF6F6F6),
          // decoration: BoxDecoration(gradient: gradient_grey_theme_color),
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      image: DecorationImage(
                          image: AssetImage(
                            ImageConstants.flt_success_bgimage,
                          ),
                          fit: BoxFit.cover)),
                  child: MediaQuery.removeViewPadding(
                    removeTop: false,
                    context: context,
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 2),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _segments.length,
                          itemBuilder: (context, j) {
                            return _fltSegmentsInfo(j, _segments[j]);
                          },
                        ),
                        _barcode(),
                        Container(
                          padding: EdgeInsets.only(bottom: 20, top: 10),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child: TextWidget(
                            text:
                               AppTexts.bookingSuccessMessage,
                            size: text_font_medium14_size,
                            color: purchase_text_color,
                            weight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                _primaryGuestDetailsWidget(),
                SizedBox(
                  height: 10,
                ),
                _priceDetailsWidget(),
                SizedBox(
                  height: 10,
                ),
                _earnBnzPnts > 0
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            color: white_text_color,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextWidget(
                              text: "Points to be earned",
                              size: text_font_medium15_size,
                              color: grey_color,
                              weight: FontWeight.w500,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            TextWidget(
                              text:
                                  "${gemsPointsFormatter(_earnBnzPnts) /*   ?? 0  */} GEMS Points",
                              weight: FontWeight.w600,
                              size: text_font_medium15_size,
                              color: blue_color,
                            )
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
                const SizedBox(
                  height: 10,
                ),
                _saveandsharebuttonWidget(),
                const SizedBox(
                  height: 20,
                ),
                _gotoHomeButton(),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(height: 100)
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      //Print(e);
      return Container();
    }
  }

  @override
  void allErr(error) {
    //Print(error);
    _emailLoader = false;
    _isloading = false;
    setState(() {});
  }

  @override
  void pgResp(FlightPurchaseOrderModel flightPurchaseOrdModal) {
    
    final _message = flightPurchaseOrdModal.message ?? '';

    if (flightPurchaseOrdModal.status == false) {
      if (flightPurchaseOrdModal.message != null) {
        if (_message.contains("Flight Booking Failed")) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => FlightBookingFail(
                        type: "Booking",
                        brfNo: widget.type != "purchase"
                            ? widget.brfNo.toString()
                            : "FLT${widget.bookingBrfNo}",
                      )));
        } else if (flightPurchaseOrdModal.code == "FLT_029") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => PaymentFailed()));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => FlightBookingFail(
                        type: "Payment",
                        brfNo: widget.type != "purchase"
                            ? widget.brfNo.toString()
                            : "FLT${widget.bookingBrfNo}",
                      )));
        }
      }
    } else if (flightPurchaseOrdModal.status == true &&
        (flightPurchaseOrdModal.values != null)) {
      //  flightPurchaseOrdModal.values!.bookSid!.result!.bookData!.result!.
      if (flightPurchaseOrdModal
              .values!.bookSid!.result!.bookData!.result!.status ==
          "pending") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FlightPendingPage(
                  data: flightPurchaseOrdModal.values,
                  brno: "${widget.brfNo}")),
        );
      } else if (_message.contains("Flight Booking Failed")) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => FlightBookingFail(
                      type: "Booking",
                      brfNo: widget.type != "purchase"
                          ? widget.brfNo.toString()
                          : "FLT${widget.bookingBrfNo}",
                    )));
      } else {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context) => FlightBookingFail(
        //               type: "Payment",
        //               brfNo: widget.type != "purchase"
        //                   ? widget.brfNo.toString()
        //                   : "FLT${widget.bookingBrfNo}",
        //             )));
      }
    }
    _flightPurchaseOrdModal = flightPurchaseOrdModal;
    _isloading = false;
    setState(() {});
  }

  @override
  void flightPurchaseDetailsResp(
      FlightPurchaseOrderModel flightPurchaseOrdModal) {
    if (flightPurchaseOrdModal.status == true) {
      setState(() {
        _flightPurchaseOrdModal = flightPurchaseOrdModal;
        _isloading = false;
      });
    } else {
      setState(() {
        _isloading = false;
        _nodataFound = true;
      });
    }
  }

  @override
  void shareEmailResponse(ShareViaEmailModel shareViaEmailModel) {
    _emailLoader = false;

    setState(() {
      Fluttertoast.showToast(
          msg: "${shareViaEmailModel.message}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: grey600_color);
    });
  }
}
