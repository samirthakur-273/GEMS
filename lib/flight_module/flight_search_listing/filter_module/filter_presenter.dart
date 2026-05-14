/*
Auther Name: Animesh Banerjee
Discription : This is the Presenter of flight filter API
*/
import 'package:http/http.dart' as http;
import 'filter_view.dart';
import 'package:gems_revamp/flight_module/flight_utils/flight_apiconfig.dart';


class FilterPresenter {
  late FilterView _filterView;
  getList(FilterView filterView, req) {
    _filterView = filterView;

    FlightApiConfig.filterApi(http.Client(), req).then((value) {
      this._filterView.filterResponse(value);
    }).catchError((err) {
      this._filterView.allErr(err);
    });
  }
}

class FilterReturnPresenter {
  late FilterView _filterView;
  getList(FilterView filterView, req) {
    _filterView = filterView;

    FlightApiConfig.filterRetrnApi(http.Client(), req).then((value) {
      this._filterView.filterRetrnResponse(value);
    }).catchError((err) {
      this._filterView.allErr(err);
    });
  }
}
