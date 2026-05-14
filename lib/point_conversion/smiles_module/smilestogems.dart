/* Author : Sanjana Shetty
 Date created : 28-April-2022
 Discription : Smiles To Gems Page*/

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gems_revamp/account/help_support/help_support.dart';
import 'package:gems_revamp/homepage/pointbalance/model_pointbalance.dart';
import 'package:gems_revamp/homepage/pointbalance/presenter_pointbalance.dart';
import 'package:gems_revamp/homepage/pointbalance/view_pointbalance.dart';
import 'package:gems_revamp/point_conversion/smiles_module/apiconfig/apiconfig_smiles.dart';
import 'package:gems_revamp/point_conversion/smiles_module/otp_smiles.dart';
import 'package:gems_revamp/point_conversion/smiles_module/transaction_module/pending_transaction_smiles.dart';
import 'package:gems_revamp/utilities/auth_utils.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/dialogAlert.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:gems_revamp/utils/time_out.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../common_widget/bottombar.dart';
import '../../common_widget/colors_widget.dart';
import '../../common_widget/font_size.dart';
import '../../common_widget/numberformat.dart';
import '../../common_widget/tabbarpage.dart';
import '../../common_widget/text_widget.dart';
import '../../utils/constants_files/imageconstants.dart';

class SmilesToGems extends StatefulWidget {
  @override
  _SmilesToGemsState createState() => _SmilesToGemsState();
}

