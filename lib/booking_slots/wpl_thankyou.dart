import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/offer_module/offer_webview.dart';
import 'package:intl/intl.dart';

import '../common_widget/font_size.dart';
import '../common_widget/tabbarpage.dart';
import '../utils/constants_files/imageconstants.dart';
import '../utils/gemsGlobals.dart';

class ThankYouWpl extends StatefulWidget {
  final wpldate;
  final email;
  const ThankYouWpl({Key? key, this.wpldate, this.email}) : super(key: key);

  @override
  State<ThankYouWpl> createState() => _ThankYouWplState();
}

class _ThankYouWplState extends State<ThankYouWpl> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (canPop) async {
        Navigator.pop(context);
        Navigator.pop(context);

      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: Container(
              decoration: BoxDecoration(gradient: gradient_theme_color),
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(
                top: 25,
              ),
              height: Platform.isIOS ? 100 : 90,
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(right: 30),
                          child: TextWidget(
                            text: "GEMS Rewards",
                            size: text_font_medium18_size,
                            weight: FontWeight.w500,
                            color: white_text_color,
                          )),
                    )
                  ],
                ),
              )),
        ),
        body: SafeArea(
            child: Container(

          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20),
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: Image.asset(
                  ImageConstants.wplThankyou,
                   width: MediaQuery.of(context).size.width / 1.1,
                    height: 180,
                    fit: BoxFit.fill,
                  // color: appbar_color,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(text: "Dear"),
                  TextWidget(
                    text:
                        " ${toBeginningOfSentenceCase('${GemsGLobals.userFirstName}')}",
                    weight: FontWeight.bold,
                  ),
                  TextWidget(text: ", Thank you for taking "),
                ],
              ),
              TextWidget(text: "advantage of this great offer."),
              SizedBox(
                height: 30,
              ),
              TextWidget(
                  text:
                      "Your booking is confirmed for ${widget.wpldate.toString()}",alignment: TextAlign.center,),
              SizedBox(
                height: 30,
              ),
              TextWidget(
                alignment: TextAlign.center,
                text:
                    "Your ${GemsGLobals.userType == "parent" ? "2 tickets (1 Adult + 1 child)" : "ticket"} will be emailed to your registered email address ${widget.email} two days before the event",
              ),
              
              SizedBox(
                height: 30,
              ),
              TextWidget(
                alignment: TextAlign.center,
                  text:
                      "Make the evening more exciting with friends and family."),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(text: "Click on the link below to avail "),
                  TextWidget(
                    text: " FLAT 15% ",
                    weight: FontWeight.bold,
                  ),
                ],
              ),
              Center(
                  child: TextWidget(
                    alignment: TextAlign.center,
                      text:
                          " discount exclusively for your friends and family!")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(text: "Use code"),
                  TextWidget(
                    text: " GEMS15",
                    weight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextWidget(text: "Link: "),
                  GestureDetector(
                    onTap: (){
                       Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForYouWeb(
                                appbarname: "Gems Rewards",
                                weburl:
                                    "https://wplworld.com/",
                              )),
                    );
                    },
                    child: Text(
                      "Buy Tickets",
                      style: TextStyle(
                          fontSize: text_font_medium15_size,
                          color: blue_color,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextWidget(
                text: "Hurry! Don't miss this offer.",
                weight: FontWeight.bold,
                alignment: TextAlign.center,
              ),
              SizedBox(
                height: 40,
              ),
              _returnToHome(),
            ],
          ),
        )),
      ),
    );
  }
  Widget _returnToHome() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TabsScreen(
                      initialIndex: 0,
                    )));
          },
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            textStyle:
            WidgetStateProperty.all(TextStyle(color: Color(0xffffffff))),
            elevation: WidgetStateProperty.all(0),
            backgroundColor: WidgetStateProperty.all(button_bgpdf_color),
            minimumSize: WidgetStateProperty.all(Size(0, 0)),
            padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15, top: 13, bottom: 13),
            child: TextWidget(
              text: "Go To Home",
              color: white_color,
              size: text_font_medium18_size,
              weight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
