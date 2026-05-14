import 'package:gems_revamp/eshop_module_new/app_version_update_check/model/app_version_model.dart';

abstract class AppVersionView {
  void appVersionResponse(AppVersionModel appVersionModel);
  void appVersionError(error);
  void onTimeout();
}
