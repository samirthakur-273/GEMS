class MyProfileModel {
  int? id;
  bool? updateResponse;
  String? success;
  String? message;
  Customer? customer;
  List<OrderList>? orderList;
  List<OrderList>? orderHistory;
  StoreCredit? storeCredit;
  ProfileAddress? address;
  Rma? rma;

  MyProfileModel(
      {this.id,
      this.updateResponse,
      this.success,
      this.message,
      this.customer,
      this.orderList,
      this.storeCredit,
      this.address,
      this.rma,
      this.orderHistory});
  factory MyProfileModel.fromJson(Map<String, dynamic> json) {
    return MyProfileModel(
      updateResponse:
          json['updateResponse'] != null ? json['updateResponse'] : null,
      success: json['success'] != null ? json['success'] : null,
      message: json['message'] != null ? json['message'] : null,
      customer:
          json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      orderList: json['order_list'] != null
          ? List<OrderList>.from(
              json["order_list"].map((x) => OrderList.fromJson(x)))
          : null,
      orderHistory: json["order_history"] == null
          ? null
          : List<OrderList>.from(
              json["order_history"].map((x) => OrderList.fromJson(x))),
      storeCredit: json['store_credit'] != null
          ? StoreCredit.fromJson(json['store_credit'])
          : null,
      address: json['address'] != null
          ? ProfileAddress.fromJson(json['address'])
          : null,
      rma: json['rma'] != null ? Rma.fromJson(json['rma']) : null,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.orderList != null) {
      data['order_list'] = this.orderList!.map((v) => v.toJson()).toList();
    }
    if (this.orderHistory != null) {
      data["order_history"] =
          this.orderHistory!.map((v) => v.toJson()).toList();
    }
    if (this.storeCredit != null) {
      data['store_credit'] = this.storeCredit!.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.rma != null) {
      data['rma'] = this.rma!.toJson();
    }
    return data;
  }
}

