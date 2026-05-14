import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/Login_module/alumni_login/alumni_otp.dart';
import 'package:gems_revamp/Login_module/alumni_login/alumni_register/alumni_register_model.dart';
import 'package:gems_revamp/Login_module/alumni_login/alumni_register/alumni_register_presenter.dart';
import 'package:gems_revamp/Login_module/alumni_login/alumni_register/alumni_register_view.dart';
import 'package:gems_revamp/Login_module/login_types/login_types.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/offer_module/offer_webview.dart';
import 'package:gems_revamp/utilities/auth_utils.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:http/http.dart' as http;
import '../../eshop_module_new/common_widget/text_widget.dart';
import '../../eshop_module_new/utils/connectivity.dart';
import '../../eshop_module_new/utils/customloader/custome_circle_loader.dart';
import '../../makesense_module/makesense_apiconfig.dart';
import '../../utils/no_internet.dart';
import '../friend&family_login/fnf_login/referral_model.dart';
import '../friend&family_login/fnf_login/referral_presenter.dart';
import '../friend&family_login/fnf_login/referral_view.dart';
 /// alumni integration
class AlumniLogin extends StatefulWidget {
  final usertype;
  final email;
  final data;
  const AlumniLogin({Key? key, this.usertype, this.email, this.data})
      : super(key: key);

  @override
  State<AlumniLogin> createState() => _AlumniLoginState();
}

