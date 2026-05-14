import '../partner_api_config.dart';
import 'delink_request_model.dart';
import 'delink_view.dart';

class DelinkPresenter {
  final DelinkView view;

  DelinkPresenter(this.view);

  Future<void> delinkApiCall(DelinkRequestModel requestBody) async {
    await PartnerApiConfig.delinkApi(requestBody)
        .then(view.onDelinkSuccess)
        .catchError((err) {
      view.onDelinkError(err.toString());
    });
  }
}
