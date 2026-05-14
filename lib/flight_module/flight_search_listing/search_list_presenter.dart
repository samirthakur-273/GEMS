/*
Auther Name: Jyoti Gite
Discription : This is the presenter of flight single jrny listing API
*/

import 'package:gems_revamp/flight_module/flight_utils/flight_apiconfig.dart';
import 'package:gems_revamp/flight_module/flight_search_listing/search_list_view.dart';
import 'package:http/http.dart' as http;

class SearchListPresenter {
  late SearchListView _searchListView;
  getList(SearchListView searchListView, req) {
    _searchListView = searchListView;

    FlightApiConfig.searchResultApi(http.Client(), req).then((value) {
      this._searchListView.responseSingleJrny(value);
    }).catchError((err) {
      this._searchListView.singleJrnyErr(err);
    });
  }
}
