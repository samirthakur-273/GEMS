

import 'package:gems_revamp/hotel_module/hotel_apiconfig/apiconfig_hotel.dart';
import 'package:gems_revamp/hotel_module/hotel_homepage/hotel_destination/hotel_desti_view.dart';
import 'package:http/http.dart' as http;

class AutoSuggestHotelPresenter{
  late AutoSuggestHotelView _autoSuggestHotelView;
  AutoSuggestHotelPresenter(this._autoSuggestHotelView);

 autoSuggest(text) {
    HotelApiconfig.autoSuggestHotelsApi(http.Client(), text).then((value) {
      this._autoSuggestHotelView.autosuggestList(value);
    }).catchError((err) {
      this._autoSuggestHotelView.allErr(err);
    });
  }

   void getpopularCity() {
    HotelApiconfig().popularCityHotel(http.Client()).then((response) {
      _autoSuggestHotelView.cityResponse(response);
    }).catchError((err) {
      this._autoSuggestHotelView.allErr(err);
    });
  }
}