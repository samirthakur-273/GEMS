// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gems_revamp/Login_module/parent_login/getOTP/generateOtp_model.dart';
// import 'package:gems_revamp/Login_module/parent_login/getOTP/generateOtp_presenter.dart';
// import 'package:gems_revamp/Login_module/parent_login/getOTP/generateOtp_view.dart';
// import 'package:gems_revamp/Login_module/parent_login/login_password/parent_password_model.dart';
// import 'package:gems_revamp/Login_module/parent_login/login_password/parent_password_presenter.dart';
// import 'package:gems_revamp/Login_module/parent_login/login_password/parent_password_view.dart';
// import 'package:gems_revamp/Login_module/parent_login/verifyOTP/parent_otp_page.dart';
// import 'package:gems_revamp/common_widget/colors_widget.dart';
// import 'package:gems_revamp/common_widget/font_size.dart';
// import 'package:gems_revamp/common_widget/tabbarpage.dart';
// import 'package:gems_revamp/common_widget/text_widget.dart';
// import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
// import 'package:gems_revamp/utilities/auth_utils.dart';
// import 'package:gems_revamp/utils/connectivity.dart';
// import 'package:gems_revamp/utils/customloader/custome_circle_loader.dart';
// import 'package:gems_revamp/utils/gemsGlobals.dart';
// import 'package:gems_revamp/utils/no_internet.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';

// class ParentLogin extends StatefulWidget {
//   final usertype;
//   final parentID;
//   final membershipNo;
//   ParentLogin({Key? key, @required this.usertype, @required this.parentID, this.membershipNo})
//       : super(key: key);
//   @override
//   _ParentLoginState createState() => _ParentLoginState();
// }

// class _ParentLoginState extends State<ParentLogin>
//     implements GenetrateOtpView, ParentPasswordView {
//   FocusNode nodeOne = FocusNode();
//   FocusNode nodeTwo = FocusNode();
//   final portalid = TextEditingController();
//   final password = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   AutovalidateMode _autoValidate = AutovalidateMode.disabled;
//   late ParentPasswordPresenter _parentPasswordPresenter;
//   late GenerateOTPPresenter _generateOTPPresenter;
//   bool editable = true;
//   bool iderror = false;
//   bool pswrderror = false;
//   bool isloading = false;
//   bool isload = false;
//   bool _isLoadingotp = false;
//   String deviceinfo = "";

//   var noConnection;
//   static const MethodChannel _channel2 = const MethodChannel('imei_plugin');

//   @override
//   void initState() {
//     super.initState();
//     _parentPasswordPresenter = ParentPasswordPresenter(this);
//     _generateOTPPresenter = GenerateOTPPresenter(this);
//   }

//   _makesenseEventCall(_action, _verificatioResultu) {
//     String keyName = "Login password verification";
//     var segmentReq = {
//       "Action": _action,
//       "Verified result": _verificatioResultu??""
//     };
//     MakesenseApiClass.makesenseEventsApi(http.Client(), segmentReq, keyName);
//   }

//   void passwordLoginapiCall() {
//     var req = {
//       "username": widget.parentID,
//       "password": password.text,
//       "usertype": widget.usertype,
//       "platform": GemsGLobals.osType,
//       "deviceid": GemsGLobals.deviceId,
//       "devicename": GemsGLobals.deviceName,
//       "deviceimei": "",
//       "latitude": GemsGLobals.lat,
//       "longitude": GemsGLobals.long
//     };

//     Internetconnectivity().isConnected().then((result) async {
//       if (result) {
//         _parentPasswordPresenter.staffLogin(req);
//       } else {
//         noConnection = await Navigator.push(context,
//             MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
//         if (noConnection != null) {
//           passwordLoginapiCall();
//         }
//       }
//     });
//   }

//   void otpapiCall() {
//     var req = {
//       "type": widget.usertype,
//       "id": widget.parentID,
//       "platform": GemsGLobals.osType,
//       "deviceid": GemsGLobals.deviceId,
//       "devicename": GemsGLobals.deviceName,
//       "deviceimei": "",
//       "latitude": GemsGLobals.lat,
//       "longitude": GemsGLobals.long
//     };

