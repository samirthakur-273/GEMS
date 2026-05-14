import '../../partner_api_config.dart';
import 'submit_transaction_request_model.dart';
import 'submit_transaction_view.dart';

class SubmitTransactionPresenter {
  final SubmitTransactionView view;

  SubmitTransactionPresenter(this.view);
  Future<void> submitTransactionApiCall(
      SubmitTransactionRequestModel requestBody) async {
    await PartnerApiConfig.submitTransactionApi(requestBody)
        .then(view.onSubmitTransactionSuccess)
        .catchError((err) {
      view.onSubmitTransactionError(err.toString());
    });
  }
}
