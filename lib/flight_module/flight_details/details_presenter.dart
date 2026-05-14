/*
Auther Name: Jyoti Gite
Discription : This is the Presenter of flight details page
*/

import 'package:gems_revamp/flight_module/flight_utils/flight_apiconfig.dart';
import 'package:http/http.dart' as http;

import 'details_view.dart';

class DetailsFlightPresenter {
  late DetailsFlightView _detailsFlightView;
  getDetails(DetailsFlightView detailsFlightView, req) {
    _detailsFlightView = detailsFlightView;

    FlightApiConfig.flightdetailsApi(http.Client(), req).then((value) {
      this._detailsFlightView.response(value);
    }).catchError((err) {
      this._detailsFlightView.allErr(err);
    });
  }
}

class RetrnJrnyDetailsFlightPresenter {
  late DetailsFlightView _detailsFlightView;
  getDetails(DetailsFlightView detailsFlightView, req) {
    _detailsFlightView = detailsFlightView;

    FlightApiConfig.returnFlightDetailsApi(http.Client(), req).then((value) {
      this._detailsFlightView.retunJrnyresponse(value);
    }).catchError((err) {
      this._detailsFlightView.allErr(err);
    });
  }
}
