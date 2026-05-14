import 'package:gems_revamp/point_conversion/airmiles_module/apiconfig_airmiles/apiconfig_airmiles.dart';
import 'package:gems_revamp/point_conversion/airmiles_module/gemtoair_module/view_gemtoair.dart';
import 'package:http/http.dart' as http;

class GemsToAirmilesPresenter {
  GemsToAirMilesView gemstoairmilesView;
  GemsToAirmilesPresenter(this.gemstoairmilesView);

  void gemsToAirmilesAPI(request) {
    AirMilesApiconfig.gemsToAirmilesApi(http.Client(), request)
        .then((response) {
      gemstoairmilesView.gemstoairmilesResponseSuccess(response);
    }).catchError((onError) {
     
    });
  }
}
