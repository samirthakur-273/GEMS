import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/font_size.dart';

import '../common_widget/colors_widget.dart';
import '../common_widget/text_widget.dart';

class MaintanencePage extends StatefulWidget {
  

  @override
  _MaintanencePageState createState() => _MaintanencePageState();
}

class _MaintanencePageState extends State<MaintanencePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: Container(
              decoration: BoxDecoration(gradient: gradient_theme_color),
              // child: AppBar(
                // backgroundColor: transColor,
                // GradientAppBar(
                // title: Text(''),
                //   color: white_text_color,
                //   size: 18,
                //   weight: FontWeight.w500,
                //   centerTitle: true,
                //   height: 100,
              // ),
            ),
          ),
          backgroundColor: white_text_color,
          resizeToAvoidBottomInset: false,
          body: retrydata(),
        ));
  }

  Widget retrydata() {
    return PopScope(
    canPop: false,
    onPopInvokedWithResult: (canPop, result) async {
      return Future.value(false);
    },
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                height: 180,
                margin: EdgeInsets.symmetric(horizontal: 60),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(
                    'images/common/under_maintenance.png',
                  ),
                  fit: BoxFit.fill,
                ))),
            SizedBox(
              height: 30,
            ),
            TextWidget(
              text: "Under Maintenance",
              size: text_font_large20_size,
              weight: FontWeight.w600,
              alignment: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            TextWidget(
              text:
                  "We're currently undergoing maintenance\n This won't take long🙂",
              size: text_font_medium16_size,
              alignment: TextAlign.center,
              color: black_color,
              weight: FontWeight.w400,
            ),
            SizedBox(
              height: 50,
            ),
            // Container(
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(12),
            //       gradient: const LinearGradient(
            //         begin: Alignment.topRight,
            //         end: Alignment.bottomLeft,
            //         colors: [
            //           bluishgradient,
            //           blue_color,
            //         ],
            //       )),
            //   width: MediaQuery.of(context).size.width / 1.2,
            //   height: 50,
            //   child: TextButton(
            //     child: TextWidget(
            //       text: "Try Again",
            //       color: white_text_color,
            //       size: 20,
            //     ),
            //     onPressed: () async {
            //       widget.type == "home"
            //           ? Navigator.pushReplacementNamed(context, "/tabbarpage")
            //           : Navigator.pushReplacement(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => SplashScreen()));
            //     },
            //   ),
            // ),
           
          ],
        ),
      ),
    );
  }
}
