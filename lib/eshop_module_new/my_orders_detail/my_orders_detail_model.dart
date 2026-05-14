// To parse this JSON data, do
//
//     final orderDetailsModels = orderDetailsModelsFromJson(jsonString);

import 'dart:convert';

List<OrderDetailsModels> orderDetailsModelsFromJson(String str) =>
    List<OrderDetailsModels>.from(
        json.decode(str).map((x) => OrderDetailsModels.fromJson(x)));

String orderDetailsModelsToJson(List<OrderDetailsModels> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderDetailsModels {
  OrderDetailsModels({
    this.success,
    this.message,
    this.orderDetails,
  });

  String? success;
  String? message;
  OrderDetails? orderDetails;

  factory OrderDetailsModels.fromJson(Map<String, dynamic> json) =>
      OrderDetailsModels(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        orderDetails: json["order details"] == null
            ? null
            : OrderDetails.fromJson(json["order details"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "order details": orderDetails == null ? null : orderDetails!.toJson(),
      };
}

class OrderDetails {
  OrderDetails(
      {this.orderId,
      this.incrementId,
      this.createAt,
      this.address,
      this.shippingMethod,
      this.paymentMethod,
      this.status,
      this.items,
      this.subtotal,
      this.codFee,
      this.shipping,
      this.tax,
      this.grandTotal,
      this.earnPoint});

  String? orderId;
  DateTime? createAt;
  String? incrementId;
  Address? address;
  String? shippingMethod;
  String? paymentMethod;
  String? status;
  List<Item>? items;
  String? subtotal;
  String? codFee;
  String? shipping;
  String? tax;
  String? grandTotal;
  String? earnPoint;

  factory OrderDetails.fromJson(Map<String, dynamic> json) => OrderDetails(
        orderId: json["order_id"] == null ? null : json["order_id"],
        incrementId: json["increment_id"] == null ? null : json["increment_id"],
        earnPoint: json["earnpoint"] == null ? null : json["earnpoint"],
        createAt: json["create_at"] == null
            ? null
            : DateTime.parse(json["create_at"]),
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        shippingMethod:
            json["shipping_method"] == null ? null : json["shipping_method"],
        paymentMethod:
            json["payment_method"] == null ? null : json["payment_method"],
        status: json["status"] == null ? null : json["status"],
        items: json["items"] == null
            ? null
            : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        subtotal: json["subtotal"] == null ? null : json["subtotal"],
        codFee: json["cod_fee"] == null ? null : json["cod_fee"],
        shipping: json["shipping"] == null ? null : json["shipping"],
        tax: json["tax"] == null ? null : json["tax"],
        grandTotal: json["grand_total"] == null ? null : json["grand_total"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId == null ? null : orderId,
        "increment_id": incrementId == null ? null : incrementId,
        "earnpoint": earnPoint == null ? null : earnPoint,
        "create_at": createAt == null ? null : createAt!.toIso8601String(),
        "address": address == null ? null : address!.toJson(),
        "shipping_method": shippingMethod == null ? null : shippingMethod,
        "payment_method": paymentMethod == null ? null : paymentMethod,
        "status": status == null ? null : status,
        "items": items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "subtotal": subtotal == null ? null : subtotal,
        "cod_fee": codFee == null ? null : codFee,
        "shipping": shipping == null ? null : shipping,
        "tax": tax == null ? null : tax,
        "grand_total": grandTotal == null ? null : grandTotal,
      };
}

class Address {
  Address({
    this.shipping,
    this.billing,
  });

  Ing? shipping;
  Ing? billing;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        shipping:
            json["shipping"] == null ? null : Ing.fromJson(json["shipping"]),
        billing: json["billing"] == null ? null : Ing.fromJson(json["billing"]),
      );

  Map<String, dynamic> toJson() => {
        "shipping": shipping == null ? null : shipping!.toJson(),
        "billing": billing == null ? null : billing!.toJson(),
      };
}

class Ing {
  Ing({
    this.entityId,
    this.parentId,
    this.customerAddressId,
    this.quoteAddressId,
    this.regionId,
    this.customerId,
    this.fax,
    this.region,
    this.postcode,
    this.lastname,
    this.street,
    this.city,
    this.email,
    this.telephone,
    this.countryId,
    this.firstname,
    this.addressType,
    this.prefix,
    this.middlename,
    this.suffix,
    this.company,
    this.vatId,
    this.vatIsValid,
    this.vatRequestId,
    this.vatRequestDate,
    this.vatRequestSuccess,
    this.giftregistryItemId,
    this.customAddressType,
    this.area,
    this.address,
    this.houseNo,
    this.countryCode,
    this.carrierCode,
  });

  String? entityId;
  String? parentId;
  dynamic customerAddressId;
  String? quoteAddressId;
  dynamic regionId;
  dynamic customerId;
  dynamic fax;
  String? region;
  dynamic postcode;
  String? lastname;
  String? street;
  String? city;
  String? email;
  String? telephone;
  String? countryId;
  String? firstname;
  String? addressType;
  dynamic prefix;
  dynamic middlename;
  dynamic suffix;
  dynamic company;
  dynamic vatId;
  dynamic vatIsValid;
  dynamic vatRequestId;
  dynamic vatRequestDate;
  dynamic vatRequestSuccess;
  dynamic giftregistryItemId;
  dynamic customAddressType;
  dynamic area;
  String? address;
  String? houseNo;
  String? countryCode;
  String? carrierCode;

  factory Ing.fromJson(Map<String, dynamic> json) => Ing(
        entityId: json["entity_id"] == null ? null : json["entity_id"],
        parentId: json["parent_id"] == null ? null : json["parent_id"],
        customerAddressId: json["customer_address_id"],
        quoteAddressId:
            json["quote_address_id"] == null ? null : json["quote_address_id"],
        regionId: json["region_id"],
        customerId: json["customer_id"],
        fax: json["fax"],
        region: json["region"] == null ? null : json["region"],
        postcode: json["postcode"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        street: json["street"] == null ? null : json["street"],
        city: json["city"] == null ? null : json["city"],
        email: json["email"] == null ? null : json["email"],
        telephone: json["telephone"] == null ? null : json["telephone"],
        countryId: json["country_id"] == null ? null : json["country_id"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        addressType: json["address_type"] == null ? null : json["address_type"],
        prefix: json["prefix"],
        middlename: json["middlename"],
        suffix: json["suffix"],
        company: json["company"],
        vatId: json["vat_id"],
        vatIsValid: json["vat_is_valid"],
        vatRequestId: json["vat_request_id"],
        vatRequestDate: json["vat_request_date"],
        vatRequestSuccess: json["vat_request_success"],
        giftregistryItemId: json["giftregistry_item_id"],
        customAddressType: json["custom_address_type"],
        area: json["area"],
        address: json["address"] == null ? null : json["address"],
        houseNo: json["house_no"] == null ? null : json["house_no"],
        countryCode: json["country_code"] == null ? null : json["country_code"],
        carrierCode: json["carrier_code"] == null ? null : json["carrier_code"],
      );

  Map<String, dynamic> toJson() => {
        "entity_id": entityId == null ? null : entityId,
        "parent_id": parentId == null ? null : parentId,
        "customer_address_id": customerAddressId,
        "quote_address_id": quoteAddressId == null ? null : quoteAddressId,
        "region_id": regionId,
        "customer_id": customerId,
        "fax": fax,
        "region": region == null ? null : region,
        "postcode": postcode,
        "lastname": lastname == null ? null : lastname,
        "street": street == null ? null : street,
        "city": city == null ? null : city,
        "email": email == null ? null : email,
        "telephone": telephone == null ? null : telephone,
        "country_id": countryId == null ? null : countryId,
        "firstname": firstname == null ? null : firstname,
        "address_type": addressType == null ? null : addressType,
        "prefix": prefix,
        "middlename": middlename,
        "suffix": suffix,
        "company": company,
        "vat_id": vatId,
        "vat_is_valid": vatIsValid,
        "vat_request_id": vatRequestId,
        "vat_request_date": vatRequestDate,
        "vat_request_success": vatRequestSuccess,
        "giftregistry_item_id": giftregistryItemId,
        "custom_address_type": customAddressType,
        "area": area,
        "address": address == null ? null : address,
        "house_no": houseNo == null ? null : houseNo,
        "country_code": countryCode == null ? null : countryCode,
        "carrier_code": carrierCode == null ? null : carrierCode,
      };
}

class Item {
  Item({
    this.name,
    this.sku,
    this.price,
    this.qty,
    this.brand,
    this.soldBy,
    this.rowTotal,
    this.originalPrice,
    this.label,
    this.value,
    this.imageUrl,
  });

  String? name;
  String? sku;
  String? price;
  var qty;
  String? brand;
  String? soldBy;
  String? rowTotal;
  String? originalPrice;
  String? label;
  String? value;
  String? imageUrl;
  

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
        label: json["label"] == null ? null : json["label"],
        value: json["value"] == null ? null : json["value"],
        imageUrl: json["image_url"] == null ? null : json["image_url"],
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
        "label": label == null ? null : label,
        "value": value == null ? null : value,
        "image_url": imageUrl == null ? null : imageUrl,
      };
}

List<CancelOrderModels> cancelOrderModelsFromJson(String str) =>
    List<CancelOrderModels>.from(
        json.decode(str).map((x) => CancelOrderModels.fromJson(x)));

String cancelOrderModelsToJson(List<CancelOrderModels> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CancelOrderModels {
  CancelOrderModels({this.success, this.message, this.orderId});

  String? success;
  String? message;
  var orderId;

  factory CancelOrderModels.fromJson(Map<String, dynamic> json) =>
      CancelOrderModels(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        orderId: json["order_id"] == null ? null : json["order_id"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
      };
}

List<OrderTrackingModel> orderTrackingModelFromJson(String str) =>
    List<OrderTrackingModel>.from(
        json.decode(str).map((x) => OrderTrackingModel.fromJson(x)));

String orderTrackingModelToJson(List<OrderTrackingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderTrackingModel {
  OrderTrackingModel({
    this.success,
    this.message,
    this.orderdata,
    this.ordertracking,
  });

  String? success;
  String? message;
  List<Orderdatum>? orderdata;
  List<Ordertracking>? ordertracking;

  factory OrderTrackingModel.fromJson(Map<String, dynamic> json) =>
      OrderTrackingModel(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        orderdata: json["orderdata"] == null
            ? null
            : List<Orderdatum>.from(
                json["orderdata"].map((x) => Orderdatum.fromJson(x))),
        ordertracking: json["ordertracking"] == null
            ? null
            : List<Ordertracking>.from(
                json["ordertracking"].map((x) => Ordertracking.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "orderdata": orderdata == null
            ? null
            : List<dynamic>.from(orderdata!.map((x) => x.toJson())),
        "ordertracking": ordertracking == null
            ? null
            : List<dynamic>.from(ordertracking!.map((x) => x.toJson())),
      };
}

class Orderdatum {
  Orderdatum({
    this.trackingId,
    this.orderStatus,
    this.createdDate,
    this.updatedDate,
  });

  String? trackingId;
  String? orderStatus;
  DateTime? createdDate;
  DateTime? updatedDate;

  factory Orderdatum.fromJson(Map<String, dynamic> json) => Orderdatum(
        trackingId: json["tracking id"] == null ? null : json["tracking id"],
        orderStatus: json["order status"] == null ? null : json["order status"],
        createdDate: json["created date"] == null
            ? null
            : DateTime.parse(json["created date"]),
        updatedDate: json["updated date"] == null
            ? null
            : DateTime.parse(json["updated date"]),
      );

  Map<String, dynamic> toJson() => {
        "tracking id": trackingId == null ? null : trackingId,
        "order status": orderStatus == null ? null : orderStatus,
        "created date":
            createdDate == null ? null : createdDate!.toIso8601String(),
        "updated date":
            updatedDate == null ? null : updatedDate!.toIso8601String(),
      };
}

class Ordertracking {
  Ordertracking({
    this.orderStatus,
    this.trackingId,
    this.trackdetail,
  });

  String? orderStatus;
  String? trackingId;
  String? trackdetail;

  factory Ordertracking.fromJson(Map<String, dynamic> json) => Ordertracking(
        orderStatus: json["order status"] == null ? null : json["order status"],
        trackingId: json["tracking id"] == null ? null : json["tracking id"],
        trackdetail: json["trackdetail"] == null ? null : json["trackdetail"],
      );

  Map<String, dynamic> toJson() => {
        "order status": orderStatus == null ? null : orderStatus,
        "tracking id": trackingId == null ? null : trackingId,
        "trackdetail": trackdetail == null ? null : trackdetail,
      };
}
