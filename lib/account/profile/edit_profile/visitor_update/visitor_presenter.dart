import 'package:gems_revamp/account/profile/edit_profile/visitor_update/visitor_model.dart';
import 'package:gems_revamp/makesense_module/makesense_apiconfig.dart';
import 'package:http/http.dart' as http;


class UpdateVisitorView {
  void visitorSuceess(VisitorUpdateModal visitorUpdateModal) {}
  void visitorError(Error error) {}
}

class UpdateVisitorPresenter {
  late UpdateVisitorView updateVisitorView;

  UpdateVisitorPresenter(this.updateVisitorView);

  visitorUpdateResponse(request) {
    MakesenseApiClass.visitorUpdateApi(http.Client(), request)
        .then((value) {
      this.updateVisitorView.visitorSuceess(value);
    }).catchError((err) {
      this.updateVisitorView.visitorError(err);
    });
  }
}