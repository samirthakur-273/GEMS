import 'package:gems_revamp/Login_module/apiConfig/apiConfig_login.dart';
import 'package:gems_revamp/account/profile/emirate/emirate_model.dart';
import 'package:http/http.dart' as http;

class EmirateView {
  void emirateSuceess(EmirateModal emirateModal) {}
  void emirateError(Error error) {}
}

class EmiratePresenter {
  late EmirateView emirateView;

  EmiratePresenter(this.emirateView);

  emirateResonse() {
    LoginApiconfig.emirateApiCall(http.Client()).then((value) {
      this.emirateView.emirateSuceess(value);
    }).catchError((err) {
      this.emirateView.emirateError(err);
    });
  }
}
