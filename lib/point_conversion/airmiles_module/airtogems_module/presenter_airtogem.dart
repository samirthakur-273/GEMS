import 'package:gems_revamp/point_conversion/airmiles_module/airtogems_module/view_airtogem.dart';
import 'package:gems_revamp/point_conversion/airmiles_module/apiconfig_airmiles/apiconfig_airmiles.dart';
import 'package:http/http.dart' as http;

class AirmilesToGemsPresenter {
  AirMilesToGemsView airmilestogemsView;
  AirmilesToGemsPresenter(this.airmilestogemsView);

  void airmilesTogemsAPI(request) {
    AirMilesApiconfig.airmilesToGemsApi(http.Client(), request)
        .then((response) {
      airmilestogemsView.airmilestogemsResponseSuccess(response);
    }).catchError((onError) {
     
    });
  }
}
