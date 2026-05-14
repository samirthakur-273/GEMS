import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_dialog/model/dialog_content_model.dart';
import 'package:gems_revamp/eshop_module_new/tab_bar_dialog/view/dialog_content_view.dart';

class DialogContentPresenter {
  DialogContentView _dialogContentView;
  DialogContentPresenter(this._dialogContentView);

  void dialogContentData(Map body) {
    ApiConfig().dialogContentDisplay(body).then((onValue) {
      _dialogContentView.dialogContentResponse(
          dialogContentFromJson(onValue.body.toString()));
    }).catchError((onError) {
      _dialogContentView.dialogContentError(onError);
    });
  }
}
