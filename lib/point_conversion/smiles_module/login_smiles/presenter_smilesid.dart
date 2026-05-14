import 'package:gems_revamp/point_conversion/smiles_module/apiconfig/apiconfig_smiles.dart';
import 'package:gems_revamp/point_conversion/smiles_module/login_smiles/view_smilesid.dart';
import 'package:http/http.dart' as http;

class SmilesLoginPresenter {
  SmilesLoginView smilesLoginView;
  SmilesLoginPresenter(this.smilesLoginView);

  void callLoginSmilesAPI(request) {
    ApiconfigSmiles.smilesLoginApi(http.Client(), request).then((response) {
      smilesLoginView.getloginsmilesResponseSuccess(response);
    }).catchError((onError) {
     
    });
  }
}
