/* Author : Sanjana Shetty
 Date created : 12-May-2022
 Discription : AirMiles Transaction Pending Page */

import 'package:flutter/material.dart';
import 'package:gems_revamp/account/mypoints/mypoints_design.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';

import '../../../common_widget/bottombar.dart';

class AirMilesTransactionPendingPage extends StatefulWidget {
  final type;
  final selectedslidervalue;
  final gemspointsleft;
  final totalairmiles;
  final int? selectedAirmilesPoints;
  const AirMilesTransactionPendingPage(
      {Key? key,
      this.type,
      this.selectedslidervalue,
      this.gemspointsleft,
      this.totalairmiles,
      this.selectedAirmilesPoints})
      : super(key: key);

  @override
  State<AirMilesTransactionPendingPage> createState() =>
      _AirMilesTransactionPendingPageState();
}

class _AirMilesTransactionPendingPageState
    extends State<AirMilesTransactionPendingPage> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  Widget _imagepending() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Container(
            height: 100,
            width: 100,
            child: Image.asset(
              ImageConstants.transaction_pending,
              fit: BoxFit.fill,
            )),
      ),
    );
  }

  Widget _transactionstatustext() {
    return Container(
      child: TextWidget(
        text: "Transaction Pending",
        weight: FontWeight.bold,
        size: text_font_large20_size,
        color: purchase_text_color,
        alignment: TextAlign.center,
      ),
    );
  }

  Widget _pointconversiontext() {
    return Column(
      children: [
        Container(
          child: TextWidget(
            text: widget.type == "gemstoairmiles"
                ? "Your points conversion from GEMS to AIRMILES"
                : "Your points conversion from AIRMILES to GEMS",
            alignment: TextAlign.center,
            color: grey_background,
            size: text_font_size_small,
            weight: FontWeight.w600,
          ),
        ),
        Container(
          child: TextWidget(
            text: "is pending.",
            alignment: TextAlign.center,
            color: grey_background,
            size: text_font_size_small,
            weight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _points() {
    return Column(
      children: [
        Container(
          child: TextWidget(
            text: widget.type == "gemstoairmiles"
                ? widget.selectedslidervalue
                : widget.totalairmiles.toString(),
            weight: FontWeight.bold,
            color: purchase_text_color,
            size: text_font_medium19_size,
          ),
        ),
        Container(
          child: TextWidget(
              text: GemsGLobals.gemsText,
              color: grey_color_new,
              size: text_font_medium19_size),
        ),
      ],
    );
  }

  Widget _viewingems() {
    return Container(
      child: TextWidget(
        text: GemsGLobals.viewGemsPointsText,
        color: grey_color_new,
        size: text_font_size_x_small,
        weight: FontWeight.w500,
      ),
    );
  }

  Widget _convertedfrom() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 40,
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: box_pingrey),
                color: convert_box,
                borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 5, right: 20, bottom: 10, top: 10),
              child: TextWidget(
                text: "Converted from",
                color: purchase_text_color,
                weight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gemspointsleft() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.type == "gemstoairmiles"
                  ? Container(
                      child: TextWidget(
                        text:
                            "${GemsGLobals.airmilesText}: +" + widget.totalairmiles.toString(),
                        color: grey_color_new,
                        weight: FontWeight.w600,
                      ),
                    )
                  : Container(
                      child: TextWidget(
                        text: "${GemsGLobals.airmilesText}: -" +
                            widget.selectedAirmilesPoints.toString(),
                        color: grey_color_new,
                        weight: FontWeight.w600,
                      ),
                    ),
              Container(
                child: Row(
                  children: [
                    TextWidget(
                      text: widget.type == "gemstoairmiles" ? "-" : "+",
                      color: grey_color_new,
                      weight: FontWeight.w600,
                    ),
                    TextWidget(
                      text: widget.type == "gemstoairmiles"
                          ? '${widget.selectedslidervalue} ${GemsGLobals.gemsPointsText}'
                          : ('${widget.totalairmiles.toString()} ${GemsGLobals.gemsPointsText}'),
                      color: grey_color_new,
                      weight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gotopoints() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyPointsDesignPage()),
            );
          },
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            elevation: WidgetStateProperty.all(0),
            textStyle: WidgetStateProperty.all(TextStyle(color: white_color)),
            backgroundColor: WidgetStateProperty.all(greenboxcolor),
            minimumSize: WidgetStateProperty.all(Size(0, 0)),
            padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10, top: 15, bottom: 15),
            child: TextWidget(
              text: "Go To Points",
              color: Colors.white,
              size: text_font_medium15_size,
              weight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _gotohome() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TabsScreen(
                        initialIndex: 0,
                      )),
            );
          },
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            elevation: WidgetStateProperty.all(0),
            textStyle: WidgetStateProperty.all(TextStyle(color: white_color)),
            backgroundColor: WidgetStateProperty.all(greenboxcolor),
            minimumSize: WidgetStateProperty.all(Size(0, 0)),
            padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10, top: 15, bottom: 15),
            child: TextWidget(
              text: "Go To Home",
              color: Colors.white,
              size: text_font_medium15_size,
              weight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          _imagepending(),
          SizedBox(
            height: 20,
          ),
          _transactionstatustext(),
          SizedBox(
            height: 15,
          ),
          _pointconversiontext(),
          SizedBox(
            height: 15,
          ),
          _points(),
          SizedBox(
            height: 15,
          ),
          _viewingems(),
          SizedBox(
            height: 15,
          ),
          _convertedfrom(),
          SizedBox(
            height: 20,
          ),
          _gemspointsleft(),
          SizedBox(
            height: 35,
          ),
          _gotopoints(),
          SizedBox(
            height: 20,
          ),
          _gotohome(),
          SizedBox(
            height: 80,
          ),
        ],
      ),
    );
  }

  Widget _tabbar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      // color: black_color,
      child: BottomBar(
        initialIndex: 2,
        tabvalue: "myaccount",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(gradient: gradient_theme_color),
        child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (canPop, result) async {
              return Future.value(false);
            },
            child: SafeArea(
                bottom: true,
                top: false,
                child: Scaffold(
                  extendBody: true,
                  backgroundColor: white_color,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(10.0),
                    child: Container(
                        decoration:
                            BoxDecoration(gradient: gradient_theme_color),
                        alignment: Alignment.bottomLeft,
                        padding: EdgeInsets.only(top: 25, bottom: 10),
                        // height: 10,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              // GestureDetector(
                              //   onTap: () {
                              //     Navigator.pop(context);
                              //     Navigator.pop(context);
                              //   },
                              //   child: Container(
                              //     margin: EdgeInsets.only(left: 10),
                              //     height: 40,
                              //     width: 40,
                              //     decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(8),
                              //       color: Colors.blue[400],
                              //     ),
                              //     child: Padding(
                              //       padding: const EdgeInsets.only(left: 10.0),
                              //       child: Container(
                              //         child: Icon(
                              //           Icons.arrow_back_ios,
                              //           size: text_font_large27_size,
                              //           color: white_text_color,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        )),
                  ),
                  body: _isLoading == true
                      ? Center(
                          child: SpinKitCircle(
                          color: btn_bg_color,
                        ))
                      : _body(),
                  bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
                ))));
  }
}
