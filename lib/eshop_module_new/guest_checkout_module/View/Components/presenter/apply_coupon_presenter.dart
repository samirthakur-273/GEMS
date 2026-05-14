import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/guest_checkout_module/View/Components/view/apply_coupon_view.dart';

class ApplyCouponPresenter {
  ApplyCouponView _applyCouponView;

  ApplyCouponPresenter(this._applyCouponView);

  void loadApplyCouponData(Map body) {
    ApiConfig().applyCouponData(body).then((onValue) {
      _applyCouponView.applyCouponResponse(onValue);
    }).catchError((onError, s) {
      _applyCouponView.applyCouponError(onError);
    });
  }
}
