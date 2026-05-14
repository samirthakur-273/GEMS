import 'package:gems_revamp/account/profile/profile_utils/user_apiconfig.dart';
import 'package:gems_revamp/utils/country_list/country_list_view.dart';
import 'package:http/http.dart' as http;

class CountryListPresenter {
  CountryListView _countryListView;

  CountryListPresenter(this._countryListView);

  countryListApiCall() {
    UserApiConfig.countryListApiCall(
      http.Client(),
    ).then((value) {
      this._countryListView.countryListSuceessRespone(value);
    }).catchError((err) {
      this._countryListView.countryListErrorRespone(err);
    });
  }
}
