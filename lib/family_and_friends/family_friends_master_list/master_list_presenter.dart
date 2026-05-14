import 'package:gems_revamp/account/profile/profile_utils/user_apiconfig.dart';
import 'package:gems_revamp/family_and_friends/family_friends_master_list/master_list_view.dart';
import 'package:http/http.dart' as http;

class MasterListPresenter {
  MasterListView _masterListView;

  MasterListPresenter(this._masterListView);

  masterListResponse() {
    UserApiConfig().masterListApiCall(http.Client()).then((value) {
      this._masterListView.masterListSuccessResp(value);
    }).catchError((err) {
      this._masterListView.masterListErrorResp(err);
    });
  }
}
