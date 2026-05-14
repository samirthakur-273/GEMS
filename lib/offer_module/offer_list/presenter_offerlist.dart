import 'package:gems_revamp/offer_module/offer_apis/apiconfigoffer.dart';
import 'package:gems_revamp/offer_module/offer_list/view_offerlist.dart';
import 'package:http/http.dart' as http;

class OfferListPresenter {
  OfferListView offerlistView;
  OfferListPresenter(this.offerlistView);

  void offerListAPI(request) {

    OfferApiconfig.offerListApi(http.Client(),request)
        .then((response) {
            
      offerlistView.offerlistResponseSuccess(response);
    }).catchError((onError) {
      
    });
  }
}
