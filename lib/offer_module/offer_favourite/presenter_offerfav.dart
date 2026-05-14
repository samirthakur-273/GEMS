import 'package:gems_revamp/offer_module/offer_apis/apiconfigoffer.dart';
import 'package:gems_revamp/offer_module/offer_favourite/view_offerfav.dart';
import 'package:http/http.dart' as http;

class OfferFavPresenter {
  OfferFavouriteView offerfavView;
  OfferFavPresenter(this.offerfavView);

  void offerFavAPI(request) {
    OfferApiconfig.offerFavApi(http.Client(), request).then((response) {
      offerfavView.offerfavResponseSuccess(response);
    }).catchError((onError) {
     
    });
  }
}
