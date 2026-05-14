import 'submit_transaction_model.dart';

abstract class SubmitTransactionView {
  void onSubmitTransactionSuccess(SubmitTransactionModel response) {}
  void onSubmitTransactionError(String error) {}
}
