import 'package:gems_revamp/offer_module/offer_apis/apiconfigoffer.dart';
import 'package:gems_revamp/offer_module/offer_list/clinks/clinks_view.dart';
import 'package:http/http.dart' as http;


class ClinksPresenter {
  ClinksView clinksView;
  ClinksPresenter(this.clinksView);

  void clinkAPI(request) {

    OfferApiconfig.clinkApi(http.Client(),request)
        .then((response) {
            
      clinksView.clinksSuccess(response);
    }).catchError((onError) {

    });
  }
}