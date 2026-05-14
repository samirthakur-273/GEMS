import 'package:gems_revamp/giftcard_module/gift_api_utls/api_config.dart';
import 'package:gems_revamp/my_purchase/gift_purchase/gift_purchase_list/gift_purchase_list_view.dart';
import 'package:http/http.dart' as http;

class GiftPurchaseListPresenter {
  GiftPurchaseListView _giftPurchaseListView;

  GiftPurchaseListPresenter(this._giftPurchaseListView);

  giftPurchaseListApiRes(membershipId,limit) {
    GiftApiconfig.giftPurchaseListApiCall(http.Client(), membershipId,limit)
        .then((value) {
      this._giftPurchaseListView.gcPurchaseListSuccessRes(value);
    }).catchError((err) {
      this._giftPurchaseListView.gcPurchaseListErrorRes(err);
    });
  }
}
