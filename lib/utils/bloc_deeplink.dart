import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/Login_module/alumni_login/alumni_login.dart';
import 'package:gems_revamp/Login_module/alumni_login/alumni_register/alumni_register_model.dart';
import 'package:gems_revamp/Login_module/alumni_login/alumni_register/alumni_register_presenter.dart';
import 'package:gems_revamp/Login_module/alumni_login/alumni_register/alumni_register_view.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/utils/gemsGlobals.dart';

import '../Login_module/parent_login/check_member/parent_poratId_page.dart';
import '../Login_module/staff_login/staff_login/staff_login.dart';
import '../common_widget/text_widget.dart';
import '../eshop_module_new/common_widget/font_size.dart';
import '../utilities/auth_utils.dart';
import 'connectivity.dart';

abstract class Bloc {
  void dispose();
}
// class DeepLinkBloc extends StatefulWidget {
//   const DeepLinkBloc({ Key? key }) : super(key: key);

//   @override
//   State<DeepLinkBloc> createState() => _DeepLinkBlocState();
// }

// class _DeepLinkBlocState extends State<DeepLinkBloc> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

class DeepLinkBloc extends Bloc implements AlumniRegisterView {
  var arrayStr;
  var urlParam;
  var paramalues;
  List _list = [];

  var noConnection;
  bool loader = false;
  late AlumniRegisterPresenter _alumniRegisterPresenter;
  // var username;
  // var schoolcode;
  // var usertype;

  static const stream = const EventChannel('gemsrewardsdeeplinkuat.com/events');

  static const platform =
      const MethodChannel('gemsrewardsdeeplinkuat.com/channel');

  StreamController<String> _stateController = StreamController();

  late BuildContext context;

  Stream<String> get state => _stateController.stream;

  Sink<String> get stateSink => _stateController.sink;

  DeepLinkBloc() {
    startUri().then(_onRedirected);
    stream.receiveBroadcastStream().listen((d) => _onRedirected(d));
// var uri='poc://deeplink.flutter.dev/firstname="sonal"/lastname="Agar"/schoolcode="123"/type="parent"';
  }

  _onRedirected(dynamic uri) async {
  //   stateSink.add(uri);
  //   // GemsGLobals.deeplinkloader=true;
  //   var encoded = Uri.encodeFull(uri);

  //   var decoded = Uri.decodeFull(encoded);
  //   arrayStr = [];
  //   urlParam = [];
  //   _list = [];
  //   uri = uri.replaceAll("//", "");
  //   arrayStr = uri.split('/');
  //   for (var i = 1; i < arrayStr.length; i++) {
  //     urlParam = arrayStr[i].split('=');
  //     paramalues = urlParam[1].replaceAll('"', ' ');
  //     // print(urlParam);
  //     // print(paramalues);
  //     // print(arrayStr);
  //     _list.add(paramalues);
  //   }

  //   if (_list[0] != null && _list[0] != "") {
  //     GemsGLobals.saveusername = _list[0];
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString(AuthUtils.savingusername, GemsGLobals.saveusername);
  //   }

  //   if (_list[1] != null && _list[1] != "") {
  //     GemsGLobals.schoolcode = _list[1];
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString(AuthUtils.savingschoolcode, GemsGLobals.schoolcode);
  //   }
  //   if (_list[2] != null && _list[2] != "") {
  //     print("aaaaaaaa");
  //     GemsGLobals.type = _list[2];
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString(AuthUtils.savingusertype, GemsGLobals.type);
  //   }
  //   if (_list[4] != null && _list[4] != "") {
  //     print("bbbbbbbb");
  //     print(_list[4].toString());
  //     GemsGLobals.email = _list[4].toString().replaceAll(" ", "");
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     prefs.setString(AuthUtils.savinguseremail, GemsGLobals.email);
  //   }
  //   print("fullllllllll");
  //   print(GemsGLobals.saveusername);
  //   print(GemsGLobals.schoolcode);
  //   print(GemsGLobals.type);
  //   print(GemsGLobals.email);

  //   print("commmmeeeeeeeeeeeeee");
  //   print(GemsGLobals.email);
  //   _alumniRegisterPresenter = AlumniRegisterPresenter(this);
  //   // if (GemsGLobals.membershipNo == null || GemsGLobals.membershipNo == "") {
  //   alumniRegisterApicall();
  //   // }

    // }
    // if (uri.endsWith("parameter")) {
    //   //Get.toNamed('/profile');
    //   print("parameter");
    // } else if (uri.endsWith("example")) {
    //   // Get.toNamed('/example');
    //   print("example");
    // } else if (uri.endsWith("newScreen")) {
    //   Get.toNamed('/newScreen');
    // } else {
    //   //navigate to home screen
    // }
  }

