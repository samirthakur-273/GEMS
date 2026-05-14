import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gems_revamp/Login_module/parent_login/check_member/login_types_model.dart';
import 'package:gems_revamp/Login_module/parent_login/check_member/login_types_presenter.dart';
import 'package:gems_revamp/Login_module/parent_login/check_member/login_types_view.dart';
import 'package:gems_revamp/Login_module/parent_login/getOTP/generateOtp_model.dart';
import 'package:gems_revamp/Login_module/parent_login/getOTP/generateOtp_presenter.dart';
import 'package:gems_revamp/Login_module/parent_login/verifyOTP/parent_otp_page.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/common_widget/font_size.dart';
import 'package:gems_revamp/common_widget/tabbarpage.dart';
import 'package:gems_revamp/common_widget/text_widget.dart';
import 'package:gems_revamp/family_and_friends/family_friends_master_list/master_list_model.dart';
import 'package:gems_revamp/family_and_friends/master_list_db/master_list_db_helper.dart';
import 'package:gems_revamp/offer_module/offer_webview.dart';
import 'package:gems_revamp/utilities/auth_utils.dart';
import 'package:gems_revamp/utils/connectivity.dart';
import 'package:gems_revamp/utils/constants_files/imageconstants.dart';
import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';
import 'package:gems_revamp/utils/no_internet.dart';
import 'package:http/http.dart' as http;
import '../../../makesense_module/makesense_apiconfig.dart';
import '../getOTP/generateOtp_view.dart';

class ParentPortalId extends StatefulWidget {
  final usertype;
  ParentPortalId({Key? key, @required this.usertype}) : super(key: key);
  @override
  ParentPortalIdState createState() => ParentPortalIdState();
}

