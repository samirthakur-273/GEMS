import 'package:gems_revamp/offer_module/offer_apis/apiconfigoffer.dart';
import 'package:gems_revamp/offer_module/offer_pin/view_offerredeem.dart';
import 'package:http/http.dart' as http;

class OfferRedeemPresenter {
  OfferRedeemView offeredeemView;
  OfferRedeemPresenter(this.offeredeemView);

  void offerRedeemAPI(request) {
    OfferApiconfig.offerRedeemApi(http.Client(), request).then((response) {
      offeredeemView.offeredeemResponseSuccess(response);
    }).catchError((onError) {

    });
  }

  void newofferRedeemAPI(request) {
    OfferApiconfig.newOfferRedeemApi(http.Client(), request).then((response) {
      offeredeemView.newOfferedeemResponseSuccess(response);
    }).catchError((onError) {

    });
  }
}
