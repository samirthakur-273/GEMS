
import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/Gradient_button.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/appbar_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';

class ServiceUnavailable extends StatelessWidget {
  final Function? onRetry;
  final bool?
      replaceRoute; //if true it will pop screen through which this was routed too

  const ServiceUnavailable(
      {Key? key, required this.onRetry, this.replaceRoute = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget retrydata() {
      return Center(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 2,
                // height: MediaQuery.of(context).size.height/3,
                child: Image.asset(
                 ImageConstants.timeout,
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              TextWidget(
                text: "Your request has timed out",
                weight: FontWeight.bold,
                size: 22,
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 60,
                // decoration: BoxDecoration(color: deepdark_orange_color),
                child: GradientButtonWidget(
                  child: Text(
                    "Try Again",
                    style: TextStyle(
                        color: Color(0xffffffff),
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () async {
                    Internetconnectivity().isConnected().then((result) {
                      if (result) {
                        Navigator.pop(context);
                        onRetry!();
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            backgroundColor: grey200_color,
            appBar: PreferredSize(
              child: StatusBarColor(),
              preferredSize: Size.fromHeight(0.0),
            ),
            body: retrydata(),
            // bottomNavigationBar: _tabbar(),
          )),
    );
  }

  // Widget build(BuildContext context) {
  //   return WillPopScope(
  //     onWillPop: () async {
  //       if (replaceRoute ?? false) {
  //         Future.delayed(
  //             Duration(milliseconds: 10), () => Navigator.pop(context));
  //       }
  //       return true;
  //     },
  //     child: Scaffold(
  //         appBar: AppBar(
  //           iconTheme: IconThemeData(
  //             color: Colors.black,
  //           ),
  //           backgroundColor: Colors.white,
  //           title: TextWidget(
  //             text: "Oops!",
  //             size: text_size_18,
  //             weight: FontWeight.w800,
  //             color: black_color,
  //           ),
  //           centerTitle: true,
  //         ),
  //         body: Column(children: [
  //           Expanded(
  //             child: Center(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: <Widget>[
  //                   TextWidget(
  //                     text: 'Service Unavailable',
  //                     weight: FontWeight.w600,
  //                   ),
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   TextWidget(
  //                     text: 'Oops! server did not respond in time',
  //                   ),
  //                   SizedBox(height: 40),
  //                   FlatButton(
  //                     color: theme_color,
  //                     child: TextWidget(
  //                       text: 'RETRY',
  //                       color: Colors.white,
  //                     ),
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                       onRetry();
  //                     },
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ])),
  //   );
  // }
}
