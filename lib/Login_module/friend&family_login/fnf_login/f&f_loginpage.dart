import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/Login_module/friend&family_login/fnf_login/referral_model.dart';
import 'package:gems_revamp/Login_module/friend&family_login/fnf_login/referral_presenter.dart';
import 'package:gems_revamp/Login_module/friend&family_login/fnf_login/referral_view.dart';
import 'package:gems_revamp/Login_module/friend&family_login/fnf_otp/fnf_verifyotp.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/offer_module/offer_webview.dart';
import 'package:gems_revamp/utilities/auth_utils.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:http/http.dart' as http;
import '../../../makesense_module/makesense_apiconfig.dart';

class FrientFamilyLoginPage extends StatefulWidget {
  final usertype;
  FrientFamilyLoginPage({Key? key, @required this.usertype}) : super(key: key);
  @override
  FrientFamilyLoginPageState createState() => FrientFamilyLoginPageState();
}

class FrientFamilyLoginPageState extends State<FrientFamilyLoginPage>
    implements ReferralView {
  FocusNode nodeOne = FocusNode();
  FocusNode nodeTwo = FocusNode();
  final _emailController = TextEditingController();
  final _mobileNoController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  late ReferralPresenter _referralPresenter;
  bool isloading = false;
  bool _checkTerms = false;
  bool _checkedValue = false;
  bool _showError = false;
  var noConnection;

  @override
  void initState() {
    super.initState();
    _referralPresenter = ReferralPresenter(this);
    makesenseEventCall();
    GemsGLobals.lastVisitPageName = GemsGLobals.loginPage;
  }

  makesenseEventCall() {
    String keyName = GemsGLobals.eventLoginViewed;
    var segmentReq = {GemsGLobals.intSource: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  void referralApicall() {
    var req = {
      "type": "referral",
      "phone": _mobileNoController.text, //9137815628
      "country_code": 971,
      "email": _emailController.text,
      "platform": GemsGLobals.osType,
      "deviceid": GemsGLobals.deviceId,
      "devicename": GemsGLobals.deviceName,
      "deviceimei": "",
      "latitude": GemsGLobals.lat,
      "longitude": GemsGLobals.long
    };

    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _referralPresenter.referral(req);
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          referralApicall();
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
    Widget _gemsLogo() {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 50, bottom: 10),
        child: Image.asset(
          ImageConstants.logo_login,
          color: white_color,
          height: 100,
        ),
      );
    }

    Widget _appBar() {
      return Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 50),
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).maybePop();
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
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: TextWidget(
                  text: 'My Family & Friends',
                  color: white_text_color,
                  size: text_font_large20_size,
                ))
          ],
        ),
      );
    }

    Widget _login() {
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Center(
                child: TextWidget(
                    text: "Login",
                    color: white_text_color,
                    weight: FontWeight.w500,
                    size: text_font_x_large_size),
              ),
            ),
          ],
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
                          child: _checkedValue
                              ? SvgPicture.asset(
                                  ImageConstants.select,
                                )
                              : SizedBox(),
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
                          referralApicall();
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

    Widget _loginEmailAndMob() {
      return Container(
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate,
          child: Column(
            children: [
              TextFormField(
                  controller: _emailController,
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
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: white_text_color),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: white_text_color),
                    ),
                    counterText: "",
                    errorMaxLines: 2,
                    prefixIcon: Container(
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        "images/login/email.png",
                       
                        height: 10,
                        width: 10,
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
              // MobileController
              TextFormField(
                  controller: _mobileNoController,
                  autofocus: true,
                  keyboardType: TextInputType.phone,
                  maxLength: 15,
                  inputFormatters: [
                    FilteringTextInputFormatter(RegExp("[0-9]"), allow: true)
                  ],
                  cursorWidth: 1.0,
                  style: TextStyle(
                      color: white_text_color,
                      fontSize: text_font_medium15_size,
                      fontWeight: FontWeight.normal),
                  validator: (String? arg) {
                    if ((arg ?? '').isEmpty) {
                      return "Please enter mobile number";
                    }
                    //  else if (arg!.length != 10) {
                    //   return 'Please enter valid mobile number';
                    // }
                    else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 15),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: white_text_color),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: white_text_color),
                    ),
                    counterText: "",
                    errorMaxLines: 2,
                    prefixIcon: Container(
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        "images/login/phone.png",
                        
                        height: 10,
                        width: 10,
                      ),
                    ),
                    hintText: "Mobile number*",
                    hintStyle: TextStyle(
                        color: grey_color_300.withOpacity(0.8),
                        fontSize: text_font_medium15_size,
                        fontWeight: FontWeight.normal),
                  )),
              SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: TextWidget(
                  text: "E.g. 971XXXXXXXXX",
                  color: white_color,
                  size: text_font_size_small,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _termsCondition(),
              _submitBtn()
            ],
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TabsScreen(
                          initialIndex: 0,
                        )));
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

    Widget _body() {
      return Container(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 1.1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _appBar(),
                _gemsLogo(),
                _login(),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 25, bottom: 3),
                  child: _loginEmailAndMob(),
                ),
                Spacer(),
                _skip()
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: Scaffold(
        backgroundColor: transColor,
        body: _body(),
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
              builder: (context) => FriendFamilyOtpPage(
                    userType: "referral",
                    otp: referralModel.values!.otp,
                    token: referralModel.values!.token,
                    mobilenumber: _mobileNoController.text,
                    email: _emailController.text,
                    membershipNo: referralModel.values!.membershipNo,
                  )));
    } else if (referralModel.status == false) {
      setState(() {
        isloading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: blue_color,
            content: Text(referralModel.message.toString())));
      });
    }
  }
}
