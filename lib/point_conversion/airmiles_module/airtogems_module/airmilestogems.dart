/* Author : Sanjana Shetty
 Date created : 2-May-2022
 Discription : Airmiles To Gems Page*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/point_conversion/airmiles_module/airtogems_module/model_airtogem.dart';
import 'package:gems_revamp/point_conversion/airmiles_module/airtogems_module/presenter_airtogem.dart';
import 'package:gems_revamp/point_conversion/airmiles_module/airtogems_module/view_airtogem.dart';
import 'package:gems_revamp/point_conversion/airmiles_module/transaction_module/pending_transaction_airmiles.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/color_constants.dart';
import 'package:gems_revamp/utils/constants_files/styles_constants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:gems_revamp/utils/time_out.dart';
import 'package:http/http.dart' as http;
import '../../../common_widget/bottombar.dart';
import '../../../common_widget/colors_widget.dart';
import '../../../common_widget/font_size.dart';
import '../../../common_widget/text_widget.dart';
import '../../../utils/constants_files/imageconstants.dart';
import '../airmiles_gems_point_conversion/airmilegems_model.dart';

class AimilesToGems extends StatefulWidget {
  final String? route;
  final List<AirmilesToGem>? airmilesToGems;

  const AimilesToGems({super.key, this.route, this.airmilesToGems});
  @override
  _AimilesToGemsState createState() => _AimilesToGemsState();
}

class _AimilesToGemsState extends State<AimilesToGems>
    implements AirMilesToGemsView {
  var data = 1;
  List<TextEditingController> _airMilesPointController = [];
  List<TextEditingController> _gemsPointController = [];
  var _voucherError = [];
  var _amountError = [];
  var samevoucher = "";
  var airmilesvalue;
  var _airmilesDataNumber;
  var dublicateValueIndex;
  var _gemsPoints;
  bool _airmilestogemsloader = false;
  var airmilestogemsresponse;
  bool _noError = false;
  AirmilesToGems corpcarddata = AirmilesToGems();
  AirmilesToGemsPresenter? _airmilespresenter;
  bool back = true;
  List airmilesNumberDataList = [];
  var _userGemsPoints;
  int passdata = 0;
  AirmilesToGem?  airmilesToGemPoints;
  int selectedAirmilesPoints=0;

  @override
  void initState() {
    super.initState();
    _userGemsPoints =
        gemsPointsFormatter(GemsGLobals.pointbalance).replaceAll(",", "");
    _airmilespresenter = AirmilesToGemsPresenter(this);
    for (int i = 0; i < 20; i++) {
      _airMilesPointController.add(TextEditingController());
      _airMilesPointController[i].addListener(onairmilesToGemsChange);
      _voucherError.add(null);
    }
    for (int i = 0; i < 20; i++) {
      _gemsPointController.add(TextEditingController());
      _gemsPointController[i].addListener(onGemsChange);
      _amountError.add(null);
    }
   makesenseEventCall();
    GemsGLobals.lastVisitPageName = GemsGLobals.airmilesToGemsPage;
  }

   makesenseEventCall() {
    String keyName = GemsGLobals.eventPointExchangePage;
    var segmentReq = {
      GemsGLobals.partner: GemsGLobals.airMiles,
      GemsGLobals.fromCurrencyParam: GemsGLobals.appCurrency,
    GemsGLobals.toCurrencyParam: GemsGLobals.appCurrency,
    GemsGLobals.conversionRateParam: GemsGLobals.gemstoAirMilesConvRate,
    GemsGLobals.intSource: GemsGLobals.lastVisitPageName
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  makesenseEventPointExchnageFailedCall(amtConvertedParam,amtCreditedParam) {
    String keyName = GemsGLobals.eventPointExchangeFailed;
    var segmentReq = {
      GemsGLobals.partner: GemsGLobals.airMiles,
      GemsGLobals.fromCurrencyParam: GemsGLobals.appCurrency,
    GemsGLobals.toCurrencyParam: GemsGLobals.appCurrency,
    GemsGLobals.conversionRateParam: GemsGLobals.gemstoAirMilesConvRate,
    GemsGLobals.amtConvertedParam: amtConvertedParam,
    GemsGLobals.amtCreditedParam: amtCreditedParam,
    GemsGLobals.reason: GemsGLobals.selectPointErrorText,
    GemsGLobals.intSource: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

makesenseEventPointExchnageSuccessfulCall(amtConvertedParam,amtCreditedParam) {
    String keyName = GemsGLobals.eventPointExchangeSuccessful;
    var segmentReq = {
      GemsGLobals.partner: GemsGLobals.airMiles,
      GemsGLobals.fromCurrencyParam: GemsGLobals.appCurrency,
    GemsGLobals.toCurrencyParam: GemsGLobals.appCurrency,
     GemsGLobals.conversionRateParam: GemsGLobals.gemstoAirMilesConvRate,
    GemsGLobals.amtConvertedParam: amtConvertedParam,
    GemsGLobals.amtCreditedParam: amtCreditedParam,
    GemsGLobals.intSource: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  void onairmilesToGemsChange() {
    for (int i = 0; i < _airMilesPointController.length; i++) {
      if (_airMilesPointController[i].text.length >= 1) {
        var _airmilesToGems = _airMilesPointController[i].text;
        if (_airmilesToGems[0] == " ") {
          _airMilesPointController[i].text = "";
        }
      }
    }
  }

  void onGemsChange() {
    for (int i = 0; i < _gemsPointController.length; i++) {
      if (_gemsPointController[i].text.length >= 1) {
        var _gemspoints = _gemsPointController[i].text;
        if (_gemspoints[0] == " ") {
          _gemsPointController[i].text = "";
        }
      }
    }
  }

  void airmilestogemsapi() {
    // _airmilesConversionRequest = {
    //           "gems_customer_id": GemsGLobals.userId.toString(),
    //           "user_type": GemsGLobals.userType,
    //           "point_balance": _userGemsPoints.toString(),
    //           "vouchers_details": airmilesNumberDataList,
    //           "transaction_type": "AirmilesToGems"
    //         };
    var request = {
      "membership_no": GemsGLobals.membershipNo ?? "2347578791",
      "gems_customer_id": GemsGLobals.userId ?? "8047578798",
      "user_type": GemsGLobals.userType ?? "parent",
      "point_balance": _userGemsPoints,
      "vouchers_deatails": airmilesNumberDataList,
      "transaction_type": "AirmilesToGems"
    };

    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _airmilespresenter!.airmilesTogemsAPI(request);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          setState(() {});
          _airmilespresenter!.airmilesTogemsAPI(request);
        }
      }
    });
  }

  Widget _imagesection() {
    return Container(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            child: Image(
              image: AssetImage(ImageConstants.airmilesToGems),
              width: 220,
            ),
          ),
        ]),
      ),
    );
  }

  Widget _userName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: TextWidget(
            text:
                '${GemsGLobals.userFirstName ?? "Farhan"}  ${GemsGLobals.userLastName ?? "Shaikh"}',
            size: text_font_medium_size,
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
                          size: text_font_medium16_size,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: TextWidget(
                          // text: "$_custId",
                          text: _userGemsPoints,
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
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            color: Colors.grey[350],
            width: 0.5,
          ),
          ],
      ),
    );
  }

  Widget _voucherAdd() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 5),
      child: Column(
        children: _structure(),
      ),
    );
  }

  List<Widget> _structure() {
    List<Widget> _listdata = [];
    for (var i = 0; i < data; i++) {
      _listdata.add(Container(
        margin: EdgeInsets.only(bottom: 5, top: 5),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextWidget(
                        text: "Air Miles E-voucher codes",
                        color: greyshade_color,
                        size: text_font_small,
                        weight: FontWeight.w500,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 2.1,
                        decoration: BoxDecoration(
                            color: white_color,
                            border: Border.all(width: 1.5, color: grey_border),
                            borderRadius: BorderRadius.circular(7)),
                        child: TextFormField(
                          controller: _airMilesPointController[i],
                          maxLength: 12,
                          onChanged: (value) {
                            _airmilesDataNumber = value;
                            _voucherError[i] = null;
                            for (int i = 0; i < data; i++) {
                              for (int j = i + 1; j < data; j++) {
                                if (_airMilesPointController[j].text ==
                                    _airMilesPointController[i].text) {
                                  setState(() {
                                    dublicateValueIndex = j;
                                    samevoucher =
                                        "E-Voucher codes cannot be duplicate";
                                  });
                                } else {
                                  setState(() {
                                    samevoucher = '';
                                  });
                                }
                              }
                            }
                          },
                          inputFormatters: [
                            new FilteringTextInputFormatter.allow(
                                RegExp("[a-zA-Z0-9]")),
                          ],
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              counterText: "",
                              contentPadding:
                                  EdgeInsets.only(left: 10, bottom: 5)),
                        ),
                      ),
                      new SizedBox(
                        height: 3,
                      ),
                      _voucherError[i] != null
                          ? Container(
                              child: TextWidget(
                                  text: _voucherError[i],
                                  color: red_color,
                                  textAlign: TextAlign.center,
                                  size: text_font_size_xx_small),
                            )
                          : _amountError[i] != null
                              ? Container(height: 15)
                              : Container(
                                  height: 0,
                                ),
                    ],
                  ),
                ),
                new SizedBox(
                  width: 20,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextWidget(
                        text: "GEMS Points",
                        color: greyshade_color,
                        size: text_font_small,
                        weight: FontWeight.w500,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                          color: white_color,
                          border: Border.all(width: 1.5, color: grey_border),
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: DropdownButtonFormField<AirmilesToGem>(
                          value: airmilesToGemPoints,
                          hint: Text(" " + GemsGLobals.selectText),
                          items: widget.airmilesToGems?.map((item) {
                            return DropdownMenuItem<AirmilesToGem>(
                              value: item,
                              child: Text(
                                  " ${item.gemsPoints}"),
                            );
                          }).toList(),
                          onChanged: (AirmilesToGem? newValue) {
                            setState(() {
                              _gemsPointController[i].text =
                                  newValue?.gemsPoints.toString() ?? '';
                              _gemsPoints = newValue?.gemsPoints.toString();
                              _amountError[i] = null;
                              selectedAirmilesPoints=newValue?.airmiles ?? 0;
                            });
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.only(left: 10, bottom: 10, right: 5),
                          ),
                          dropdownColor: white_color,
                          style: AppTheme.blackColorStyle
                        ),
                      ),

                      new SizedBox(
                        height: 3,
                      ),
                      _amountError[i] != null
                          ? Container(
                              child: Center(
                              child: TextWidget(
                                  text: _amountError[i],
                                  color: red_color,
                                  textAlign: TextAlign.center,
                                  size: text_font_size_xx_small),
                            ))
                          : _voucherError[i] != null
                              ? Container(
                                  height: 15,
                                )
                              : Container(height: 0),
                    ],
                  ),
                ),
                new SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _airMilesPointController.removeAt(i);
                      _gemsPointController.removeAt(i);
                      data--;
                    });
                  },
                  child: i == 0
                      ? Container(height: 0)
                      : Container(
                          margin: EdgeInsets.only(top: 25),
                          height: 23,
                          width: 23,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 0.5, color: grey_gunsmoke_text_color)),
                          child: Center(
                            child: Icon(
                              Icons.remove,
                              size: 15,
                              color: greenishicon_color,
                            ),
                          ),
                        ),
                )
              ],
            ),
            samevoucher != '' && dublicateValueIndex == i
                ? Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 0, top: 3),
                    child: TextWidget(
                      text: samevoucher,
                      color: red_color,
                    ),
                  )
                : Container(
                    height: 0,
                  ),
          ],
        ),
      ));
    }

    return _listdata;
  }

  Widget _addEvoucher() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (data != 10) {
            data++;
          } else {}
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 10),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: SvgPicture.asset(ImageConstants.plus),
            ),
            new SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: TextWidget(
                text: "Add more E-Voucher",
                color: black_color,
                size: text_font_small,
                weight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _convertyourpointsbox() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () async {
            onsubmit();
          },
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            textStyle:
                WidgetStateProperty.all(TextStyle(color: Color(0xffffffff))),
            backgroundColor: WidgetStateProperty.all(boxgreencolor),
            minimumSize: WidgetStateProperty.all(Size(0, 0)),
            padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
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

  void onsubmit() {
    for (int i = 0; i < data; i++) {
      if (_airMilesPointController[i].text.startsWith("EV") != true &&
          _airMilesPointController[i].text.length != 0) {
        setState(() {
          _voucherError[i] = "voucher code should start with EV";
        });
      } else {
        if (_airMilesPointController[i].text.length >= 3 &&
            _airMilesPointController[i].text.length <= 12) {
          var _airmilesToGems = _airMilesPointController[i].text;
          if (_airmilesToGems[0] == " ") {
            _airMilesPointController[i].text = "";
          }
          setState(() {
            _voucherError[i] = null;
          });
        } else if (_airMilesPointController[i].text.length < 3 &&
            _airMilesPointController[i].text.length >= 1) {
          setState(() {
            _voucherError[i] = "please enter minimum 3 characters";
          });
        } else {
          setState(() {
            _voucherError[i] = "please enter voucher code";
          });
        }
      }
    }
    for (int i = 0; i < data; i++) {
      if (_gemsPointController[i].text.length >= 1) {
        var _gemspoints = _gemsPointController[i].text;
        if (_gemspoints[0] == " ") {
          _gemsPointController[i].text = "";
        }
        setState(() {
          _amountError[i] = null;
        });
      } else {
        setState(() {
          _amountError[i] = GemsGLobals.selectPointErrorText;
        });
      }
    }
    for (int i = 0; i < data; i++) {
      if (_voucherError[i] == null && _amountError[i] == null) {
        setState(() {
          _noError = true;
        });
      } else {
        setState(() {
          _noError = false;
        });
        break;
      }
    }
    if (_noError == true) {
      for (int i = 0; i < data; i++) {
        for (int j = i + 1; j < data; j++) {
          if (_airMilesPointController[j].text ==
              _airMilesPointController[i].text) {
            setState(() {
              dublicateValueIndex = j;
              samevoucher = "E-Voucher codes cannot be duplicate";
            });
          }
        }
      }
    }

    if (_noError == true && samevoucher == '') {
      // var _userGemsPoints =
      //     GemsGLobals.userGEMSpoints.replaceAll(",", "");
      passdata = 0;
      airmilesNumberDataList.clear();
      for (int i = 0; i < data; i++) {
        var _airmilesVoucherCode = _airMilesPointController[i].text;
        var _gemsPoints = _gemsPointController[i].text;
        airmilesNumberDataList.add({
          "voucher_code": _airmilesVoucherCode,
          "voucher_points": _gemsPoints
        });

        passdata = passdata + int.parse(_gemsPointController[i].text);
      }

      setState(() {
        proceedforAirMilestogemsTransaction(context);
      });
    }
  }

  proceedforAirMilestogemsTransaction(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                // margin: EdgeInsets.only(top: 25, left: 15, right: 15),
                height: 95,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextWidget(
                        text: "Are you sure you want to",
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
                        text: "proceed?",
                        size: text_font_size_small,
                        weight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          // Container(
                          //   height: 35,
                          //   decoration: BoxDecoration(
                          //       border: Border.all(
                          //         width: 1.0,
                          //         color: blue_color,
                          //       ),
                          //       borderRadius: BorderRadius.circular(3)),
                          //   child: new TextButton(
                          //     child: TextWidget(
                          //       text: "No",
                          //       textAlign: TextAlign.center,
                          //       color: blue_color,
                          //       size: text_font_size_small,
                          //       weight: FontWeight.bold,
                          //     ),
                          //     onPressed: () {
                          //       Navigator.of(context).pop();
                          //     },
                          //   ),
                          // ),
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
                                  // color: blue_color,
                                  alignment: TextAlign.center,
                                  size: 12,
                                  weight: FontWeight.bold),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                          ),
                          _airmilestogemsloader == false
                              ? Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1.0,
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(3)),
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(
                                  //       width: 1.0,
                                  //       color: blue_color,
                                  //     ),
                                  //     borderRadius: BorderRadius.circular(3)),
                                  child: new MaterialButton(
                                    child: TextWidget(
                                      text: "Yes",
                                      textAlign: TextAlign.center,
                                      // color: blue_color,
                                      size: text_font_size_small,
                                      weight: FontWeight.bold,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _airmilestogemsloader = true;
                                        airmilestogemsapi();
                                      });
                                    },
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0.0, right: 0, bottom: 5),
                                  child: Container(
                                    height: 30,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1.0,
                                          color: Colors.white,
                                          //  color: Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(3)),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 26.0, right: 26, bottom: 0),
                                      child: Center(
                                        child: SpinKitCircle(
                                          size: 35,
                                          color: btn_bg_color,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }));
      },
    );
  }
  Widget _body() {
    return Column(
      children: [
        Expanded(
            child: ListView(
          children: [
            _imagesection(),
            _userName(),
            SizedBox(height: 10),
            _tabBarsPointsEarning(),
            new SizedBox(
              height: 20,
            ),
            _voucherAdd(),
            new SizedBox(
              height: 10,
            ),
            _addEvoucher(),
            new SizedBox(
              height: 120,
            ),
            _convertyourpointsbox(),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: GemsGLobals.noteText,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontSize: text_font_medium14_size),
                    ),
                    TextSpan(
                      text: GemsGLobals.exchangeInstructionsAirmilesToGems,
                      style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                          fontSize: text_font_medium14_size),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: GemsGLobals.pointsConvertInfo
                  .map<Widget>((text) => Padding(
                        padding: const EdgeInsets.only(left: 30, bottom: 10),
                        child: Text(
                          '• $text',
                          style: TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                          fontSize: text_font_medium14_size),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ))
      ],
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
                extendBody: true,
                backgroundColor: white_color,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(90.0),
                  child: GradientAppBar(
                    title: GemsGLobals.airMilesToGemsHeading,
                    color: white_text_color,
                    size: text_font_medium18_size,
                    weight: FontWeight.w500,
                    centerTitle: true,
                    height: 90,
                  ),
                ),
                body: _body(),
                bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
              ),
            )));
  }

  @override
  Future<void> airmilestogemsFailure(error) async {
    setState(() {
      _airmilestogemsloader = false;
      makesenseEventPointExchnageFailedCall(airmilesvalue,_gemsPoints);  
    });
    bool isRetry = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TimeOut()));
    if (isRetry && isRetry != null) {
      airmilestogemsapi();
    }
  }

  @override
  void airmilestogemsResponseSuccess(AirmilesToGems airmilestogemsModel) {
    airmilestogemsresponse = airmilestogemsModel;
    setState(() {
      if (airmilestogemsresponse.status == true) {
        _airmilestogemsloader = false;
        makesenseEventPointExchnageSuccessfulCall(airmilesvalue,_gemsPoints);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AirMilesTransactionPendingPage(
              type: "airmilestogems",
              totalairmiles: passdata,
              selectedAirmilesPoints: selectedAirmilesPoints,
            ),
          ),
        );
         Fluttertoast.showToast(
          msg: airmilestogemsModel.message ?? '',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: AppColors.black,
          fontSize: 16.0,
        );
      }
      else{
         Fluttertoast.showToast(
          msg: airmilestogemsModel.message ?? '',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: AppColors.black,
          fontSize: 16.0,
        );
      }
      
    });
  }

  @override
  void timeOutError(String error) {
    setState(() {
      _airmilestogemsloader = false;
    });
  }
}
