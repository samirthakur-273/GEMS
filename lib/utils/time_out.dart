import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/connectivity.dart';


class TimeOut extends StatefulWidget {
  final String? noConnection;
  final String? type;

  const TimeOut({Key? key, this.noConnection, this.type}) : super(key: key);

  @override
  _TimeOutState createState() => _TimeOutState();
}

class _TimeOutState extends State<TimeOut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
      preferredSize: Size.fromHeight(100.0),
      child: GradientAppBar(
    title: "",
    color: white_text_color,
    size: 18,
    weight: FontWeight.w500,
    centerTitle: true,
    height: 100,
      ),
    ),
      body: retrydata(),
    );
  }

  Widget retrydata() {
    return Container(
      child: Column(
        children: <Widget>[
          Column(
          children: <Widget>[
            SizedBox(height: 80,),
            Container(
                height: 180,
                margin: EdgeInsets.symmetric(horizontal: 60),
                width: MediaQuery.of(context).size.width,
                child: SvgPicture.asset(
                    'images/common/serviceUnavl.svg',
                  ),
                ),
            SizedBox(
              height: 30,
            ),
            TextWidget(
            text: "Service Unavailable",
            size: text_font_large20_size,
            weight: FontWeight.w600,
            alignment: TextAlign.center,
          ),
          SizedBox(height: 20,),
          TextWidget(
            text:
                "Oops! server not respond in time",
            size: text_font_medium16_size,
            alignment: TextAlign.center,
            color: black_color,
            weight: FontWeight.w400,
          ),
          SizedBox(
            height: 50,
          ),Container(
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
        
          ]
        
    )]));
  }
}
