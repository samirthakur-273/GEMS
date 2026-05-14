import 'package:gems_revamp/giftcard_module/gift_api_utls/api_config.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/giftcard_voucherlist/giftcard_voucherlist_view.dart';
import 'package:http/http.dart' as http;

class GiftVoucherPresenter {
  late GiftVoucherView _giftVoucherView;
  getList(GiftVoucherView giftVoucherView, String catName,String brandName, String search,
      String sort, currency, String country,bool callapi ) {
    _giftVoucherView = giftVoucherView;

    GiftApiconfig()
        .getVoucherList(http.Client(), catName,brandName, search, sort, currency,
            country, callapi)
        .then((value) {
      this._giftVoucherView.giftvoucherresponse(value);
    }).catchError((err) {
      this._giftVoucherView.voucherlisterr(err);
    });
  }
}
