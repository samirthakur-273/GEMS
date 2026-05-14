import 'package:gems_revamp/Login_module/apiConfig/apiConfig_login.dart';
import 'package:gems_revamp/Login_module/parent_login/verifyOTP/verifyotp_view.dart';
import 'package:http/http.dart' as http;

class VerifyOTPPresenter {
  late VerifyOtpView _verifyOtpView;
  VerifyOTPPresenter (this._verifyOtpView);
  verifyOtp(req) {
    LoginApiconfig.verifyOtpApi(http.Client(), req).then((value) {
      this._verifyOtpView.response(value);
    }).catchError((err) {
      this._verifyOtpView.verifyErr(err);
    });
  }
}
