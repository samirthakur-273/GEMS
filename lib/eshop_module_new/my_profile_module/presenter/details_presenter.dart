import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/View/details_view.dart';

class MyDetailsPresenter {
  DetailsView _view;
  MyDetailsPresenter(this._view);

  getMyDetailsData() {
    ApiConfig()
        .fetchMyDetailsData()
        .then((c) => _view.onDetailsViewSuccess(c))
        .catchError((onError) {
      _view.onDetailsViewError(onError);
    });
  }
}
