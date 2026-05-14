import 'package:gems_revamp/hotel_module/hotel_apiconfig/apiconfig_hotel.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_details/purchaseOrder_view.dart';
import 'package:http/http.dart' as http;

class PurchasePresenter {
  PurchaseOrderView purchaseOrderView;
  PurchasePresenter(this.purchaseOrderView);
  void getOrderDetails(req) {
    HotelApiconfig.purchaseOrders(http.Client(), req).then((response) {
      purchaseOrderView.purchaseresponse(response);
    }).catchError((err) {
      this.purchaseOrderView.allErr(err);
    });
  }

  hotelPurchaseDetailsapicall(req) {
    HotelApiconfig.getHotelpurchaseDetails(req).then((value) {
      purchaseOrderView.hotelPurchasedetailsResponse(value);
    }).catchError((onError) {
     
      purchaseOrderView.allErr(onError);
    });
  }
}
