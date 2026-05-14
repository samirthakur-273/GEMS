import 'package:gems_revamp/Login_module/apiConfig/apiConfig_login.dart';
import 'package:gems_revamp/Login_module/parent_login/login_password/parent_password_view.dart';
import 'package:http/http.dart' as http;

class ParentPasswordPresenter{
  late ParentPasswordView _parentPasswordView;
  ParentPasswordPresenter(this._parentPasswordView);

 staffLogin(req) {
    LoginApiconfig.parentPasswordLogin(http.Client(), req).then((value) {
      this._parentPasswordView.parentPasswordloginview(value);
    }).catchError((err) {
      this._parentPasswordView.allErr(err);
    });
  }
}