//     Internetconnectivity().isConnected().then((result) async {
//       if (result) {
//         _generateOTPPresenter.getotp(req);
//       } else {
//         noConnection = await Navigator.push(context,
//             MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
//         if (noConnection != null) {
//           otpapiCall();
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget _appBar() {
//       return Container(
//         height: 60,
//         child: Stack(
//           children: <Widget>[
//             GestureDetector(
//               onTap: () {
//                 _makesenseEventCall("back", "");
//                 Navigator.pop(context);
//                  setState(() {
//             GemsGLobals.deeplinkloader=false;
//           });
//               },
//               child: Container(
//                 alignment: Alignment.centerLeft,
//                 height: 40,
//                 width: 40,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.blue[400],
//                 ),
//                 margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
//                 child: Center(
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 10.0),
//                     child: Icon(
//                       Icons.arrow_back_ios,
//                       size: 27,
//                       color: white_text_color,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               alignment: Alignment.center,
//               child: TextWidget(
//                 text: "I am a GEMS Parent",
//                 color: white_text_color,
//                 size: text_font_medium19_size,
//                 weight: FontWeight.w500,
//               ),
//             )
//           ],
//         ),
//       );
//     }

//     Widget _gemsLogo() {
//       return Container(
//         margin: EdgeInsets.only(top: 40, right: 40, left: 20),
//         child: Center(
//           child: Image.asset(
//             "images/login/logo_login.png",
//             color: white_text_color,
//             height: 100,
//           ),
//         ),
//       );
//     }

//     Widget _login() {
//       return Container(
//         child: Column(
//           children: <Widget>[
//             Container(
//               margin: EdgeInsets.only(top: 40),
//               child: Center(
//                 child: TextWidget(
//                   text: "Login Using OTP",
//                   color: white_text_color,
//                   size: text_font_large_size,
//                   weight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     Widget _loginpass() {
//       return Container(
//         child: Column(
//           children: <Widget>[
//             Container(
//               margin: EdgeInsets.only(top: 40, bottom: 20),
//               child: Center(
//                 child: TextWidget(
//                   text: "Login Using Password",
//                   color: grey_color_300,
//                   size: text_font_large_size,
//                   weight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     Widget _password() {
//       return Container(
//         margin: EdgeInsets.symmetric(horizontal: 20),
//         child: Form(
//           key: _formKey,
//           autovalidateMode: _autoValidate,
//           child: Column(
//             children: <Widget>[
//               Container(
//                 child: TextFormField(
//                     controller: password,
//                     obscureText: editable,
//                     focusNode: nodeTwo,
//                     onFieldSubmitted: (term) {
//                       nodeTwo.unfocus();
//                     },
//                     validator: (String? arg) {
//                       if ((arg ?? '').isEmpty) {
//                         return "Please enter your Password";
//                       } else {
//                         return null;
//                       }
//                     },
//                     cursorWidth: 1.0,
//                     style: TextStyle(
//                         color: white_text_color,
//                         fontSize: text_font_medium15_size,
//                         fontWeight: FontWeight.normal),
//                     textInputAction: TextInputAction.done,
//                     decoration: InputDecoration(
//                         contentPadding: EdgeInsets.only(top: 15),
//                         focusedBorder: UnderlineInputBorder(
//                           borderSide: BorderSide(color: white_text_color),
//                         ),
//                         counterText: "",
//                         errorMaxLines: 2,
//                         prefixIcon: Container(
//                           height: 10,
//                           width: 10,
//                           padding: const EdgeInsets.all(13),
//                           child: Image.asset(
//                             "images/login/password.png",
//                             // scale: 7,
//                           ),
//                         ),
//                         hintText: "Parent portal password",
//                         hintStyle: TextStyle(
//                             color: grey_color_300,
//                             fontSize: text_font_medium15_size,
//                             fontWeight: FontWeight.normal),
//                         suffixIcon: GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 if (editable == true) {
//                                   editable = false;
//                                 } else {
//                                   editable = true;
//                                 }
//                               });
//                             },
//                             child: editable == true
//                                 ? Image.asset(
//                                     "images/login/view.png",
//                                     scale: 1.2,
//                                     color: grey_color_300,
//                                   )
//                                 : Container(
//                                     padding: EdgeInsets.only(right: 10),
//                                     child: Image.asset(
//                                       "images/login/view_click.png",
//                                       scale: 6,
//                                     ),
//                                   )))),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     Widget _forgotPassword() {
//       return GestureDetector(
//           onTap: () async {
//             const url = 'https://selfreset.gemseducation.com/default.aspx';
//             if (await canLaunch(url)) {
//               await launch(url);
//             } else {
//               throw 'Could not launch $url';
//             }
//           },
//           child: Container(
//             alignment: Alignment.center,
//             margin: EdgeInsets.only(top: 30),
//             child: Center(
//               child: TextWidget(
//                 text: "Forgot Password",
//                 color: grey100_color,
//                 weight: FontWeight.w500,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           ));
//     }

