import 'package:http/http.dart' as http;

import '../partner_api_config.dart';
import 'get_membership_list_view.dart';

class GetMembershipListPresenter {
  late GetMembershipView getMembershipView;

  GetMembershipListPresenter(this.getMembershipView);
  Future<void> getMembershipResponse(Map<String, dynamic> request) async {
    await PartnerApiConfig.getMembershipApi(http.Client(), request)
        .then((value) {
      getMembershipView.getMembershipListSuccess(value);
    }).catchError((err) {
      getMembershipView.getMembershipListErr(err.toString());
    });
  }
}
