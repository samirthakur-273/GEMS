import 'package:gems_revamp/eshop_module_new/tab_bar_dialog/model/dialog_content_model.dart';

abstract class DialogContentView {
  void dialogContentResponse(List<DialogContent> dialogContent);
  void dialogContentError(error);
}
