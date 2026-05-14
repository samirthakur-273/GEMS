import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/constants_files/styles_constants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';

class RootErrorPage extends StatelessWidget {
  const RootErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isAndroid = Platform.isAndroid;
    final titleText = isAndroid
        ? GemsGLobals.rootedDeviceText
        : GemsGLobals.jailBrokenDeviceText;
    final messageText = isAndroid
        ? GemsGLobals.rootedDeviceMsg
        : GemsGLobals.jailBrokendeviceMsg;
    return Scaffold(
      backgroundColor: white_color,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: SvgPicture.asset(
              ImageConstants.rootErrorimage,
              height: 100,
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              titleText,
              textAlign: TextAlign.center,
              style: AppTheme.dmDisplayLightYellow28Regular,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: GemsGLobals.warningMsg,
                style:
                    AppTheme.manropeBlack14Normal.copyWith(color: grey_color),
                children: [
                  TextSpan(
                      text: messageText,
                      style: AppTheme.manropeBlack14Normal
                          .copyWith(color: grey_color)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 60.0,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: gradient_theme_color,
                ),
                child: MaterialButton(
                  onPressed: () {
                    exit(0);
                  },
                  child: const Text(
                    GemsGLobals.exitAppText,
                    style: AppTheme.interTextSize18Style,
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
