import 'package:flutter/material.dart';

class GlobalValue {
  static bool isstoreaapplied = false;
  static bool amtAvailable = false;
  static int tabValue = 0;
  static String? firstname;
  static String? lastname;
  static String paymentType = "collectbounz";
  static num? totalCartCount = 0;

  static final gradientColor = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF3ef4136), Color(0xFFfbb040)]);
  static final disablegradientColor = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.white, Colors.white]);
}

calculatePrice(double price, double specialPrice) {
  if (price > specialPrice) {
    return specialPrice;
  } else {
    return price;
  }
}
