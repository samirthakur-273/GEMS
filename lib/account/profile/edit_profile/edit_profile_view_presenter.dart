import 'package:gems_revamp/Login_module/apiConfig/apiConfig_login.dart';
import 'package:http/http.dart' as http;
import 'package:gems_revamp/account/profile/edit_profile/edit_profile_model.dart';

class UpdateRegisterView {
  void updateRegisterSuceess(UpdateRegistrationModal updateRegistrationModal) {}
  void updateRegisterError(Error error) {}
}

class UpdateRegisterPresenter {
  late UpdateRegisterView updateRegisterView;

  UpdateRegisterPresenter(this.updateRegisterView);

  userProfileResonse(request) {
    LoginApiconfig.updateRegisterProfileApiCall(http.Client(), request)
        .then((value) {
      this.updateRegisterView.updateRegisterSuceess(value);
    }).catchError((err) {
      this.updateRegisterView.updateRegisterError(err);
    });
  }
}