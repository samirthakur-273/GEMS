import 'package:gems_revamp/giftcard_module/gift_api_utls/api_config.dart';
import 'package:gems_revamp/giftcard_module/pg_module/pg_view.dart';
import 'package:http/http.dart' as http;

class GiftPGInitPresenter {
  late GiftPGInitView _giftPGInitView;
  getList(GiftPGInitView giftPGInitView, request) {
    _giftPGInitView = giftPGInitView;
    GiftApiconfig.pgInit(http.Client(), request).then((value) {
      //Print("CCCCC");
      this._giftPGInitView.pgResp(value);
    }).catchError((err) {
      this._giftPGInitView.allErr(err);
    });
  }
}
