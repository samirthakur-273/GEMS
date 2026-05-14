import 'package:flutter/material.dart';

import '../common_widget/colors_widget.dart';
import '../common_widget/text_widget.dart';
import 'connectivity.dart';
import 'no_internet.dart';

class InternetConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*return Container(
      child: AlertDialog(
        content: TextWidget(
            text:
                "R & B requires an Internet Connection to view the latest styles"),
        actions: [
          Center(
            child: MaterialButton(
              color: theme_color,
              onPressed: () async {
                Navigator.pop(context, "1");
              },
              child: TextWidget(text: 'Retry'),
            ),
          )
        ],
      ),
    );*/
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          title: TextWidget(
            text: "No Internet",
            size: 18,
            weight: FontWeight.w800,
            color: black_color,
          ),
          centerTitle: true,
        ),
        body: Column(children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: 100,
                      child: Image(
                          color: theme_color,
                          image: AssetImage(
                            'assets/shop_assets/nointernet.png',
                          ))),
                  SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text: "Can't connect",
                    weight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text: 'Please check your internet connection',
                  ),
                  SizedBox(height: 40),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(theme_color),
                    ),
                    // color: theme_color,
                    child: TextWidget(
                      text: 'RETRY',
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  )
                ],
              ),
            ),
          ),
        ]));
  }
}

internetCall(BuildContext context, Function onSuccess) {
  Internetconnectivity().isConnected().then((isConnected) async {
    if (isConnected == true) {
      onSuccess();
    } else if (isConnected == false) {
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return NoInternet();
          }).then((value) {
        if (value != null) {
          internetCall(context, onSuccess);
        }
      });
      // setState(() {
      //   isloadaing = false;
      // });
    }
  });
}

// void _showAlert(BuildContext context) {

// }
