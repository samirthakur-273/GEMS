import 'package:gems_revamp/offer_module/offer_apis/apiconfigoffer.dart';

import '../view/addWpl_view.dart';
import 'package:http/http.dart' as http;
class AddWplPresenter{

  late AddWplView _addWplView;
  AddWplPresenter(this._addWplView);

  addWplTicket(req) {
    OfferApiconfig.addWplTicket(http.Client(),req).then((value) {
      _addWplView.addingWplView(value);
    }).catchError((err) {
    });
  }

   

}