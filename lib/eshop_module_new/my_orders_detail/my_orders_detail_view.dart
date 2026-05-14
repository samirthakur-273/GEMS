import 'package:gems_revamp/eshop_module_new/my_orders_detail/my_orders_detail_model.dart';

class MyOrdersDetailView {
  void myOrderdetailResponse(List<OrderDetailsModels> orderDetailModel) {}
  void cancelOrderResponse(List<CancelOrderModels> cancelorderModel) {}
  void orderTrackingResponse(List<OrderTrackingModel> orderTrackingModel) {}
  void responseFailure(error) {}
  void onTimeout() {}
  void onOrderTrackingTimeout() {}
}
