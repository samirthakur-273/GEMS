/* Author : Ruchita Manve
 Date created : 03-July-2019
 Discription : Common Wideget for Appbar */
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';

class AppBarWidget extends StatelessWidget {
  final AsyncCallback? onLeftTap;

  final AsyncCallback? onRightTap;
  final String? title;
  final double? size;
  final Color? color;
  final FontWeight? weight;

  const AppBarWidget(
      {Key? key,
      this.onLeftTap,
      this.onRightTap,
      this.title,
      this.color,
      this.size,
      this.weight})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: AppBar(
        title: TextWidget(
          text: this.title?.toUpperCase(),
          size: this.size,
          color: const Color(0xffffffff),
          weight: FontWeight.bold,
        ),
        leading: Container(
          margin: EdgeInsets.only(left: 5),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, true);
                },
                child: Container(
                  child: Image.asset(
                    ImageConstants.left_arrow,
                    color: Colors.white,
                    height: 27,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xff00A0DD),
        centerTitle: true,
        elevation: 0.0,
      ),
    );
  }
}

class StatusBarColor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xff00A0DD),
    );
  }
}

class GradientAppBar extends StatelessWidget {
  final AsyncCallback? onLeftTap;

  final AsyncCallback? onRightTap;
  final String? title;
  final double? size;
  final double? height;
  final Color? color;
  final FontWeight? weight;
  final bool? centerTitle;
  final List<Widget>? action;
  final Image? image;
  final String? routeType;

  const GradientAppBar(
      {Key? key,
      this.onLeftTap,
      this.onRightTap,
      this.title,
      this.color,
      this.size,
      this.weight,
      this.centerTitle,
      this.height,
      this.action,
      this.image,
      this.routeType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
          decoration: BoxDecoration(gradient: gradient_theme_color),
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.only(
            top: Platform.isIOS ? 35 : 25,
          ),
          height: height == null
              ? Platform.isIOS
                  ? 100
                  : 90
              : height,
          child: Container(
            child: Row(
              children: <Widget>[
                routeType == "offer_thank_you"
                    ? Container(
                        height: 0,
                      )
                    : GestureDetector(
                        onTap: () {
                          if (routeType == 'fee_redeemption') {
                            Navigator.pop(context, true);
                          } else {
                            Navigator.of(context).maybePop();
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
                    margin: EdgeInsets.only(right: 40),
                    child: image == null
                        ? TextWidget(
                            text: this.title!,
                            size: this.size!,
                            weight: this.weight ?? FontWeight.w500,
                            color: white_text_color,
                          )
                        : image,
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class GradientAppBarWithImage extends StatelessWidget {
  final AsyncCallback? onLeftTap;

  final AsyncCallback? onRightTap;
  final String? title;
  final double? size;
  final double? height;
  final Color? color;
  final FontWeight? weight;
  final bool? centerTitle;
  final List<Widget>? action;

  const GradientAppBarWithImage(
      {Key? key,
      this.onLeftTap,
      this.onRightTap,
      this.title,
      this.color,
      this.size,
      this.weight,
      this.centerTitle,
      this.height,
      this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
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
                          size: 27,
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
                      text: this.title!,
                      size: this.size!,
                      weight: this.weight ?? FontWeight.w500,
                      color: white_text_color,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
