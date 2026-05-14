class MyReturnsModel {
  String? success;
  String? message;
  List<ReturnableItems>? returnableItems;
  List<ReturnedItem>? returnedItems;

  MyReturnsModel({
    this.success,
    this.message,
    this.returnableItems,
    this.returnedItems,
  });
  factory MyReturnsModel.fromJson(Map<String, dynamic> json) => MyReturnsModel(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        returnableItems: json["returnable_items"] == null
            ? null
            : List<ReturnableItems>.from(json["returnable_items"]
                .map((x) => ReturnableItems.fromJson(x))),
        returnedItems: json["returned_items"] == null
            ? null
            : List<ReturnedItem>.from(
                json["returned_items"].map((x) => ReturnedItem.fromJson(x))),
      );
}

class ReturnedItem {
  String? rmaId;
  String? requestNo;
  String? requestedOn;
  String? status;
  PickupAddress? pickupAddress;
  List<Item>? items;

  ReturnedItem({
    this.rmaId,
    this.requestNo,
    this.requestedOn,
    this.status,
    this.pickupAddress,
    this.items,
  });
  factory ReturnedItem.fromJson(Map<String, dynamic> json) => ReturnedItem(
        rmaId: json["rma_id"] == null ? null : json["rma_id"],
        requestNo: json["request_no"] == null ? null : json["request_no"],
        status: json["status"] == null ? null : json["status"],
        pickupAddress: json['pickup_address'] != null
            ? new PickupAddress.fromJson(json['pickup_address'])
            : null,
        requestedOn: json["requested_on"] == null ? null : json["requested_on"],
        items: json["items"] == null
            ? null
            : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );
}

class ReturnableItems {
  bool? selectedItem;
  String? incrementId;
  String? orderItemId;
  String? sku;
  int? qty;
  String? image;
  String? createdDate;
  String? sizeLabel;
  String? sizeValue;
  String? price;
  ShippingAddress? shippingAddress;
  List? returnReasons;
  List? itemConditions;
  String? paymentMethod;
  List? resolutionOptions;

  ReturnableItems(
      {this.selectedItem,
      this.incrementId,
      this.orderItemId,
      this.sku,
      this.qty,
      this.image,
      this.createdDate,
      this.sizeLabel,
      this.sizeValue,
      this.price,
      this.shippingAddress,
      this.returnReasons,
      this.itemConditions,
      this.paymentMethod,
      this.resolutionOptions});
      
  factory ReturnableItems.fromJson(Map<String, dynamic> json) {
    return ReturnableItems(
      selectedItem: json['selectedItem'] != null ? json['selectedItem'] : false,
      incrementId: json['increment_id'] != null ? json['increment_id'] : null,
      orderItemId: json['order_item_id'] != null ? json['order_item_id'] : null,
      sku: json['sku'] != null ? json['sku'] : null,
      qty: json['qty'] != null ? json['qty'] : null,
      image: json['image'] != null ? json['image'] : null,
      createdDate: json['created_date'] != null ? json['created_date'] : null,
      sizeLabel: json['size_label'] != null ? json['size_label'] : null,
      sizeValue: json['size_value'] != null ? json['size_value'] : null,
      price: json['price'] != null ? json['price'] : null,
      shippingAddress: json['shipping_address'] != null
          ? new ShippingAddress.fromJson(json['shipping_address'])
          : null,
      returnReasons: json["return_reasons"] == null
          ? null
          : List<ReturnReasons>.from(
              json["return_reasons"].map((x) => ReturnReasons.fromJson(x))),
      itemConditions: json["item_conditions"] == null
          ? null
          : List<ItemCondition>.from(
              json["item_conditions"].map((x) => ItemCondition.fromJson(x))),
      paymentMethod:
          json['payment_method'] != null ? json['payment_method'] : null,
      resolutionOptions: json["resolution_options"] == null
          ? null
          : List<ResolutionOptions>.from(
              json["resolution_options"].map((x) => ResolutionOptions.fromJson(x))),
    );
  }
}
class ItemCondition {
    ItemCondition({
        this.id,
        this.label,
    });

    String? id;
    String? label;

    factory ItemCondition.fromJson(Map<String, dynamic> json) => ItemCondition(
        id: json["id"],
        label: json["label"],
    );

  
}

class ReturnReasons {
  String? id;
  String? label;

  ReturnReasons({this.id, this.label});

  ReturnReasons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
  }
}
class ResolutionOptions {
  int? id;
  String? label;

