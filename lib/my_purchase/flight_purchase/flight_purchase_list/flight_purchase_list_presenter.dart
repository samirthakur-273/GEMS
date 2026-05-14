import 'package:gems_revamp/flight_module/flight_utils/flight_apiconfig.dart';
import 'package:gems_revamp/my_purchase/flight_purchase/flight_purchase_list/flight_purchase_list_view.dart';
import 'package:http/http.dart' as http;

class FlightPurchaseListPresenter {
  FlightPurchaseListView _flightPurchaseListView;

  FlightPurchaseListPresenter(this._flightPurchaseListView);

  fltPurchaseListApiRes(membershipId) {
    FlightApiConfig.fltPurchaseListApiCall(http.Client(), membershipId)
        .then((value) {
      this._flightPurchaseListView.fltPurchaseListSuccessRes(value);
    }).catchError((err) {
      this._flightPurchaseListView.fltPurchaseListErrorRes(err);
    });
  }
}
