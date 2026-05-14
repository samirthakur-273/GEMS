import '../partner_api_config.dart';
import 'transaction_capping_request_model.dart';
import 'transaction_capping_view.dart';

class TransactionCappingPresenter {
  final TransactionCappingView view;

  TransactionCappingPresenter(this.view);

  Future<void> transactionCappingLimitApi(
      TransactionCappingRequestModel requestBody) async {
    await PartnerApiConfig.transactionCappingLimitApi(requestBody)
        .then(view.onTransactionCappingSuccess)
        .catchError((err) {
      view.onTransactionCappingError(err.toString());
    });
  }
}