  ResolutionOptions({this.id, this.label});

  ResolutionOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
  }

  
}

class ReturnedItems {
  String? rmaId;
  String? requestNo;
  String? requestedOn;
  String? status;
  ShippingAddress? pickupAddress;
  List<Items>? items;

  ReturnedItems(
      {this.rmaId,
      this.requestNo,
      this.requestedOn,
      this.status,
      this.pickupAddress,
      this.items});

  ReturnedItems.fromJson(Map<String, dynamic> json) {
    rmaId = json['rma_id'];
    requestNo = json['request_no'];
    requestedOn = json['requested_on'];
    status = json['status'];
    pickupAddress = json['pickup_address'] != null
        ? new ShippingAddress.fromJson(json['pickup_address'])
        : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

 
}
class Items {
  String? productName;
  String? orderId;
  String? sku;
  String? qty;
  String? item;
  String? createdAt;
  String? image;
  String? itemCondition;
  String? reason;
  String? sizeLabel;
  String? sizeValue;

  Items(
      {this.productName,
      this.orderId,
      this.sku,
      this.qty,
      this.item,
      this.createdAt,
      this.image,
      this.itemCondition,
      this.reason,
      this.sizeLabel,
      this.sizeValue});

  Items.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    orderId = json['order_id'];
    sku = json['sku'];
    qty = json['qty'];
    item = json['item'];
    createdAt = json['created_at'];
    image = json['image'];
    itemCondition = json['item_condition'];
    reason = json['reason'];
    sizeLabel = json['size_label'];
    sizeValue = json['size_value'];
  }

 
}
class PickupAddress {
  String? entityId;
  String? parentId;
  String? customerAddressId;
  String? quoteAddressId;
  var regionId;
  var customerId;
  var fax;
  String? region;
  String? postcode;
  String? lastname;
  String? street;
  String? city;
  String? email;
  String? telephone;
  String? countryId;
  String? firstname;
  String? addressType;
  String? prefix;
  String? middlename;
  String? suffix;
  String? company;
  String? vatId;
  String? vatIsValid;
  String? vatRequestId;
  String? vatRequestDate;
  String? vatRequestSuccess;
  String? giftregistryItemId;
  String? customAddressType;
  String? area;
  String? address;
  String? houseNo;
  String? countryCode;
  String? carrierCode;

  PickupAddress(
      {this.entityId,
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
      this.carrierCode});

