/*
Auther Name: Animesh Banerjee
Discription : This is the Presenter of flight return jrny listing API
*/
import 'package:gems_revamp/flight_module/flight_search_listing/return_srch_view.dart';
import 'package:http/http.dart' as http;
import 'package:gems_revamp/flight_module/flight_utils/flight_apiconfig.dart';

class ReturnSearchListPresenter {
  late ReturnSearchListView _returnSearchListView;
  getList(ReturnSearchListView returnSearchListView, req) {
    _returnSearchListView = returnSearchListView;

    FlightApiConfig.retsearchResultApi(http.Client(), req).then((value) {
      this._returnSearchListView.response(value);
    }).catchError((err) {
      this._returnSearchListView.allErr(err);
    });
  }
}
