import 'package:gems_revamp/eshop_module_new/tab_bar_dialog/model/dialog_model.dart';

abstract class DialogView {
  void dialogResponse(DialogModel dialogModel);
  void dialogError(error);
}
