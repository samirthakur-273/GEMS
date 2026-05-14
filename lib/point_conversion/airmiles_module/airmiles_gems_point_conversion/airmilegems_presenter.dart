import '../apiconfig_airmiles/apiconfig_airmiles.dart';
import 'airmilegems_view.dart';
import 'package:http/http.dart' as http;

class AirmilesToGemsToAirmilesPresenter {
  AirmilesGemsView airmilesToGemsView;
  AirmilesToGemsToAirmilesPresenter(this.airmilesToGemsView);

  void airmilesToGemsAPI() {
    AirMilesApiconfig.airmilesToGemsToAirmilesApi(http.Client())
        .then((response) {
      airmilesToGemsView.gemsToAirmilesSucess(response);
    }).catchError((onError) {});
  }
}
