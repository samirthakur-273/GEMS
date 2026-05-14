import 'dart:async';

import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/my_orders_detail/my_orders_detail_model.dart';
import 'package:gems_revamp/eshop_module_new/my_orders_detail/my_orders_detail_view.dart';

class MyOrderDetailpresenter {
  MyOrdersDetailView myOrdersDetailView;
  MyOrderDetailpresenter(this.myOrdersDetailView);
  void myOrderDetailResponse(body) {
    ApiConfig().myOrderDetail(body).then((response) {
      myOrdersDetailView.myOrderdetailResponse(
          orderDetailsModelsFromJson(response.body.toString()));
    }).catchError((onError) {
      //print(onError);
      if (onError is TimeoutException) {
        //myOrdersDetailView.responseFailure(response);
        myOrdersDetailView.onTimeout();
      } else {
        myOrdersDetailView.responseFailure(onError);
      }
    });
  }

  void cancelOrder(body) {
    ApiConfig().myOrderCancel(body).then((response) {
      myOrdersDetailView.cancelOrderResponse(
          cancelOrderModelsFromJson(response.body.toString()));
    }).catchError((onError) {
      if (onError is TimeoutException) {
        //myOrdersDetailView.responseFailure(response);
        myOrdersDetailView.onTimeout();
      } else {
        myOrdersDetailView.responseFailure(onError);
      }
    });
  }

  void trackOrder(body) {
    ApiConfig().orderTrack(body).then((response) {
      myOrdersDetailView.orderTrackingResponse(
          orderTrackingModelFromJson(response.body.toString()));
    }).catchError((onError) {
      if (onError is TimeoutException) {
        myOrdersDetailView.onOrderTrackingTimeout();
      } else {
        myOrdersDetailView.responseFailure(onError);
      }
    });
  }
}