  factory PickupAddress.fromJson(Map<String, dynamic> json) => PickupAddress(
        entityId: json["entity_id"] == null ? null : json["entity_id"],
        parentId: json["parent_id"] == null ? null : json["parent_id"],
        customerAddressId: json["customer_address_id"] == null
            ? null
            : json["customer_address_id"],
        quoteAddressId:
            json["quote_address_id"] == null ? null : json["quote_address_id"],
        regionId: json["region_id"] == null ? null : json["region_id"],
        customerId: json["customer_id"] == null ? null : json["customer_id"],
        fax: json["fax"] == null ? null : json["fax"],
        region: json["region"] == null ? null : json["region"],
        postcode: json["postcode"] == null ? null : json["postcode"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        street: json["street"] == null ? null : json["street"],
        city: json["city"] == null ? null : json["city"],
        email: json["email"] == null ? null : json["email"],
        telephone: json["telephone"] == null ? null : json["telephone"],
        countryId: json["countryId"] == null ? null : json["countryId"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        addressType: json["address_type"] == null ? null : json["address_type"],
        prefix: json["prefix"] == null ? null : json["prefix"],
        middlename: json["middlename"] == null ? null : json["middlename"],
        suffix: json["suffix"] == null ? null : json["suffix"],
        company: json["company"] == null ? null : json["company"],
        vatId: json["vat_id"] == null ? null : json["vat_id"],
        vatIsValid: json["vat_is_valid"] == null ? null : json["vat_is_valid"],
        vatRequestId:
            json["vat_request_id"] == null ? null : json["vat_request_id"],
        vatRequestDate:
            json["vat_request_date"] == null ? null : json["vat_request_date"],
        vatRequestSuccess: json["vat_request_success"] == null
            ? null
            : json["vat_request_success"],
        giftregistryItemId: json["giftregistry_item_id"] == null
            ? null
            : json["giftregistry_item_id"],
        customAddressType: json["custom_address_type"] == null
            ? null
            : json["custom_address_type"],
        area: json["area"] == null ? null : json["area"],
        address: json["address"] == null ? null : json["address"],
        houseNo: json["house_no"] == null ? null : json["house_no"],
        countryCode: json["country_code"] == null ? null : json["country_code"],
        carrierCode: json["carrier_code"] == null ? null : json["carrier_code"],
      );
}

class ShippingAddress {
  String? entityId;
  String? parentId;
  String? customerAddressId;
  String? quoteAddressId;
  var regionId;
  var customerId;
  var fax;
  String? region;
  var postcode;
  String? lastname;
  String? street;
  String? city;
  String? email;
  String? telephone;
  String? countryId;
  String? firstname;
  String? addressType;
  var prefix;
  var middlename;
  var suffix;
  var company;
  var vatId;
  var vatIsValid;
  var vatRequestId;
  var vatRequestDate;
  var vatRequestSuccess;
  var giftregistryItemId;
  String? customAddressType;
  var area;
  String? address;
  String? houseNo;
  String? countryCode;
  String? carrierCode;

  ShippingAddress(
      {this.entityId,
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
      this.carrierCode});

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      entityId: json['entity_id'] != null ? json['entity_id'] : null,
      parentId: json['parent_id'] != null ? json['parent_id'] : null,
      customerAddressId: json['customer_address_id'] != null
          ? json['customer_address_id']
          : null,
      quoteAddressId:
          json['quote_address_id'] != null ? json['quote_address_id'] : null,
      regionId: json['region_id'] != null ? json['region_id'] : null,
      customerId: json['customer_id'] != null ? json['customer_id'] : null,
      fax: json['fax'] != null ? json['fax'] : null,
      region: json['region'] != null ? json['region'] : null,
      postcode: json['postcode'] != null ? json['postcode'] : null,
      lastname: json['lastname'] != null ? json['lastname'] : null,
      street: json['street'] != null ? json['street'] : null,
      city: json['city'] != null ? json['city'] : null,
      email: json['email'] != null ? json['email'] : null,
      telephone: json['telephone'] != null ? json['telephone'] : null,
      countryId: json['country_id'] != null ? json['country_id'] : null,
      firstname: json['firstname'] != null ? json['firstname'] : null,
      addressType: json['address_type'] != null ? json['address_type'] : null,
      prefix: json['prefix'] != null ? json['prefix'] : null,
      middlename: json['middlename'] != null ? json['middlename'] : null,
      suffix: json['suffix'] != null ? json['suffix'] : null,
      company: json['company'] != null ? json['company'] : null,
      vatId: json['vat_id'] != null ? json['vat_id'] : null,
      vatIsValid: json['vat_is_valid'] != null ? json['vat_is_valid'] : null,
      vatRequestId:
          json['vat_request_id'] != null ? json['vat_request_id'] : null,
      vatRequestDate:
          json['vat_request_date'] != null ? json['vat_request_date'] : null,
      vatRequestSuccess: json['vat_request_success'] != null
          ? json['vat_request_success']
          : null,
      giftregistryItemId: json['giftregistry_item_id'] != null
          ? json['giftregistry_item_id']
          : null,
      customAddressType: json['custom_address_type'] != null
          ? json['custom_address_type']
          : null,
      area: json['area'] != null ? json['area'] : null,
      address: json['address'] != null ? json['address'] : null,
      houseNo: json['house_no'] != null ? json['house_no'] : null,
      countryCode: json['country_code'] != null ? json['country_code'] : null,
      carrierCode: json['carrier_code'] != null ? json['carrier_code'] : null,
    );
  }
}

class Item {
  String? productName;
  String? orderId;
  String? sku;
  String? item;
  String? createdAt;
  String? image;
  String? sizeLabel;
  String? sizeValue;

  Item({
    this.productName,
    this.orderId,
    this.sku,
    this.item,
    this.createdAt,
    this.image,
    this.sizeLabel,
    this.sizeValue,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        productName: json["product_name"] == null ? null : json["product_name"],
        orderId: json["order_id"] == null ? null : json["order_id"],
        sku: json["sku"] == null ? null : json["sku"],
        item: json["item"] == null ? null : json["item"],
        createdAt: json["created_at"] == null ? null : json["created_at"],
        image: json["image"] == null ? null : json["image"],
        sizeLabel: json["size_label"] == null ? null : json["size_label"],
        sizeValue: json["size_value"] == null ? null : json["size_value"],
      );
}
