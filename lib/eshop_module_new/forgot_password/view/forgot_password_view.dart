import 'package:gems_revamp/eshop_module_new/forgot_password/model/forgot_password_model.dart';

abstract class ForgotPasswordView {
  void forgotPasswordResponse(ForgotPasswordModel forgotPasswordModel);
  void forgotPasswordError(error);
  void onTimeout();
}
