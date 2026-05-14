
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/appbar_widget.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/point_conversion/airmiles_module/gemtoair_module/model_gemtoair.dart';
import 'package:gems_revamp/point_conversion/airmiles_module/gemtoair_module/presenter_gemtoair.dart';
import 'package:gems_revamp/point_conversion/airmiles_module/gemtoair_module/view_gemtoair.dart';
import 'package:gems_revamp/point_conversion/airmiles_module/transaction_module/pending_transaction_airmiles.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:gems_revamp/utils/time_out.dart';

import '../../../common_widget/bottombar.dart';
import '../../../common_widget/colors_widget.dart';
import '../../../common_widget/font_size.dart';
import '../../../common_widget/numberformat.dart';
import '../../../common_widget/text_widget.dart';
import '../../../makesense_module/makesense_apiconfig.dart';
import '../../../utils/constants_files/color_constants.dart';
import '../../../utils/constants_files/styles_constants.dart';
import '../../../utils/constants_files/text_constants.dart';
import '../../../utils/customloader/custome_circle_loader.dart';
import 'package:http/http.dart' as http;

import '../airmiles_gems_point_conversion/airmilegems_model.dart';

class GemsToAimiles extends StatefulWidget {
  final String? route;
  final List<AirmilesToGem>? gemsToAirmiles;

  const GemsToAimiles({super.key, this.route, this.gemsToAirmiles});
  @override
  _GemsToAimilesState createState() => _GemsToAimilesState();
}

