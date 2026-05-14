
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';

class NoResultFound extends StatefulWidget {
  final String details;

  @override
  _NoResultFoundState createState() => _NoResultFoundState();

  NoResultFound(this.details);
}

class _NoResultFoundState extends State<NoResultFound> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: SafeArea(
        top: false,
        bottom: false,
        child: PopScope(
          canPop: false,
          onPopInvoked: (canPop) async {
            Navigator.of(context).pop();
            return Future.value(true);
          },
          child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: GradientAppBar(
                  title: "Search Results",
                  color: white_text_color,
                  size: 17,
                  weight: FontWeight.w600,
                  centerTitle: true,
                  height: 85,
                ),
              ),
              body: Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 20),
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
          SizedBox(height: 20,),
          TextWidget(
            text: "Please try another way as we were unable to find what you were looking for.",
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
          SizedBox(height: 50,)
        ],
      ),
    // );SizedBox(
    //                   height: 5,
    //                 ),
    //               ],
    //             ),
              )),
        ),
      ),
    );
  }
}
