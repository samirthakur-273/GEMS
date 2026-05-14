import 'package:barcode_widgets/barcode_flutter.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:intl/intl.dart';

import '../../../common_widget/bottombar.dart';

class FlightPurchaseDetailsPage extends StatefulWidget {
  const FlightPurchaseDetailsPage({Key? key}) : super(key: key);

  @override
  _FlightPurchaseDetailsPageState createState() =>
      _FlightPurchaseDetailsPageState();
}

class _FlightPurchaseDetailsPageState extends State<FlightPurchaseDetailsPage> {
  bool isExpandedPrice = false;

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
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.8, color: date_text_color),
                        image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('images/emirates.png')),
                        borderRadius: BorderRadius.circular(14),
                      )),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const TextWidget(
                            text: 'Emirates E6-91',
                            size: text_font_medium17_size,
                            color: purchase_text_color,
                            weight: FontWeight.w500,
                          ),
                        ),
                        // Container(
                        //   alignment: Alignment.centerLeft,
                        //   child: const TextWidget(
                        //     text: 'Dubai United Arab Emirates',
                        //     size: 13,
                        //     color: Color(0xff969390),
                        //     weight: FontWeight.w600,
                        //   ),
                        // ),
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
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const TextWidget(
                        text: "DXB 05:00",
                        size: text_font_medium15_size,
                        color: purchase_text_color,
                        weight: FontWeight.w600,
                      ),
                      TextWidget(
                        text: dateformate('2022-02-24 09:23:36'),
                        size: text_font_size_x_small,
                        color: common_grey_text_color,
                        weight: FontWeight.w400,
                      ),
                      // Container(
                      //   width: 120,
                      //   child: const TextWidget(
                      //     text: 'Dubai international Airport,Terminal 1',
                      //     size: 14,
                      //     color:  Color(0xff8F92A1),
                      //      softwrap: true,
                      //     maxLines: 2,
                      //   ),
                      // ),
                    ],
                  ),
                  Container(
                    height: 30,
                    width: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.black),
                    child: const Center(
                      child: TextWidget(
                        text: '3h 40m',
                        color: white_text_color,
                        weight: FontWeight.w600,
                        size: text_font_size_small,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const TextWidget(
                        text: "BOM 12:00",
                        size: text_font_medium15_size,
                        color: purchase_text_color,
                        weight: FontWeight.w600,
                      ),
                      TextWidget(
                        text: dateformate('2022-02-24 09:23:36'),
                        size: text_font_size_x_small,
                        color: common_grey_text_color,
                        weight: FontWeight.w400,
                      ),
                      //   Container(
                      //      width: 120,
                      //     child: const TextWidget(
                      //     text: 'Dubai international Airport,Terminal 1',
                      //     size: 14,
                      //     color:  Color(0xff8F92A1),
                      //     softwrap: true,
                      //     maxLines: 2,
                      // ),
                      //   ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // Container(
            //   margin: const EdgeInsets.only(left: 20, right: 20),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children:  [
            //        Container(
            //         //  alignment: Alignment.centerLeft,
            //           child: const TextWidget(
            //             text: 'Dubai international Airport,Terminal 1',
            //             size: 14,
            //             color: Color(0xff8F92A1),
            //             softwrap: true,
            //             maxLines: 2,
            //           ),
            //         ),

            //       Container(
            //           // alignment: Alignment.centerRight,
            //           child: const TextWidget(
            //             text: 'Dubai international Airport,Terminal 1',
            //             size: 14,
            //             color: Color(0xff8F92A1),
            //             softwrap: true,
            //             maxLines: 2,
            //           ),
            //         ),

            //     ],
            //   ),
            // ),

            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: BarCodeImage(
                params: Code39BarCodeParams(
                  "7729429379874544",
                  lineWidth: 1.3,
                  barHeight: 50.0,
                  withText: false,
                ),
                onError: (error) {},
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: const TextWidget(
                text: 'Thank you for booking your flight with us!',
                color: purchase_text_color,
                size: text_font_medium15_size,
                weight: FontWeight.w600,
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
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: button_bgpdf_color,
                    borderRadius: BorderRadius.circular(14)),
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
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: button_bgemail_color,
                    borderRadius: BorderRadius.circular(18)),
                child: const Center(
                  child: TextWidget(
                    text: 'Share via Email',
                    color: white_text_color,
                    size: text_font_medium17_size,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget _priceDetailsWidget() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
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
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: TextWidget(
                    textAlign: TextAlign.left,
                    text: 'You Paid',
                    size: text_font_medium17_size,
                    color: purchase_text_color,
                    weight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: TextWidget(
                    textAlign: TextAlign.left,
                    text: 'AED 2000',
                    size: text_font_medium17_size,
                    color: purchase_text_color,
                    weight: FontWeight.w700,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
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
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: TextWidget(
                    textAlign: TextAlign.left,
                    text: 'AED 680',
                    size: text_font_medium15_size,
                    color: date_text_color,
                    weight: FontWeight.w400,
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
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextWidget(
                textAlign: TextAlign.left,
                text: 'Farah Khan',
                size: text_font_small,
                color: purchase_text_color,
                weight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextWidget(
                textAlign: TextAlign.left,
                text: '+971 56 804 7329',
                size: text_font_small,
                color: date_text_color,
                weight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: TextWidget(
                textAlign: TextAlign.left,
                text: 'Farhan.khan@gmail.com',
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
        height: 150,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  ImageConstants.appbarbgimage,
                ))
            //     gradient: LinearGradient(
            //       tileMode: TileMode.repeated,
            //       begin: Alignment.topRight,
            //       end: Alignment.bottomLeft,
            //       stops: [0.1, 2.0],
            //       colors: [
            //         Color(0xFF283593),
            //         Color(0xFF00A3E0),
            //       ],
            //     ),
            ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context, true);
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10, top: 0),
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    shape: BoxShape.rectangle,
                    color: const Color(0xff3cabea)),
                child: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 220,
                    child: const TextWidget(
                      text: 'Thank you for booking your stay with us !',
                      size: text_font_medium17_size,
                      softwrap: true,
                      maxLines: 2,
                      color: white_text_color,
                      weight: FontWeight.w500,
                      // alignment: TextAlign.left,
                    ),
                  ),
                  Container(
                    child: const TextWidget(
                      text: 'BOOKING ID - FLTH6323232',
                      size: text_font_medium15_size,
                      softwrap: true,
                      maxLines: 2,
                      color: white_text_color,
                      weight: FontWeight.w500,
                    ),
                  ),
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
                    )),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
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

    Widget _body() {
      return Container(
        color: const Color(0xffF6F6F6),
        child: Column(
          children: [
            _appBar(),
            Expanded(
                child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
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
                  height: 20,
                ),
              ],
            ))
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

    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        extendBody: true,

        body: _body(),
        bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
      ),
    );
  }
}

dateformate(format) {
  var now = DateTime.parse(format);
  var formatter = DateFormat('EE, d MMM yyyy');
  var formated = formatter.format(now);

  return formated;
}

timeformate(format) {
  DateTime now = DateTime.parse(format);
  String formattedDate = DateFormat('hh:mm a').format(now);

  return formattedDate;
}
