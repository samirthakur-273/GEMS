import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gems_revamp/common_widget/colors_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/font_size.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/internetconnectingbox.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/loader_widget.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/text_widget.dart';
import 'package:gems_revamp/eshop_module_new/constants.dart';
import 'package:gems_revamp/eshop_module_new/forgot_password/model/forgot_password_model.dart';
import 'package:gems_revamp/eshop_module_new/forgot_password/presenter/forgot_password_presenter.dart';
import 'package:gems_revamp/eshop_module_new/forgot_password/view/forgot_password_view.dart';
import 'package:gems_revamp/eshop_module_new/service_unavailable/service_unavailable.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>
    implements ForgotPasswordView {
  TextEditingController _emailController = new TextEditingController();
  var email;
  var _emailErrmsg;
  bool _isEmailErr = false;
  bool _isLoading = false;

  ForgotPasswordPresenter? _forgotPasswordPresenter;
  //ForgotPasswordModel data;

  @override
  void initState() {
    _emailController.addListener(emailListner);
    _forgotPasswordPresenter = ForgotPasswordPresenter(this);
    super.initState();
  }

  onChanged() {
    email = _emailController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: TextWidget(
          text: "Forgot Password",
          color: theme_color,
          size: 20.0,
          weight: FontWeight.bold,
        ),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            child: TextWidget(
              text:
                  "Please enter your email address below to receive a password reset link",
              color: Colors.black,
            ),
          ),
          _textLabel("email"),
          _emailTextfield(),
          _isLoading
              ? Container(
                  padding: EdgeInsets.only(top: 18, bottom: 18),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
                  child: Container(
                      height: 30,
                      width: 30,
                      child: Loader(
                        color: theme_color,
                      )),
                )
              : Container(
                  margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      textStyle: WidgetStateProperty.all(TextStyle(
                        color: Colors.white
                      )),
                      backgroundColor: WidgetStateProperty.all(theme_color),
                      padding: WidgetStateProperty.all(EdgeInsets.only(top: 18, bottom: 18))
                    ),
                    // textColor: Colors.white,
                    // color: theme_color,
                    // padding: EdgeInsets.only(top: 18, bottom: 18),
                    child: TextWidget(
                      text: "Submit",
                      color: Colors.white,
                      weight: FontWeight.bold,
                    ),
                    onPressed: () {
                      _emailIdValidation();
                      internetCall(context, () {
                        if (_isEmailErr == false) {
                          var body = {
                            "brandcode": Constants.brandCode,
                            "country_code": Constants.countryCode,
                            "lang_code": Constants.langCode,
                            "email": _emailController.text
                          };
                          _isLoading = true;

                          _forgotPasswordPresenter
                              ?.loadForgotPasswordData(body);
                          setState(() {
                            _isLoading = true;
                          });
                        }
                      });
                      _isLoading = false;
                    },
                  ),
                ),
        ],
      ),
    );
  }

  void _emailIdValidation() {
    if (_emailController.text.isEmpty) {
      setState(() {
        _isEmailErr = true;
        _emailErrmsg = "email_blank";
      });
    } else if (_emailController.text.length < 2 ||
        _emailController.text.length > 50) {
      setState(() {
        _isEmailErr = true;
        _emailErrmsg = "email_valid";
      });
    } else {
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(_emailController.text);
      if (emailValid == true) {
        setState(() {
          _isEmailErr = false;
          _emailErrmsg = "";
        });
      } else {
        setState(() {
          _isEmailErr = true;
          _emailErrmsg = "email_valid";
        });
      }
    }
  }

  Widget _textLabel(label) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
      child: TextWidget(
        text: label,
        size: text_font_size_x_small,
        color: Colors.black,
      ),
    );
  }

  Widget _emailTextfield() {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
            child: TextFormField(
              textAlign: TextAlign.left,
              autofocus: false,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: text_font_size_x_small,
                  fontWeight: FontWeight.normal),
              controller: _emailController,
              onChanged: onChanged(),
              enabled: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                hintText: "",
                hintStyle: TextStyle(
                    color: Colors.black, fontSize: text_font_size_x_small),
              ),
            ),
          ),
          _isEmailErr
              ? Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, left: 20.0, right: 20.0),
                    child: TextWidget(
                      text: _emailErrmsg ?? "",
                      color: red_color,
                      size: 13,
                    ),
                  ),
                )
              : Container(
                  height: 0,
                )
        ]));
  }

  @override
  void forgotPasswordError(error) {}

  @override
  void forgotPasswordResponse(ForgotPasswordModel response) {
    setState(() {
      _isLoading = false;
      //data = response;
      if (response.success == "true") {
        _isEmailErr = false;
        Fluttertoast.showToast(
            msg: response.message.toString(),
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xAA000000),
            textColor: white_text_color,
            toastLength: Toast.LENGTH_LONG);
        /*Fluttertoast.showToast(
            msg: response.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );*/
      } else {
        _isEmailErr = true;
        Fluttertoast.showToast(
            msg: response.message.toString(),
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Color(0xAA000000),
            textColor: white_text_color,
            toastLength: Toast.LENGTH_LONG);
        /*Fluttertoast.showToast(
            msg: response.message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );*/
      }
    });
  }

  void emailListner() {
    if (_emailController.text.length > 0) {
      setState(() {
        _isEmailErr = false;
        _emailErrmsg = "";
      });
    }
  }

  @override
  void onTimeout() {
    var body = {
      "brandcode": Constants.brandCode,
      "country_code": Constants.countryCode,
      "lang_code": Constants.langCode,
      "email": _emailController.text
    };
    if (mounted)
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (cxt) => ServiceUnavailable(
                  onRetry: () =>
                      _forgotPasswordPresenter?.loadForgotPasswordData(body))));
  }
}
