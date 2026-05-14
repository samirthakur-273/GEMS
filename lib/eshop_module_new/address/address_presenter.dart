import 'dart:async';

import 'package:gems_revamp/eshop_module_new/address/address_model.dart';
import 'package:gems_revamp/eshop_module_new/address/address_view.dart';
import 'package:gems_revamp/eshop_module_new/api_config.dart';

class CustomerAddressPresenter {
  CustomerAddressView _customerAddressView;
  CustomerAddressPresenter(this._customerAddressView);
  void customeraddressResponse(body) {
    ApiConfig().editaddress(body).then((response) {
      _customerAddressView.editAddressResponse(
          customerAddressModelFromJson(response.body.toString()));
    }).catchError((onError) {
      if (onError is TimeoutException) {
        //_customerAddressView.responseFailure(response);
        _customerAddressView.onAddressTimeout();
      } else {
        _customerAddressView.responseFailure(onError);
      }
    });
  }

  void deleteAddressResponse(body) {
    ApiConfig().deleteaddress(body).then((resp) {
      _customerAddressView.deleteaddressResponse(
          deleteAddressModelFromJson(resp.body.toString()));
    }).catchError((onError) {
      if (onError is TimeoutException) {
        //_customerAddressView.responseFailure(response);
        _customerAddressView.onAddressTimeout();
      } else {
        _customerAddressView.responseFailure(onError);
      }
    });
  }

  void addAddressResponse(body) {
    ApiConfig().addAddress(body).then((resp) {
      _customerAddressView
          .addAddressResponse(addAddressModelFromJson(resp.body.toString()));
    }).catchError((onError) {
      if (onError is TimeoutException) {
        //_customerAddressView.responseFailure(response);
        _customerAddressView.onAddressTimeout();
      } else {
        _customerAddressView.responseFailure(onError);
      }
    });
  }
}
