import 'package:gems_revamp/hotel_module/hotel_apiconfig/apiconfig_hotel.dart';
import 'package:http/http.dart' as http;
import 'hotel_detail_view.dart';

class HotelDetailPresenter {
  HoteldetailView _hotelDetailView;
  HotelDetailPresenter(this._hotelDetailView);

  void hoteldetail(reqbody) {
    HotelApiconfig.hotelDetailApi(http.Client(), reqbody).then((response) {
      _hotelDetailView.hotelDetailResponse(response);
    }).catchError((err) {
      this._hotelDetailView.hotelDetailPageError(err);
    });
  }
}
