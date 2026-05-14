import 'delink_model.dart';

abstract class DelinkView {
  void onDelinkSuccess(DelinkModel response);
  void onDelinkError(String error);
}
