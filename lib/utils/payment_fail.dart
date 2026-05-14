/* Author : Sanjana Shetty
 Date created : 06-May-2022
 Discription : Payment Failed Page*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';

import '../../common_widget/appbar_widget.dart';
import '../../common_widget/font_size.dart';
import '../common_widget/bottombar.dart';
import '../common_widget/tabbarpage.dart';

class PaymentFailed extends StatefulWidget {
  @override
  _PaymentFailedState createState() => _PaymentFailedState();
}

class _PaymentFailedState extends State<PaymentFailed> {
  Widget _image() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Container(
            child: Image(
          image: AssetImage(ImageConstants.payment_fail),
          fit: BoxFit.fill,
          height: 220,
        )),
      ),
    );
  }

  Widget _paymentText() {
    return Center(
      child: Column(
        children: [
          TextWidget(
            text: "Your Payment for this booking ",
            weight: FontWeight.bold,
            size: text_font_medium_x_size,
          ),
          TextWidget(
            text: "has been failed. Please check with your",
            weight: FontWeight.bold,
            size: text_font_medium_x_size,
          ),
          TextWidget(
            text: "service provider!!",
            weight: FontWeight.bold,
            size: text_font_medium_x_size,
          )
        ],
      ),
    );
  }

  Widget _supportText() {
    return Center(
      child: Column(
        children: [
          TextWidget(
            text: "Please do feel free to get in touch with GEMS",
            weight: FontWeight.w500,
          ),
          TextWidget(
            text: " Customer Support at support@gemsrewards.com",
            weight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _downarrow() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Container(
            child: SvgPicture.asset(ImageConstants.bluearrowdown, height: 10)),
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
        margin: const EdgeInsets.only(left: 20, right: 20, top: 60),
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
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

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30),
          _image(),
          SizedBox(height: 10),
          _paymentText(),
          SizedBox(height: 20),
          _supportText(),
          _downarrow(),
          SizedBox(height: 10),
          _gotoHomeButton(),
          SizedBox(height: 30),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(gradient: gradient_theme_color),
        child: SafeArea(
            bottom: true,
            top: false,
            child: Scaffold(
               extendBody: true,
              backgroundColor: white_color,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(110.0),
                child: GradientAppBar(
                  title: "Your payment has failed.",
                  color: white_text_color,
                  size: 18,
                  weight: FontWeight.w500,
                  centerTitle: true,
                  height: 110,
                ),
              ),
              body: _body(),
              bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
            )));
  }
}
