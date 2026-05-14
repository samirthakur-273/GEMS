


import 'package:gems_revamp/eshop_module_new/conversion_module/shop_globals.dart';

String earnConversion(double value, [int? quantity]) {
  var valuenew =
      (value / 1.07625); //  new earn rate formula given by dheeraj sir.

  var convertedEarnValue = valuenew * ShopGlobals.earn_rate;

  var finalValue;
  if (quantity == null) {
    finalValue = convertedEarnValue.floor().toStringAsFixed(0);
  } else {
    finalValue = (convertedEarnValue * quantity).floor().toStringAsFixed(0);
  }
  return finalValue;
}

String burnConversion(double value, [int? quantity]) {
  var convertedBurnValue = value / ShopGlobals.burn_rate;
  var finalValue;

  if (quantity == null) {
    finalValue = convertedBurnValue.floor().toStringAsFixed(0);
  } else {
    finalValue = (convertedBurnValue * quantity).floor().toStringAsFixed(0);
  }

  return finalValue;
}
