import 'package:gems_revamp/account/mysaving/my_saving_view.dart';
import 'package:gems_revamp/account/profile/profile_utils/user_apiconfig.dart';
import 'package:http/http.dart' as http;

class MySavingPresenter{

  final MySavingView _mySavingView;

  MySavingPresenter(this._mySavingView);

  void mySavingApiResponse(req) {
    UserApiConfig.mySavingsApiCall(http.Client(), req)
        .then((value) => _mySavingView.mySavingListSuccessRes(value))
        .catchError((onError) => _mySavingView.mySavingListError(onError));
  }
}