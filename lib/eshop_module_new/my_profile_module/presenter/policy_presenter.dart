import 'dart:async';
import 'package:gems_revamp/eshop_module_new/api_config.dart';
import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/policy_model.dart';

abstract class PolicyView {
  void policyViewSuccess(List<PolicyModel> model);
  void policyViewError(var error);
  void policyViewTimeout();
}

class PolicyPresenter {
  PolicyView _view;
  PolicyPresenter(this._view);

  getPolicyData(String? indentifier) {
    ApiConfig().policyContent(indentifier!).then((c) {
      _view.policyViewSuccess(policyModelFromJson(c.body.toString()));
    }).catchError((onError) {
      if (onError is TimeoutException) _view.policyViewTimeout();
      _view.policyViewError(onError);
    });
  }
}
