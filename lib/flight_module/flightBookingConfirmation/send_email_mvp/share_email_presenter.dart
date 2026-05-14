import 'package:gems_revamp/flight_module/flight_utils/flight_apiconfig.dart';
import 'package:http/http.dart' as http;

import 'share_email_view.dart';

class ShareViaEmailPresenter {
  late ShareViaEmailView _shareViaEmailView;
  getList(ShareViaEmailView shareViaEmailView, request, type,tmCode) {
    _shareViaEmailView = shareViaEmailView;
    FlightApiConfig.shareviaemail(http.Client(), request, type,tmCode).then((value) {
      this._shareViaEmailView.shareEmailResponse(value);
    }).catchError((err) {
      this._shareViaEmailView.allErr(err);
    });
  }
}
