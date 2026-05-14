import 'package:gems_revamp/Login_module/apiConfig/apiConfig_login.dart';
import 'package:gems_revamp/Login_module/parent_login/resend_otp/resend_parent_view.dart';
import 'package:http/http.dart' as http;


class ParentResendOtpPresenter{
  late ParentResendOtpView _parentResendOtpView;
  ParentResendOtpPresenter(this._parentResendOtpView);

 resendOtp(req) {
    LoginApiconfig.parentResendOtp(http.Client(), req).then((value) {
      this._parentResendOtpView.parentResendOtpview(value);
    }).catchError((err) {
      this._parentResendOtpView.allErr(err);
    });
  }
}