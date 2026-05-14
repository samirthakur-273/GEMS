import 'package:gems_revamp/hotel_module/hotel_apiconfig/apiconfig_hotel.dart';
import 'package:gems_revamp/my_purchase/hotel_purchase/hotel_purchase_list/hotel_purchase_list_view.dart';
import 'package:http/http.dart' as http;

class HotelPurchaseListPresenter {
  HotelPurchaseListView _hotelPurchaseListView;

  HotelPurchaseListPresenter(this._hotelPurchaseListView);

  hotelPurchaseListResApi(membershipId) {
    HotelApiconfig.hotelPurchaseListApiCall(http.Client(), membershipId)
        .then((value) {
      this._hotelPurchaseListView.hltPurchaseListSuccessRes(value);
    }).catchError((err) {
      this._hotelPurchaseListView.hltPurchaseListErrorRes(err);
    });
  }
}
