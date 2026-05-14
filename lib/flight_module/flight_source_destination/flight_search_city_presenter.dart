import 'package:gems_revamp/flight_module/flight_utils/flight_apiconfig.dart';
import 'package:gems_revamp/flight_module/flight_source_destination/flight_search_list_view.dart';
import 'package:http/http.dart' as http;

class FlightSearchCityPresenter {
  FlightSearchCityView flightSearchView;

  FlightSearchCityPresenter(this.flightSearchView);

  searchCity(FlightSearchCityView _flightSearchView, searchTerm) {
    flightSearchView = _flightSearchView;
    FlightApiConfig.autoSuggest(http.Client(), searchTerm).then((response) {
      this.flightSearchView.flightSearchCiyResponse(response);
    }).catchError((err) {
      this.flightSearchView.networkError(err);
    });
  }

  // PopularCityModel popularCityModel;
  popularCityFn(FlightSearchCityView _popularCityModel) {
    flightSearchView = _popularCityModel;

    FlightApiConfig().popularCityApi(http.Client()).then((response) {
      this.flightSearchView.flightpopularCityResponse(response);
    }).catchError((err) {
      this.flightSearchView.networkError(err);
    });
  }
}
