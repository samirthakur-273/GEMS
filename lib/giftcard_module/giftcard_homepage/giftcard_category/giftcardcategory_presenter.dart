import 'package:gems_revamp/giftcard_module/gift_api_utls/api_config.dart';
import 'package:gems_revamp/giftcard_module/giftcard_homepage/giftcard_category/giftcardcategory_view.dart';
import 'package:http/http.dart' as http;

class CategoryPresenter {
  late CategoryListView _categoryListView;
  getList(CategoryListView categoryListView, _context) {
    _categoryListView = categoryListView;

    GiftApiconfig.getcategoryList(
      http.Client(),
    ).then((value) {
      this._categoryListView.response(value);
    }).catchError((err) {
      this._categoryListView.categoryerr(err);
    });
  }
}
