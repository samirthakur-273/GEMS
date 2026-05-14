import 'dart:async';

import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/review_page/review_page_model.dart'
    as reviewPageModel;
import 'package:gems_revamp/eshop_module_new/review_page/review_page_view.dart';

class ReviewPagePresenter {
  ReviewPageView _reviewPageView;

  ReviewPagePresenter(this._reviewPageView);
  void shippingaddress(body) {
    ApiConfig().loggedincustomeraddresses(body).then((response) {
      _reviewPageView.reviewPageResponse(
          reviewPageModel.shippingAddresssFromJson(response.body.toString()));
    }).catchError((onError) {
      if (onError is TimeoutException) {
        //_reviewPageView.responseFailure(response);

        _reviewPageView.onReviewTimeout();
      } else {
        _reviewPageView.responseFailure(onError);
      }
    });
  }
}
