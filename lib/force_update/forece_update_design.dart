import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdate extends StatefulWidget {
  final bool? value;
  const ForceUpdate({Key? key, this.value}) : super(key: key);

  @override
  State<ForceUpdate> createState() => _ForceUpdateState();
}

class _ForceUpdateState extends State<ForceUpdate> {
  bool checkvalueno = false;

  _launchURL(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      }
      else {
      throw 'Could not launch $url';
    }
  }

  String? platform;
  @override
  Widget build(BuildContext context) {
    return PopScope(
          canPop: false,
          onPopInvoked: (canPop) async {
             Future.value(false);
          },
      child: Container(
        decoration: BoxDecoration(gradient: gradient_theme_color),
        child: SafeArea(
          top: true,
          child: Scaffold(
            body: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    ImageConstants.forceUpdateimg,
                    height: 250,
                    width: 250,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextWidget(
                    text: "A new experience awaits!",
                    size: text_font_large20_size,
                    weight: FontWeight.w500,
                    alignment: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextWidget(
                    text:
                        "This exciting update features some minor\n bug fixes and enhancements,\n please continue with the update to\n improve your experience on the app.",
                    size: text_font_medium16_size,
                    alignment: TextAlign.center,
                    color: black_color,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  widget.value == false
                      ? Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: white_color,
                                    border: Border.all(
                                        width: 0.5, color: blue_color)),
                                width: MediaQuery.of(context).size.width / 2.5,
                                height: 50,
                                child: TextButton(
                                  child: TextWidget(
                                    text: "Continue",
                                    color: blue_color,
                                    size: text_font_medium17_size,
                                    weight: FontWeight.w500,
                                  ),
                                  onPressed: () async {
                                    checkvalueno = true;
                                    GemsGLobals.checkvalueno = checkvalueno;

                                    Navigator.of(context).pop(false);
                                  },
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: const LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        bluishgradient,
                                        blue_color,
                                      ],
                                    )),
                                width: MediaQuery.of(context).size.width / 2.5,
                                height: 50,
                                child: TextButton(
                                  child: TextWidget(
                                    text: "Update Now",
                                    color: white_text_color,
                                    size: text_font_medium17_size,
                                    weight: FontWeight.w500,
                                  ),
                                  onPressed: () async {
                                    if (Platform.isAndroid) {
                                      platform = "android";
                                      _launchURL(
                                          "https://play.google.com/store/apps/details?id=com.clubclass.gemsrewards");
                                    } else {
                                      platform = "ios";
                                      _launchURL(
                                          "https://apps.apple.com/ae/app/gems-rewards/id1287373984");
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  bluishgradient,
                                  blue_color,
                                ],
                              )),
                          width: MediaQuery.of(context).size.width / 2,
                          height: 50,
                          child: TextButton(
                            child: TextWidget(
                              text: "Update Now",
                              color: white_text_color,
                              size: text_font_medium17_size,
                              weight: FontWeight.w500,
                            ),
                            onPressed: () async {
                              if (Platform.isAndroid) {
                                platform = "android";
                                _launchURL(
                                    "https://play.google.com/store/apps/details?id=com.clubclass.gemsrewards");
                              } else {
                                platform = "ios";
                                _launchURL(
                                    "https://apps.apple.com/ae/app/gems-rewards/id1287373984");
                              }
                            },
                          ),
                        ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
