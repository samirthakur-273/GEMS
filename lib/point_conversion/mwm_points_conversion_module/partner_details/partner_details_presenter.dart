import 'package:http/http.dart' as http;

import '../partner_api_config.dart';
import 'partner_details_view.dart';

class PartnerDetailsPresenter {
  late PartnerDetailsView partnerDetailsView;

  PartnerDetailsPresenter(this.partnerDetailsView);
  Future<void> partnerDetailsResponse(String? partnerCurrencyCode) async {
    await PartnerApiConfig.partnerDetailsApi(http.Client(), partnerCurrencyCode)
        .then((value) {
      partnerDetailsView.partnerDetailsSuccess(value);
    }).catchError((err) {
      partnerDetailsView.partnerDetailsErr(err.toString());
    });
  }
}
