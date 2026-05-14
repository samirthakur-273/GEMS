import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gems_revamp/Login_module/parent_login/resend_otp/resend_parent_model.dart';
import 'package:gems_revamp/Login_module/parent_login/resend_otp/resend_parent_presenter.dart';
import 'package:gems_revamp/Login_module/parent_login/resend_otp/resend_parent_view.dart';
import 'package:gems_revamp/Login_module/parent_login/verifyOTP/verifyotp_modal.dart';
import 'package:gems_revamp/Login_module/parent_login/verifyOTP/verifyotp_presenter.dart';
import 'package:gems_revamp/Login_module/parent_login/verifyOTP/verifyotp_view.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:gems_revamp/utilities/auth_utils.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';

class AlumniOtp extends StatefulWidget {
  final token;
  final otp;
  final userType;
  final id;
  final email;
  final mobilenumber;
  final membershipNo;

  const AlumniOtp(
      {Key? key,
      this.token,
      this.otp,
      this.userType,
      this.id,
      this.email,
      this.mobilenumber,
      this.membershipNo})
      : super(key: key);

  @override
  _AlumniOtpState createState() => _AlumniOtpState();
}

class _AlumniOtpState extends State<AlumniOtp>
    implements VerifyOtpView, ParentResendOtpView {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _isLoading = false;
  var noConnection;
  var onTapRecognizer;
  bool hasError = false;
  bool _isResend = false;
  String currentText = "";
  String _otp = "";
  String _resendOtp = "";
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  late VerifyOTPPresenter _verifyOTPPresenter;
  late ParentResendOtpPresenter _parentResendOtpPresenter;

  @override
  void initState() {
    _verifyOTPPresenter = VerifyOTPPresenter(this);
    _parentResendOtpPresenter = ParentResendOtpPresenter(this);
    super.initState();
    makesenseEventCall();
    GemsGLobals.lastVisitPageName = GemsGLobals.otpPage;
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        _isResend = true;

        resendOtpCall();
      };
  }

  makesenseEventCall() {
    String keyName = GemsGLobals.eventOTPscreenViewed;
    var segmentReq = {GemsGLobals.intSource: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  makesenseEventOtpSubmittedCall() {
    String keyName = GemsGLobals.eventOTPSubmitted;
    var segmentReq = {GemsGLobals.intSource: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  makesenseEventLoginFailedCall(reason) {
    String keyName = GemsGLobals.eventLoginFailed;
    var segmentReq = {GemsGLobals.reason : reason,GemsGLobals.intSource: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  makesenseEventLoginSuccessCall() {
    String keyName = GemsGLobals.eventLoginSuccessful;
    var segmentReq = {GemsGLobals.intSource: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  void verifyOtpCall() {
    var req = {"token": widget.token, "otp": textEditingController.text};

    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _verifyOTPPresenter.verifyOtp(req);
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          verifyOtpCall();
        }
      }
    });
  }

  void resendOtpCall() {
    var req = {
      "token": this.widget.token,
      "type": widget.userType,
      "id": widget.mobilenumber
    };

    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _parentResendOtpPresenter.resendOtp(req);
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          resendOtpCall();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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

    Widget _pinviewbox() {
      //This is function used to entered the OTP text.
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Form(
              key: formKey,
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 4,
                    obscureText: true,
                    obscuringCharacter: '*',
                    animationType: AnimationType.fade,
                    validator: (text) {
                      if (text!.length != 4) {
                        hasError = true;
                      } else {
                        hasError = false;
                        currentText = text;
                        _isLoading = true;
                      }
                    },
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldOuterPadding: EdgeInsets.only(bottom: 20),
                        fieldHeight: 55,
                        fieldWidth: 55,
                        borderWidth: 1,
                        selectedFillColor: transColor,
                        inactiveFillColor: transColor,
                        activeFillColor: transColor,
                        inactiveColor: grey200_color,
                        activeColor: grey200_color,
                        selectedColor: grey200_color),
                    focusNode: FocusNode(),
                    cursorColor: black_color,
                    animationDuration: Duration(milliseconds: 300),
                    textStyle: TextStyle(
                        fontSize: 20, height: 1.6, color: grey200_color),
                    enableActiveFill: true,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    onCompleted: (text) async {
                      setState(() {
                        if (_isResend == true) {
                          _otp = _resendOtp;
                        } else {
                          _otp = widget.otp.toString();
                        }
                      });
                      if (currentText != _otp) {
                        hasError = true;

                        textEditingController.clear();
                        setState(() {
                          _isLoading = false;
                        });
                      }
                      makesenseEventOtpSubmittedCall();
                     verifyOtpCall();
                    },
                    onChanged: (value) {
                      
                    },
                  )),
            ),
            hasError == true
                ? Text(
                    "Please enter valid OTP",
                    style: TextStyle(
                        color: red_color,
                        fontSize: text_font_medium14_size,
                        fontWeight: FontWeight.w400),
                  )
                : Container(),
            SizedBox(
              height: 10,
            ),
            _isLoading == true
                ? SpinKitCircle(
                    color: blue_color,
                  )
                : Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                    width: MediaQuery.of(context).size.width / 1.1,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: green_color,
                    ),
                    child: MaterialButton(
                      child: TextWidget(
                        text: "Submit",
                        color: Colors.white,
                        size: 16.0,
                      ),
                      onPressed: () {
                        setState(() {
                          formKey.currentState!.validate();
                          formKey.currentState?.save();
                          // apiCall();
                        });
                      },
                    ),
                  ),
            SizedBox(
              height: 20,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "Haven't received code yet? ",
                  style: TextStyle(
                      color: grey200_color, fontSize: text_font_medium15_size),
                  children: [
                    TextSpan(
                        text: " Resend",
                        recognizer: onTapRecognizer,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: grey200_color,
                            fontSize: text_font_medium15_size))
                  ]),
            ),
          ],
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

    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: Scaffold(
        backgroundColor: transColor,
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 1.1,
            child: Column(
              children: [
                _appBar(),
                _gemsLogo(),
                SizedBox(height: 40),
                TextWidget(
                  text: 'Verification',
                  color: white_text_color,
                  size: text_font_large25_size,
                  weight: FontWeight.w500,
                ),
                SizedBox(height: 20),
                TextWidget(
                  text:
                      'Verification OTP has been sent to\n Mob No. ${mobileMasker(widget.mobilenumber)} and \n Email ID ${emailMasker(widget.email)}\n Please enter OTP here.',
                  color: grey_color_300,
                  size: text_font_medium17_size,
                  weight: FontWeight.w400,
                  alignment: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextWidget(
                  text: 'Enter OTP',
                  color: grey200_color,
                  size: text_font_medium19_size,
                  weight: FontWeight.w500,
                ),
                SizedBox(height: 30),
                _pinviewbox(),
                Spacer(),
                _skip()
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void response(VerifyOtpModal verifyOtpModal) {
    setState(() async {
      if (verifyOtpModal.status == true) {
        AuthUtils.setuserType("3");
        GemsGLobals.userType = widget.userType;
        _isLoading = false;
        AuthUtils.setStringValue(
            "membershipNo", verifyOtpModal.values!.membershipNo ?? '');
        GemsGLobals.membershipNo =
            await AuthUtils.getStringValue("membershipNo");

        GemsGLobals.alumniStatus = false;
        AuthUtils.setStringValue("alumni", widget.email ?? '');

        GemsGLobals.alumniEmail = await AuthUtils.getStringValue("alumni");
        GemsGLobals.useremail = widget.email ?? '';

        GemsGLobals.userType = widget.userType ?? '';
        GemsGLobals.mobilenumber = verifyOtpModal.values!.phone ?? '';
        GemsGLobals.countryCode = verifyOtpModal.values!.countryCode ?? '';
        GemsGLobals.membershipNo = verifyOtpModal.values!.membershipNo ?? '';
        GemsGLobals.userFirstName = verifyOtpModal.values!.firstName ?? '';
        GemsGLobals.userLastName = verifyOtpModal.values!.lastName ?? '';
        GemsGLobals.schoolcode = verifyOtpModal.values!.schoolCode ?? '';
         makesenseEventLoginSuccessCall();
        
             verifyOtpCall();
                      
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TabsScreen(
                initialIndex: 0,
              ),
            ));        
      } else {
        _isLoading = false;
        makesenseEventLoginFailedCall(verifyOtpModal.message ??'');
      }
    });
  }

  @override
  void verifyErr(error) {
    // TODO: implement verifyErr
  }

  @override
  void allErr(error) {
    // TODO: implement allErr
  }

  @override
  void parentResendOtpview(ResendParentOtpModel resendParentOtpModel) {
    if (resendParentOtpModel.status == true) {
      AuthUtils.setuserType("3");
      _isLoading = false;
      GemsGLobals.userType = widget.userType;
      _resendOtp = resendParentOtpModel.values!.otp!;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: blue_color,
          content: Text('OTP resend Successfully')));
    } else if (resendParentOtpModel.status == false) {
      setState(() {
        _isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: blue_color,
            content: Text(resendParentOtpModel.message.toString())));
      });
    }
  }
}
