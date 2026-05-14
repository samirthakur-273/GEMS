import 'package:gems_revamp/flight_module/flight_utils/flight_apiconfig.dart';
import 'package:http/http.dart' as http;
import 'flight_booking_confirm_view.dart';

class FlightPurchaseOrderPresenter {
  late FlightPurchaseOrdView _flightPurchaseOrdView;
  getList(FlightPurchaseOrdView flightPurchaseOrdView, request) {
    _flightPurchaseOrdView = flightPurchaseOrdView;
    FlightApiConfig.purchaseOrder(http.Client(), request).then((value) {
      this._flightPurchaseOrdView.pgResp(value);
    }).catchError((err) {
      this._flightPurchaseOrdView.allErr(err);
    });
  }

  flightPurchaseDetailsApiCall(
      FlightPurchaseOrdView flightPurchaseOrdView, cpBrfNo) {
    _flightPurchaseOrdView = flightPurchaseOrdView;
    FlightApiConfig.flightPurchaseDetailsApi(http.Client(), cpBrfNo)
        .then((value) {
      this._flightPurchaseOrdView.flightPurchaseDetailsResp(value);
    })
      ..catchError((err) {
        this._flightPurchaseOrdView.allErr(err);
      });
  }
}
