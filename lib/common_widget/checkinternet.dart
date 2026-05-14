import 'package:gems_revamp/utils/connectivity.dart';

class CheckInternet {
  Future apiCall() async {
    Internetconnectivity internetconnectivity = Internetconnectivity();
    var _value = await internetconnectivity.isConnected();

    return _value;
  }
}