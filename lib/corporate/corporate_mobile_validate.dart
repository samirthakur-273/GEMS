import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/Login_module/parent_login/getOTP/generateOtp_model.dart';
import 'package:gems_revamp/Login_module/parent_login/getOTP/generateOtp_presenter.dart';
import 'package:gems_revamp/Login_module/parent_login/getOTP/generateOtp_view.dart';
import 'package:gems_revamp/Login_module/parent_login/verifyOTP/parent_otp_page.dart';
import 'package:gems_revamp/Login_module/staff_login/staff_otp/staff_otp.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/utils/connectivity.dart';
import 'package:gems_revamp/offer_module/offer_webview.dart';
import 'package:gems_revamp/utilities/auth_utils.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';

class MobileValidation extends StatefulWidget {
  @override
  State<MobileValidation> createState() => _MobileValidationState();
}

class _MobileValidationState extends State<MobileValidation>
    implements GenetrateOtpView {
  bool isMobile = false;
  bool isloading = false;
  String? countryImage;
  String mobileError = "";
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;
  TextEditingController mobileController = TextEditingController();
  GenerateOTPPresenter? generateOTPPresenter;
  List<dynamic>? countryCodeList;
  int? mobileNumberLength = 9;
  var noConnection;

  @override
  void initState() {
    super.initState();
    GemsGLobals.lastVisitPageName = GemsGLobals.loginPage;
    generateOTPPresenter = GenerateOTPPresenter(this);
  }

  void otpApiCall() {
    var req = {
      "type": GemsGLobals.userType,
      "mobile_no": mobileController.text,
      "country_code": GemsGLobals.defaultCountryCode,
      "email_id": GemsGLobals.useremail,
      "platform": GemsGLobals.osType,
      "deviceid": GemsGLobals.deviceId,
      "devicename": GemsGLobals.deviceName,
      "deviceimei": "",
      "latitude": GemsGLobals.lat,
      "longitude": GemsGLobals.long
    };

    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        generateOTPPresenter!.getotp(req);
      } else {
        noConnection = await Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          otpApiCall();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget gemsLogo() {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 50, bottom: 10),
        child: Image.asset(
          ImageConstants.logo_login,
          color: white_text_color,
          height: 100,
        ),
      );
    }

    void mobileValidation() {
      setState(() {
        if (mobileController.text.isEmpty) {
          isMobile = true;
          mobileError = GemsGLobals.mobileErrorText;
        } else if (mobileController.text.length != mobileNumberLength) {
          isMobile = true;
          mobileError = '${GemsGLobals.mobileDigitText}';
        } else {
          isMobile = false;
          mobileError = "";
        }
      });
    }

    Widget submitButton() {
      return isloading
          ? SpinKitCircle(
              color: blue_color,
            )
          : Container(
              width: MediaQuery.of(context).size.width / 1.1,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: green_color,
                  boxShadow: [
                    BoxShadow(
                        color: blue_color.withOpacity(0.4),
                        offset: Offset(0, 7.0),
                        blurRadius: 7.0,
                        spreadRadius: 0.0),
                  ]),
              margin: EdgeInsets.only(top: 15),
              child: MaterialButton(
                child: TextWidget(
                  text: GemsGLobals.submitText,
                  color: Colors.white,
                  size: text_font_medium18_size,
                ),
                onPressed: () {
                  mobileValidation();
                  if (!isMobile) {
                    setState(() {
                      isloading = true;
                    });
                    otpApiCall();
                  }
                },
              ),
            );
    }

    Widget numberTextField() {
      return Container(
        child: Form(
          key: formKey,
          autovalidateMode: autoValidate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: white_text_color),
                )),
                child: Row(
                  children: [
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: countryImage == null ||
                                          countryImage == ""
                                      ? NetworkImage(
                                          ImageConstants.countryDefaultImage)
                                      : NetworkImage('$countryImage'),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          SizedBox(
                            width: 1,
                          ),
                          TextWidget(
                            text: "+${GemsGLobals.defaultCountryCode}",
                            color: grey_color_300,
                            size: text_font_medium15_size,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          SizedBox(width: 10),
                          Container(
                              height: 30,
                              width: 2,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: blue_color),
                                ),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Image.asset(
                        ImageConstants.phone,
                        color: grey_color_300,
                        fit: BoxFit.contain,
                        scale: 2,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.disabled,
                          textAlign: TextAlign.start,
                          controller: mobileController,
                          onChanged: (value) {
                            if (mobileController.text.startsWith("0")) {
                              var data = value.replaceAll("0", "");
                              mobileController.text = data;
                            }
                          },
                          maxLength: 9,
                          cursorWidth: 1.0,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color: white_text_color,
                              fontSize: text_font_medium15_size,
                              fontWeight: FontWeight.normal),
                          decoration: InputDecoration(
                              counterText: "",
                              isDense: true,
                              hintText: GemsGLobals.mobileNoText,
                              hintStyle: TextStyle(
                                  color: grey_color_300.withOpacity(0.8),
                                  fontSize: text_font_medium15_size,
                                  fontWeight: FontWeight.normal),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              isMobile
                  ? Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: TextWidget(
                          text: "$mobileError",
                          size: text_font_size_x_small,
                          color: Colors.red,
                          softwrap: true),
                    )
                  : Container(
                      height: 0,
                      color: Colors.red,
                    ),
              SizedBox(
                height: 10,
              ),
              submitButton()
            ],
          ),
        ),
      );
    }

    Widget skip() {
      return GestureDetector(
        onTap: () {
          setState(() {
            AuthUtils.setuserType(GemsGLobals.guest);
            GemsGLobals.userType = GemsGLobals.guest;
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
                text: GemsGLobals.skipText,
                color: white_text_color,
                weight: FontWeight.w500,
                decoration: TextDecoration.underline,
              ),
            )),
      );
    }

    Widget appBar() {
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
                  text: GemsGLobals.corporatePartnerText,
                  color: white_text_color,
                  size: text_font_large20_size,
                ))
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: gradient_theme_color),
      child: Scaffold(
        backgroundColor: transColor,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(children: [
              appBar(),
              SizedBox(
                height: 10,
              ),
              gemsLogo(),
              SizedBox(height: 50),
              TextWidget(
                text: GemsGLobals.getStartedText,
                color: white_text_color,
                size: text_font_large25_size,
                weight: FontWeight.w500,
              ),
              SizedBox(height: 20),
              Padding(
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 25,
                  ),
                  child: numberTextField()),
              Spacer(),
              skip()
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void allErr(error) {}

  @override
  void response(GenerateOtpModal generateOtpModal) {
    if (generateOtpModal.status ?? true) {
      isloading = false;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StaffOTP(
                  fromMobileValidation: true,
                  userType: GemsGLobals.userType,
                  otp: generateOtpModal.values!.otp,
                  token: generateOtpModal.values!.token,
                  mobilenumber: mobileController.text,
                  email: generateOtpModal.values!.email,
                  isDomainWhiteListed: generateOtpModal.values!.isDomainWhitelist,
                  membershipNo: generateOtpModal.values!.membershipNo)));
      if (GemsGLobals.geustLoginFlag != null) {
        Navigator.pop(context);
      }
    } else if (generateOtpModal.status == false) {
      setState(() {
        isloading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: blue_color,
            content: Text(generateOtpModal.message.toString())));
      });
    }
  }
}
