import 'package:gems_revamp/account/profile/profile_utils/user_apiconfig.dart';
import 'package:gems_revamp/account/profile/user_intrest_list/user_interest_view.dart';
import 'package:http/http.dart' as http;

class UserInterstPresenter {
  UserInterestView _userInterestView;

  UserInterstPresenter(this._userInterestView);

  getUserIntrestList() {
    UserApiConfig.intrestListApiCall(http.Client()).then((value) {
      this._userInterestView.interestresponse(value);
    }).catchError((err) {
      this._userInterestView.networkError(err);
    });
  }
}
