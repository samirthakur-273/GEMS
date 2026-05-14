import 'package:gems_revamp/giftcard_module/gift_api_utls/api_config.dart';
import 'package:gems_revamp/giftcard_module/giftcard_detailspage/giftcard_deatails_view.dart';
import 'package:http/http.dart' as http;

class GiftDetailsPresenter {
  late GiftCardDetailsView _giftCardDetailsView;
  getGiftcardDetails(GiftCardDetailsView giftCardDetailsView, int brandId,
       String supplierCode) {
    _giftCardDetailsView = giftCardDetailsView;
    GiftApiconfig.getDetailsList(
            http.Client(), brandId, supplierCode)
        .then((value) {
      this._giftCardDetailsView.giftdeatailsresponse(value);
    }).catchError((err) {
      this._giftCardDetailsView.giftdetailserr(err);
    });
  }
}