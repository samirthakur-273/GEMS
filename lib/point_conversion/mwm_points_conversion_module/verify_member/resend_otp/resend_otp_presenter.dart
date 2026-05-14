import 'package:gems_revamp/point_conversion/mwm_points_conversion_module/partner_api_config.dart';
import 'package:gems_revamp/point_conversion/mwm_points_conversion_module/verify_member/resend_otp/resend_otp_view.dart';
import 'package:http/http.dart' as http;

class ResendOtpPresenter {
  late ResendOtpView resendOtpView;

  ResendOtpPresenter(this.resendOtpView);
  Future<void> resendOtpResponse(Map<String, dynamic> request) async {
    await PartnerApiConfig.resendOtpApi(http.Client(), request)
        .then((value) {
      resendOtpView.resendOtpSuccess(value);
    }).catchError((err) {
      resendOtpView.resendOtpErr(err.toString());
    });
  }
}
