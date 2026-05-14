/* Author : Sanjana Shetty
 Date created : 05-May-2022
 Discription : Smiles Otp Page*/

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gems_revamp/point_conversion/smiles_module/apiconfig/apiconfig_smiles.dart';
import 'package:gems_revamp/point_conversion/smiles_module/switch_options_smiles.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:gems_revamp/utils/time_out.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widget/appbar_widget.dart';
import '../../common_widget/bottombar.dart';
import '../../common_widget/colors_widget.dart';
import '../../common_widget/font_size.dart';
import '../../common_widget/text_widget.dart';
import '../../utilities/auth_utils.dart';
import '../../utils/constants_files/imageconstants.dart';
import '../../utils/customloader/custome_circle_loader.dart';
import '../../utils/gemsGlobals.dart';

class SmilesOtpPage extends StatefulWidget {
  final data;
  final linking;
  final smilesid;
  @override
  _SmilesOtpPageState createState() => _SmilesOtpPageState();
  SmilesOtpPage({Key? key, this.data, this.linking, this.smilesid})
      : super(key: key);
}

class _SmilesOtpPageState extends State<SmilesOtpPage>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _controller = new TextEditingController();
  final firstotp = TextEditingController();

  final twootp = TextEditingController();
  final threeopt = TextEditingController();
  final fourotp = TextEditingController();
  final fiveotp = TextEditingController();
  GlobalKey<ScaffoldState>? _key;
  String currentText = "";
  bool goahead = false;
  bool clicked = false;

  FocusNode fp1 = FocusNode();
  FocusNode fp2 = FocusNode();
  FocusNode fp3 = FocusNode();
  FocusNode fp4 = FocusNode();
  FocusNode fp5 = FocusNode();
  bool saving = false;

  var totalotp;
  bool isvalid = false;
  var mobileNo = "+71 9975175954";
  var userData;
  var _isLoading = false;
  var noConnection;
  bool checktap = false;

  Future<SharedPreferences> _userdatata = SharedPreferences.getInstance();
  SharedPreferences? _data;
  Future<String> _getuserdata(_sharedPreferences, _userdatata) async {
    _data = await _userdatata;
    var custData = AuthUtils.getuserData(_data!);
    return custData;
  }

  @override
  void initState() {
    clicked = false;
    super.initState();
    //  WidgetsBinding.instance!.addObserver(this);

    goahead = false;
    _getuserdata(_data, _userdatata).then((result) {
      setState(() {
        userData = jsonDecode(result);
      });
    });
    if (this.widget.linking == true) {
      // calltimer();
    }
    if (this.widget.linking == false) {
      // calltimerforsmilestogems();
    }
  }

  @override
  void dispose() {
    super.dispose();
    // WidgetsBinding.instance?.removeObserver(this);
    FocusScope.of(context).requestFocus();
  }

  @override
  void didChangeMetrics() {
    final value = MediaQuery.of(context).viewInsets.bottom;
    if (value > 0) {
      setState(() {
        FocusScope.of(context).requestFocus(new FocusNode());
      });
    }
  }

  launchURL(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      }else {
      throw 'Could not launch $url';
    }
  }

  void showSnack() {
    final snackBar = new SnackBar(
      backgroundColor: blue_color,
      content: TextWidget(
        text: "OTP has been sent to you.",
        size: text_font_medium18_size,
      ),
      duration: new Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  validate(value) {
    var otp = _controller.text;

    if (otp.length == 0 || (otp.length >= 1 && otp.length < 5)) {
      setState(() {
        isvalid = true;
        _isLoading = false;
      });
    } else {
      if (otp.length == 5) {
        setState(() {
          isvalid = false;
          _isLoading = true;
          fnfOtp(otp);
        });
      }
    }

    return isvalid;
  }

  void fnfOtp(otp) {
    var otpdata = {
      "sourceProgramCode": "GEMS",
      "membership_no": "${GemsGLobals.membershipNo}",
      "targetProgramCode": "SMILES",
      "smiles_id": widget.smilesid != null && widget.smilesid != ""
          ? widget.smilesid
          : "${GemsGLobals.etisaladSmilesID}",
      "otp": "$otp",
      "operation": "V"
    };

    Internetconnectivity().isConnected().then((isConnected) async {
      if (isConnected) {
// _isLoading = true;
        if (this.widget.data == "sessionExpired" ||
            this.widget.data == "sessionExpire") {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop("$otp");
        } else {
          ApiconfigSmiles.linkOtpVerify(http.Client(), json.encode(otpdata))
              .then((result) async {
            setState(() {
              _isLoading = false;
            });

            if (result["status"] == true) {
              if (this.widget.data == "sessionExpired") {
                Navigator.of(context).pop("$otp");
              } else {
                saving = true;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SmilesSwitchOptions(
                            // save: saving,
                            // alreadylinked: false,
                            )));
              }
            } else {
              if (result["message"] == "timeout") {
                var notresponding = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => TimeOut()));

                if (notresponding != null) {
                } else {}
                setState(() {
                  _isLoading = false;
                });
              } else {
                setState(() {
                  showAlertLoginCred(context, "Invalid Credentials");

                  _isLoading = false;
                });
              }
            }
          }).catchError((onError) {
            setState(() {
              _isLoading = false;
            });
            showLoginAlert(context, "Something went wrong,please try again");
          });
        }
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          setState(() {
            _isLoading = false;
            fnfOtp(otp);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _verification() {
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Center(
                child: TextWidget(
                  text: "Verification",
                  size: text_font_large24_size,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget _enterOTP() {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 35),
        child: TextWidget(
          text: "Enter Your PIN",
          color: grey_color_pin_text,
          size: text_font_medium_size,
        ),
      );
    }

    Widget _submitButton() {
      return GestureDetector(
          onTap: () {
            setState(() {
              _isLoading = true;
              validate("submit");
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (BuildContext context) =>
              //             SmilesSwitchOptions()));
            });
          },
          child: _isLoading == false
              ? Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.only(
                      top: isvalid ? 20 : 40, left: 40, right: 40),
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
                  margin: EdgeInsets.only(top: 10),
                  child: SpinKitCircle(
                    color: btn_bg_color,
                  ),
                ));
    }

    Widget _gemsLogo() {
      return Container(
        margin: EdgeInsets.only(top: 70),
        child: Center(
          child: Image.asset(
            ImageConstants.brandLogo,
            height: 90,
          ),
        ),
      );
    }

    Widget _pleasewait() {
      return _isLoading
          ? Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 0),
              child: TextWidget(
                text: "Please wait!!",
                size: text_font_medium_size,
              ))
          : Container();
    }

    Widget _waitmessage() {
      return _isLoading
          ? Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 4),
              child: TextWidget(
                text: "We are linking your account...",
                size: text_font_medium_size,
              ))
          : Container();
    }

    Future<void> _launchInWebViewWithoutJavaScript(Uri url) async {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
        webViewConfiguration:
            const WebViewConfiguration(enableJavaScript: true),
      )) {
        throw Exception('Could not launch $url');
      }
    }

    Widget _getsmilesid() {
      return GestureDetector(
        onTap: () {
          var newUri = Uri.parse('https://smilesmobile.page.link/smilescard');
          _launchInWebViewWithoutJavaScript(newUri);

          // _launchURL("https://smilesmobile.page.link/smilescard");
        },
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top: 10),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                      text: "Click here to view your",
                      style: TextStyle(
                        color: blue_color_text,
                        decoration: TextDecoration.underline,
                        fontSize: text_font_medium_size,
                      )),
                  textAlign: TextAlign.center,
                ),
                RichText(
                  text: TextSpan(
                      text: "PIN on the SMILES mobile app",
                      style: TextStyle(
                        color: blue_color_text,
                        decoration: TextDecoration.underline,
                        fontSize: text_font_medium_size,
                      )),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _newpin() {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
          child: GestureDetector(
            child: Container(
              child: PinCodeTextField(
                enableActiveFill: true,
                cursorColor: box_pingrey,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  selectedFillColor: box_pingrey,
                  activeFillColor: box_pingrey,
                  inactiveFillColor: box_pingrey,
                  fieldHeight: 60,
                  fieldWidth: 50,
                  activeColor: box_pingrey,
                  inactiveColor: box_pingrey,
                ),
                backgroundColor: Colors.transparent,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                length: 5,
                controller: _controller,
                onCompleted: (value) {
                  setState(() {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    clicked = true;
                  });
                },
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                onChanged: (value) {
                  setState(() {
                    currentText = value;
                  });
                },
                appContext: context,
              ),
            ),
          ));
    }

    Widget _body() {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: boxgrey,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    _gemsLogo(),
                    _verification(),
                    _enterOTP(),
                    SizedBox(height: 10),
                    _newpin(),
                    isvalid
                        ? Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 10, top: 5),
                            child: Text(
                              "Please enter otp",
                              style: TextStyle(color: Colors.red, fontSize: 15),
                            ),
                          )
                        : Container(),
                    // _messagetext(),
                    // _ortext(),
                    SizedBox(
                      height: 5,
                    ),
                    _getsmilesid(),
                    SizedBox(
                      height: 5,
                    ),
                    _submitButton(),
                    _pleasewait(),
                    _waitmessage(),
                    SizedBox(height: 30)
                  ],
                ),
              )
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
              size: text_font_medium18_size,
              weight: FontWeight.w500,
              centerTitle: true,
              height: 90,
            ),
          ),
          body: _body(),
          bottomNavigationBar: SizedBox(height: 95, child: _tabbar()),
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
            margin: EdgeInsets.only(top: 20, left: 10, right: 10),
            height: 100,
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
                    height: 30,
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
}
