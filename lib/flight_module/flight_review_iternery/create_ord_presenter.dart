/*
Auther Name: Animesh Banerjee
Discription : This is the Presenter of flight create order (PG)
*/

import 'package:gems_revamp/flight_module/flight_utils/flight_apiconfig.dart';
import 'package:http/http.dart' as http;

import 'create_ord_view.dart';

class GiftPGInitPresenter {
  late FlightCreateOrdView _flightCreateOrdView;
  getList(FlightCreateOrdView flightCreateOrdView, request) {
    _flightCreateOrdView = flightCreateOrdView;
    FlightApiConfig.createOrder(http.Client(), request).then((value) {
      this._flightCreateOrdView.pgResp(value);
    }).catchError((err) {
      this._flightCreateOrdView.allErr(err);
    });
  }
}
