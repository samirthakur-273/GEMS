import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/model/payment_card_model.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/model/checkout_model.dart';
import 'package:gems_revamp/eshop_module_new/payment_gateway/token_model.dart';

abstract class GuestCheckoutVieww {
  void checkoutResponse(List<CheckoutModel> checkoutmodel);
  void checkoutTimeOut() {}
  void paymentMethodResponse(List<PaymentMethodModel> paymentMethod);
  void paymentTimeOut() {}
  void paymentGatewayCreateToken(TokenModel? tokenModel);
  void paymentByCard(PaymentCardModel tokenModel);
  void applystorecreditResponse(List<StoreCreditModel> storecreditmodel);
  void statusCheck(List<OrderStatusModel> orderstatus);
  void statusCheckTimeout() {}
  void responseFailure(error);
  void checkoutResponseFailure(error);
  void statusUpadetaResponseFailure(error);
  void paymentMethodresponseFailure(error);
}