  void alumniRegisterApicall() {
    var req = {
      // "email": loginController.text,
      // "email": "tenplus@yopmail.com"
      // "email":"sonal@gmail.com"
      "email": GemsGLobals.email
    };
    Internetconnectivity().isConnected().then((result) async {
      if (result) {
        _alumniRegisterPresenter.alumniRegister(req,"");
      } else {
        // noConnection = await Navigator.push(context,
        //     MaterialPageRoute(builder: (BuildContext context) => NoInternet()));
        if (noConnection != null) {
          alumniRegisterApicall();
        }
      }
    });
  }

  @override
  void dispose() {
    _stateController.close();
  }

  Future<dynamic> startUri() async {
    try {
      return platform.invokeMethod('initialLink');
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }

  static Future<dynamic> copyVouchercode(BuildContext context, message) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0))),
          child: Container(
            margin: EdgeInsets.only(top: 0, left: 10, right: 5, bottom: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.maybePop(context);
                  },
                  child: Container(
                      margin: EdgeInsets.only(top: 5, bottom: 10, right: 5),
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.close_outlined,
                        color: shadow_color,
                      )),
                ),
                Center(
                  child: TextWidget(
                    alignment: TextAlign.center,
                    text: message,
                    size: 15,
                    weight: FontWeight.bold,
                    softwrap: true,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 5),
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          color: blue_color,
                        ),
                        borderRadius: BorderRadius.circular(3)),
                    child: TextButton(
                      child: TextWidget(
                        text: 'OK',
                        alignment: TextAlign.center,
                        color: blue_color,
                        size: text_font_size_small,
                        weight: FontWeight.bold,
                      ),
                      onPressed: () async {
                        if (message == 'Already registerd as staff') {
                          // setState(() {
                          AuthUtils.setuserType("1");
                          // });

                          Navigator.pop(context);
                          var staff = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StaffLogin(
                                        usertype: "staff",
                                      )));

                          if (GemsGLobals.geustLoginFlag != null) {
                            Navigator.pop(context);
                          }
                        } else if (message == 'Already registerd as parent') {
                          // setState(() {
                          AuthUtils.setuserType("0");
                          // });

                          // _makesenseEventCall(
                          //     "Tapped parent", "value from frontend for login");
                          Navigator.pop(context);

                          var parent = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ParentPortalId(
                                        usertype: "parent",
                                      )));
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void allErr(error) {
    // TODO: implement allErr
  }

  @override
  void alumniRegisterview(AlumniRegisterModel alumniRegisterModel,data) {
    // isloading = false;
    if (alumniRegisterModel.status == true) {
      GemsGLobals.alumniStatus = true;
      //  setState(() {
      GemsGLobals.deeplinkloader = true;
      // });
      if (alumniRegisterModel.message == 'Already registerd as alumni' ||
          alumniRegisterModel.message == "Alumni Registered Successful") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AlumniLogin(
                      usertype: "alumni",
                    )));
        GemsGLobals.deeplinkloader = false;
      } else if (alumniRegisterModel.message!.contains("Already register") ||
          alumniRegisterModel.message != 'Already registerd as alumni') {
        GemsGLobals.deeplinkloader = false;
        copyVouchercode(context, alumniRegisterModel.message);
      }
    } else if (alumniRegisterModel.status == false) {
      GemsGLobals.alumniStatus = false;
      GemsGLobals.deeplinkloader = false;

      // setState(() {
      // isloading = false;
      Fluttertoast.showToast(
          msg: alumniRegisterModel.message.toString(),
          // msg:GemsGLobals.email,
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Color(0xAA000000),
          textColor: white_text_color,
          gravity: ToastGravity.BOTTOM);
      // });
    }
  }
}
    // private val CHANNEL = "gemsrewards.deepLink.gemsrewards.com/channel"
    // private val EVENTS = "gemsrewards.deepLink.gemsrewards.com/events"
