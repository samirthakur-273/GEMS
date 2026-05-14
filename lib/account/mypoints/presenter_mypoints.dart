import 'package:gems_revamp/account/mypoints/view_mypoints.dart';
import 'package:gems_revamp/account/profile/profile_utils/user_apiconfig.dart';
import 'package:http/http.dart' as http;

class MyPointsPresenter {
  MyPointsView mypointsView;
  MyPointsPresenter(this.mypointsView);

  void myPointsAPI(request) {
    UserApiConfig.myPointsApiCall(http.Client(), request).then((response) {
      mypointsView.mypointsResponseSuccess(response);
    }).catchError((onError) {
      
    });
  }
}
