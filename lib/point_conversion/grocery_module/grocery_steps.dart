import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gems_revamp/point_conversion/smiles_module/apiconfig/apiconfig_smiles.dart';
import 'package:gems_revamp/point_conversion/smiles_module/mainscreen_smiles.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/time_out.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../common_widget/colors_widget.dart';
import '../../common_widget/font_size.dart';
import '../../common_widget/text_widget.dart';
import '../../makesense_module/makesense_apiconfig.dart';
import '../../utils/constants_files/imageconstants.dart';

class GrocerySteps extends StatefulWidget {
  var htmlData, androidUrl, iosUrl;
  GrocerySteps({Key? key, this.htmlData, this.androidUrl, this.iosUrl})
      : super(key: key);

  @override
  State<GrocerySteps> createState() => _GroceryStepsState();
}

class _GroceryStepsState extends State<GrocerySteps> {
  var openAppResult;
  bool linkloader = false;
  bool _islinkOrnot = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var data = {
      "sourceProgramCode": "GEMS",
      "membership_no": "${GemsGLobals.membershipNo}"
    };
    linkloader = true;
    grocery(data);
    makesenseEventGroceryPartnerDetailPageCall();
    GemsGLobals.lastVisitPageName = GemsGLobals.eventGroceryPartnerDetailPage;
  }

  makesenseEventGroceryPartnerDetailPageCall() {
    String keyName = GemsGLobals.eventGroceryPartnerDetailPage;
    var segmentReq = {
      GemsGLobals.partner: GemsGLobals.smilesText,
      GemsGLobals.intSource: GemsGLobals.lastVisitPageName
      };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  makesenseEventGroceryInitiatedCall() {
    String keyName = GemsGLobals.eventGroceryInitiated;
    var segmentReq = {GemsGLobals.intSource: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }


  _launchURL(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void grocery(data) {
    ApiconfigSmiles.checkUserAccount(http.Client(), json.encode(data))
        .then((result) async {
      if (result["status"] == true) {
        setState(() {
          linkloader = false;
          _islinkOrnot = true;
        });
      } else if (result["status"] == false) {
        setState(() {
          linkloader = false;
          _islinkOrnot = false;
        });
      } else if (result["message"] == "timeout") {
        var notresponding = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => TimeOut()));
      } else {
        setState(() {
          linkloader = false;
          _islinkOrnot = false;
        });
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => SmilesMainScreen()));
      }
    }).catchError((onError) async {
      setState(() {
        linkloader = false;
        _islinkOrnot = false;
      });
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => SmilesMainScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _submitbutton() {
      return Container(
        height: 70,
        child: GestureDetector(
          onTap: () async {
            if (Platform.isAndroid) {
              if (GemsGLobals.isDeepLink == true) {
                widget.androidUrl =GemsGLobals.smileMarketUrl;
              }
              await launchUrl(Uri.parse(widget.androidUrl),
                  mode: LaunchMode.externalApplication);
            } else {
              _launchURL(widget.iosUrl);
            }
            makesenseEventGroceryInitiatedCall();
          },
          child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width / 1.25,
              child: Container(
                  decoration: BoxDecoration(
                      color: button_bgpdf_color,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: TextWidget(
                      text: "Smiles Market",
                      color: Colors.white,
                      weight: FontWeight.w500,
                      size: text_font_medium_size,
                    ),
                  ))),
        ),
      );
    }

    Widget _linkedbutton() {
      return Container(
        height: 70,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SmilesMainScreen(routesFrom: "grocery")));
              },
              child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width / 1.25,
                  child: Container(
                      decoration: BoxDecoration(
                          color: blue_color,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: TextWidget(
                          text: "Link Now",
                          color: Colors.white,
                          weight: FontWeight.w500,
                          size: text_font_medium_size,
                        ),
                      ))),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      );
    }

    return SafeArea(
      bottom: false,
      top: false,
      child: PopScope(
          canPop: true,
          onPopInvokedWithResult: (canPop, result) async {
             Future.value(false);},
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(90.0),
              child: Container(
                  decoration: BoxDecoration(gradient: gradient_theme_color),
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.only(
                    top: 25,
                  ),
                  height: 90,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
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
                                text: "Smiles Market",
                                color: white_text_color,
                                size: text_font_medium18_size,
                                weight: FontWeight.w500,
                              )),
                        )
                      ],
                    ),
                  ))),
          body: linkloader == true
              ? SpinKitCircle(color: blue_color)
              : ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 235, 247, 250),
                      ),
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.only(top: 20),
                              height: MediaQuery.of(context).size.height / 3.3,
                              child: Image.asset(
                                ImageConstants.smiles_marketImg,
                              )),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Html(
                              data: widget.htmlData ?? "",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _submitbutton(),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    _islinkOrnot == false &&
                            (GemsGLobals.referralRelationType !=
                                    GemsGLobals.spouseValue &&
                                GemsGLobals.referralRelationType !=
                                    GemsGLobals.childValue)
                        ? Container(
                            margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromARGB(255, 235, 247, 250),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: TextWidget(
                                    text:
                                        'If you have not linked your account, press the below button and follow the steps',
                                    alignment: TextAlign.center,
                                    color: grey_color,
                                    fontStyle: FontStyle.italic,
                                    size: text_font_medium14_size,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                _linkedbutton(),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          )
                        : Container(
                            height: 0,
                          )
                  ],
                ),
        ),
      ),
    );
  }
}
