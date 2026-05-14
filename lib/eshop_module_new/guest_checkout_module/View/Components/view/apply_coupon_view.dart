import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/model/apply_coupon_model.dart';

abstract class ApplyCouponView {
  void applyCouponResponse(ApplyCouponModel applyCouponModel);
  void applyCouponError(error);
}