//     Widget _submitButton() {
//       return GestureDetector(
//           onTap: () {
//             _makesenseEventCall("Verified", "Success");
//             if (_formKey.currentState?.validate() == true) {
//               setState(() {
//                 _formKey.currentState?.save();
//                 isloading = true;
//                 passwordLoginapiCall();
//                 // Navigator.of(context)
//                 //     .push(MaterialPageRoute(builder: (context) => StaffOTP()));
//               });
//             } else {
//               setState(() {
//                 _autoValidate = AutovalidateMode.always;
//               });
//             }
//           },
//           child: isloading == false
//               ? Container(
//                   height: 55,
//                   width: 55,
//                   margin: EdgeInsets.only(top: 30, left: 30, right: 30),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: green_color),
//                   child: Center(
//                     child: TextWidget(
//                       text: "Submit",
//                       color: white_text_color,
//                       size: text_font_medium18_size,
//                       weight: FontWeight.w700,
//                     ),
//                   ))
//               : Container(
//                   margin: EdgeInsets.only(
//                     top: 30,
//                   ),
//                   child: SpinKitCircle(
//                     color: Colors.blue,
//                   ),
//                 ));
//     }

//     Widget _or() {
//       return Container(
//         margin: EdgeInsets.only(left: 30, right: 30, top: 30),
//         child: Row(
//           children: <Widget>[
//             Container(
//               height: 1,
//               width: MediaQuery.of(context).size.width / 3.2,
//               decoration: BoxDecoration(
//                 color: white_text_color,
//               ),
//             ),
//             Expanded(
//               child: Container(
//                   margin: EdgeInsets.only(left: 5, right: 5),
//                   child: Center(
//                     child: TextWidget(
//                       text: "OR",
//                       size: 15,
//                       color: grey100_color,
//                     ),
//                   )),
//             ),
//             Container(
//               height: 1,
//               width: MediaQuery.of(context).size.width / 3.2,
//               decoration: BoxDecoration(
//                 color: white_text_color,
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     Widget _loginusingotp() {
//       return GestureDetector(
//           onTap: () {
//             setState(() {
//               _isLoadingotp = true;
//               otpapiCall();
//             });
//           },
//           child: _isLoadingotp == false
//               ? Container(
//                   height: 55,
//                   width: 55,
//                   margin: EdgeInsets.only(top: 20, left: 30, right: 30),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.orange),
//                   child: Center(
//                     child: TextWidget(
//                       text: "Get OTP",
//                       color: white_text_color,
//                       size: text_font_medium18_size,
//                       weight: FontWeight.w500,
//                     ),
//                   ))
//               : Container(
//                   margin: EdgeInsets.only(top: 20),
//                   child: SpinKitCircle(
//                     color: Colors.blue,
//                   ),
//                 ));
//     }

//     Widget _skip() {
//       return GestureDetector(
//         onTap: () {
//           setState(() {
//             AuthUtils.setuserType("guest");
//             GemsGLobals.userType = "guest";
//             _makesenseEventCall("skip", "");
//           });
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => TabsScreen(
//                         initialIndex: 0,
//                       )));
//         },
//         child: Container(
//             height: 100,
//             child: Center(
//               child: TextWidget(
//                 text: "Skip",
//                 color: white_text_color,
//                 weight: FontWeight.w500,
//                 decoration: TextDecoration.underline,
//               ),
//             )),
//       );
//     }

//     Widget _body() {
//       return Container(
//         height: MediaQuery.of(context).size.height,
//         decoration: BoxDecoration(
//           gradient: gradient_theme_color,
//           // image: DecorationImage(
//           //     image: AssetImage("images/login/bg_login.jpg"),
//           //     fit: BoxFit.cover),
//         ),
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               child: ListView(
//                 children: <Widget>[
//                   _appBar(),
//                   _gemsLogo(),
//                   _login(),
//                   _loginusingotp(),
//                   _or(),
//                   _loginpass(),
//                   _password(),
//                   _submitButton(),
//                   _forgotPassword(),
//                   _skip()
//                 ],
//               ),
//             )
//           ],
//         ),
//       );
//     }

//     return Container(
//       color: blue_color,
//       child: SafeArea(
//         top: false,
//         bottom: false,
//         child: WillPopScope(
//           onWillPop: () async {
//           setState(() {
//             GemsGLobals.deeplinkloader=false;
//           });
//           return false;
//         },
//           child: Scaffold(
//             body: _body(),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void allErr(error) {
//     // TODO: implement allErr
//   }

//   @override
//   void response(GenerateOtpModal generateOtpModal) {
//     setState(() {
//        _isLoadingotp = false;
//     });
   

//     if (generateOtpModal.status == true) {
//       isloading = false;
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => ParentOtpPage(
//                     userType: 0,
//                     otp: generateOtpModal.values!.otp,
//                     token: generateOtpModal.values!.token,
//                     mobilenumber: widget.parentID,
//                     email: generateOtpModal.values!.email,
//                     membershipNo: generateOtpModal.values!.membershipNo
//                   )));
//       if (GemsGLobals.geustLoginFlag != null) {
//         Navigator.pop(context);
//       }
//     } else if (generateOtpModal.status == false) {
//       setState(() {
//         isloading = false;
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: blue_color,
//             content: Text(generateOtpModal.message.toString())));
//       });
//     }
//   }

//   @override
//   void parentPasswordloginview(ParentPasswordModel parentPasswordModel) {
//     setState(() async {
//       if (parentPasswordModel.status == true) {
//         isloading = false;
//         AuthUtils.setuserType("0");

//         // GemsGLobals.userType = "parent";

//         if (GemsGLobals.geustLoginCheck != null) {
//           setState(() {
//             GemsGLobals.userType = "parent";
//             GemsGLobals.geustLoginFlag = 1;
//           });

//           Navigator.pop(context);
//         } else {
//           AuthUtils.setStringValue(
//               "membershipNo", parentPasswordModel.values!.membershipNo ?? '');
//           GemsGLobals.membershipNo =
//               await AuthUtils.getStringValue("membershipNo");

//         AuthUtils.setStringValue(
//             "alumni", parentPasswordModel.values!.email ?? '');
//         GemsGLobals.useremail =
//             await AuthUtils.getStringValue("alumni"); 

//           GemsGLobals.useremail = parentPasswordModel.values!.email ?? '';
//           GemsGLobals.userType = parentPasswordModel.values!.type ?? '';
//           GemsGLobals.userId = parentPasswordModel.values!.gemsCustomerId ?? '';
//           GemsGLobals.mobilenumber = parentPasswordModel.values!.phone ?? '';
//           GemsGLobals.countryCode =
//               parentPasswordModel.values!.countryCode ?? '';
//           GemsGLobals.membershipNo =
//               parentPasswordModel.values!.membershipNo ?? '';
//           GemsGLobals.userFirstName =
//               parentPasswordModel.values!.firstName ?? '';
//           GemsGLobals.userLastName = parentPasswordModel.values!.lastName ?? '';
//           GemsGLobals.schoolcode = parentPasswordModel.values!.schoolCode ?? '';

//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => TabsScreen(
//                   initialIndex: 0,
//                 ),
//               ));
//                String keyName = "Success Login";
//         var segmentReq = {
//           "User type": 'parent',
//           "membership ID": parentPasswordModel.values!.membershipNo ?? '',
//           "success login": 'parent',
//           "login homepage clicks": 'parent'
//         };
//         MakesenseApiClass.makesenseEventsApi(
//             http.Client(), segmentReq, keyName);
//         }
//       } else if (parentPasswordModel.status == false) {
//         setState(() {
//           isloading = false;
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//               padding: EdgeInsets.all(0),
//               backgroundColor: blue_color,
//               content: Padding(
//                 padding: const EdgeInsets.only(top: 15.0, bottom: 15, left: 20),
//                 child: Text("Incorrect password!"),
//               )));
//           _makesenseEventCall("Verified", "Failed");
//            String keyName = "Success Login";
//         var segmentReq = {
//           "User type": 'parent',
//           "membership ID": this.widget.membershipNo,//parentPasswordModel.membershipNo ?? '',
//           "failed login": 'parent'
//         };
//         MakesenseApiClass.makesenseEventsApi(
//             http.Client(), segmentReq, keyName);
//         });
//       }
//     });
//   }
// }
