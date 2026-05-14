import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/common_widget/global.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/details_model.dart';
import 'package:flutter/material.dart';

class WishListCartCount extends ChangeNotifier {
  WishListCartCount() {
    _getInitialCount();
  }
  List wishListItems = [];
  int cartListItems = 0;

  void addWishList(var item) {
    if (wishListItems.isEmpty) {
      _getInitialCount();
    } else {
      wishListItems.add(item);
      notifyListeners();
    }
  }

  void removeWishList(var item) {
    //   wishListItems.remove(item);
    wishListItems.removeLast();
    notifyListeners();
  }

  int get countWishList {
    return wishListItems.length;
  }

  void addCartList(int item) {
    cartListItems += item;
    GlobalValue.totalCartCount = cartListItems;
    notifyListeners();
  }

  void removeCartList(var item) {
    cartListItems -= int.parse(item);
    GlobalValue.totalCartCount = cartListItems;
    notifyListeners();
  }

  int get countCartList {
    return cartListItems;
  }

  void _getInitialCount() async {
    final resp = await ApiConfig().fetchMyDetailsData().catchError((onError) {
      return DetailsModel();
    });

    cartListItems = resp.header?.cartCount ?? 0;
    GlobalValue.totalCartCount = cartListItems;
    for (var i = 0; i < (resp.header?.wishlistCount ?? 0); i++) {
      wishListItems.add(0);
    }
    notifyListeners();
  }
}
