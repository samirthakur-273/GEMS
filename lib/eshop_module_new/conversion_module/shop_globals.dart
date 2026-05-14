class ShopGlobals {
  static var earn_rate = 0.08;
  static var burn_rate = 0.1;

  static num? totalCartCount = 0;
}

calculatePrice(double price, double specialPrice) {
  if (price > specialPrice) {
    return specialPrice;
  } else {
    return price;
  }
}
