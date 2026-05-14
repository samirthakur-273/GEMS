import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/my_account_module/update_acc_view.dart';

class UpdateInfoPresenter {
  UpdateinfoView? _updateinfoView;
  getList(UpdateinfoView updateinfoView, req) {
    _updateinfoView = updateinfoView;

    ApiConfig().profileUpdate(req).then((value) {
      this._updateinfoView!.response(value);
    }).catchError((err) {
      this._updateinfoView!.allErr(err);
    });
  }
}
