import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';

class FlightGradientAppBarWidget extends StatelessWidget {
  final AsyncCallback? onLeftTap;

  final AsyncCallback? onRightTap;
  final String? title;
  final double? size;
  final Color? color;
  final double? height;
  final FontWeight? weight;

  const FlightGradientAppBarWidget(
      {Key? key,
      this.onLeftTap,
      this.onRightTap,
      this.title,
      this.color,
      this.size,
      this.height,
      this.weight})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: AppBar(
        title: TextWidget(
          text: this.title?.toUpperCase(),
          size: this.size,
          color: const Color(0xffffffff),
          weight: FontWeight.w500,
        ),
        leading: Container(
          margin: EdgeInsets.only(left: 5),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.all(10),
                  // padding: EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                      color: appbar_color,
                      borderRadius: BorderRadius.circular(8)),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        flexibleSpace: Image.asset(
          ImageConstants.appbarbgimage,
          fit: BoxFit.fill,
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
    );
  }
}
