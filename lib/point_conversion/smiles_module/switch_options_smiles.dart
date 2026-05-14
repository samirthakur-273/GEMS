/* Author : Sanjana Shetty
 Date created : 27-April-2022
 Discription : Smiles Switch Option Page*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/point_conversion/smiles_module/gemstosmiles.dart';
import 'package:gems_revamp/point_conversion/smiles_module/smilestogems.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widget/bottombar.dart';
import '../../common_widget/colors_widget.dart';
import '../../common_widget/font_size.dart';
import '../../common_widget/text_widget.dart';
import '../../utils/constants_files/imageconstants.dart';
import '../../utils/constants_files/text_constants.dart';

class SmilesSwitchOptions extends StatefulWidget {
  final routesFrom;

  const SmilesSwitchOptions({Key? key, this.routesFrom}) : super(key: key);
  @override
  _SmilesSwitchOptionsState createState() => _SmilesSwitchOptionsState();
}

class _SmilesSwitchOptionsState extends State<SmilesSwitchOptions> {
  bool gemsorsmiles = true;

  void whatsappBottomModalold(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            bottom: true,
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 45,
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.only(bottom: 3, top: 15),
                        child: Center(
                          child: SvgPicture.asset(
                            ImageConstants.whatsapp,
                            height: 40,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.only(
                          top: 10,
                          right: 5,
                          bottom: 0,
                        ),
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          child: SvgPicture.asset(
                            ImageConstants.cross,
                            height: 35,
                            width: 35,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: TextWidget(
                        text: AppTexts.connectingText,
                        textAlign: TextAlign.center,
                        size: appbar_text_size,
                        weight: FontWeight.bold),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 5),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextWidget(
                        text: AppTexts.connectingMessageText,
                        textAlign: TextAlign.center,
                        size: text_font_medium15_size,
                        color: Colors.black),
                  ),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: aqua_blue,
                      ),
                      child: Center(
                        child: TextWidget(
                            text:AppTexts.proceedText,
                            textAlign: TextAlign.center,
                            color: white_color,
                            size: text_font_large20_size),
                      ),
                    ),
                    onTap: () {
                      whatsappcallnew(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  static void whatsappcallnew(BuildContext context) async {
    var whatsappUrl;
    Navigator.of(context).pop();
    var whatsappstore = Platform.isAndroid
        ? "https://play.google.com/store/apps/details?id=com.whatsapp&hl=en_IN"
        : "https://apps.apple.com/in/app/whatsapp-messenger/id310633997";

    whatsappUrl =
        "whatsapp://send?phone=+971504350673&text=Hello Team, I%20need%20your%20assistance%20in%20GEMS%20Rewards.";

    whatsappUrl = whatsappUrl.replaceAll(" ", "%20");

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      await launchUrl(Uri.parse(whatsappstore));
    }
  }

  Widget _needHelp() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: GestureDetector(
        onTap: () {
          setState(() {
            whatsappBottomModalold(context);
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 65,
                decoration: BoxDecoration(
                    color: common_gray_color,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: white_color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(ImageConstants.whatsapp,
                                height: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 5),
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: TextWidget(
                              text: "Need Help?",
                              weight: FontWeight.w500,
                              size: text_font_medium_x_size,
                            )),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _imagesection() {
      return Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              child: Image(
                image: AssetImage(gemsorsmiles
                    ? ImageConstants.gemstosmiles
                    : ImageConstants.smilestogems),
                width: MediaQuery.of(context).size.width / 1.2,
                height: 100,
              ),
            ),
          ]),
        ),
      );
    }

    Widget _convertimage() {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      gemsorsmiles = !gemsorsmiles;
                    });
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    textStyle: WidgetStateProperty.all(
                        TextStyle(color: white_color)),
                    backgroundColor: WidgetStateProperty.all(darkgreen),
                    minimumSize: WidgetStateProperty.all(Size(0, 0)),
                    padding: WidgetStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15, top: 15, bottom: 15),
                    child: SvgPicture.asset(
                      ImageConstants.convert,
                      color: white_color,
                      width: 50,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget smilesText() {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Text(
          GemsGLobals.smilesPromotionText,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: text_font_medium_x_size,
            color: grey_text,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    Widget termAndCondition() {
      return Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Row(children: [
                TextWidget(
                  text: '*',
                  size: text_font_medium18_size,
                  color: red_color,
                ),
                TextWidget(
                  text: GemsGLobals.termcondition,
                  size: text_font_medium_x_size,
                  color: grey_text,
                  weight: FontWeight.w500,
                ),
              ]),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Html(
                  data: GemsGLobals.smilesPageTermAndCondition,
                ),
              )
            ],
          ));
    }

    Widget _convertText() {
      return Center(
        child: Column(
          children: [
            Container(
              child: TextWidget(
                text: "Convert your points now ",
                weight: FontWeight.w500,
                color: grey_color_pin_text,
                size: text_font_medium15_size,
              ),
            ),
          ],
        ),
      );
    }

    Widget _proceed() {
      return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () async {
              if (gemsorsmiles) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GemsToSmiles()),
                );
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SmilesToGems()));
              }
            },
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              textStyle:
                  WidgetStateProperty.all(TextStyle(color: white_color)),
              backgroundColor: WidgetStateProperty.all(greenboxcolor),
              minimumSize: WidgetStateProperty.all(Size(0, 0)),
              padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, top: 15, bottom: 15),
              child: TextWidget(
                text: "Proceed",
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
            SizedBox(height: 50),
            _imagesection(),
            SizedBox(height: 20),
            _convertText(),
            SizedBox(height: 20),
            _convertimage(),
            SizedBox(height: 100),
            _proceed(),
            SizedBox(height: 45),
            _needHelp(),
            SizedBox(height: 50),
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

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (widget.routesFrom == "grocery") {
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
      child: Container(
          decoration: BoxDecoration(gradient: gradient_theme_color),
          child: SafeArea(
              bottom: true,
              top: false,
              child: Scaffold(
                extendBody: true,
                backgroundColor: white_color,
                appBar: PreferredSize(
                    preferredSize: Size.fromHeight(90.0),
                    child: Container(
                        decoration:
                            BoxDecoration(gradient: gradient_theme_color),
                        alignment: Alignment.bottomLeft,
                        padding: EdgeInsets.only(
                          top: 25,
                        ),
                        height: 90,
                        child: Container(
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  if (widget.routesFrom == "grocery") {
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  }
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
                                        size: 22,
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
                                  child: Image.asset(
                                    ImageConstants.gemsunfilled,
                                    height: 40,
                                    color: white_color,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ))),
                body: _body(),
                bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
              ))),
    );
  }
}
