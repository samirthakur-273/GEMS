import 'package:gems_revamp/eshop_module_new/shipping_address/shipping_address_model.dart';

abstract class ShppingAddressView {
  void shippingAddressCityRespone(List<CityModel> citymodel);
  void shippingAddressAreaRespone(List<AreaModel> areamodel);
  void responseFailure(response);
  void onCityTimeout();
  void onAreaTimeout();
}
