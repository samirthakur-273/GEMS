import 'dart:async';
import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/forgot_password/view/forgot_password_view.dart';

class ForgotPasswordPresenter {
  ForgotPasswordView _forgotPasswordView;

  ForgotPasswordPresenter(this._forgotPasswordView);

  void loadForgotPasswordData(Map body) {
    ApiConfig().forgotPassword(body).then((onValue) {
      _forgotPasswordView.forgotPasswordResponse(onValue);
    }).catchError((onError, s) {
      _forgotPasswordView.forgotPasswordError(onError);
      if (onError is TimeoutException) _forgotPasswordView.onTimeout();
    });
  }
}
