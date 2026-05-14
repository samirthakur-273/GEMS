import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';

class NoResultFoundNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
