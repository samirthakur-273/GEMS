import 'package:gems_revamp/account/profile/profile_utils/user_apiconfig.dart';
import 'package:gems_revamp/family_and_friends/family_friends_list/famil_friends_list_view.dart';
import 'package:http/http.dart' as http;

class FamilyAndFriendsPresenter {
  FamilyAndFriendsView _familyAndFriendsView;

  FamilyAndFriendsPresenter(this._familyAndFriendsView);

  familyFriendsListResponse(membershipId) {
    UserApiConfig.familyFriendsListApiCall(http.Client(), membershipId)
        .then((value) {
      this._familyAndFriendsView.familyFriendsListSuccessRes(value);
    }).catchError((err) {
      this._familyAndFriendsView.familyFriendsListError(err);
    });
  }
}
