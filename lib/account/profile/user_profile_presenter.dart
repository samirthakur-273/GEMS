import 'package:gems_revamp/account/profile/user_profile_view.dart';
import 'package:gems_revamp/account/profile/profile_utils/user_apiconfig.dart';
import 'package:http/http.dart' as http;

class UserProfilePresenter {
  UserProfileView _userProfileView;

  UserProfilePresenter(this._userProfileView);

  userProfileResonse(membershipId) {
    UserApiConfig.userProfileApiCall(http.Client(), membershipId)
        .then((value) {
      this._userProfileView.userProfileSuceessRespone(value);
    }).catchError((err) {
      this._userProfileView.userProfileErrorRespone(err);
    });
  }
}
