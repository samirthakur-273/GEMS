import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/Login_module/parent_login/check_member/login_types_model.dart';
import 'package:gems_revamp/Login_module/parent_login/getOTP/generateOtp_model.dart';
import 'package:gems_revamp/Login_module/parent_login/getOTP/generateOtp_presenter.dart';
import 'package:gems_revamp/Login_module/parent_login/getOTP/generateOtp_view.dart';
import 'package:gems_revamp/Login_module/staff_login/staff_otp/staff_otp.dart';
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
import '../../login_types/login_types.dart';
import '../../parent_login/check_member/login_types_presenter.dart';
import '../../parent_login/check_member/login_types_view.dart';

class StaffLogin extends StatefulWidget {
  final usertype;
  final data;

  StaffLogin({Key? key, this.usertype, this.data}) : super(key: key);

  @override
  State<StaffLogin> createState() => _StaffLoginState();
}

class _StaffLoginState extends State<StaffLogin>
    implements GenetrateOtpView, LoginTypesView {
  TextEditingController loginController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  late GenerateOTPPresenter _generateOTPPresenter;
  TextEditingController emailController = new TextEditingController();
  late LoginTypesPresenter _loginTypesPresenter;

  bool _showError = false;
  bool _checkTerms = false;
  bool _checkedValue = false;
  bool _loader = false;
  bool showNotifyText = true;
  var noConnection;
  var otp;
  var _token;

  @override
  void initState() {
    super.initState();
    makesenseEventCall();
    GemsGLobals.lastVisitPageName = GemsGLobals.loginPage;
    _loginTypesPresenter = LoginTypesPresenter(this);
    _generateOTPPresenter = GenerateOTPPresenter(this);
  }

  makesenseEventCall() {
    String keyName = GemsGLobals.eventLoginViewed;
    var segmentReq = {GemsGLobals.intSource: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  makesenseEventEmailVerificationCall() {
    String keyName = GemsGLobals.eventEmailAddressVerification;
    var segmentReq = {
      GemsGLobals.intSource: GemsGLobals.lastVisitPageName,
      GemsGLobals.emailKey: emailController.text,
      GemsGLobals.pageName: GemsGLobals.corporatePartnerText
    };
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  void staffLoginapiCall() {
    var req = {
      "type": widget.usertype,
      "mobile_no": null,
      "country_code": null,
      "email_id": emailController.text,
      "platform": GemsGLobals.osType,
      "deviceid": GemsGLobals.deviceId,
      "devicename": GemsGLobals.deviceName,
      "deviceimei": "",
      "latitude": GemsGLobals.lat,
      "longitude": GemsGLobals.long
    };

    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _generateOTPPresenter.getotp(req);
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          staffLoginapiCall();
        }
      }
    });
  }

  void apiCall() {
    // var req = {"customer_id": portalid.text, "type": widget.usertype};
    var req = {
      "type": widget.usertype,
      "email_id": emailController.text,
      "country_code": null,
      "mobile_no": null
    };
    print(req);
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _loginTypesPresenter.loginTypes(req);
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          apiCall();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _validateInputs() {
      if (_formKey.currentState?.validate() == true) {
        setState(() {
          _formKey.currentState?.save();
          showNotifyText = false;
          if (_checkedValue == true) {
            _loader = true;
            apiCall();
            // staffLoginapiCall();
          }
        });
      } else {
        setState(() {
          _autoValidate = AutovalidateMode.always;
        });
      }
    }

    Widget _submitBtn() {
      return _loader == true
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
                    _validateInputs();
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
                      margin: EdgeInsets.only(left: 0),
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

    onChanged() {
      //email = emailController.text;
    }
    _staffLogin() {
      return Container(
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate,
          child: Column(
            children: [
              TextFormField(
                  controller: emailController,
                  autofocus: false,
                  keyboardType: TextInputType.emailAddress,
                  cursorWidth: 1.0,
                  style: TextStyle(
                      color: white_text_color,
                      fontSize: text_font_medium15_size,
                      fontWeight: FontWeight.normal),
                  onChanged: onChanged(),
                  enabled: true,
                  validator: (String? arg) {
                    if ((arg ?? '').isEmpty) {
                      showNotifyText = true;
                      return "Please enter email ID";
                    } else if (arg!.length < 2 || arg.length > 50) {
                      return "Please enter a valid email";
                    } else {
                      bool emailValid = RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                          .hasMatch(arg);
                      if (emailValid == true) {
                        showNotifyText = true;
                        return null;
                      } else {
                        return "Please enter a valid email";
                      }
                    }
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 15),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: white_text_color),
                    ),
                    counterText: "",
                    errorMaxLines: 2,
                    errorStyle: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.red,
                        fontSize: text_font_size_x_small),
                    prefixIcon: Container(
                      padding: EdgeInsets.all(13),
                      height: 10,
                      width: 10,
                      child: Image.asset(
                        ImageConstants.email_login,
                       
                        fit: BoxFit.contain,
                      ),
                    ),
                    hintText: widget.usertype ==
                            GemsGLobals.defaultSource.toLowerCase()
                        ? GemsGLobals.emailIdText + '*'
                        : GemsGLobals.gemsText +
                            " " +
                            GemsGLobals.emailIdText +
                            '*',
                    hintStyle: TextStyle(
                        color: grey_color_300.withOpacity(0.8),
                        fontSize: text_font_medium15_size,
                        fontWeight: FontWeight.normal),
                  )),
              showNotifyText == true &&
                      widget.usertype == GemsGLobals.defaultSource.toLowerCase()
                  ? Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 0, top: 10),
                      child: TextWidget(
                          text: GemsGLobals.enterCorporateEmailInstrustions,
                          size: text_font_size_x_small,
                          color: Colors.white,
                          softwrap: true),
                    )
                  : Container(
                      height: 0,
                    ),
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
                  text: widget.usertype == GemsGLobals.smallCorporateText
                      ? GemsGLobals.corporatePartnerText
                      : GemsGLobals.gemsEmployeeText,
                  color: white_text_color,
                  size: text_font_large20_size,
                ))
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: PopScope(
        canPop: true,
        onPopInvoked: (canPop) async {
          setState(() {
            GemsGLobals.deeplinkloader = false;
            if (widget.data == "0") {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginHomePage()));
            } 
          });
          Future.value(false);
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
                  text: widget.usertype == GemsGLobals.defaultSource.toLowerCase()
                      ? GemsGLobals.getStartedText
                      : GemsGLobals.loginText,
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
  void allErr(error) {}

  @override
  void response(GenerateOtpModal generateOtpModal) {
    _loader = false;
    print("Generate OTP Response: ${generateOtpModal.toString()}");


    if (generateOtpModal.status == true) {
      GemsGLobals.corporateCode =
          generateOtpModal.values!.corporateCode.toString();
      GemsGLobals.corporateName = 
          generateOtpModal.values!.corporateName.toString();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StaffOTP(
                  userType: widget.usertype,
                  corporateId: generateOtpModal.values?.corporateId ?? 0,
                  otp: generateOtpModal.values!.otp,
                  token: generateOtpModal.values!.token,
                  mobilenumber: "",
                  email: generateOtpModal.values!.email,
                  isDomainWhiteListed: generateOtpModal.values!.isDomainWhitelist,
                  corporateCode : generateOtpModal.values!.corporateCode ??"",
                  membershipNo: generateOtpModal.values!.membershipNo)));
    } else if (generateOtpModal.status == false) {
      setState(() {
        _loader = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: blue_color,
            content: Text(generateOtpModal.message.toString())));
      });
    }
    if (widget.usertype != null &&
        widget.usertype == GemsGLobals.defaultSource.toLowerCase()) {
      makesenseEventEmailVerificationCall();
    }
  }

  @override
  void loginTypesview(CheckMemberModel checkMemberModel) {
    if (checkMemberModel.status == true ||
        checkMemberModel.isCisco == 1 ||
        checkMemberModel.isCorporate == 1) {
      setState(() async {
        _loader = false;
        staffLoginapiCall();
        setState(() {
          _loader = true;
        });

        if (GemsGLobals.geustLoginFlag != null) {
          Navigator.pop(context);
        }
      });
    } else if (checkMemberModel.status == false) {
      setState(() {
        _loader = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: blue_color,
            content: Text(checkMemberModel.message.toString())));
      });
    }
  }
}