class _GemsToAimilesState extends State<GemsToAimiles>
    implements GemsToAirMilesView {
  int _value = 0;
  int? minGemsPoints;
  var _earnAirMiles;
  var zerogemspoints;
  double equivalentPOint = 0;
  final _gemsAirmilesPointController = TextEditingController();
  bool validateAirmilesNumber = false;
  var gemsAirMilesNumbererror;
  GemsToAirmiles gemstoairdata = GemsToAirmiles();
  GemsToAirmilesPresenter? _gemtoairpresenter;
  bool _gemtoairmilesloader = false;
  var gemstoairmilesresponse;
  var _gemsPointsLeft;
  int? _userGemsPoints;
  bool gemsPointsError = false;
  AirmilesToGem? airmilesToGemPoints;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    findMinimumGemsPoints();

    zerogemspoints = "${pointsFormatter(0)}";
    _gemtoairpresenter = GemsToAirmilesPresenter(this);

    _userGemsPoints = int.tryParse(
        gemsPointsFormatter(GemsGLobals.pointbalance).replaceAll(",", ""));
    _gemsPointsLeft = GemsGLobals.pointbalance - _value;

    makesenseEventCall();
    GemsGLobals.lastVisitPageName = GemsGLobals.gemsToAirmilesPage;
  }

  void findMinimumGemsPoints() {
    if (widget.gemsToAirmiles != null && widget.gemsToAirmiles!.isNotEmpty) {
      minGemsPoints = widget.gemsToAirmiles!
          .map((e) => e.gemsPoints)
          .reduce((a, b) => a < b ? a : b);
      setState(() => _isLoading = false);
    } else {
      minGemsPoints = null;
      setState(() => _isLoading = false);
    }
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

  makesenseEventPointExchnageFailedCall() {
    String keyName = GemsGLobals.eventPointExchangeFailed;
    var segmentReq = {
      GemsGLobals.partner: GemsGLobals.airMiles,
      GemsGLobals.fromCurrencyParam: GemsGLobals.appCurrency,
    GemsGLobals.toCurrencyParam: GemsGLobals.appCurrency,
    GemsGLobals.conversionRateParam: GemsGLobals.gemstoAirMilesConvRate,
    GemsGLobals.amtConvertedParam: _value,
    GemsGLobals.amtCreditedParam: _earnAirMiles,
    GemsGLobals.reason: gemsAirMilesNumbererror,
    GemsGLobals.intSource: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

makesenseEventPointExchnageSuccessfulCall() {
    String keyName = GemsGLobals.eventPointExchangeSuccessful;
    var segmentReq = {
      GemsGLobals.partner: GemsGLobals.airMiles,
      GemsGLobals.fromCurrencyParam: GemsGLobals.appCurrency,
    GemsGLobals.toCurrencyParam: GemsGLobals.appCurrency,
     GemsGLobals.conversionRateParam: GemsGLobals.gemstoAirMilesConvRate,
    GemsGLobals.amtConvertedParam: _value,
    GemsGLobals.amtCreditedParam: _earnAirMiles,
    GemsGLobals.intSource: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }


  void callgemstoairmilesapi() {
    var request = {
      "membership_no": GemsGLobals.membershipNo,
      // "gems_customer_id": GemsGLobals.userId??"8047578798",
      // "user_type": GemsGLobals.userType ?? "parent",
      "point_balance": _userGemsPoints,
      // "air_miles_no": "738393",
      "air_miles_no": _gemsAirmilesPointController.text,
      // "conversion": 2,
      "conversion": GemsGLobals.gemstoAirMilesConvRate,
      "gems_points": _value.floor().toString(),
      "air_miles_points": _earnAirMiles.floor().toString(),
      "transaction_type": "GemsToAirmiles"
    };
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _gemtoairpresenter!.gemsToAirmilesAPI(request);
      } else {
        bool connectionResult = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (connectionResult == null) {
          Navigator.pop(context);
        }
        if (connectionResult) {
          setState(() {});
          _gemtoairpresenter!.gemsToAirmilesAPI(request);
        }
      }
    });
  }

  proceedforgemstoAirMilesTransaction(BuildContext context) {
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
                          _gemtoairmilesloader == false
                              ? Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1.0,
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(3)),
                                  child: new MaterialButton(
                                    child: _gemtoairmilesloader == false?
                                         TextWidget(
                                            text: GemsGLobals.yesText,

                                            textAlign: TextAlign.center,
                                            size: text_font_size_small,
                                            weight: FontWeight.bold,
                                          )
                                        : SpinKitCircle(
                                            size: 35,
                                            color: btn_bg_color,
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        _gemtoairmilesloader = true;
                                        callgemstoairmilesapi();
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

  Widget _imagesection() {
    return Container(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            child: Image(
              image: AssetImage(ImageConstants.gemsToAirmiles),
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
                          text: _userGemsPoints.toString(),
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

  Widget _airmilesNumber() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextWidget(
            text: "Air Miles Number",
            size: text_font_medium16_size,
            color: greyshade_color,
          ),
          new SizedBox(
            height: 10,
          ),
          Container(
            height: 40,
            width: 300,
            decoration: BoxDecoration(
                border: Border.all(width: 0.5, color: grey_gunsmoke_text_color),
                borderRadius: BorderRadius.circular(4)),
            child: TextFormField(
              controller: _gemsAirmilesPointController,
              onChanged: (value) {
                setState(() {
                  setState(() {
                    validateAirmilesNumber = false;
                  });
                });
              },
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
              ],
              maxLength: 13,
              decoration: InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10, bottom: 5)),
            ),
          ),
          Container(
              alignment: Alignment.bottomLeft,
              margin: EdgeInsets.only(right: 10, top: 5),
              child: TextWidget(
                text: "E.g. 274XXXXXXXXXX",
                color: blackshade_color,
              )),
          validateAirmilesNumber
              ? Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 5, top: 5),
                  child: TextWidget(
                      text: gemsAirMilesNumbererror.toString(),
                      color: Colors.red),
                )
              : Container(height: 0),
          new SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _slider() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 2.0, color: Colors.transparent),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 0),
                child: TextWidget(
                  text: GemsGLobals.selectGemsPointsToBeConvert,
                  color: grey_color,
                  size: text_font_medium_x_size,
                ),
              )),
          new SizedBox(
            height: 20,
          ),
          Container(
              width: 120,
              child: DropdownMenu<AirmilesToGem>(
                initialSelection: airmilesToGemPoints,
                hintText: GemsGLobals.selectText,
                onSelected: (AirmilesToGem? newValue) {
                  setState(() {
                    airmilesToGemPoints = newValue;
                    _value = newValue?.gemsPoints ?? 0;
                    _earnAirMiles = newValue?.airmiles ?? 0;
                    _gemsPointsLeft = GemsGLobals.pointbalance - _value;
                  });
                },
                dropdownMenuEntries: widget.gemsToAirmiles?.map((item) {
                      return DropdownMenuEntry<AirmilesToGem>(
                        value: item,
                        label: '${item.gemsPoints}',
                      );
                    }).toList() ??
                    [],
                menuStyle: const MenuStyle(
                  alignment: Alignment.bottomLeft,
                ),
              )),
          new SizedBox(
            height: 10,
          ),
          gemsPointsError == true && airmilesToGemPoints == null
              ? Container(
                  child: Center(
                  child: TextWidget(
                      text: GemsGLobals.selectPointErrorText,
                      color: red_color,
                      textAlign: TextAlign.center,
                      size: text_font_size_small),
                ))
              : Container(
                  height: 0,
                ),
          Padding(
            padding: EdgeInsets.only(
              top: 20,
            ),
            child: airmilesToGemPoints == null
                ? Container(height: 0)
                : Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Container(
                            child: TextWidget(
                              text: GemsGLobals.selectedGemsPoints +
                                  "${pointsFormatter(_value.toInt())}",
                              alignment: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
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
            color: purchase_text_color,
            weight: FontWeight.w500,
          ),
          new SizedBox(
            width: 5,
          ),
          TextWidget(
            text: "${(_earnAirMiles ?? 0).floor()}${GemsGLobals.airmilesText} ",
            size: text_font_medium_size,
            color: darkorange,
            weight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _convertyourpointsbox() {
    final bool isButtonDisabled = _userGemsPoints == 0 ||
        _value > (_userGemsPoints ?? 0) ||
        (_userGemsPoints ?? 0) < (minGemsPoints ?? 0);

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: isButtonDisabled
              ? null
              : () async {
                  airmileNumberValidation();
                },
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            textStyle: WidgetStateProperty.all(TextStyle(color: white_color)),
            backgroundColor: WidgetStateProperty.all(
                isButtonDisabled ? AppColors.grey : boxgreencolor),
            minimumSize: WidgetStateProperty.all(Size(0, 0)),
            padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15, top: 15, bottom: 15),
            child: TextWidget(
              text: GemsGLobals.convertYourPoints,
              color: white_color,
              size: text_font_medium15_size,
              weight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void airmileNumberValidation() {
    setState(() {
      if (airmilesToGemPoints == null) {
        gemsPointsError = true;
      }
      if (_gemsAirmilesPointController.text.length == 0) {
        validateAirmilesNumber = true;
        gemsAirMilesNumbererror = "Please enter Air Miles Number";
      } else if (_gemsAirmilesPointController.text.length < 13) {
        validateAirmilesNumber = true;
        gemsAirMilesNumbererror = "Please enter valid Air Miles number";
      } else if (_gemsAirmilesPointController.text.startsWith("2741") != true &&
          _gemsAirmilesPointController.text.startsWith("2742") != true &&
          _gemsAirmilesPointController.text.startsWith("2743") != true) {
        validateAirmilesNumber = true;
        gemsAirMilesNumbererror = "Please enter valid Air Miles number";
      } else {
        gemsPointsError = false;
        validateAirmilesNumber = false;
        proceedforgemstoAirMilesTransaction(context);
      }
    });
  }

  Widget _body() {
    final hasMinimumPoints = _userGemsPoints != null && minGemsPoints != null
        ? _userGemsPoints! >= minGemsPoints!
        : false;

    final hasEnoughToTransfer =
        hasMinimumPoints && (_value <= (_userGemsPoints ?? 0));
    final selectedMoreThanAvailable = (_value > (_userGemsPoints ?? 0));
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              _imagesection(),
              _userName(),
              SizedBox(height: 10),
              _tabBarsPointsEarning(),
              SizedBox(height: 15),

              if (hasEnoughToTransfer) _airmilesNumber(),

              SizedBox(height: 20),

              if (!hasMinimumPoints)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: RichText(
                          text: TextSpan(
                            text: AppTexts.minimumText,
                            style: AppTheme.interRed14Regular,
                            children: [
                              TextSpan(
                                text: ' $minGemsPoints ',
                                style: AppTheme.interRed14Regular,
                              ),
                              TextSpan(
                                text: AppTexts.pointsText,
                                style: AppTheme.interRed14Regular,
                              ),
                              TextSpan(
                                text: AppTexts.initiatedText,
                                style: AppTheme.interRed14Regular,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),

              if (hasMinimumPoints) _slider(),

              Column(
                children: [
                  SizedBox(height: 15),

                  if (hasEnoughToTransfer) _earnPoints(),

                  if (selectedMoreThanAvailable)
                    Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: RichText(
                            text: TextSpan(
                              text:
                                  AppTexts.insufficientGemsPointsText,
                              style: AppTheme.interRed14Regular,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),

                  SizedBox(height: 25),
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
                              fontSize: text_font_medium14_size,
                            ),
                          ),
                          TextSpan(
                            text:
                                GemsGLobals.exchangeInstructionsGemsToAirmiles,
                            style: TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                              fontSize: text_font_medium14_size,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: GemsGLobals.gemsToMilesConvertInfo
                    .map<Widget>((text) => Padding(
                          padding: const EdgeInsets.only(left: 30, bottom: 10),
                          child: Text(
                            '• $text',
                            style: AppTheme.blackColorStyle14
                          ),
                        ))
                    .toList(),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _tabbar() {
    return Container(
      width: MediaQuery.of(context).size.width,
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
                    title: AppTexts.gemsToAirmilesText,
                    color: white_text_color,
                    size: text_font_medium18_size,
                    weight: FontWeight.w500,
                    centerTitle: true,
                    height: 90,
                  ),
                ),
                body: _isLoading ||
                        _userGemsPoints == null ||
                        minGemsPoints == null
                    ? Center(child: CircularProgressIndicator())
                    : _body(),
                bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
              ),
            )));
  }

  @override
  void gemstoairmilesFailure(error) {
    if (error == "timeout") {
      setState(() {
        _gemtoairmilesloader = false;
      });
      makesenseEventPointExchnageFailedCall();  
    }
  }

  @override
  void gemstoairmilesResponseSuccess(GemsToAirmiles gemstoairmilesModel) {
    gemstoairmilesresponse = gemstoairmilesModel;
    setState(() {
      if (gemstoairmilesModel.status == true) {
        _gemtoairmilesloader = false;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AirMilesTransactionPendingPage(
                  type: "gemstoairmiles",
                  selectedslidervalue: "${pointsFormatter(_value.toInt())}",
                  gemspointsleft: _gemsPointsLeft,
                  totalairmiles: _earnAirMiles,
                  )),
        );
        Fluttertoast.showToast(
          msg: gemstoairmilesModel.message ?? '',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: AppColors.black,
          fontSize: 16.0,
        );

        makesenseEventPointExchnageSuccessfulCall();
      } else {
        Fluttertoast.showToast(
          msg: gemstoairmilesModel.message ?? '',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          textColor: AppColors.black,
          fontSize: 16.0,
        );
      }
    });
  }

  @override
  Future<void> timeOutError(String error) async {
    if (error == "timeout") {
      setState(() {
        _gemtoairmilesloader = false;
      });
      bool isRetry = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => TimeOut()));
      if (isRetry && isRetry != null) {
        callgemstoairmilesapi();
      }
    }
  }
}
