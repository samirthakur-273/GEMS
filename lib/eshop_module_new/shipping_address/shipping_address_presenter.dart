import 'dart:async';

import 'package:gems_revamp/eshop_module_new/shipping_address/shipping_address_model.dart';
import 'package:gems_revamp/eshop_module_new/shipping_address/shipping_address_view.dart';
import 'package:gems_revamp/eshop_module_new/api_config.dart';

class ShippingAddressPresenter {
  ShppingAddressView _shppingAddressView;
  ShippingAddressPresenter(this._shppingAddressView);

  void cityResponse(body) {
    ApiConfig().cityResp(body).then((response) {

      _shppingAddressView.shippingAddressCityRespone(
          cityModelFromJson(response.body.toString()));
    }).catchError((onError) {
      if (onError is TimeoutException) {
        //_shppingAddressView.responseFailure(response);
        _shppingAddressView.onCityTimeout();
      } else {
        _shppingAddressView.responseFailure(onError);
      }
    });
  }

  void areaResponse(body) {
    ApiConfig().cityResp(body).then((response) {

      _shppingAddressView.shippingAddressAreaRespone(
          areaModelFromJson(response.body.toString()));
    }).catchError((onError) {
      if (onError is TimeoutException) {
        //_shppingAddressView.responseFailure(response);
        _shppingAddressView.onAreaTimeout();
      } else {
        _shppingAddressView.responseFailure(onError);
      }
    });
  }
}
