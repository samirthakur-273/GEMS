import 'package:gems_revamp/Login_module/apiConfig/apiConfig_login.dart';
import 'package:gems_revamp/Login_module/parent_login/check_member/login_types_view.dart';
import 'package:http/http.dart' as http;

class LoginTypesPresenter{
  late LoginTypesView _loginTypesView;
  LoginTypesPresenter(this._loginTypesView);

 loginTypes(req) {
    LoginApiconfig.checkMemberApi(http.Client(), req).then((value) {
      this._loginTypesView.loginTypesview(value);
    }).catchError((err) {
      this._loginTypesView.allErr(err);
    });
  }
}