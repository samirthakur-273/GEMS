import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';

class NoInternetDetection extends StatelessWidget {
  ConnectivityResult? oldRes;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextWidget(
          text:
              "R & B requires an Internet Connection to view the latest styles"),
      actions: [
        Center(
          child: MaterialButton(
            color: theme_color,
            onPressed: () async {
              oldRes = await (Connectivity().checkConnectivity());
              if (oldRes == ConnectivityResult.mobile) {
                Navigator.pop(context, true);
              } else if (oldRes == ConnectivityResult.wifi) {
                Navigator.pop(context, true);
              } else if (oldRes == ConnectivityResult.none) {
                Fluttertoast.showToast(
                    backgroundColor: Color(0xAA000000),
                    textColor: white_text_color,
                    msg: "Check your internet connection.",
                    gravity: ToastGravity.BOTTOM,
                    toastLength: Toast.LENGTH_LONG);
              }
            },
            child: TextWidget(text: 'Retry'),
          ),
        )
      ],
    );
  }
}
