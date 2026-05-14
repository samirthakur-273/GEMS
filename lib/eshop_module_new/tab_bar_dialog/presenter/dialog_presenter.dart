import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_dialog/view/dialog_view.dart';

class DialogPresenter {
  DialogView _dialogView;
  DialogPresenter(this._dialogView);

  void dialogData(Map body) {
    ApiConfig().dialogSaveMoney(body).then((onValue) {
      _dialogView.dialogResponse(onValue);
    }).catchError((onError, s) {
      _dialogView.dialogError(onError);
    });
  }
}
