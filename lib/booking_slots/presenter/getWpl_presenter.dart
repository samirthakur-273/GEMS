import 'package:gems_revamp/offer_module/offer_apis/apiconfigoffer.dart';
import 'package:http/http.dart' as http;
import '../view/getWpl_view.dart';

class GetWplPresenter{

  late GetWplView _getWplView;
  GetWplPresenter(this._getWplView);

  getWplTicket() {
  OfferApiconfig.getWplTicket(http.Client()).then((value) {
  _getWplView.getWplView(value);
  }).catchError((err) {
  _getWplView.allErr(err);
  });
  }

}