import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';

class ButtonWidgetPage extends StatelessWidget {
  final AsyncCallback? onTap;
  final String? buttonText1;
  final String? buttonText2;
  final String? buttonText3;
  final String? buttonText4;
  final double? width;
  final double? height;
  final textColor;
  final color;
  final sizeText1;
  final sizeText2;
  final sizeText3;
  final sizeText4;
  final FontWeight? weight;

  const ButtonWidgetPage(
      {Key? key,
      this.onTap,
      this.buttonText1,
      this.buttonText2,
      this.buttonText4,
      this.buttonText3,
      this.height,
      this.width,
      this.color,
      this.textColor,
      this.sizeText1,
      this.sizeText2,
      this.sizeText3,
      this.sizeText4,
      this.weight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: onTap,
      child: Container(
//        height: 80,
        color: this.color,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: Container(
                  color: const Color(0xff00A0DD),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: TextWidget(
                              textAlign: TextAlign.center,
                              text: this.buttonText4,
                              color: this.textColor,
                              size: this.sizeText4,
                             // weight: this.weight,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            alignment: Alignment.center,
                            child: TextWidget(
                              textAlign: TextAlign.center,
                              text: this.buttonText2,
                              color: this.textColor,
                              size: this.sizeText3,
                              weight: this.weight,
                            ),
                          ),
                          Container(
                            child: TextWidget(
                              size: 12,
                              text: this.buttonText1,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
            ),
            // new SizedBox(
            //   width: 5,
            // ),
            Container(
              //  margin: EdgeInsets.only(left: 5),
              height: 100,
              width: 1,
              color: Colors.grey[600],
            ),
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  color: Colors.orangeAccent[400],
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
//                      color: Color(0xff3995ca),
//                        border: Border.all(width: 1, color: Colors.deepOrange),
//                        borderRadius: BorderRadius.circular(10)
                        ),
                    child: TextWidget(
                      text: this.buttonText3,
                      color: this.textColor,
                      size: this.sizeText3,
                      weight: this.weight,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ButtonWidgetFlightPage extends StatelessWidget {
  final AsyncCallback? onTap;
  final String? buttonText1;
  final String? buttonText2;
  final String? buttonText3;
  final String? buttonText4;
  final String? buttonText5;
  final String? buttonText6;
  final double? width;
  final double? height;
  final textColor;
  final color;
  final sizeText1;
  final sizeText2;
  final sizeText3;
  final sizeText4;
  final sizeText5;
  final sizeText6;
  final FontWeight? weight;

  const ButtonWidgetFlightPage(
      {Key? key,
      this.onTap,
      this.buttonText1,
      this.buttonText2,
      this.buttonText3,
      this.height,
      this.width,
      this.color,
      this.textColor,
      this.sizeText1,
      this.sizeText2,
      this.sizeText3,
      this.weight,
      this.buttonText4,
      this.sizeText4,
      this.sizeText5,
      this.sizeText6,
      this.buttonText5,
      this.buttonText6})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    return GestureDetector(
      // onTap: onTap,
      child: Container(
        height: this.height,
        color: this.color,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
//            Expanded(
//              child: Container(
//                  color: appbar_color,
//                  height: 60,
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      Container(
//                        margin: EdgeInsets.only(left: 10, bottom: 2),
//                        child: TextWidget(
//                          text: this.buttonText1,
//                          color: this.textColor,
//                          size: this.sizeText1,
//                          weight: this.weight,
//                        ),
//                      ),
//                      Container(
//                        margin: EdgeInsets.only(bottom: 2),
//                        child: TextWidget(
//                          text: this.buttonText2,
//                          color: this.textColor,
//                          size: this.sizeText2,
//                          weight: this.weight,
//                        ),
//                      ),
//
//                      Container(
//                        alignment: Alignment.centerRight,
//                        margin: EdgeInsets.only(right: 5),
//                        child: TextWidget(
//                          text: this.buttonText4,
//                          color: this.textColor,
//                          size: this.sizeText4,
//                          weight: this.weight,
//                        ),
//
//                      ),
//                    ],
//                  )),
//            ),
//            // new SizedBox(
//            //   width: 5,
//            // ),
//            Container(
//              //  margin: EdgeInsets.only(left: 5),
////              height: 50,
//              width: 1,
//              color: Colors.grey[600],
//            ),
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                    height: 58,
                    color: const Color(0xff00A0DD),
                    child: Container(
                      alignment: Alignment.center,
                      child: TextWidget(
                        text: this.buttonText3,
                        color: this.textColor,
                        size: this.sizeText3,
                        weight: this.weight,
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
