/*
Auther Name: Jyoti Gite
Discription : This is the  flight booking fail Page
Date: June 3,2021
*/

import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/Gradient_button.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';

import '../../utils/constants_files/text_constants.dart';

class FlightBookingFail extends StatefulWidget {
  final String type;
  final String brfNo;
  FlightBookingFail({Key? key, required this.type, required this.brfNo})
      : super(key: key);
  @override
  _FlightBookingFailState createState() => _FlightBookingFailState();
}

class _FlightBookingFailState extends State<FlightBookingFail> {
  @override
  Widget build(BuildContext context) {
    Widget _body() {
      return PopScope(
        canPop: false,
        onPopInvoked: (canPop) async {
          Future.value(false);
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "images/flight/Mobile Failed Vector_00000.gif",
                height: 190,
              ),
              SizedBox(
                height: 10,
              ),
              TextWidget(
                text: widget.type == AppTexts.bookingText
                    ? AppTexts.bookingFailed(widget.brfNo ?? "")
                    : AppTexts.paymentFailed(widget.brfNo ?? ""),
                weight: FontWeight.w500,
                size: text_font_medium15_size,
                alignment: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              TextWidget(
                  text:
                      AppTexts.bookingFailedMessage,
                  weight: FontWeight.w500,
                  size: text_font_medium15_size,
                  alignment: TextAlign.center),
              Wrap(
                children: [
                  TextWidget(
                      text: AppTexts.bookingFailedSupportText,
                      weight: FontWeight.w500,
                      size: text_font_medium15_size,
                      alignment: TextAlign.center),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: AppTexts.supportEmailText,
                            style: TextStyle(
                              color: aqua_blue,
                              fontWeight: FontWeight.bold,
                              fontSize: text_font_medium15_size,
                            ),
                          ),
                          TextSpan(
                            text: AppTexts.bookingFailedSupportMessage,
                            style: TextStyle(
                              color: black_text_color,
                              fontWeight: FontWeight.w500,
                              fontSize: text_font_medium15_size,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextWidget(
                      text:
                          AppTexts.bookingFailedSupportContact,
                      weight: FontWeight.w500,
                      size: text_font_medium15_size,
                      alignment: TextAlign.center),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget _appbar() {
      return Container(
        decoration: BoxDecoration(gradient: gradient_theme_color),
        height: 90,
        padding: EdgeInsets.only(top: 45, left: 0),
        alignment: Alignment.center,
        child: TextWidget(
          text: "Your ${widget.type /* ?? "Booking" */} has failed.",
          size: 20,
          weight: FontWeight.w500,
          color: white_text_color,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
              appBar: PreferredSize(
                  child: _appbar(), preferredSize: Size.fromHeight(80)),
              body: _body(),
              bottomNavigationBar: Container(
                height: 50,
                margin:
                    EdgeInsets.only(top: 15, bottom: 15, left: 25, right: 25),
                child: GradientButtonWidget(
                  gradientcolor: gradient_theme_color,
                  onTap: () {
                    Navigator.of(context).pushNamed('/tabbarpage');
                  },
                  child: TextWidget(
                    text: AppTexts.goToHomeText,
                    size: text_font_medium17_size,
                    color: white_text_color,
                    weight: FontWeight.w500,
                  ),
                ),
              ))),
    );
  }
}
