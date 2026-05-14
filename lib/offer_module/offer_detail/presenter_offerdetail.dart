import 'package:gems_revamp/offer_module/offer_apis/apiconfigoffer.dart';
import 'package:gems_revamp/offer_module/offer_detail/view_offerdetail.dart';
import 'package:http/http.dart' as http;

class OfferDetailsPresenter {
  OfferDetailsView offerdetailView;
  OfferDetailsPresenter(this.offerdetailView);

  void offerDetailsAPI(request) {
    OfferApiconfig.offerDetailsApi(http.Client(), request).then((response) {
      offerdetailView.offerdetailsResponseSuccess(response);
    }).catchError((onError) {
     
    });
  }
}
