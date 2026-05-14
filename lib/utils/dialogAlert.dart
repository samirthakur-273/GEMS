import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/Login_module/login_types/login_types.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:url_launcher/url_launcher.dart';

_launchURL(url) async {
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  } else {
    throw 'Could not launch $url';
  }
}

bool checkvalueno = false;
var noConnection;

String? platform;

class DialogAlert {
  static Future<dynamic> showLoginAlert(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Container(
            margin: EdgeInsets.only(top: 25, left: 15, right: 15),
            height: 120,
            child: Column(
              children: <Widget>[
                Container(
                  child: TextWidget(
                    text: "To continue ahead you need to login.",
                    size: text_font_size_small,
                    weight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                new SizedBox(
                  height: 10,
                ),
                Container(
                  child: TextWidget(
                    text: "Do you want to login?",
                    size: text_font_size_small,
                    weight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 35,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: blue_color,
                            ),
                            borderRadius: BorderRadius.circular(3)),
                        child: new TextButton(
                          child: TextWidget(
                            text: "No",
                            color: blue_color,
                            textAlign: TextAlign.center,
                            size: text_font_size_small,
                            weight: FontWeight.bold,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Container(
                        height: 35,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: blue_color,
                            ),
                            borderRadius: BorderRadius.circular(3)),
                        child: new TextButton(
                          child: TextWidget(
                            text: "Yes",
                            color: blue_color,
                            textAlign: TextAlign.center,
                            size: text_font_size_small,
                            weight: FontWeight.bold,
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginHomePage()));
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          // actions: <Widget>[],
        );
      },
    );
  }

  static void showfnfadvplusMessage(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextWidget(
                    text:
                        "GEMS Rewards Plus is currently not available for Friends & Family, \n we will be launching it soon, watch this space for updates.",
                  ),
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: TextWidget(
                    text: "OK",
                    color: blue_color,
                  ),
                )),
              ],
            )
          ],
          // buttonPadding: EdgeInsets.zero,
          // content: Padding(
          //   padding: const EdgeInsets.only(top: 15.0, right: 25, left: 25),
          //   child: TextWidget(text: "GEMS Rewards Plus is currently not available for Friends & Family, \n we will be launching it soon, watch this space for updates.",),
          // ),
          // actions: [
          // MaterialButton(
          //   child: Center(
          //       child: Padding(
          //     padding: const EdgeInsets.only(bottom: 5.0),
          //     child: TextWidget(
          //       text: "OK",
          //       color: blue_color,
          //     ),
          //   )),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
          // ],
        );
      },
    );
  }

  static void whatsappBottomModalAdvPlusDrawer(BuildContext context, contact) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return IntrinsicHeight(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 45,
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.only(top: 25),
                      child: Center(
                        child: SvgPicture.asset(
                          ImageConstants.whatsapp,
                          height: 45,
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.only(right: 10, bottom: 10),
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        child: SvgPicture.asset(
                          ImageConstants.cross,
                          height: 30,
                          width: 30,
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextWidget(
                      text: "Now Connecting",
                      textAlign: TextAlign.center,
                      size: 25,
                      weight: FontWeight.bold),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 5),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextWidget(
                      text:
                          "We are now connecting you with our WhatsApp support number. Our support hours are from 9 am to 6 pm Sun - Thu. Please add the following	number in your contact list: +$contact",
                      textAlign: TextAlign.center,
                      size: 18,
                      color: Colors.black),
                ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        image: DecorationImage(
                            image: AssetImage("images/gradientbutton.png"),
                            fit: BoxFit.cover)),
                    child: Center(
                      child: TextWidget(
                          text: "PROCEED",
                          textAlign: TextAlign.center,
                          color: Colors.white,
                          size: 20),
                    ),
                  ),
                  onTap: () {
                    // whatsappcall();
                    whatsappcalldrwaerAdvantageplus(context, contact);
                  },
                ),
              ],
            ),
          );
        });
  }

  static void whatsappcalldrwaerAdvantageplus(
      BuildContext context, contact) async {
    var whatsappUrl;
    Navigator.of(context).pop();
    var whatsappstore = Platform.isAndroid
        ? "https://play.google.com/store/apps/details?id=com.whatsapp&hl=en_IN"
        : "https://apps.apple.com/in/app/whatsapp-messenger/id310633997";

    whatsappUrl =
        "whatsapp://send?phone=+$contact&text=Hello,I%20am%20facing%20some%20issues"; //%20kindly%20do%20let%20us%20know%20how%20can%20we%20assist%20you?

    whatsappUrl = whatsappUrl.replaceAll(" ", "%20");

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      await launchUrl(Uri.parse(whatsappstore));
    }
  }

  static Future<void> flightPriceChngDialog(BuildContext context,refresh, bool value,
      int revisedPrice, String paymentTyp, int previousPrice) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return PopScope(
            canPop: false,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Container(
                  margin: EdgeInsets.only(top: 20, left: 15, right: 15),
                  height: 180,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextWidget(
                            text: "Previous Price :",
                            size: text_font_medium16_size,
                            weight: FontWeight.w600,
                          ),
                          TextWidget(
                            text:
                                // paymentTyp == "cash" ?
                                "AED ${gemsPointsFormatter(previousPrice)}",
                            // : "$previousPrice BOUNZ",
                            size: text_font_medium16_size,
                            weight: FontWeight.w600,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextWidget(
                            text: "Revised Price :",
                            size: text_font_medium16_size,
                            weight: FontWeight.w600,
                          ),
                          TextWidget(
                            text: //paymentTyp == "cash"?

                                "AED ${gemsPointsFormatter(revisedPrice)}",
                            // : "$revisedPrice BOUNZ",
                            size: text_font_medium16_size,
                            weight: FontWeight.w600,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextWidget(
                        text:
                            "Do you still wish to continue with your booking?",
                        size: text_font_medium16_size,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                                gradient: gradient_theme_color,
                                borderRadius: BorderRadius.circular(30)),
                            child: MaterialButton(
                                onPressed: () {
                          
                                  Navigator.pop(context, true);
                                  Navigator.pop(context, true);
                                  refresh();
                                },
                                child: TextWidget(
                                  text: "No",
                                  color: white_text_color,
                                  size: text_font_medium14_size,
                                  weight: FontWeight.bold,
                                )),
                          ),
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                                gradient: gradient_theme_color,
                                borderRadius: BorderRadius.circular(30)),
                            child: MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: TextWidget(
                                  text: "Yes",
                                  color: white_text_color,
                                  size: text_font_medium14_size,
                                  weight: FontWeight.bold,
                                )),
                          )
                        ],
                      )
                    ],
                  )),
            ),
            onPopInvokedWithResult: (canPop, res) async {
                             return Future.value(false);
                  },);
      },
    );
  }

  static Future<dynamic> proceedTrnxAlert(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Container(
            margin: EdgeInsets.only(top: 25, left: 15, right: 15),
            height: 120,
            child: Column(
              children: <Widget>[
                Container(
                  child: TextWidget(
                    text:
                        'Are you sure you want to proceed\nwith your purchase?',
                    size: 12,
                    weight: FontWeight.bold,
                    color: Colors.grey[700]!,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 22),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(3)),
                        child: MaterialButton(
                          child: TextWidget(
                              text: 'No',
                              alignment: TextAlign.center,
                              size: 12,
                              weight: FontWeight.bold),
                          onPressed: () {
                            Navigator.of(context).pop('no');
                          },
                        ),
                      ),
                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(3)),
                        child: MaterialButton(
                          child: TextWidget(
                              text: 'Yes',
                              alignment: TextAlign.center,
                              size: 12,
                              weight: FontWeight.bold),
                          onPressed: () {
                            Navigator.of(context).pop('yes');
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<dynamic> simpleAlert(BuildContext context, message) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Container(
            margin: EdgeInsets.only(top: 20, left: 15, right: 15),
            height: 230,
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          alignment: Alignment.topRight,
                          child: Icon(Icons.close)),
                    )),
                Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        // alignment: Alignment.topCenter,
                        child: Image.asset(
                          "images/hotel/noresult.png",
                          width: 100,
                          height: 100,
                        ),
                      ),
                    )),
                Container(
                  child: TextWidget(
                    text: message,
                    size: text_font_medium16_size,
                    weight: FontWeight.bold,
                    color: black_color,
                    alignment: TextAlign.center,
                  ),
                ),
                new SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /* customer not found alert */
  static Future<dynamic> customerNotFoundAlert(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Container(
            margin: EdgeInsets.only(top: 25, left: 15, right: 15),
            height: 110,
            child: Column(
              children: <Widget>[
                Container(
                  child: TextWidget(
                    text: "Payment is not completed,\n try again later!!!",
                    size: 15,
                    weight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: deepdark_orange_color,
                        ),
                        borderRadius: BorderRadius.circular(3)),
                    child: new MaterialButton(
                      child: TextWidget(
                        text: "OK",
                        textAlign: TextAlign.center,
                        color: deepdark_orange_color,
                        size: text_font_size_small,
                        weight: FontWeight.bold,
                      ),
                      onPressed: () async {
                        Navigator.of(context).pushNamed('/tabbarpage');
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

// watsapp for drwawer
  static void whatsappcallnew(
      BuildContext context, outletname, offerName) async {
    var whatsappUrl;
    Navigator.of(context).pop();
    var whatsappstore = Platform.isAndroid
        ? "https://play.google.com/store/apps/details?id=com.whatsapp&hl=en_IN"
        : "https://apps.apple.com/in/app/whatsapp-messenger/id310633997";

    whatsappUrl =
        "whatsapp://send?phone=+971504350673&text=Hello,I%20am%20facing%20some%20issues%20with%20${outletname.replaceAll(new RegExp('&'), "%26")}%20(${offerName.replaceAll(new RegExp('&'), "%26")})offer%20in%20GEMS%20Rewards"; //%20kindly%20do%20let%20us%20know%20how%20can%20we%20assist%20you?

    whatsappUrl = whatsappUrl.replaceAll(" ", "%20");

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      await launchUrl(Uri.parse(whatsappstore));
    }
  }

  // watsapp for drwawer
  static void whatsappcalldrwaer(BuildContext context) async {
    var whatsappUrl;
    Navigator.of(context).pop();
    var whatsappstore = Platform.isAndroid
        ? "https://play.google.com/store/apps/details?id=com.whatsapp&hl=en_IN"
        : "https://apps.apple.com/in/app/whatsapp-messenger/id310633997";

    whatsappUrl =
        "whatsapp://send?phone=+971504350673&text=Hello , I%20am%20facing%20some%20issues%20in%20GEMS%20Rewards."; //%20kindly%20do%20let%20us%20know%20how%20can%20we%20assist%20you?

    whatsappUrl = whatsappUrl.replaceAll(" ", "%20");

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      await launchUrl(Uri.parse(whatsappstore));
    }
  }

  static void whatsappcalldrwaerforhelpsupport(BuildContext context) async {
    var whatsappUrl;
    Navigator.of(context).pop();
    var whatsappstore = Platform.isAndroid
        ? "https://play.google.com/store/apps/details?id=com.whatsapp&hl=en_IN"
        : "https://apps.apple.com/in/app/whatsapp-messenger/id310633997";

    whatsappUrl =
        "whatsapp://send?phone=+971504350673&text=Hello Team, I%20need%20your%20assistance%20in%20GEMS%20Rewards."; //%20kindly%20do%20let%20us%20know%20how%20can%20we%20assist%20you?

    whatsappUrl = whatsappUrl.replaceAll(" ", "%20");

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      await launchUrl(Uri.parse(whatsappstore));
    }
  }

  static Future<void> showDialogUpdate(BuildContext context, bool value) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Container(
                margin: EdgeInsets.only(top: 25, left: 15, right: 15),
                height: 150,
                child: value == false
                    ? Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            //margin: EdgeInsets.only(top: 5),
                            child: TextWidget(
                              softwrap: true,
                              textAlign: TextAlign.center,
                              text:
                                  "We have released an important update for the GEMS Rewards app. It is recommended that you proceed with the update for better user experience.",
                              size: text_font_size_small,
                              weight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          new SizedBox(
                            height: 5,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  height: 35,
                                  // width: 60,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1.0,
                                        color: blue_color,
                                      ),
                                      borderRadius: BorderRadius.circular(3)),
                                  child: new TextButton(
                                    child: TextWidget(
                                      text: "No",
                                      color: blue_color,
                                      textAlign: TextAlign.center,
                                      size: text_font_size_small,
                                      weight: FontWeight.w500,
                                    ),
                                    onPressed: () {
                                      checkvalueno = true;
                                      GemsGLobals.checkvalueno = checkvalueno;

                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                ),
                                Container(
                                  height: 35,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1.0,
                                        color: blue_color,
                                      ),
                                      borderRadius: BorderRadius.circular(3)),
                                  child: new TextButton(
                                    child: TextWidget(
                                      text: "Continue",
                                      textAlign: TextAlign.center,
                                      color: blue_color,
                                      size: text_font_size_small,
                                      weight: FontWeight.w500,
                                    ),
                                    onPressed: () {
                                      if (Platform.isAndroid) {
                                        platform = "android";
                                        _launchURL(
                                            "https://play.google.com/store/apps/details?id=com.clubclass.gemsrewards");
                                      } else {
                                        platform = "ios";
                                        _launchURL(
                                            "https://apps.apple.com/ae/app/gems-rewards/id1287373984");
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          Container(
                            //margin: EdgeInsets.only(top: 5),
                            child: TextWidget(
                              text:
                                  "We have released a critical update for the GEMS Rewards app. To continue using our services you must proceed with the update.",
                              size: text_font_size_small,
                              weight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          new SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 22),
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.0,
                                  color: blue_color,
                                ),
                                borderRadius: BorderRadius.circular(3)),
                            child: new TextButton(
                              child: TextWidget(
                                text: "Proceed",
                                textAlign: TextAlign.center,
                                color: blue_color,
                                size: text_font_size_small,
                                weight: FontWeight.w500,
                              ),
                              onPressed: () {
                                if (Platform.isAndroid) {
                                  platform = "android";
                                  _launchURL(
                                      "https://play.google.com/store/apps/details?id=com.clubclass.gemsrewards");
                                } else {
                                  platform = "ios";
                                  _launchURL(
                                      "https://apps.apple.com/ae/app/gems-rewards/id1287373984");
                                }
                              },
                            ),
                          ),
                        ],
                      )),
          ),
          
          onPopInvokedWithResult: (canPop, res) async {
                             return Future.value(false);
                  },
        );
      },
    );
  }
}

enum ConfirmAction { CANCEL, ACCEPT }
