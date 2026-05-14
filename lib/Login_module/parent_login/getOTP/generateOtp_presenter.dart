import 'package:gems_revamp/Login_module/apiConfig/apiConfig_login.dart';
import 'package:gems_revamp/Login_module/parent_login/getOTP/generateOtp_view.dart';
import 'package:http/http.dart' as http;

class GenerateOTPPresenter {
  late GenetrateOtpView _genetrateOtpView;
  GenerateOTPPresenter(this._genetrateOtpView);
  getotp(req) {
    LoginApiconfig.generateOtpApi(http.Client(), req).then((value) {
      this._genetrateOtpView.response(value);
    }).catchError((err) {
      this._genetrateOtpView.allErr(err);
    });
  }
}
