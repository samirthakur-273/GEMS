import '../../partner_api_config.dart';
import 'validate_otp_view.dart';
import 'package:http/http.dart' as http;


class ValidateOtpPresenter {
  late ValidateOTPView validateOTPView;

  ValidateOtpPresenter(this.validateOTPView);
  Future<void> validateOtpResponse(Map<String, dynamic> request) async {
    await PartnerApiConfig.validateOtpApi(http.Client(), request)
        .then((value) {
      validateOTPView.validateOtpSuccess(value);
    }).catchError((err) {
      validateOTPView.validateOtpErr(err.toString());
    });
  }
}