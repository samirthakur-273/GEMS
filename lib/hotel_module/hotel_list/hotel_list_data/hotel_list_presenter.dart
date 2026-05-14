import 'package:gems_revamp/hotel_module/hotel_apiconfig/apiconfig_hotel.dart';
import 'package:http/http.dart' as http;

import 'hotel_list_view.dart';

class HotelListPresenter {
  HotelListView _hotelListlView;
  HotelListPresenter(this._hotelListlView);

  void hotellistdata(reqbody) {
    HotelApiconfig.hotelListing(http.Client(), reqbody)
        .then((onValue) => _hotelListlView.hotellistData(onValue))
        .catchError((onError) => _hotelListlView.hotellistmError(onError));
  }

}