class ProfileAddress {
  BillingAddress? billingAddress;
  BillingAddress? shippingAddress;
  List<AdditionalAddress>? additionalAddress;
  ProfileAddress(
      {this.billingAddress, this.shippingAddress, this.additionalAddress});
  factory ProfileAddress.fromJson(Map<String, dynamic> json) {
    return ProfileAddress(
      billingAddress: json['billing_address'] != null
          ? new BillingAddress.fromJson(json['billing_address'])
          : null,
      shippingAddress: json['shipping_address'] != null
          ? new BillingAddress.fromJson(json['shipping_address'])
          : null,
      additionalAddress: json["additional_address"] == null
          ? null
          : List<AdditionalAddress>.from(json["additional_address"]
              .map((x) => AdditionalAddress.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "billing_address": billingAddress,
        "shipping_address": shippingAddress,
        "additional_address": additionalAddress == null
            ? null
            : List<dynamic>.from(additionalAddress!.map((x) => x.toJson())),
      };
}

class BillingAddress {
  String? addressId;
  String? firstname;
  String? lastname;
  String? city;
  String? countryId;
  String? postcode;
  String? region;
  String? regionId;
  String? street;
  String? address1;
  String? address2;
  String? telephone;
  dynamic countryCode;
  dynamic carrierCode;
  dynamic customAddressType;
  dynamic houseNo;
  dynamic address;

  BillingAddress(
      {this.addressId,
      this.firstname,
      this.lastname,
      this.city,
      this.countryId,
      this.postcode,
      this.region,
      this.regionId,
      this.street,
      this.address1,
      this.address2,
      this.telephone,
      this.countryCode,
      this.carrierCode,
      this.customAddressType,
      this.houseNo,
      this.address});
  factory BillingAddress.fromJson(Map<String, dynamic> json) {
    return BillingAddress(
      addressId: json["address_id"] == null ? null : json["address_id"],
      firstname: json["firstname"] == null ? null : json["firstname"],
      lastname: json["lastname"] == null ? null : json["lastname"],
      city: json["city"] == null ? null : json["city"],
      countryId: json["country_id"] == null ? null : json["country_id"],
      postcode: json["postcode"] == null ? null : json["postcode"],
      region: json["region"] == null ? null : json["region"],
      regionId: json["region_id"] == null ? null : json["region_id"],
      street: json["street"] == null ? null : json["street"],
      address1: json["address1"] == null ? null : json["address1"],
      address2: json["address2"] == null ? null : json["address2"],
      telephone: json["telephone"] == null ? null : json["telephone"],
      countryCode: json["country_code"],
      carrierCode: json["carrier_code"],
      customAddressType: json["custom_address_type"],
      houseNo: json["house_no"],
      address: json["address"],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_id'] = this.addressId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['city'] = this.city;
    data['country_id'] = this.countryId;
    data['postcode'] = this.postcode;
    data['region'] = this.region;
    data['region_id'] = this.regionId;
    data['street'] = this.street;
    data['telephone'] = this.telephone;
    data['country_code'] = this.countryCode;
    data['carrier_code'] = this.carrierCode;
    data['custom_address_type'] = this.customAddressType;
    data['house_no'] = this.houseNo;
    data['address'] = this.address;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    return data;
  }
}

class Customer {
  String? email;
  String? lastName;
  String? firstName;
  String? fullName;

  Customer({
    this.email,
    this.lastName,
    this.firstName,
    this.fullName,
  });
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      email: json['email'] != null ? json['email'] : null,
      lastName: json['lastName'] != null ? json['lastName'] : null,
      firstName: json['firstName'] != null ? json['firstName'] : null,
      fullName: json['fullName'] != null ? json['fullName'] : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "fullName": fullName,
      };
}

class OrderList {
  OrderList({
    this.id,
    this.orderId,
    this.date,
    this.shipTo,
    this.orderTotal,
    this.state,
    this.status,
    this.itemCount,
    this.storeId,
    this.items,
    this.showCancel,
  });

  String? id;
  String? orderId;
  String? date;
  String? shipTo;
  String? orderTotal;
  String? state;
  String? status;
  String? itemCount;
  String? storeId;
  List<Item>? items;
  bool? showCancel;
  factory OrderList.fromJson(Map<String, dynamic> json) => OrderList(
        id: json["id"] == null ? null : json["id"],
        orderId: json["order_id"] == null ? null : json["order_id"],
        date: json["date"] == null ? null : json["date"],
        shipTo: json["ship_to"] == null ? null : json["ship_to"],
        orderTotal: json["order_total"] == null ? null : json["order_total"],
        state: json["state"] == null ? null : json["state"],
        status: json["status"] == null ? null : json["status"],
        itemCount: json["item_count"] == null ? null : json["item_count"],
        storeId: json["store_id"] == null ? null : json["store_id"],
        items: json["items"] == null
            ? null
            : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        showCancel: json["show_cancel"] == null ? null : json["show_cancel"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "order_id": orderId == null ? null : orderId,
        "date": date == null ? null : date,
        "ship_to": shipTo == null ? null : shipTo,
        "order_total": orderTotal == null ? null : orderTotal,
        "state": state == null ? null : state,
        "status": status == null ? null : status,
        "item_count": itemCount == null ? null : itemCount,
        "store_id": storeId == null ? null : storeId,
        "items": items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "show_cancel": showCancel == null ? null : showCancel,
      };
}

class Item {
  Item(
      {this.name,
      this.sku,
      this.price,
      this.qty,
      this.rowTotal,
      this.originalPrice,
      this.imageUrl,
      this.brand,
      this.soldBy,
      this.burnPoint,
      this.burnAmount,
      this.earnRate,
      this.earnPoint});

  String? name;
  String? sku;
  String? price;
  String? qty;
  String? rowTotal;
  String? originalPrice;
  String? imageUrl;
  String? brand;
  String? soldBy;
  String? burnPoint;
  String? burnAmount;
  String? earnRate;
  String? earnPoint;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        name: json["name"] == null ? null : json["name"],
        sku: json["sku"] == null ? null : json["sku"],
        price: json["price"] == null ? null : json["price"],
        qty: json["qty"] == null ? null : json["qty"],
        brand: json["brand"] == null ? null : json["brand"],
        soldBy: json["sold_by"] == null ? null : json["sold_by"],
        rowTotal: json["row_total"] == null ? null : json["row_total"],
        originalPrice:
            json["original_price"] == null ? null : json["original_price"],
        imageUrl: json["image_url"] == null ? null : json["image_url"],
        burnPoint: json["burnpoint"] == null ? null : json["burnpoint"],
        burnAmount: json["burnamount"] == null ? null : json["burnamount"],
        earnRate: json["earnrate"] == null ? null : json["earnrate"],
        earnPoint: json["earnpoint"] == null ? null : json["earnpoint"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "sku": sku == null ? null : sku,
        "price": price == null ? null : price,
        "qty": qty == null ? null : qty,
        "brand": brand == null ? null : brand,
        "sold_by": soldBy == null ? null : soldBy,
        "row_total": rowTotal == null ? null : rowTotal,
        "original_price": originalPrice == null ? null : originalPrice,
        "image_url": imageUrl == null ? null : imageUrl,
        "burnpoint": burnPoint == null ? null : burnPoint,
        "burnamount": burnAmount == null ? null : burnAmount,
        "earnrate": earnRate == null ? null : earnRate,
        "earnpoint": earnPoint == null ? null : earnPoint
      };
}

class Rma {
  int? returnableItem;
  int? itemReturned;

  Rma({
    this.returnableItem,
    this.itemReturned,
  });
  factory Rma.fromJson(Map<String, dynamic> json) {
    return Rma(
      returnableItem:
          json['returnable_item'] != null ? json['returnable_item'] : null,
      itemReturned:
          json['item_returned'] != null ? json['item_returned'] : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "returnable_item": returnableItem,
        "item_returned": itemReturned,
      };
}

class StoreCredit {
  var availableAmount;
  List<BalanceHistory>? balanceHistory;

  StoreCredit({
    this.availableAmount,
    this.balanceHistory,
  });
  factory StoreCredit.fromJson(Map<String, dynamic> json) {
    return StoreCredit(
      availableAmount:
          json['available_amount'] != null ? json['available_amount'] : null,
      balanceHistory: json['balance_history'] != null
          ? List<BalanceHistory>.from(
              json["balance_history"].map((x) => BalanceHistory.fromJson(x)))
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['available_amount'] = this.availableAmount;
    if (this.balanceHistory != null) {
      data['balance_history'] =
          this.balanceHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BalanceHistory {
  String? historyId;
  String? balanceId;
  String? updatedAt;
  String? action;
  String? balanceAmount;
  String? balanceDelta;
  String? additionalInfo;
  String? isCustomerNotified;
  String? customerId;
  String? websiteId;
  dynamic baseCurrencyCode;
  String? actionTitle;

  BalanceHistory({
    this.historyId,
    this.balanceId,
    this.updatedAt,
    this.action,
    this.actionTitle,
    this.balanceAmount,
    this.balanceDelta,
    this.additionalInfo,
    this.isCustomerNotified,
    this.customerId,
    this.websiteId,
    this.baseCurrencyCode,
  });

  factory BalanceHistory.fromJson(Map<String, dynamic> json) {
    return BalanceHistory(
      historyId: json['history_id'] != null ? json['history_id'] : null,
      balanceId: json['balance_id'] != null ? json['balance_id'] : null,
      updatedAt: json['updated_at'] != null ? json['updated_at'] : null,
      action: json['action'] != null ? json['action'] : null,
      actionTitle: json["action_title"] == null ? null : json["action_title"],
      additionalInfo:
          json['additional_info'] != null ? json['additional_info'] : null,
      balanceAmount:
          json['balance_amount'] != null ? json['balance_amount'] : null,
      balanceDelta:
          json['balance_delta'] != null ? json['balance_delta'] : null,
      baseCurrencyCode: json['base_currency_code'] != null
          ? json['base_currency_code']
          : null,
      customerId: json['customer_id'] != null ? json['customer_id'] : null,
      isCustomerNotified: json['is_customer_notified'] != null
          ? json['is_customer_notified']
          : null,
      websiteId: json['website_id'] != null ? json['website_id'] : null,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['history_id'] = this.historyId;
    data['balance_id'] = this.balanceId;
    data['updated_at'] = this.updatedAt;
    data['action'] = this.action;
    data["action_title"] = this.actionTitle;
    data['balance_amount'] = this.balanceAmount;
    data['balance_delta'] = this.balanceDelta;
    data['additional_info'] = this.additionalInfo;
    data['is_customer_notified'] = this.isCustomerNotified;
    data['customer_id'] = this.customerId;
    data['website_id'] = this.websiteId;
    data['base_currency_code'] = this.baseCurrencyCode;
    return data;
  }
}

class AdditionalAddress {
  AdditionalAddress({
    this.addressId,
    this.firstname,
    this.lastname,
    this.city,
    this.countryId,
    this.postcode,
    this.region,
    this.regionId,
    this.street,
    this.telephone,
    this.countryCode,
    this.carrierCode,
    this.customAddressType,
    this.houseNo,
    this.address,
    this.address1,
    this.address2,
  });

  String? addressId;
  String? firstname;
  String? lastname;
  String? city;
  String? countryId;
  dynamic postcode;
  String? region;
  String? regionId;
  String? street;
  String? telephone;
  dynamic countryCode;
  dynamic carrierCode;
  dynamic customAddressType;
  dynamic houseNo;
  dynamic address;
  String? address1;
  String? address2;

  factory AdditionalAddress.fromJson(Map<String, dynamic> json) =>
      AdditionalAddress(
        addressId: json["address_id"] == null ? null : json["address_id"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        city: json["city"] == null ? null : json["city"],
        countryId: json["country_id"] == null ? null : json["country_id"],
        postcode: json["postcode"],
        region: json["region"] == null ? null : json["region"],
        regionId: json["region_id"] == null ? null : json["region_id"],
        street: json["street"] == null ? null : json["street"],
        telephone: json["telephone"] == null ? null : json["telephone"],
        countryCode: json["country_code"],
        carrierCode: json["carrier_code"],
        customAddressType: json["custom_address_type"],
        houseNo: json["house_no"],
        address: json["address"],
        address1: json["address1"] == null ? null : json["address1"],
        address2: json["address2"] == null ? null : json["address2"],
      );

  Map<String, dynamic> toJson() => {
        "address_id": addressId == null ? null : addressId,
        "firstname": firstname == null ? null : firstname,
        "lastname": lastname == null ? null : lastname,
        "city": city == null ? null : city,
        "country_id": countryId == null ? null : countryId,
        "postcode": postcode,
        "region": region == null ? null : region,
        "region_id": regionId == null ? null : regionId,
        "street": street == null ? null : street,
        "telephone": telephone == null ? null : telephone,
        "country_code": countryCode,
        "carrier_code": carrierCode,
        "custom_address_type": customAddressType,
        "house_no": houseNo,
        "address": address,
        "address1": address1 == null ? null : address1,
        "address2": address2 == null ? null : address2,
      };
}
