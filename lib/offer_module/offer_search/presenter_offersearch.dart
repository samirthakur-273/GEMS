import 'package:gems_revamp/offer_module/offer_apis/apiconfigoffer.dart';
import 'package:gems_revamp/offer_module/offer_search/view_offersearch.dart';
import 'package:http/http.dart' as http;

class OfferSearchPresenter {
  OfferSearchView offersearchView;
  OfferSearchPresenter(this.offersearchView);

  void offerSearchAPI(request) {
    OfferApiconfig.offerSearchApi(http.Client(), request).then((response) {
      offersearchView.offersearchResponseSuccess(response);
    }).catchError((onError) {
     
    });
  }
}
