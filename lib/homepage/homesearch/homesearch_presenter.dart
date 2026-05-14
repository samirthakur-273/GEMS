import 'package:gems_revamp/homepage/apiconfig/apiconfighome.dart';
import 'package:gems_revamp/homepage/homesearch/homesearch_view.dart';
import 'package:http/http.dart' as http;

class HomeSearchPresenter {
  HomeSearchView homesearchView;
  HomeSearchPresenter(this.homesearchView);

  void homeSearchAPI(controllertext) {
    HomeApiconfig.homesearchApiCall(http.Client(), controllertext)
        .then((response) {
      homesearchView.homesearchResponseSuccess(response);
    }).catchError((onError) {
      
    });
  }

  void commonSearchAPI(req) {
    HomeApiconfig.commonSearchApiCall(http.Client(), req)
        .then((response) {
      homesearchView.commonsearchResponseSuccess(response);
    }).catchError((onError) {
      
    });
  }
}
