import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gems_revamp/advanced_plus/api_utils/advantageplus_apiconfig.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/apiconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class AdvantagePlusClubsWebPage extends StatefulWidget {
  const AdvantagePlusClubsWebPage({Key? key}) : super(key: key);

  @override
  _AdvantagePlusClubsWebPageState createState() =>
      _AdvantagePlusClubsWebPageState();
}

class _AdvantagePlusClubsWebPageState extends State<AdvantagePlusClubsWebPage> {
  String? advantagePlusClubUrl;
  bool webPageLoading = false;
  WebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    advantagePlusClubdata();
  }

  void advantagePlusClubdata() {
    Internetconnectivity().isConnected().then((value) {
      if (value == true) {
        var advantagePlusClubsReq = {
          "membership_no": GemsGLobals.membershipNo,
          "advantage_plus_id": GemsGLobals.gemsPlusMembershipNo.toString(),
          "affiliate_id": ApiConstanst.advantagePlusAffiliateId,
          "type": "sson",
          "user_type": GemsGLobals.userType == 'referral'
              ? 'friends_and_family'
              : GemsGLobals.userType
        };
        setState(() {
          webPageLoading = true;
        });
        AdvantageplusApiConfig.advantagePlusRegistrationApi(
                http.Client(), advantagePlusClubsReq)
            .then((response) {
          if (response["status"] == true) {
            setState(() {
              webPageLoading = false;
              advantagePlusClubUrl = response["URL"];
              initializeWebView(); 
            });
          }
        });
      }
    });
  }

  void initializeWebView() {
    if (advantagePlusClubUrl != null) {
      webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (val) {
              setState(() {
                webPageLoading = true;
              });
            },
            onPageFinished: (val) {
              setState(() {
                webPageLoading = false;
              });
            },
          ),
        )
        ..loadRequest(Uri.parse(advantagePlusClubUrl ?? ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        top: false,
        child: Scaffold(
          extendBody: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(90.0),
            child: Container(
                decoration: BoxDecoration(gradient: gradient_theme_color),
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(
                  top: 25,
                ),
                height: Platform.isIOS ? 100 : 90,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, true);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue[400],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 22,
                                color: white_text_color,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(right: 30),
                            child: TextWidget(
                              text: "GEMS Rewards",
                              size: text_font_medium18_size,
                              weight: FontWeight.w500,
                              color: white_text_color,
                            )),
                      )
                    ],
                  ),
                )),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                    child: advantagePlusClubUrl != null && webViewController != null
                        ? WebViewWidget(controller: webViewController!)
                        : Container(
                            child: Center(
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  child: SpinKitCircle(
                                    color: btn_bg_color,
                                  )),
                            ),
                          )),
              )
            ],
          ),
        ));
  }
}
