import 'package:gems_revamp/homepage/apiconfig/apiconfighome.dart';
import 'package:gems_revamp/homepage/pointbalance/view_pointbalance.dart';
import 'package:http/http.dart' as http;

class MyPointsBalancePresenter {
  MyPointsBalanceView mypointsbalanceView;
  MyPointsBalancePresenter(this.mypointsbalanceView);

  void myPointsBalanceAPI() {
    HomeApiconfig.myPointsApiCall(http.Client()).then((response) {
      mypointsbalanceView.mypointsbalanceResponseSuccess(response);
    }).catchError((onError) {
    });
  }
}
