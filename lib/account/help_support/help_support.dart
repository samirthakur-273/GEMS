/* Author : Sanjana Shetty
 Date created : 26-April-2022
 Discription : Help and Support Design*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/constants_files/text_constants.dart';
import 'package:gems_revamp/utils/dialogAlert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widget/bottombar.dart';
import '../../common_widget/font_size.dart';

class HelpSupport extends StatefulWidget {
  @override
  _HelpSupportState createState() => _HelpSupportState();
}

class _HelpSupportState extends State<HelpSupport> {
  Widget _image() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Container(
            child: Image(
          image: AssetImage(ImageConstants.helpandsupport),
          fit: BoxFit.fill,
          height: 250,
        )),
      ),
    );
  }

  Widget _customercare() {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: boxgrey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
                text: "Customer Care",
                weight: FontWeight.w500,
                size: text_font_large20_size),
            SizedBox(height: 5),
            // TextWidget(
            //   text: "Email us at",
            //   color: greyshade,
            // ),
            // SizedBox(height: 5),
            // TextWidget(text: "support@gemsrewards.com"),
            // SizedBox(height: 10),
            TextWidget(
              text: "Timings",
              color: greyshade,
            ),
            SizedBox(height: 5),
            TextWidget(text: "10 am to 10 pm (Sunday - Friday)"),
            SizedBox(height: 5),
            // TextWidget(
            //   text: "Whats app",
            //   color: greyshade,
            // ),
            // SizedBox(height: 5),
            // TextWidget(text: "+971504350673"),
          ],
        ));
  }

  void _gmailurl(String toMailId, String subject, String body) async {
    subject = subject.replaceAll(" ", "%20");
    subject = subject.replaceAll("&", "%26");
    body = body.replaceAll(" ", "%20");
    body = body.replaceAll("&", "%26");
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      } else {
      throw 'Could not launch $url';
    }
  }

  Widget _proceed() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  DialogAlert.whatsappcalldrwaerforhelpsupport(context);
                  // var title = _offerdata?.offers![0].offerTitle ?? '';
                  // whatsappBottomModalold(
                  //     context,
                  //     "${_offerdata!.outletName!.replaceAll(new RegExp('&'), "%26")}",
                  //     "${title.replaceAll(new RegExp('&'), "%26")}");
                },
                child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                        color: const Color(0xfff2f2f2),
                        borderRadius: BorderRadius.circular(14)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: white_color,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SvgPicture.asset(ImageConstants.whatsapp,
                                    height: 20),
                              )),
                          new SizedBox(
                            width: 10,
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: TextWidget(
                                text: "Whatsapp",
                                weight: FontWeight.w500,
                                size: text_font_medium15_size,
                              )),
                        ],
                      ),
                    )),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  String subject1 =
                      Uri.encodeComponent('Facing some issues in GEMS Rewards');
                  String body = Uri.encodeComponent(
                      'Hello Team,\n I need your assistance in GEMS Rewards.');
                  String toMailId = 'support@gemsrewards.com';
                  _gmailurl(toMailId, subject1, body);
                },
                child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                        color: common_gray_color,
                        borderRadius: BorderRadius.circular(14)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: white_color,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SvgPicture.asset(ImageConstants.email,
                                    height: 20),
                              )),
                          new SizedBox(
                            width: 10,
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: TextWidget(
                                text: "Support Mail",
                                weight: FontWeight.w500,
                                size: text_font_medium15_size,
                              )),
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Widget _proceed() {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 0.0, right: 0, top: 5),
  //     child: Container(
  //       width: 180,
  //       child: ElevatedButton(
  //         onPressed: () async {
  //           DialogAlert.whatsappcalldrwaer(context);
  //         },
  //         style: ButtonStyle(
  //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //             RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(14.0),
  //             ),
  //           ),
  //           textStyle:
  //               MaterialStateProperty.all(TextStyle(color: Color(0xffffffff))),
  //           backgroundColor: MaterialStateProperty.all(button_bgpdf_color),
  //           minimumSize: MaterialStateProperty.all(Size(0, 0)),
  //           padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.only(
  //               left: 20.0, right: 20, top: 10, bottom: 10),
  //           child: TextWidget(
  //             text: "Proceed",
  //             color: Colors.white,
  //             size: text_font_medium18_size,
  //             weight: FontWeight.w500,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _image(),
          _customercare(),
          _proceed(),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _tabbar() {
    return Container(
      // height: 80,
      width: MediaQuery.of(context).size.width,
      // color: black_color,
      child: BottomBar(
        initialIndex: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: true,
        top: false,
        child: Scaffold(
          extendBody: true,
          backgroundColor: white_color,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(110.0),
              child: Container(
                  decoration: BoxDecoration(gradient: gradient_theme_color),
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(
                    top: Platform.isIOS ? 35 : 25,
                  ),
                  height: Platform.isIOS ? 100 : 90,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).maybePop();
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
                                  size: text_font_large20_size,
                                  color: white_text_color,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 30),
                            child: TextWidget(
                              text: AppTexts.helpAndSupportText,
                              size: text_font_medium18_size,
                              weight: FontWeight.w500,
                              color: white_text_color,
                            ),
                          ),
                        )
                      ],
                    ),
                  ))),
          body: _body(),
          bottomNavigationBar:  SizedBox(height: 95, child: _tabbar()),
        ));
  }
}
