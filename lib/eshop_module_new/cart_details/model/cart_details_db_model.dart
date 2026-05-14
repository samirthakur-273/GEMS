class CartDetailsDbModel {
  int? id;
  dynamic cartdetailsdata;

  CartDetailsDbModel(this.id, this.cartdetailsdata);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'cartdetailsdata': cartdetailsdata,
    };
    return map;
  }

  CartDetailsDbModel.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    cartdetailsdata = map['cartdetailsdata'];
  }
}

class ShippingMethodDbModel {
  int? id;
  dynamic shippingMethoddata;

  ShippingMethodDbModel(this.id, this.shippingMethoddata);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'shippingMethoddata': shippingMethoddata,
    };
    return map;
  }

  ShippingMethodDbModel.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    shippingMethoddata = map['shippingMethoddata'];
  }
}
