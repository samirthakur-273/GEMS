import 'package:gems_revamp/Login_module/login_types/view_registerdevice.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:http/http.dart' as http;

class RegisterDevicePresenter {
  RegisterDeviceView registerdeviceView;
  RegisterDevicePresenter(this.registerdeviceView);

  void registerDeviceAPI(request) {
    MakesenseApiConfig.registerdeviceApi(http.Client(), request)
        .then((response) {
      registerdeviceView.registerdeviceResponseSuccess(response);
    }).catchError((onError) {
    
    });
  }
}
