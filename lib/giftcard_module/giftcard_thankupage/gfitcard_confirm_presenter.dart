import 'package:gems_revamp/giftcard_module/gift_api_utls/api_config.dart';
import 'package:gems_revamp/giftcard_module/giftcard_thankupage/gfitcard_confirm_view.dart';
import 'package:http/http.dart' as http;


class GiftCnfrmPresenter {
  GiftCnfrmView? _giftCnfrmView;
  getList(GiftCnfrmView giftCnfrmView, request) {
    _giftCnfrmView = giftCnfrmView;
    GiftApiconfig.pgUpdate(http.Client(), request).then((value) {
      this._giftCnfrmView!.confirmResp(value);
    }).catchError((err) {
      this._giftCnfrmView!.allErr(err);
    });
  }
}