class _AlumniLoginState extends State<AlumniLogin>
    implements ReferralView, AlumniRegisterView {
  TextEditingController loginController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  bool _showError = false;
  bool _checkTerms = false;
  bool _checkedValue = false;
  bool _loader = false;
  var noConnection;
  var otp;
  var _token;
  late ReferralPresenter _referralPresenter;
  late AlumniRegisterPresenter _alumniRegisterPresenter;
  bool isloading = false;
  bool fnfConerttoAlumni = false;

  @override
  void initState() {
    loginController = TextEditingController(text: this.widget.email.toString().replaceAll('"', ''));
    _alumniRegisterPresenter = AlumniRegisterPresenter(this);
    _referralPresenter = ReferralPresenter(this);
    GemsGLobals.deeplinkloader = false;
    makesenseEventCall();
    GemsGLobals.lastVisitPageName = GemsGLobals.loginPage;
    super.initState();
  }

  makesenseEventCall() {
    String keyName = GemsGLobals.eventLoginViewed;
    var segmentReq = {GemsGLobals.intSource: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  void alumniRegisterApicall() {
    var req = {
      "email": loginController.text,
    };

    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _alumniRegisterPresenter.alumniRegister(req, "");
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          alumniRegisterApicall();
        }
      }
    });
  }

  void alumniApicall() {
    var req = {
      "type": "alumni",
      "email": loginController.text,
      "platform": GemsGLobals.osType,
      "deviceid": GemsGLobals.deviceId,
      "devicename": GemsGLobals.deviceName,
      "deviceimei": "",
      "latitude": GemsGLobals.lat,
      "longitude": GemsGLobals.long
    };
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _referralPresenter.alumni(req);
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          alumniApicall();
        }
      }
    });
  }

  /* Email Validation*/
  String? validateEmail(String? data) {
    String value = data ?? '';
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter an email id';
    } else if (!regex.hasMatch(value)) {
      return 'Please enter a valid email id';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _submitBtn() {
      return isloading == true
          ? SpinKitCircle(
              color: blue_color,
            )
          : Container(
              width: MediaQuery.of(context).size.width / 1.1,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: green_color,
              ),
              margin: EdgeInsets.only(top: 15),
              child: MaterialButton(
                child: TextWidget(
                  text: "Submit",
                  color: Colors.white,
                  size: 16.0,
                ),
                onPressed: () {
                  setState(() {
                    if (_checkedValue == false) {
                      _showError = true;
                    } else {
                      _showError = false;
                    }
                    if (_formKey.currentState?.validate() == true) {
                      setState(() {
                        _formKey.currentState?.save();
                        if (_checkedValue == true) {
                          isloading = true;
                          if (GemsGLobals.email == null ||
                              GemsGLobals.email == "" ||
                              GemsGLobals.userType != "alumni") {
                            alumniRegisterApicall();
                          } else {
                            alumniApicall();
                          }
                        }
                      });
                    } else {
                      setState(() {
                        _autoValidate = AutovalidateMode.always;
                      });
                    }
                  });
                },
              ),
            );
    }

    Widget _termsCondition() {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 1.0, 6.0, 8.0),
          child: Column(
            children: [
            new InkWell(
                  onTap: () {
                    setState(() {
                   _checkedValue = !_checkedValue;
                   _checkTerms = !_checkedValue;
                   if (_checkedValue) {
                     _showError = false;
                   }
                  });
                  },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                    Container(
                        height: 22,
                        width: 22,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(width: 1, color: white_color),
                            color: transColor),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: _checkedValue?
                          SvgPicture.asset(
                            ImageConstants.select,
                            
                          ):SizedBox(),
                        )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Row(
                      children: <Widget>[
                        TextWidget(
                            text: 'I agree to the ',
                            size: text_font_size_x_small,
                            color: grey200_color),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForYouWeb(
                                        appbarname: "Terms and Conditions",
                                        weburl:
                                            "https://www.gemsrewards.com/terms-and-conditions",
                                      )),
                            );
                          },
                          child: new TextWidget(
                            text: 'Terms & Conditions',
                            weight: FontWeight.bold,
                            size: text_font_size_x_small,
                            decoration: TextDecoration.underline,
                            color: white_text_color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ),
              _showError == true
                  ? Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: TextWidget(
                          text: "Please agree to the Terms & Conditions",
                          size: text_font_size_x_small,
                          color: Colors.red,
                          softwrap: true),
                    )
                  : Container(
                      height: 0,
                      color: Colors.red,
                    )
            ],
          ),
        ),
      );
    }

    _staffLogin() {
      return Container(
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate,
          child: Column(
            children: [
              TextFormField(
                  controller: loginController,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  cursorWidth: 1.0,
                  style: TextStyle(
                      color: white_text_color,
                      fontSize: text_font_medium15_size,
                      fontWeight: FontWeight.normal),
                  validator: (String? arg) {
                    return validateEmail(arg);
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 15),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: white_text_color),
                    ),
                    counterText: "",
                    errorMaxLines: 2,
                    prefixIcon: Container(
                      padding: EdgeInsets.all(13),
                      height: 10,
                      width: 10,
                      child: Image.asset(
                        ImageConstants.user_login,
                        
                        fit: BoxFit.contain,
                      ),
                    ),
                    hintText: "Email ID*",
                    hintStyle: TextStyle(
                        color: grey_color_300.withOpacity(0.8),
                        fontSize: text_font_medium15_size,
                        fontWeight: FontWeight.normal),
                  )),
              SizedBox(
                height: 30,
              ),
              _termsCondition(),
              _submitBtn()
            ],
          ),
        ),
      );
    }

    Widget _gemsLogo() {
      return Container(
        margin: EdgeInsets.only(top: 40),
        child: Center(
          child: Image.asset(
            "images/login/logo_login.png",
            height: 100,
            color: white_color,
            
          ),
        ),
      );
    }

    Widget _skip() {
      return GestureDetector(
        onTap: () {
          setState(() {
            AuthUtils.setuserType("guest");
            GemsGLobals.userType = "guest";
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TabsScreen(
                        initialIndex: 0,
                      )));
        },
        child: Container(
            height: 100,
            child: Center(
              child: TextWidget(
                text: "Skip",
                color: white_text_color,
                weight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            )),
      );
    }

    Widget _appBar() {
      return Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 50),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                // Navigator.of(context).maybePop();
                setState(() {
                  GemsGLobals.deeplinkloader = false;
                  if (widget.data == "0") {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginHomePage()));
                  } else {
                    Navigator.pop(context);
                  }

                  GemsGLobals.deeplinkloader = false;
                });
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
            Container(
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: TextWidget(
                  text: 'I am a Alumni',
                  color: white_text_color,
                  size: text_font_large20_size,
                ))
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: WillPopScope(
        onWillPop: () async {
          setState(() {
            GemsGLobals.deeplinkloader = false;
            if (widget.data == "0") {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginHomePage()));
            } else {
              Navigator.pop(context);
            }

            GemsGLobals.deeplinkloader = false;
          });
          return false;
        },
        child: Scaffold(
          backgroundColor: transColor,
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(children: [
                _appBar(),
                SizedBox(
                  height: 10,
                ),
                _gemsLogo(),
                SizedBox(height: 50),
                TextWidget(
                  text: 'Login',
                  color: white_text_color,
                  size: text_font_large25_size,
                  weight: FontWeight.w500,
                ),
                SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 25, bottom: 3),
                    child: _staffLogin()),
                Spacer(),
                _skip()
              ]),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void allErr(error) {
    // TODO: implement allErr
  }

  @override
  void referralview(ReferralModel referralModel) {
    isloading = false;
    if (referralModel.status == true) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AlumniOtp(
                      userType: "alumni",
                      otp: referralModel.values!.otp,
                      token: referralModel.values!.token,
                      mobilenumber: referralModel.values!.mobileNumber,
                      email: loginController.text,
                      membershipNo: referralModel.values!.membershipNo,
                    )));
      // }
    } else if (referralModel.status == false) {
      setState(() {
        isloading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: blue_color,
            content: Text(referralModel.message.toString())));
      });
    }
  }

  _showupgradeToalumniDialog(otp, token, mobileNumber, email) async {
    await Future.delayed(Duration(milliseconds: 10));
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Container(
              margin: EdgeInsets.only(top: 25, left: 15, right: 15),
              height: 120,
              child: Column(
                children: <Widget>[
                  Container(
                    child: TextWidget(
                      text:
                          "Your Family & Friends account\nis upgraded to Alumni.",
                      size: text_font_size_small,
                      weight: FontWeight.bold,
                      color: Colors.grey[700],
                      alignment: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 22, bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: blue_color,
                              ),
                              borderRadius: BorderRadius.circular(3)),
                          child: new TextButton(
                            child: TextWidget(
                              text: "OK",
                              color: blue_color,
                              textAlign: TextAlign.center,
                              size: text_font_size_small,
                              weight: FontWeight.bold,
                            ),
                            onPressed: () async {
                              // setState(() {
                              //   isloading = true;
                              // });

                              // alumniApicall();
                            await  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AlumniOtp(
                                            userType: "alumni",
                                            otp: otp,
                                            token: token,
                                            mobilenumber: mobileNumber,
                                            email: email,
                                          )));

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
            // actions: <Widget>[],
          );
        });
  }

  @override
  void alumniRegisterview(AlumniRegisterModel alumniRegisterModel, data) {

    if (alumniRegisterModel.status == true) {
      alumniApicall();

    } else if (alumniRegisterModel.status == false &&
        alumniRegisterModel.message == "Please login by using valid Email ID") {
      GemsGLobals.alumniStatus = false;

      setState(() {
        isloading = false;
        GemsGLobals.deeplinkloader = false;
      });
      // setState(() {
      // isloading = false;
      Fluttertoast.showToast(
          msg:
              "Sorry!! You are not GEMS Alumni member", //alumniRegisterModel.message.toString(),
          // msg:GemsGLobals.email,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          gravity: ToastGravity.BOTTOM);
    } else if (alumniRegisterModel.status == false) {
      GemsGLobals.alumniStatus = false;
      setState(() {
        GemsGLobals.deeplinkloader = false;
        isloading = false;
      });

      Fluttertoast.showToast(
          msg: alumniRegisterModel.message.toString(),
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          gravity: ToastGravity.BOTTOM);
    } else {
      setState(() {
        GemsGLobals.deeplinkloader = false;
      });
    }
  }
}