class _SmilesToGemsState extends State<SmilesToGems>
    implements MyPointsBalanceView {
  bool availablepoints = true;
  double _value = 1;
  var multiple = 10;
  double? rangee = 0.0;
  var zerogemspoints;
  double equivalentPOint = 0;
  double _conversionRate = 0.0;
  var _gemspointsleft;
  bool? resul;
  var vall;
  var currentgemspointsbalance = 4000;
  var _userGemsPoints;
  var _linkedData;
  var _smilesPointsBal = 0;
  var _roundOffMethod;
  var _minConversion;
  bool _submitLoader = false;
  bool _isLoading = true;
  bool _nodatafound = false;
  List _responseData = [];
  var _smilesMemberID;
  bool refreshloader = false;
  MyPointsModel pointbalancedata = MyPointsModel();
  MyPointsBalancePresenter? _pointbalancepresenter;
  var _pointbalancedata;
  var stoploader=false;
  @override
  void initState() {
    super.initState();
      stoploader=false;
    _userGemsPoints =
        gemsPointsFormatter(GemsGLobals.pointbalance).replaceAll(",", "");
    // rangee = double.parse(_userGemsPoints);
    zerogemspoints = "${pointsFormatter(0)}";
    _gemspointsleft = GemsGLobals.pointbalance + _value;
    var data = {
      "sourceProgramCode": "GEMS",
      "membership_no": "${GemsGLobals.membershipNo}"
    };
    smiles(data);
  }

  static Future<dynamic> showLoginAlert(BuildContext context, message) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
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

  void smiles(data) {
    ApiconfigSmiles.getAllMembershipsData(http.Client(), json.encode(data))
        .then((result) async {
      if (result["status"] == true) {
        _nodatafound = false;
        _responseData.add(result["data"]);

        for (int i = 0; i < _responseData.length; i++) {
          _linkedData = _responseData[i]["linkedPartners"];
        }
        if (_linkedData.length > 0) {
          setState(() {
            if(stoploader==true){
            _isLoading = false;
            }
            _nodatafound = false;
          });
          for (int j = 0; j < _linkedData.length; j++) {
            setState(() {
              // rangee = double.parse(_gemsPoints);
              if (rangee == null) {
                rangee = double.parse("${pointsFormatter(0)}");
              }
              _smilesPointsBal = _linkedData[j]["points"];
              rangee=_smilesPointsBal.toDouble();
             
               _smilesMemberID = _linkedData[j]["targetMembershipNo"];
              // _conversionRate = _linkedData[j]["SO"]["conversionRate"] * 1.0;
              _conversionRate = (_linkedData[j]["OS"]["nominator"] /
                      _linkedData[j]["OS"]["denominator"]) *
                  1.0;
              _roundOffMethod = _linkedData[j]["OS"]["roundOffMethod"];
              _minConversion = _linkedData[j]["OS"]["minConversion"] ?? 0.0;
              multiple = _linkedData[j]["OS"]["multipleOf"];

              if (rangee! < _minConversion) {
                availablepoints = false;
              } else {
                availablepoints = true;
              }
            });
          }
          if(stoploader==false){
           var req = {
            "membership_no": "${GemsGLobals.membershipNo}",
            "smiles_id": "$_smilesMemberID"
          };
          refreshapi(req,"");
          }
        } else {
          setState(() {
              if(stoploader==true){
            _isLoading = false;
              }
            _nodatafound = true;
        
          });
        }
      } else if (result["message"] == "timeout") {
        var notresponding = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => TimeOut()));
        if (notresponding != null) {
          smiles(data);
        } else {}
      } else {
        setState(() {
            if(stoploader==true){
          _isLoading = false;
            }
          _nodatafound = true;
        });
      }
    }).catchError((onError) {
      setState(() {
          if(stoploader==true){
        _isLoading = false;
          }
        
      });
      // showLoginAlert(context, "Something went wrong,please try again");
    });
  }

  void refreshapi(data,pickloader) {
    ApiconfigSmiles.refreshgetlatestpoints(http.Client(), json.encode(data))
        .then((result) {
          setState(() {
            stoploader=true;
          });
          if(pickloader!="yes"){
          var data = {
      "sourceProgramCode": "GEMS",
      "membership_no": "${GemsGLobals.membershipNo}"
    };
    smiles(data);
          }
      // if (result['status'] == true) {

      // userPoints();please call point balance
      // }
      // else {
      //   setState(() {
      //     refreshloader = false;
      //   });
      // }
    }).catchError((onError) {
      setState(() {
        refreshloader = false;
        stoploader=true;
        
      });
       var data = {
      "sourceProgramCode": "GEMS",
      "membership_no": "${GemsGLobals.membershipNo}"
    };
    smiles(data);
      showLoginAlert(context, "Something went wrong,please try again");
    });
  }

  void callpointbalanceapi() {
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _pointbalancepresenter!.myPointsBalanceAPI();
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          setState(() {});
          _pointbalancepresenter!.myPointsBalanceAPI();
        }
      }
    });
  }

  Widget _userName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width-20,
            child: TextWidget(
              text: toBeginningOfSentenceCase(
                      '${GemsGLobals.userFirstName}  ${GemsGLobals.userLastName}'),
              size: text_font_medium_size,
              alignment: TextAlign.center,
              maxLines: 5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _tabBarsPointsEarning() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
        ),
      ),
      height: 80,
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
            child: Container(
              padding: const EdgeInsets.only(top: 8.0),
              decoration: BoxDecoration(
                color: balancebox,
                border:
                    Border(bottom: BorderSide(width: 2.0, color: balancebox)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: TextWidget(
                      text: "Smiles Balance",
                      size: text_font_size_small,
                      color: greyish_color,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: TextWidget(
                          text: "${pointsFormatter(_smilesPointsBal)}",
                          // "${pointsFormatter(saveaed[0]["save_aed"] == null ? "0" : saveaed[0]["save_aed"])}",
                          size: text_font_medium16_size,
                          color: blackish,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                ],
              ),
            ),
          )
            
            
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            color: Colors.grey[350],
            width: 0.5,
          ),
          Expanded(
              child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: pointbox,
                  border: Border(
                    bottom: BorderSide(width: 2.0, color: pointbox),
                  ),
                ),
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: TextWidget(
                          text: "GEMS Points",
                          color: greyish_color,
                          size: text_font_size_small,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: TextWidget(
                          text: gemsPointsFormatter(GemsGLobals.pointbalance),
                          size: text_font_medium16_size,
                          color: blackish,
                          weight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),),
        ],
      ),
    );
  }

  Widget _slider() {
    return availablepoints == true
        ? Container(
            // height: 140,
            decoration: BoxDecoration(color: white_text_color),
            child: Column(children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 2.0, color: Colors.transparent),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: TextWidget(
                      text: "Select GEMS points to be Convert",
                      color: grey_color,
                      size: text_font_medium_x_size,
                    ),
                  )),
              Container(
                padding: EdgeInsets.only(top: 40, left: 20, right: 20),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    valueIndicatorColor: active_track_color,
                    valueIndicatorTextStyle: TextStyle(
                        color: orange_shade,
                        fontSize: text_font_medium_x_size,
                        fontWeight: FontWeight.bold),
                    showValueIndicator: ShowValueIndicator.always,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
                    trackShape: RoundedRectSliderTrackShape(),
                    trackHeight: 5,
                  ),
                  child: Slider(
                      thumbColor: red_color,
                      inactiveColor: sliderinactivecolor,
                      activeColor: active_track_color,
                      value: _value <= rangee! - (rangee! % multiple)
                          ? _value
                          : 1.0,
                      // min: 1.0,
                      // max: 100,
                      // divisions: 10,
                      min: 1.0,
                      // max: rangee ?? "",
                      max: rangee! - (rangee! % multiple) >= _value
                          ? rangee! - (rangee! % multiple)
                          : 1.0,
                      label: "${pointsFormatter(_value.toInt())}",
                      // divisions: ((rangee-(rangee%100))/100).round(),
                      divisions: ((rangee! - (rangee! % multiple)) / multiple)
                                  .round() >
                              0.0
                          ? ((rangee! - (rangee! % multiple)) / multiple)
                              .round()
                          : 1,
                      semanticFormatterCallback: (double newValue) {
                        return '${newValue.round()}';
                      },
                      onChanged: (double value) {
                        setState(() {
                          _value = value;
                          if (_value.toInt() == 1) {
                            equivalentPOint = _conversionRate;
                          } else {
                            equivalentPOint =
                                (_conversionRate * _value.toInt());
                          }

   _gemspointsleft =
                              GemsGLobals.pointbalance + equivalentPOint;
                        });
                      }),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 0, left: 40, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextWidget(
                      text: "1",
                    ),
                    Container(
                      child: TextWidget(
                          text:
                              "${pointsFormatter((rangee! - (rangee! % multiple)).toInt())}"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Container(
                            child: TextWidget(
                                text:
                                    "Selected Smiles Points: ${pointsFormatter(_value.toInt())}")),
                      ),
                    ],
                  ),
                ),
              ),
            ]))
        : Container(
            height: 180,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey[300]!),
                ),
                color: white_text_color),
            child: Center(
                child: TextWidget(
                    text: "Minimum 7500 Smiles point required for conversion",
                    weight: FontWeight.bold,
                     alignment: TextAlign.center,
                    size: text_font_medium_x_size)));
  }

  Widget _earnPoints() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextWidget(
            text: "You will earn",
            size: text_font_medium_size,
            color: black_color,
          ),
          new SizedBox(
            width: 5,
          ),
          TextWidget(
            // text: "${_earnAirMiles.floor().toString()}"
            text: equivalentPOint != 0.0
                ? equivalentPOint == 1 ||
                        equivalentPOint == 0 ||
                        equivalentPOint == _conversionRate ||
                        equivalentPOint == null
                    ? _roundOffMethod == null
                        ? _conversionRate.toString()
                        : _roundOffMethod == "Floor"
                            ? "${pointsFormatter(_conversionRate.floor())}"
                            : "${pointsFormatter(_conversionRate.ceil())}"
                    : _roundOffMethod == "Floor"
                        ? "${pointsFormatter(equivalentPOint.floor())}"
                        : "${pointsFormatter(equivalentPOint.ceil())}"
                : _roundOffMethod == null
                    ? _conversionRate.toString()
                    : _roundOffMethod == "Floor"
                        ? "${pointsFormatter(_conversionRate.floor())}"
                        : "${pointsFormatter(_conversionRate.ceil())}",

            size: text_font_medium_size,
            color: darkorange,
            weight: FontWeight.w500,
          ),
          TextWidget(
            text: " GEMS POINTS",
            size: text_font_medium_size,
            color: darkorange,
            weight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
  static Future<dynamic> showAlertLoginCred(BuildContext context, message) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          child: Container(
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            height: 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: TextWidget(
                    textAlign: TextAlign.center,
                    text: message,
                    size: 15,
                    weight: FontWeight.bold,
                    color: Colors.grey[700],
                    softwrap: true,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 5),
                  child: Container(
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
                        text: "OK",
                        textAlign: TextAlign.center,
                        color: blue_color,
                        size: text_font_size_small,
                        weight: FontWeight.bold,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
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

  void showInSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
        content: TextWidget(
          // text: "Minimum $_minConversion Smiles point required for conversion",
          text: "Minimum conversion of $_minConversion is required",
          size: text_font_medium14_size,
          weight: FontWeight.w500,
        )));
  }

  void calling(data, pointgained) {
    Internetconnectivity().isConnected().then((result) async {
      ApiconfigSmiles.verifypostTransaction(http.Client(), json.encode(data))
          .then((result) async {
          
        if (result['status'] == true) {
          setState(() {
            _submitLoader = false;
          });
          var req = {
            "membership_no": "${GemsGLobals.membershipNo}",
            "smiles_id": "$_smilesMemberID"
          };
          refreshapi(req,"");
          var dat = {
            "sourceProgramCode": "GEMS",
            "membership_no": "${GemsGLobals.membershipNo}"
          };
          callpointbalanceapi();
          smiles(dat);
          // methodd();
          var reqs = {
            "membership_no": "${GemsGLobals.membershipNo}",
            "smiles_id": "$_smilesMemberID"
          };
          _gemspointsleft = pointgained + GemsGLobals.pointbalance;
          // re(reqs);//unc
          // resul = await Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => NewScreen(vari: vall)));
          bool resul = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SmilesTransactionPendingPage(
                      type: "smilestogems",
                      selectedslidervalue: "${pointsFormatter(_value.toInt())}",
                      gemspointsleft: _gemspointsleft,
                      pointgained: pointgained.toString(),
                    )),
          );

          if (resul == true) {
            var req = {
              "membership_no": "${GemsGLobals.membershipNo}",
              "smiles_id": "$_smilesMemberID"
            };
            refreshapi(req,"");
            var dat = {
              "sourceProgramCode": "GEMS",
              "membership_no": "${GemsGLobals.membershipNo}"
            };
            callpointbalanceapi();
            smiles(dat);
            data = false;
          }
          // methodd();//uncomment
        } else if (result["message"] == "timeout") {
          var notresponding = await Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) => TimeOut()));
          if (notresponding != null) {
            calling(data, pointgained);
          } else {
            setState(() {
              _submitLoader = false;
            });

            //Navigator.pop(context);
          }
          // isDataFound = true;
        } else {
          setState(() {
            _submitLoader = false;
            showAlertLoginCred(context, "Invalid OTP");
          });

        }
      }).catchError((onError) {
        setState(() {
          _submitLoader = false;
        });
        showLoginAlert(context, "Something went wrong,please try again");
      });
    });
  }

  Future<dynamic> sessionAlert(BuildContext context) {
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
                height: 100,
                child: Column(children: <Widget>[
                  Container(
                    //margin: EdgeInsets.only(top: 5),
                    child: TextWidget(
                      text: "Your session has been Expired",
                      size: 15,
                      weight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  // new SizedBox(
                  //   height: 5,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Container(
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
                                text: "Enter Pin",
                                textAlign: TextAlign.center,
                                color: blue_color,
                                size: text_font_size_small,
                                weight: FontWeight.bold,
                              ),
                              onPressed: () async {

                                Navigator.pop(context);
                                vall = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SmilesOtpPage(
                                            // linking: false,
                                            data: "sessionExpire",
                                            smilesid: "$_smilesMemberID",
                                            )));

                                if (vall != null) {
                                  setState(() {
                                    _submitLoader = true;
                                  });
                                  var req = {
                                    "transactionSubType": "OS",
                                    "membership_no":
                                        "${GemsGLobals.membershipNo}",
                                    "smiles_id": "$_smilesMemberID",
                                    "convert_point": _value.toInt(),
                                    // "calculate_point": _roundOffMethod == "Floor"
                                    //     ? equivalentPOint.floor()
                                    //     : equivalentPOint.ceil(),
                                    "calculate_point":
                                        _roundOffMethod == "Floor"
                                            ? equivalentPOint.floor()
                                            : equivalentPOint.ceil(),
                                    "sourceProgramCode": "GEMS",
                                    "targetProgramCode": "SMILES",
                                    "point": gemsPointsFormatter(
                                            GemsGLobals.pointbalance)
                                        .replaceAll(",", ""),
                                    "otp": "$vall"
                                  };
                                  calling(
                                      req,
                                      _roundOffMethod == "Floor"
                                          ? equivalentPOint.floor()
                                          : equivalentPOint.ceil());
                                }
                              
                              }),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 20),
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
                              text: "Cancel",
                              textAlign: TextAlign.center,
                              color: blue_color,
                              size: text_font_size_small,
                              weight: FontWeight.bold,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ))
                    ],
                  ),
                ]))
            // actions: <Widget>[],
            );
      },
    );
  }

  void onsubmitApi(data, pointgained) {
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        ApiconfigSmiles.postTransactionToBlockchain(
                http.Client(), json.encode(data))
            .then((result) async {
          if (result["status"] == true) {
            if (result["message"] == "Success") {
              setState(() {
                _submitLoader = false;
              });
              // resul = await Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => NewScreen(vari: vals)));
              var req = {
                "membership_no": "${GemsGLobals.membershipNo}",
                "smiles_id": "$_smilesMemberID"
              };
              refreshapi(req,"");
              var dat = {
                "sourceProgramCode": "GEMS",
                "membership_no": "${GemsGLobals.membershipNo}"
              };
              callpointbalanceapi();
              smiles(dat);
              _gemspointsleft = GemsGLobals.pointbalance + equivalentPOint;
              bool resul = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SmilesTransactionPendingPage(
                          type: "smilestogems",
                          selectedslidervalue:
                              "${pointsFormatter(_value.toInt())}",
                          gemspointsleft: _gemspointsleft,
                          pointgained: pointgained.toString(),
                        )),
              );
              setState(() {
                if (resul == true) {
                  // methodd();

                  var req = {
                    "membership_no": "${GemsGLobals.membershipNo}",
                    "smiles_id": "$_smilesMemberID"
                  };
                  refreshapi(req,"");
                  var dat = {
                    "sourceProgramCode": "GEMS",
                    "membership_no": "${GemsGLobals.membershipNo}"
                  };
                  callpointbalanceapi();
                  smiles(dat);
                  resul = false;
                }
              });
            } else if (result["messages"] == "OTP Send successfully") {
              setState(() {
                _submitLoader = false;
              });

              sessionAlert(context);
            }
          } else if (result["message"] == "timeout") {
            var notresponding = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => TimeOut()));
            if (notresponding != null) {
              onsubmitApi(data, pointgained);
            } else {
              //Navigator.pop(context);
            }
            // isDataFound = true;
          } else {
            setState(() {
              // _submitLoader = false;
              onsubmitApi(data, pointgained);
            });
          }
        }).catchError((onError) {
          setState(() {
            _submitLoader = false;
          });
          showLoginAlert(context, "Something went wrong,please try again");
        });
      }
    });
  }

  Widget _convertyourpointsbox() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: _submitLoader == true
          ? Container(
              margin: EdgeInsets.only(top: 0),
              child: Center(
                child: SpinKitCircle(
                  color: Colors.blue,
                ),
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () async {
                  var req = {
                    "transactionSubType": "OS",
                    "membership_no": "${GemsGLobals.membershipNo}",
                    "smiles_id": "$_smilesMemberID",
                    "convert_point": _value.toInt(),
                    "calculate_point": _roundOffMethod == "Floor"
                        ? equivalentPOint.floor()
                        : equivalentPOint.ceil(),
                    "sourceProgramCode": "GEMS",
                    "targetProgramCode": "SMILES",
                    "point": gemsPointsFormatter(GemsGLobals.pointbalance)
                        .replaceAll(",", "")
                  };
                  if (_value.toInt() < _minConversion ||
                      availablepoints == false) {
                    setState(() {
                      _submitLoader = false;
                    });

                    showInSnackBar();
                  } else {
                    setState(() {
                      _submitLoader = true;
                    });

                    onsubmitApi(
                        req,
                        _roundOffMethod == "Floor"
                            ? equivalentPOint.floor()
                            : equivalentPOint.ceil());
                  }
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SmilesTransactionPendingPage(type:"smilestogems",
                  //   selectedslidervalue: "${pointsFormatter(_value.toInt())}",gemspointsleft:_gemspointsleft)),
                  // );
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  textStyle: WidgetStateProperty.all(
                      TextStyle(color: Color(0xffffffff))),
                  backgroundColor: WidgetStateProperty.all(boxgreencolor),
                  minimumSize: WidgetStateProperty.all(Size(0, 0)),
                  padding:
                      WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15, top: 15, bottom: 15),
                  child: TextWidget(
                    text: "Convert your Points",
                    color: white_color,
                    size: text_font_medium15_size,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _imagesection() {
    return Container(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            child: Image(
              image: AssetImage(ImageConstants.smilestogems),
              width: 220,
            ),
          ),
        ]),
      ),
    );
  }

  static Future<dynamic> feedbackAlert(BuildContext context, status) {
    return showDialog(
      barrierDismissible: false,
      barrierColor: barrier_color,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Container(
            margin: EdgeInsets.only(top: 25, left: 15, right: 15),
            height: status == true ? 110 : 140,
            child: Column(
              children: <Widget>[
                Container(
                  child: TextWidget(
                    text: status == true
                        ? "Account delinked successfully"
                        : "There is issue in account delinking, please contact administrator.",
                    size: text_font_medium_x_size,
                    weight: FontWeight.w600,
                    color: blackk,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Container(
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        color: boxgreencolor,
                        borderRadius: BorderRadius.circular(10)),
                    child: new TextButton(
                      child: TextWidget(
                        text: "OK",
                        textAlign: TextAlign.center,
                        color: white_color,
                        size: text_font_medium_x_size,
                        weight: FontWeight.bold,
                      ),
                      onPressed: () {
                        if (status == true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TabsScreen(
                                  initialIndex: 0,
                                ),
                              ));
                        } else {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HelpSupport(),
                              ));
                        }
                      },
                    ),
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

  void _delinkAcc(request) {
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        ApiconfigSmiles.delinkProgramAccount(
                http.Client(), json.encode(request))
            .then((res) {
          if (res["status"] == true) {
          } else {
          }
          feedbackAlert(context, res["status"]);
        });
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          _delinkAcc(request);
        }
      }
    });
  }

  Widget _delink() {
    return GestureDetector(
      onTap: () async {
        setState(() {
          var req = {
            "sourceProgramCode": "GEMS",
            "membership_no": "${GemsGLobals.membershipNo}",
            "targetProgramCode": "SMILES",
            // "smiles_id": "${GemsGLobals.etisaladSmilesID}",
            "smiles_id":"$_smilesMemberID"
          };
          _delinkAcc(req);
        });
      },
      child: Container(
        height: 30,
        color: Colors.transparent,
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: 20,
        ),
        child: TextWidget(
          text: "Delink your account",
          color: darkorange,
          size: text_font_medium14_size,
          weight: FontWeight.w500,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _body() {
    return _isLoading == true
        ? Container(
            height: MediaQuery.of(context).size.height - 100,
            child: Center(
              child: SpinKitCircle(
                color: btn_bg_color,
              ),
            ),
          )
        : _nodatafound
            ? ListView(
              shrinkWrap: true,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 2 + 200,
                    child: Center(
                        child: TextWidget(
                      text: "No Data Found",
                      size: 20,
                      color: appbar_color,
                      weight: FontWeight.bold,
                    )),
                  ),
                  Container(child: _delink()),
                ],
              )
            : SingleChildScrollView(
                child: Container(
                   height: MediaQuery.of(context).size.height - 100,
                  // margin: EdgeInsets.only(bottom: 100),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      _imagesection(),
                      _userName(),
                      SizedBox(height: 10),
                      _tabBarsPointsEarning(),
                      SizedBox(height: 40),
                      _slider(),
                      SizedBox(height: 30),
                      if (availablepoints) _earnPoints(),
                      SizedBox(height: 15),
                      _convertyourpointsbox(),
                      SizedBox(height: 5),
                      _delink(),
                      SizedBox(height: 60),
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

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(gradient: gradient_theme_color),
        child: SafeArea(
            bottom: true,
            top: false,
            child: Scaffold(
              extendBody: true,
              backgroundColor: white_color,
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
                                    size: 27,
                                    color: white_text_color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              // margin: EdgeInsets.only(right: 30),
                              child: TextWidget(
                                text: "Smiles To GEMS",
                                size: text_font_medium18_size,
                                weight: FontWeight.w500,
                                color: white_text_color,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                refreshloader = true;
                              });
                              var req = {
                                "membership_no": "${GemsGLobals.membershipNo}",
                                "smiles_id": "$_smilesMemberID"
                              };
                              refreshapi(req,"yes");
                              Timer.periodic(Duration(minutes: 1),
                                  (Timer timer) {
                                setState(() {
                                  var dat = {
                                    "sourceProgramCode": "GEMS",
                                    "membership_no":
                                        "${GemsGLobals.membershipNo}"
                                  };
                                  smiles(dat);
                                  callpointbalanceapi();
                                  refreshloader = false;
                                });
                                timer.cancel();
                              });
                            },
                            child: refreshloader == true
                                ? Container(
                                    height: 30,
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: Center(
                                      child: SpinKitCircle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(right: 10),
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.blue[400],
                                    ),
                                    child: Container(
                                      child: Image.asset(
                                        ImageConstants.refreshbutton,
                                        height: 27,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    )),
              ),
              body: _body(),
              bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
            )));
  }

  @override
  void mypointsbalanceResponseSuccess(MyPointsModel mypointsModel) {
    _pointbalancedata = mypointsModel;
    setState(() {
      if (_pointbalancedata.status == true) {
        AuthUtils.setStringValue("pointbalance",
            gemsPointsFormatter(_pointbalancedata.values.pointBalance));
        GemsGLobals.pointbalance = _pointbalancedata.values.pointBalance;
      } else {
        GemsGLobals.pointbalance = 0;
      }
    });
  }
}
