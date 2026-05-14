import 'package:gems_revamp/eshop_module_new/my_profile_module/Model/details_model.dart';

abstract class DetailsView {
  void onDetailsViewSuccess(DetailsModel response);
  void onDetailsViewError(var error);
}
