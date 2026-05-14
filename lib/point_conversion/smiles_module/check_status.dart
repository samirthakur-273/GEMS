import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/point_conversion/smiles_module/apiconfig/apiconfig_smiles.dart';
import 'package:gems_revamp/point_conversion/smiles_module/mainscreen_smiles.dart';
import 'package:gems_revamp/point_conversion/smiles_module/switch_options_smiles.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/time_out.dart';

import 'package:http/http.dart' as http;

class CheckStatus extends StatefulWidget {
  final String? route;

  const CheckStatus({super.key, this.route});
  @override
  _CheckStatusState createState() => _CheckStatusState();
}

class _CheckStatusState extends State<CheckStatus> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var noConnection;
  bool linkloader = false;
  var _linkedData;
  List _responseData = [];
  @override
  void initState() {
    super.initState();
    var data = {
      "sourceProgramCode": "GEMS",
      "membership_no": "${GemsGLobals.membershipNo}"
    };
    smiles(data);
  }

  void smiles(data) {
    ApiconfigSmiles.getAllMembershipsData(http.Client(), json.encode(data))
        .then((result) async {
      if (result["status"] == true) {
        _responseData.add(result["data"]);
        for (int i = 0; i < _responseData.length; i++) {
          _linkedData = _responseData[i]["linkedPartners"];
        }
        if (_linkedData.length > 0) {
          setState(() {
            linkloader = false;
          });
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SmilesSwitchOptions(
                      // save: false, alreadylinked: true
                      )));
        } else {
          setState(() {
            linkloader = false;
          });
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => SmilesMainScreen()));
        }
      } else if (result["message"] == "timeout") {
        var notresponding = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => TimeOut()));
        if (notresponding != null) {
          smiles(data);
        } else {}
      } else {
        setState(() {
          linkloader = false;
        });
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => SmilesMainScreen()));
      }
    }).catchError((onError) async {
      setState(() {
        linkloader = false;
      });
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => SmilesMainScreen()));
      // showLoginAlert(context, "Something went wrong,please try again");
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _appBar() {
      return Container(
        height: 60,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.centerLeft,
                height: 27,
                margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: Image.asset(
                  ImageConstants.left_arrow,
                  color: white_text_color,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              child: TextWidget(
                text: "Account Linking",
                color: white_text_color,
                size: appbar_text_size,
                weight: FontWeight.bold,
              ),
            )
          ],
        ),
      );
    }

    Widget _gemsLogo() {
      return Container(
        margin: EdgeInsets.only(top: 40),
        child: Center(
          child: Image.asset(
            ImageConstants.brandLogoWhite,
            
            height: 100,
          ),
        ),
      );
    }

    Widget _pleasewait() {
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Center(
                child: TextWidget(
                  text: "Please Wait Loading...",
                  color: white_text_color,
                  size: 24,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _loader() {
      return Container(
          child: Center(
        child: SpinKitCircle(
          color: btn_bg_color,
        ),
      ));
    }

    Widget _body() {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          decoration: BoxDecoration(gradient: gradient_theme_color),
          // image: DecorationImage(
          //     image: AssetImage("images/login/bg_login.jpg"),
          //     fit: BoxFit.cover),
          // color: white_text_color,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    _appBar(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _gemsLogo(),
                    SizedBox(
                      height: 40.0,
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    _pleasewait(),
                    SizedBox(
                      height: 40.0,
                    ),
                    _loader(),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: SafeArea(
        bottom: false,
        child: PopScope(
          canPop: true,
          onPopInvoked: (canPop) async {
            if (widget.route == GemsGLobals.pushNotificationRouteType) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => TabsScreen(
                            initialIndex: 0,
                          )));
            }
            return Future.value(false);
          },
          child: Scaffold(
            key: _scaffoldKey,
            body: _body(),
          ),
        ),
      ),
    );
  }
}
