/* Author : Sanjana Shetty
 Date created : 04-May-2022
 Discription : Smiles Login Page*/

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/point_conversion/smiles_module/apiconfig/apiconfig_smiles.dart';
import 'package:gems_revamp/point_conversion/smiles_module/login_smiles/model_smilesid.dart';
import 'package:gems_revamp/point_conversion/smiles_module/login_smiles/presenter_smilesid.dart';
import 'package:gems_revamp/point_conversion/smiles_module/login_smiles/view_smilesid.dart';
import 'package:gems_revamp/point_conversion/smiles_module/otp_smiles.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/dialogAlert.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:gems_revamp/utils/time_out.dart';
import 'package:http/http.dart' as http;

import '../../../common_widget/bottombar.dart';

class SmilesLoginPage extends StatefulWidget {
  @override
  SmilesLoginPageState createState() => SmilesLoginPageState();
}

class SmilesLoginPageState extends State<SmilesLoginPage>
    implements SmilesLoginView {
  FocusNode nodeOne = FocusNode();
  FocusNode nodeTwo = FocusNode();
  final portalid = TextEditingController();
  bool iderror = false;
  var _errMsg;
  bool isloading = false;
  SmilesLoginModel smileslogindata = SmilesLoginModel();
  SmilesLoginPresenter? _smilesloginpresenter;
  SmilesLoginModel? smilesloginresponse;

  @override
  void initState() {
    super.initState();
    GemsGLobals.etisaladSmilesID = "";
    _smilesloginpresenter = SmilesLoginPresenter(this);
  }

  void callsmilesloginapi() {
    var request = {
      "sourceProgramCode": "GEMS",
      "membership_no": "${GemsGLobals.membershipNo}",
      "targetProgramCode": "SMILES",
      "smiles_id": "${portalid.text}",
    };

    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _smilesloginpresenter!.callLoginSmilesAPI(request);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          setState(() {});
          _smilesloginpresenter!.callLoginSmilesAPI(request);
        }
      }
    });
  }

  void _delinkAcc(request) {
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        ApiconfigSmiles.delinkProgramAccount(
                http.Client(), json.encode(request))
            .then((res) {
          if (res["status"] == true) {
          } else {
          }
        });
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          _delinkAcc(request);
        }
      }
      callsmilesloginapi();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _gemsLogo() {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 50, bottom: 20),
        child: Image.asset(
          ImageConstants.brandLogo,
          height: 85,
        ),
      );
    }

    Widget _login() {
      return Container(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 35, bottom: 10),
          child: Center(
            child: TextWidget(
              text: "LINK ACCOUNT USING PIN",
              color: black_text,
              size: text_font_large_size,
              weight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    Widget _portalid() {
      return Container(
        margin: EdgeInsets.only(top: 30, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 25,
              child: TextFormField(
                  autofocus: true,
                  maxLength: 12,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (term) {
                    nodeTwo.unfocus();
                    FocusScope.of(context).requestFocus(nodeTwo);
                  },
                  controller: portalid,
                  focusNode: nodeOne,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  ],
                  onChanged: (String text) {
                    if (portalid.text.length > 0) {
                      setState(() {
                        iderror = false;
                        _errMsg = "";
                      });
                    }
                  },
                  style: TextStyle(
                      color: black_color, fontSize: text_font_medium_size),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 30, bottom: 5),
                    border: InputBorder.none,
                    counterText: '',
                    hintText: "Smiles Registered Mobile/Fixed Number",
                    hintStyle: TextStyle(color: grey_hint__text, fontSize: 15),
                    prefixIcon: Padding(
                        padding: const EdgeInsetsDirectional.only(bottom: 5.0),
                        child: Image.asset(ImageConstants.user,
                            color: black_color)),
                  )),
            ),
            Container(
              margin: EdgeInsets.only(left: 5, right: 5),
              child: Divider(
                color: grey_hint__text,
                height: 2,
              ),
            ),
          ],
        ),
      );
    }

    Widget _portaliderror() {
      return iderror == true
          ? Container(
              margin: EdgeInsets.only(left: 30, top: 10),
              child: Center(
                child: TextWidget(
                    text: "$_errMsg",
                    color: Colors.red,
                    textAlign: TextAlign.center,
                    size: text_font_size_x_small),
              ),
            )
          : Container(
              height: 0,
            );
    }

    Widget _submitButton() {
      return GestureDetector(
          onTap: () {
            setState(() {
              FocusScope.of(context).requestFocus(new FocusNode());
              if (portalid.text.length == 0) {
                setState(() {
                  isloading = false;
                  iderror = true;
                  _errMsg = "Please enter Smiles Registered Number";
                });
              } else if (portalid.text.length != 0) {
                setState(() {
                  iderror = false;
                  isloading = true;
                });
                callsmilesloginapi();
              } else {
                setState(() {
                  isloading = false;
                  iderror = true;
                  _errMsg = "Please enter valid Smiles Registered Number";
                });
              }
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => SmilesOtpPage()));
            });
          },
          child: isloading == false
              ? Container(
                  height: 45,
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: greenboxcolor),
                  child: Center(
                    child: TextWidget(
                      text: "Submit",
                      color: white_shade,
                      size: text_font_medium_size,
                      weight: FontWeight.w500,
                    ),
                  ))
              : Container(
                  margin: EdgeInsets.only(
                    top: 30,
                  ),
                  child: SpinKitCircle(
                    color: btn_bg_color,
                  ),
                ));
    }

    Widget _patternmatch() {
      return Container(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 0, left: 20, right: 20),
          child: RichText(
            text: TextSpan(
              text: "Hint: Mobile (05X XXX XXXX) / Fixed (0X XXX XXXX) number.",
              style: TextStyle(
                color: grey_hint__text,
                fontSize: text_font_size_x_small,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    Widget _body() {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: boxgrey,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: ListView(
                  children: <Widget>[
                    _gemsLogo(),
                    _login(),
                    SizedBox(
                      height: 20,
                    ),
                    _portalid(),
                    _portaliderror(),
                    SizedBox(height: 10),
                    _patternmatch(),
                    SizedBox(
                      height: iderror == true ? 25 : 50,
                    ),
                    _submitButton(),
                  ],
                ),
              )),
            ],
          ),
        ),
      );
    }

    Widget _tabbar() {
      return Container(
        width: MediaQuery.of(context).size.width,
        // color: black_color,
        child: BottomBar(
          initialIndex: 0,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: SafeArea(
        bottom: true,
        top: false,
        child: Scaffold(
          extendBody: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(90.0),
            child: GradientAppBar(
              title: "Account Linking",
              color: white_text_color,
              size: text_font_medium18_size,
              weight: FontWeight.w500,
              centerTitle: true,
              height: 90,
            ),
          ),
          body: _body(),
          bottomNavigationBar: SizedBox(
            height: 95,
            child: _tabbar(),
          ),
        ),
      ),
    );
  }

  static Future<dynamic> showLoginAlert(BuildContext context, message) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Container(
            margin: EdgeInsets.only(top: 20),
            height: 110,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: TextWidget(
                    text: "$message",
                    size: text_font_size_small,
                    weight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        child: new TextButton(
                          child: TextWidget(
                            text: "OK",
                            color: blue_color,
                            size: text_font_size_small,
                            weight: FontWeight.bold,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
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

  @override
  void getloginsmilesFailure(error) {
    // TODO: implement getloginsmilesFailure
  }

  @override
  void getloginsmilesResponseSuccess(SmilesLoginModel smilesloginModel) {
    smilesloginresponse = smilesloginModel;
    setState(() {
      if (smilesloginresponse!.status == true) {
        isloading = false;
        GemsGLobals.etisaladSmilesID = "${portalid.text}";
        isloading = false;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SmilesOtpPage(smilesid: "",)));
      } else {
        GemsGLobals.etisaladSmilesID = "${portalid.text}";

        var req = {
          "sourceProgramCode": "GEMS",
          "membership_no": "${GemsGLobals.membershipNo}",
          "targetProgramCode": "SMILES",
          "smiles_id": "${GemsGLobals.etisaladSmilesID}",
        };
        _delinkAcc(req);
      }
    });
  }

  @override
  Future<void> timeOutError(String error) async {
    if (error == "timeout") {
      setState(() {
        isloading = false;
      });
      bool isRetry = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => TimeOut()));
      if (isRetry && isRetry != null) {
        callsmilesloginapi();
      }
    }
  }
}
