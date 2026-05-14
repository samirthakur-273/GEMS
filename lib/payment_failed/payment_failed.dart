import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';

class PaymentFailed extends StatefulWidget {
  const PaymentFailed({ Key? key }) : super(key: key);

  @override
  State<PaymentFailed> createState() => _PaymentFailedState();
}

class _PaymentFailedState extends State<PaymentFailed> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
          canPop: false,
          onPopInvokedWithResult: (canPop, result) async {
             Future.value(false);
      },
      child: Scaffold(
        backgroundColor: white_text_color,
        body:  Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 40,),
            Image.asset(
                  ImageConstants.failedPayment,
                  height: 300,
                  width: 300,
                ),
            SizedBox(
              height: 30,
            ),
            TextWidget(
              text: "Your payment has failed",
              size: text_font_large20_size,
              weight: FontWeight.bold,
              alignment: TextAlign.center,
            ),
            SizedBox(height: 20,),
            TextWidget(
              text:
                  "You can retry the payment\nbelow to continue this",
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
              width: MediaQuery.of(context).size.width / 2,
              height: 50,
              child: TextButton(
                child: TextWidget(
                  text: "Try Again",
                  color: white_text_color,
                  size: 18,
                ),
                onPressed: () async {
                     Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TabsScreen(
                            initialIndex: 0,
                          )));
                },
              ),
            ),
            SizedBox(height: 50,)
          ],
        ),
      ),
        
      ),
    );
  }
}