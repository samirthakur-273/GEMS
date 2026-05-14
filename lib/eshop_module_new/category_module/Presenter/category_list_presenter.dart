import 'dart:async';
import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/category_module/Model/category_list_model.dart';

abstract class CategoryListViewContract {
  void onCategoryListViewSuccess(CategoryListModel response);
  void onCategoryListViewError(var error);
  void onTimeout();
}

class CategoryListPresenter {
  CategoryListViewContract _view;
  CategoryListPresenter(this._view);

  getCategoryListData() {
    ApiConfig()
        .fetchCategoryListData()
        .then((c) => _view.onCategoryListViewSuccess(c))
        .catchError((onError) {
      if (onError is TimeoutException) _view.onTimeout();
      _view.onCategoryListViewError(onError);
    });
  }
}
