
import 'package:gems_revamp/hotel_module/hotel_apiconfig/apiconfig_hotel.dart';
import 'package:gems_revamp/hotel_module/hotel_list/hotel_list_data/hotel_list_view.dart';
import 'package:gems_revamp/hotel_module/hotel_list/hotel_sort_filter/hotel_filter_view.dart';
import 'package:http/http.dart' as http;


class FilterCountPresenter {
  FilterCountView filterCountView;
  FilterCountPresenter(this.filterCountView);
  void getFilterCount(req) {
    HotelApiconfig.getfilterDataApi(http.Client(), req).then((response) {
      filterCountView.filterCountresponse(response);
    }).catchError((err) {
      this.filterCountView.allErr(err);
    });
  }
}

class SortFilterPresenter {
  HotelListView _hotelListlView;
  SortFilterPresenter(this._hotelListlView);
  void sortFilterdata(request) {
    HotelApiconfig.updateFilterApi(http.Client(), request).then((response) {
      _hotelListlView.hotellistData(response);
    }).catchError((err) {
      this._hotelListlView.hotellistmError(err);
    });
  }
}