class ParentPortalIdState extends State<ParentPortalId>
    implements LoginTypesView, GenetrateOtpView {
  final portalid = TextEditingController();
  bool _checkTerms = false;
  bool _checkedValue = false;
  bool _showError = false;
  var noConnection;
  late LoginTypesPresenter _loginTypesPresenter;
  bool isloading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  TextEditingController _mobileController = TextEditingController();
  late GenerateOTPPresenter _generateOTPPresenter;
  String? selectedCountryCode = "971";
  List<dynamic>? countryCodeList;
  int? mobilenumberlength = 9;
  String? countryImage;
  MasterListModel? _masterListModel;
  var _mobileerr = "";
  bool _ismobile = false;
  var errormsg = "";
  @override
  void initState() {
    super.initState();    
    _loginTypesPresenter = LoginTypesPresenter(this);
    fetchMasterListData();
    _generateOTPPresenter = GenerateOTPPresenter(this);
    makesenseEventCall();
    GemsGLobals.lastVisitPageName = GemsGLobals.loginPage;
  }

  makesenseEventCall() {
    String keyName = GemsGLobals.eventLoginViewed;
    var segmentReq = {GemsGLobals.intSource: GemsGLobals.lastVisitPageName};
    MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
  }

  void fetchMasterListData() async {
    MasterListDbHelper().fetchMasterListData().then((value) {
      _masterListModel = masterListModelFromJson(value[0].masterlistdata);

      countryCodeList = _masterListModel!.values!.countryList;
    });
  }

  void apiCall() {
    var req = {
      "type": widget.usertype,
      "email_id": "",
      "country_code": selectedCountryCode,
      "mobile_no": _mobileController.text
    };
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

    void _mobilevalidation() {
      if (_mobileController.text.isEmpty) {
        _ismobile = true;
        _mobileerr = "Please enter mobile number";
        setState(() {});
      } else if (_mobileController.text.length != mobilenumberlength) {
        _ismobile = true;
        _mobileerr = "Please enter $mobilenumberlength digit number";
        setState(() {});
      } else {
        _ismobile = false;
        _mobileerr = "";
      }
      setState(() {});
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
                          child:_checkedValue?
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

    Widget _submitBtn() {
      return isloading == true
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
                  text: "Submit",
                  color: Colors.white,
                  size: text_font_medium18_size,
                ),
                onPressed: () {
                  _mobilevalidation();
                  setState(() {
                    if (_checkedValue == false) {
                      _showError = true;
                    } else {
                      _showError = false;
                    }
                     if (_showError == false && _ismobile == false) {
                      isloading = true;
                      apiCall();
                    }
                  });
                },
              ),
            );
    }

    Widget countryBottomSheet(countryCodeList) {
      return Container(
        height: MediaQuery.of(context).size.height - 125,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: countryCodeList.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context, countryCodeList[index]);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, bottom: 5, top: 5),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          countryCodeList[index].image != null ||
                                  countryCodeList[index].image != ""
                              ? Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image:
                                            NetworkImage(
                                                '${countryCodeList[index].image}'),
 fit: BoxFit.fill),
                                  ),
                                )
                              : Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image:
                                            AssetImage(ImageConstants.noimages),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                          SizedBox(
                            width: 10,
                          ),
   Expanded(
                            child: TextWidget(
                              text: countryCodeList[index].name,
                              color: purchase_text_color,
                              size: text_font_medium15_size,
                              weight: FontWeight.w500,
                            ),
                          ),

                          Container(
                            width: 55,
                            child: TextWidget(
                              text: '+${countryCodeList[index].countryCode}',
                              color: purchase_text_color,
                              size: text_font_medium15_size,
                              weight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
      );
    }

    Widget _portalid() {
      return Container(
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate,
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
                    GestureDetector(
                      onTap: () async {
                        var data = await showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25),
                              ),
                            ),
                            backgroundColor: white_text_color,
                            context: context,
                            builder: (context) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Center(
                                        child: Container(
                                      width: 75,
                                      height: 3,
                                      color: grey_border,
                                      margin: EdgeInsets.only(top:20, bottom: 10),
                                    )),

                                      countryBottomSheet(countryCodeList)
                                  ],
                                ),
                              );
                            });

                        setState(() {
                          selectedCountryCode = data.countryCode;
                          mobilenumberlength = data.mobileNumberLength;

                          countryImage = data.image;
                        });
                      },
                      child: Container(
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
                                            'http://44.199.170.200:8082/uploads/images/countries/AE.jpg')
                                        : NetworkImage('$countryImage'),
                                    fit: BoxFit.fill),
                              ),
                            ),
                            SizedBox(
                              width: 1,
                            ),
                            TextWidget(
                              text: "+$selectedCountryCode",
                              color: white_text_color,
                              size: text_font_medium15_size,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: white_text_color,
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
                          controller: _mobileController,
                          onChanged: (value) {
                            if (_mobileController.text.startsWith("0")) {
                              var data = value.replaceAll("0", "");
                              _mobileController.text = data;
                            }
                          },
                          maxLength: 50,
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
                              hintText: "Parent Mobile Number",
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
              _ismobile == true
                  ? Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 15),
                      child: TextWidget(
                          text: "$_mobileerr",
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
                  text: 'I am a GEMS Parent',
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
              _appBar(),
              SizedBox(
                height: 10,
              ),
              _gemsLogo(),
              SizedBox(height: 30),
              TextWidget(
                text: 'Login',
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
                  child: _portalid()),
              Spacer(),
              _skip()
            ]),
          ),
        ),
      ),
    );
  }

  @override
  void allErr(error) {
  }
  void otpapiCall() {
    var req = {
      "type": widget.usertype,
      "mobile_no": _mobileController.text,
      "country_code": selectedCountryCode,
      "email_id": "",
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
          otpapiCall();
        }
      }
    });
  }

  @override
  void loginTypesview(CheckMemberModel checkMemberModel) {
    if (checkMemberModel.status == true) {
      setState(() async {
        AuthUtils.setuserType("0");
        isloading = false;
        otpapiCall();

        setState(() {
          isloading = true;
        });

         if (GemsGLobals.geustLoginFlag != null) {
          Navigator.pop(context);
        }
      });
    } else if (checkMemberModel.status == false) {
      setState(() {
        isloading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: blue_color,
            content: Text(checkMemberModel.message.toString())));
      });
    }
  }

  @override
  void response(GenerateOtpModal generateOtpModal) {
    if (generateOtpModal.status == true) {
      isloading = false;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ParentOtpPage(
                  userType: 0,
                  otp: generateOtpModal.values!.otp,
                  token: generateOtpModal.values!.token,
                  mobilenumber: _mobileController.text,
                  email: generateOtpModal.values!.email,
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
