import 'package:gems_revamp/Login_module/alumni_login/alumni_register/alumni_register_view.dart';
import 'package:gems_revamp/Login_module/apiConfig/apiConfig_login.dart';
import 'package:http/http.dart' as http;


class AlumniRegisterPresenter{
  late AlumniRegisterView _alumniRegisterView;
  AlumniRegisterPresenter(this._alumniRegisterView);

 alumniRegister(req,passing) {
    LoginApiconfig.alumniRegisterApi(http.Client(), req).then((value) {
      this._alumniRegisterView.alumniRegisterview(value,passing);
    }).catchError((err) {
      this._alumniRegisterView.allErr(err);
    });
  }
}