import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gems_revamp/advanced_plus/api_utils/advantageplus_apiconfig.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/apiconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class AdvantagePlusWebPage extends StatefulWidget {
  const AdvantagePlusWebPage({Key? key}) : super(key: key);

  @override
  _AdvantagePlusWebPageState createState() => _AdvantagePlusWebPageState();
}

class _AdvantagePlusWebPageState extends State<AdvantagePlusWebPage> {
  bool webPageLoading = true;
  String? advantagePlusUrl;
  late final WebViewController webViewController;

  @override
  void initState() {
    super.initState();

    final params = const PlatformWebViewControllerCreationParams();
    webViewController = WebViewController.fromPlatformCreationParams(params);

    advantagePlusRegistration();
  }

  void advantagePlusRegistration() async {
    bool isConnected = await Internetconnectivity().isConnected();
    if (isConnected) {
      var advantagePlusRegistrationReq = {
        "membership_no": GemsGLobals.membershipNo,
        "affiliate_id": ApiConstanst.advantagePlusAffiliateId,
        "type": "registration",
        "user_type": GemsGLobals.userType == 'referral'
            ? 'friends_and_family'
            : GemsGLobals.userType,
        "first_name": GemsGLobals.userFirstName,
        "last_name": GemsGLobals.userLastName
      };

      var response = await AdvantageplusApiConfig.advantagePlusRegistrationApi(
          http.Client(), advantagePlusRegistrationReq);

      if (response["status"] == true) {
        setState(() {
          advantagePlusUrl = response["URL"];
          webViewController
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onPageStarted: (url) {
                  setState(() {
                    webPageLoading = true;
                  });
                },
                onPageFinished: (url) {
                  setState(() {
                    webPageLoading = false;
                  });
                },
              ),
            )
            ..loadRequest(Uri.parse(advantagePlusUrl ?? ''));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: TextWidget(
            text: "GEMS Rewards",
            size: text_font_medium18_size,
            weight: FontWeight.w500,
            color: white_text_color,
          ),
          backgroundColor: Colors.blue,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: white_text_color),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: advantagePlusUrl != null
            ? Stack(
                children: [
                  WebViewWidget(controller: webViewController),
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                  color: btn_bg_color,
                ),
              ),
      ),
    );
  }
}
