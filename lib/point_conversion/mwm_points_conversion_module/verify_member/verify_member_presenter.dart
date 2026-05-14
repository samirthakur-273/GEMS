import 'package:http/http.dart' as http;

import '../partner_api_config.dart';
import 'verify_member_view.dart';

class VerifyPartnerPresenter {
  late VerifyPartnerView verifyPartnerView;

  VerifyPartnerPresenter(this.verifyPartnerView);
  Future<void> verifyPartnerResponse(Map<String, dynamic> request) async {
    await PartnerApiConfig.verifyPartnerApi(http.Client(), request)
        .then((value) {
      verifyPartnerView.verifyPartnerSuccess(value);
    }).catchError((err) {
      verifyPartnerView.verifyPartnerErr(err.toString());
    });
  }
}
