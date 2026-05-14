import 'package:gems_revamp/Login_module/apiConfig/apiConfig_login.dart';
import 'package:gems_revamp/Login_module/friend&family_login/fnf_login/referral_view.dart';
import 'package:http/http.dart' as http;

class ReferralPresenter{
  late ReferralView _referralView;
  ReferralPresenter(this._referralView);

 referral(req) {
    LoginApiconfig.referralApi(http.Client(), req).then((value) {
      this._referralView.referralview(value);
    }).catchError((err) {
      this._referralView.allErr(err);
    });
  }

  alumni(req) {
    LoginApiconfig.alumniLoginApi(http.Client(), req).then((value) {
      this._referralView.referralview(value);
    }).catchError((err) {
      this._referralView.allErr(err);
    });
  }
}