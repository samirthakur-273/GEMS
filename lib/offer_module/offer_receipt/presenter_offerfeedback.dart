import 'package:gems_revamp/offer_module/offer_apis/apiconfigoffer.dart';
import 'package:gems_revamp/offer_module/offer_receipt/view_offerfeedback.dart';
import 'package:http/http.dart' as http;

class OfferFeedbackPresenter {
  OfferFeedbackView offerFeedbackView;
  OfferFeedbackPresenter(this.offerFeedbackView);

  void callOfferFeedbackAPI(request) {
    OfferApiconfig.offerFeedbackApi(http.Client(), request).then((response) {
      offerFeedbackView.getofferfeedbackResponseSuccess(response);
      // }
    }).catchError((onError) {
      
    });
  }
}
