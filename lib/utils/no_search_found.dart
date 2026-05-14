import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';

import '../common_widget/bottombar.dart';

class NoSearchResult extends StatefulWidget {
  const NoSearchResult({Key? key}) : super(key: key);

  @override
  State<NoSearchResult> createState() => _NoSearchResultState();
}

class _NoSearchResultState extends State<NoSearchResult> {
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
    Widget _body() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(ImageConstants.noResultFound),
            SizedBox(
              height: 30,
            ),
            TextWidget(
              text: "Sorry! No result found",
              size: text_font_large20_size,
              weight: FontWeight.bold,
              alignment: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            TextWidget(
              text:"Please try another way as we were unable to find what you were looking for.",
                  // "We're sorry what you were looking for.\n Please try another way",
              size: text_font_medium16_size,
              alignment: TextAlign.center,
              color: black_color,
            ),
            SizedBox(
              height: 50,
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
              width: MediaQuery.of(context).size.width / 1.2,
              height: 50,
              child: TextButton(
                child: TextWidget(
                  text: "Try Again",
                  color: white_text_color,
                  size: 20,
                ),
                onPressed: () async {
                  Internetconnectivity().isConnected().then((result) {
                    if (result) {
                      Navigator.pop(context, "1");
                    }
                  });
                },
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      );
    }

    return Container(
        decoration: BoxDecoration(gradient: gradient_theme_color),
        child: SafeArea(
            bottom: true,
            top: false,
            child: Scaffold(
               extendBody: true,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(90.0),
                child: GradientAppBar(
                  title: "Search",
                  color: white_text_color,
                  size: text_font_medium18_size,
                  weight: FontWeight.w500,
                  centerTitle: true,
                  height: 90,
                ),
              ),
              body: _body(),
              bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
            )));
  }
}
