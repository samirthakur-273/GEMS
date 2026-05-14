import 'dart:io';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/utils/constants_files/apiconstants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../makesense_module/makesense_apiconfig.dart';
import '../../offer_module/offer_detail/offer_detail.dart';
import '../../utils/gemsGlobals.dart';

class FeeRedemptionDetailsPage extends StatefulWidget {
  final String? title;
  final String? description;
  final String? routeFrom;
  final String? url;
  final String? urlforandroid;
  final String? urlforios;
  const FeeRedemptionDetailsPage(
      {Key? key,
      this.title,
      this.description,
      this.routeFrom,
      this.url,
      this.urlforandroid,
      this.urlforios})
      : super(key: key);

  @override
  State<FeeRedemptionDetailsPage> createState() =>
      _FeeRedemptionDetailsPageState();
}

class _FeeRedemptionDetailsPageState extends State<FeeRedemptionDetailsPage> {
  var openAppResult;

  @override
  void initState() {
    super.initState();
    makesenseEventcall();
    GemsGLobals.lastVisitPageName = GemsGLobals.eventEducationSpendsDetailPage;
  }

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

  makesenseEventcall() {
    String keyName = GemsGLobals.eventEducationSpendsDetailPage;
    var segmentReq = {GemsGLobals.partner: widget.title, GemsGLobals.intSource: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  makesenseEventEducationSpendInitiatedcall() {
    String keyName = GemsGLobals.eventEducationSpendInitiated;
    var segmentReq = {};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  @override
  Widget build(BuildContext context) {
    Widget _body() {
      return Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: [
                TextWidget(
                  text: widget.description,
                ),
              ],
            ))
          ],
        ),
      );
    }

    Widget _submitbutton() {
      return Container(
        height: 70,
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                if (widget.routeFrom == "uniform_redeemption") {
                  await launchUrl(Uri.parse(widget.url.toString()));
                } else {
                  openAppResult = await LaunchApp.isAppInstalled(
                    androidPackageName: ApiConstanst.androidPackageName,
                    iosUrlScheme: ApiConstanst.iosUrlScheme,
                  );

                  if (Platform.isAndroid) {
                    if (openAppResult == true) {
                      _launchURL(widget.urlforandroid);
                    } else {
                      await LaunchUrl.openLink(
                          url:
                              "https://play.google.com/store/apps/details?id=com.GEMS.Connect"
                          // "com.gems.connecttst://GEMSConnectNew/FeesPayment"

                          );
                    }
                  } else {
                    if (openAppResult == true) {
                      _launchURL(widget.urlforandroid);
                    } else {
                      await LaunchUrl.openLink(
                          url:
                              "https://apps.apple.com/ae/app/gems-connect/id1462613346");
                    }
                  }
                }
                makesenseEventEducationSpendInitiatedcall();
              },
              child: Container(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: button_bgpdf_color,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Center(
                          child: TextWidget(
                            text: widget.routeFrom == "school_fee_redeemption"
                                ? "Fee Redemption"
                                : widget.routeFrom == "uniform_redeemption"
                                    ? "Uniform Redemption"
                                    : 'Bus Redemption',
                            color: Colors.white,
                            weight: FontWeight.w500,
                            size: text_font_medium_size,
                          ),
                        )),
                  )),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90.0),
          child: GradientAppBar(
            routeType: "fee_redeemption",
            title: widget.title,
            color: white_text_color,
            size: text_font_medium18_size,
            weight: FontWeight.w500,
            centerTitle: true,
            height: 90,
          ),
        ),
        body: _body(),
            bottomNavigationBar: _submitbutton(),
      ),
    );
  }
}
