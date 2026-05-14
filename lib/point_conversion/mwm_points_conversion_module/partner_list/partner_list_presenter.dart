import 'package:http/http.dart' as http;

import '../partner_api_config.dart';
import 'partner_list_view.dart';

class PartnerListPresenter {
  late PartnerListView partnerListView;

  PartnerListPresenter(this.partnerListView);
  Future<void> partnerListResponse() async {
    await PartnerApiConfig.partnerListApi(http.Client()).then((value) {
      partnerListView.partnerListSuccess(value);
    }).catchError((err) {
      partnerListView.partnerListErr(err.toString());
    });
  }
}
