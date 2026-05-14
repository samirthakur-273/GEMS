import 'transaction_capping_model.dart';

abstract class TransactionCappingView{
  void onTransactionCappingSuccess(TransactionCappingModel response) {}
  void onTransactionCappingError(String string) {}
}