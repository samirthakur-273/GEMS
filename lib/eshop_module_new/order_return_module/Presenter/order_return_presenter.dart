import 'package:gems_revamp/eshop_module_new/order_return_module/Model/order_return_model.dart';
import 'package:gems_revamp/eshop_module_new/api_config.dart';

abstract class OrderReturnContract {
  void onOrderReturnViewSuccess(CreateReturnSuccess response);
  void onOrderReturnViewError(var error);
  void onTimeout();
}

class OrderReturnPresenter {
  OrderReturnContract _view;
  OrderReturnPresenter(this._view);

  sendOrderReturnData(request) {
    ApiConfig()
        .sendOrderReturnData(request)
        .then((c) => _view.onOrderReturnViewSuccess(c))
        .catchError((onError) {
      _view.onTimeout();
      //print(onError);
      _view.onOrderReturnViewError(onError);
    });
  }
}
