
import 'package:gems_revamp/hotel_module/hotel_apiconfig/apiconfig_hotel.dart';
import 'package:http/http.dart' as http;

import 'share_email_view.dart';

class ShareViaEmailPresenter {
  ShareViaEmailView? _shareViaEmailView;
  getList(ShareViaEmailView shareViaEmailView, request, type) {
    _shareViaEmailView = shareViaEmailView;
    HotelApiconfig.shareviaemail(http.Client(), request, type).then((value) {
      this._shareViaEmailView!.shareEmailResponse(value);
    }).catchError((err) {
      this._shareViaEmailView!.allErr(err);
    });
  }
}
