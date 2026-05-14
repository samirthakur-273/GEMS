import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';

class HotelBookingFailPage extends StatefulWidget {
  const HotelBookingFailPage({Key? key}) : super(key: key);

  @override
  State<HotelBookingFailPage> createState() => _HotelBookingFailPageState();
}

class _HotelBookingFailPageState extends State<HotelBookingFailPage> {
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
        margin: const EdgeInsets.only(left: 20, right: 20, top: 60),
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient:gradient_theme_color ),
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
      color: white_text_color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
          ),
          Container(
            height: 250,
            child: Image.asset(
              ImageConstants.htl_failed,
              fit: BoxFit.fill,
            ),
          ),
          Container(
              child: const Center(
                  child: TextWidget(
            text: 'Please try again Something went wrong',
            size: text_font_medium16_size,
            color: black_color,
            weight: FontWeight.w500,
          ))),
          _gotoHomeButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(gradient: gradient_theme_color),
        child: SafeArea(
            bottom: false,
            top: false,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(90.0),
                child: GradientAppBar(
                  title: "Your Booking has failed",
                  color: white_text_color,
                  size: text_font_medium17_size,
                  weight: FontWeight.w400,
                  centerTitle: true,
                  height: 90,
                ),
              ),
              body: _body(),
            )));
  }
}
