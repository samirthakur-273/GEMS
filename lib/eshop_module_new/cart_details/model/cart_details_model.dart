// To parse this JSON data, do
//
//     final cartDetailsModel = cartDetailsModelFromJson(jsonString);

import 'dart:convert';

List<CartDetailsModel> cartDetailsModelFromJson(String str) =>
    List<CartDetailsModel>.from(
        json.decode(str).map((x) => CartDetailsModel.fromJson(x)));

String cartDetailsModelToJson(List<CartDetailsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartDetailsModel {
  CartDetailsModel(
      {this.updateResponse,
      this.success,
      this.shippingBurnrate,
      this.message,
      this.items,
      this.subTotal,
      this.tax,
      this.shippingAmount,
      this.storeCredit,
      this.couponCode,
      this.discount,
      this.grandTotal,
      this.totalItems,
      this.totalQty,
      this.freeShippingMessage,
      this.freeShippingApply,
      this.giftEmail});
  bool? updateResponse;
  String? success;
  String? message;
  List<Itemss>? items;
  String? subTotal;
  String? tax;
  String? shippingBurnrate;
  String? shippingAmount;
  String? storeCredit;
  dynamic couponCode;
  String? discount;
  String? grandTotal;
  int? totalItems;
  int? totalQty;
  String? giftEmail;
  String? freeShippingMessage;
  int? freeShippingApply;

  factory CartDetailsModel.fromJson(Map<String, dynamic> json) =>
      CartDetailsModel(
        updateResponse:
            json["updateResponse"] == null ? false : json["updateResponse"],
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        shippingBurnrate: json["shipping_burnrate"] == null
            ? null
            : json["shipping_burnrate"],
        giftEmail: json["giftemail"] == null ? null : json["giftemail"],
        items: json["items"] == null
            ? null
            : List<Itemss>.from(json["items"].map((x) => Itemss.fromJson(x))),
        subTotal: json["sub_total"] == null ? null : json["sub_total"],
        tax: json["tax"] == null ? null : json["tax"],
        shippingAmount:
            json["shipping_amount"] == null ? null : json["shipping_amount"],
        storeCredit: json["store_credit"] == null ? null : json["store_credit"],
        couponCode: json["coupon_code"],
        discount: json["discount"] == null ? null : json["discount"],
        grandTotal: json["grand_total"] == null ? null : json["grand_total"],
        totalItems: json["total_items"] == null ? null : json["total_items"],
        totalQty: json["total_qty"] == null ? null : json["total_qty"],
        freeShippingMessage: json["free_shipping_message"] == null
            ? null
            : json["free_shipping_message"],
        freeShippingApply: json["free_shipping_apply"] == null
            ? null
            : json["free_shipping_apply"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "giftemail": giftEmail == null ? null : giftEmail,
        "items": items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "sub_total": subTotal == null ? null : subTotal,
        "tax": tax == null ? null : tax,
        "shipping_burnrate": shippingBurnrate == null ? null : shippingBurnrate,
        "shipping_amount": shippingAmount == null ? null : shippingAmount,
        "store_credit": storeCredit == null ? null : storeCredit,
        "coupon_code": couponCode,
        "discount": discount == null ? null : discount,
        "grand_total": grandTotal == null ? null : grandTotal,
        "total_items": totalItems == null ? null : totalItems,
        "total_qty": totalQty == null ? null : totalQty,
        "free_shipping_message":
            freeShippingMessage == null ? null : freeShippingMessage,
        "free_shipping_apply":
            freeShippingApply == null ? null : freeShippingApply,
      };
}

class Itemss {
  Itemss(
      {this.quoteId,
      this.quoteitemId,
      this.name,
      this.sku,
      this.price,
      this.image,
      this.shortDescriprtion,
      this.descriprtion,
      this.mainprice,
      this.specialPrice,
      this.specialPriceFromDate,
      this.specialPriceToDate,
      this.productId,
      this.childId,
      this.currencySymbol,
      this.qty,
      this.iswishlist,
      this.configurableProductOptions,
      this.earnrate,
      this.burnrate,
      this.minipointrequired,
      this.pointEarned,
      this.excltaxprice,
      this.type,
      this.isAvailable,
      this.soldBy,
      this.edvoucher,
      this.stock,
      this.brandName,
      this.categoryType,
      this.subCategory,});

  String? quoteId;
  String? quoteitemId;
  String? name;
  String? sku;
  String? price;
  String? image;
  String? shortDescriprtion;
  String? descriprtion;
  String? mainprice;
  String? specialPrice;
  dynamic specialPriceFromDate;
  dynamic specialPriceToDate;
  String? productId;
  String? childId;
  String? currencySymbol;
  var qty;
  bool? iswishlist;
  var configurableProductOptions;
  String? earnrate;
  String? burnrate;
  String? minipointrequired;
  String? pointEarned;
  String? excltaxprice;
  String? type;
  int? isAvailable;
  String? soldBy;
  bool? edvoucher;
  String? stock;
  String? brandName;
  String? categoryType;
  String? subCategory;


  factory Itemss.fromJson(Map<String, dynamic> json) => Itemss(
      quoteId: json["quoteID"] == null ? null : json["quoteID"],
      quoteitemId: json["quoteitemId"] == null ? null : json["quoteitemId"],
      name: json["name"] == null ? null : json["name"],
      sku: json["sku"] == null ? null : json["sku"],
      price: json["price"] == null || json["price"] == '' ? '0' : json["price"],
      image: json["image"] == null ? null : json["image"],
      edvoucher: json['edvoucher'] == null ? null : json['edvoucher'],
      shortDescriprtion: json["short_descriprtion"] == null
          ? null
          : json["short_descriprtion"],
      descriprtion: json["descriprtion"] == null ? null : json["descriprtion"],
      mainprice: json["mainprice"] == null ? null : json["mainprice"],
      specialPrice: json["special_price"] == null || json["special_price"] == ''
          ? '0'
          : json["special_price"],
      soldBy: json["soldby"] == null ? null : json["soldby"],
      specialPriceFromDate: json["special_price_from_date"],
      specialPriceToDate: json["special_price_to_date"],
      productId: json["product_id"] == null ? null : json["product_id"],
      childId: json["child_id"] == null ? null : json["child_id"],
      currencySymbol:
          json["currency_symbol"] == null ? null : json["currency_symbol"],
      qty: json["qty"] == null ? null : json["qty"],
      iswishlist: json["iswishlist"] == null ? null : json["iswishlist"],
      configurableProductOptions: json["configurable_product_options"] == null
          ? null
          : json["configurable_product_options"],
      earnrate: json["earnrate"] == null || json["earnrate"] == ''
          ? '0'
          : json["earnrate"],
      burnrate: json["burnrate"] == null || json["burnrate"] == ''
          ? '0'
          : json["burnrate"],
      minipointrequired:
          json["minipointrequired"] == null ? null : json["minipointrequired"],
      pointEarned: json["point_earned"] == null ? null : json["point_earned"],
      excltaxprice: json["excltaxprice"] == null ? null : json["excltaxprice"],
      type: json["type"] == null ? null : json["type"],
      isAvailable: json["is_available"] == null ? null : json["is_available"],
      stock: json["Stock"]  == null ? null : json["Stock"],
      brandName: json["brand_name"]  == null ? null : json["brand_name"],
      categoryType: json["category_type"]  == null ? null : json["category_type"],
      subCategory: json["sub_category"]  == null ? null : json["sub_category"]);

  Map<String, dynamic> toJson() => {
        "quoteID": quoteId == null ? null : quoteId,
        "quoteitemId": quoteitemId == null ? null : quoteitemId,
        "name": name == null ? null : name,
        "sku": sku == null ? null : sku,
        "price": price == null || price == '' ? '0' : price,
        "image": image == null ? null : image,
        "short_descriprtion":
            shortDescriprtion == null ? null : shortDescriprtion,
        "descriprtion": descriprtion == null ? null : descriprtion,
        "mainprice": mainprice == null ? null : mainprice,
        "special_price":
            specialPrice == null || specialPrice == '' ? '0' : specialPrice,
        "special_price_from_date": specialPriceFromDate,
        "special_price_to_date": specialPriceToDate,
        "product_id": productId == null ? null : productId,
        "child_id": childId == null ? null : childId,
        "currency_symbol": currencySymbol == null ? null : currencySymbol,
        "qty": qty == null ? null : qty,
        "iswishlist": iswishlist == null ? null : iswishlist,
        "configurable_product_options": configurableProductOptions == null
            ? null
            : configurableProductOptions,
        "edvoucher": edvoucher == null ? null : edvoucher,
        "earnrate": earnrate == null || earnrate == '' ? '0' : earnrate,
        "burnrate": burnrate == null || burnrate == '' ? '0' : burnrate,
        "minipointrequired":
            minipointrequired == null ? null : minipointrequired,
        "point_earned": pointEarned == null ? null : pointEarned,
        "excltaxprice": excltaxprice == null ? null : excltaxprice,
        "type": type == null ? null : type,
        "is_available": isAvailable == null ? null : isAvailable,
        "soldby": soldBy == null ? null : soldBy,
        "Stock": stock  == null ? null : stock,
        "brand_name": brandName == null ? null : brandName,
        "category_type": categoryType == null ? null : categoryType,
        "sub_category": subCategory == null ? null : subCategory,
      };
}

class ConfigurableProductOptions {
  ConfigurableProductOptions({
    this.the160,
    this.configOptions,
  });

  List<The160>? the160;
  List<int>? configOptions;

  factory ConfigurableProductOptions.fromJson(Map<String, dynamic> json) =>
      ConfigurableProductOptions(
        the160: json["160"] == null
            ? null
            : List<The160>.from(json["160"].map((x) => The160.fromJson(x))),
        configOptions: json["config_options"] == null
            ? null
            : List<int>.from(json["config_options"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "160": the160 == null
            ? null
            : List<dynamic>.from(the160!.map((x) => x.toJson())),
        "config_options": configOptions == null
            ? null
            : List<dynamic>.from(configOptions!.map((x) => x)),
      };
}

class The160 {
  The160({
    this.childId,
    this.productId,
    this.price,
    this.specialPrice,
    this.optionValue,
    this.label,
    this.specialPriceFromDate,
    this.specialPriceToDate,
    this.optionLabel,
  });

  String? childId;
  String? productId;
  String? price;
  String? specialPrice;
  String? optionValue;
  String? label;
  dynamic specialPriceFromDate;
  dynamic specialPriceToDate;
  String? optionLabel;

  factory The160.fromJson(Map<String, dynamic> json) => The160(
        childId: json["child_id"] == null ? null : json["child_id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        price: json["price"] == null ? null : json["price"],
        specialPrice:
            json["special_price"] == null ? null : json["special_price"],
        optionValue: json["option_value"] == null ? null : json["option_value"],
        label: json["label"] == null ? null : json["label"],
        specialPriceFromDate: json["special_price_from_date"],
        specialPriceToDate: json["special_price_to_date"],
        optionLabel: json["option_label"] == null ? null : json["option_label"],
      );

  Map<String, dynamic> toJson() => {
        "child_id": childId == null ? null : childId,
        "product_id": productId == null ? null : productId,
        "price": price == null ? null : price,
        "special_price": specialPrice == null ? null : specialPrice,
        "option_value": optionValue == null ? null : optionValue,
        "label": label == null ? null : label,
        "special_price_from_date": specialPriceFromDate,
        "special_price_to_date": specialPriceToDate,
        "option_label": optionLabel == null ? null : optionLabel,
      };
}

List<RemoveProductModel> removeProductModelFromJson(String str) =>
    List<RemoveProductModel>.from(
        json.decode(str).map((x) => RemoveProductModel.fromJson(x)));

String removeProductModelToJson(List<RemoveProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RemoveProductModel {
  RemoveProductModel({
    this.success,
    this.message,
  });

  String? success;
  String? message;

  factory RemoveProductModel.fromJson(Map<String, dynamic> json) =>
      RemoveProductModel(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}

List<EditProductModel> editProductModelFromJson(String str) =>
    List<EditProductModel>.from(
        json.decode(str).map((x) => EditProductModel.fromJson(x)));

String editProductModelToJson(List<EditProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EditProductModel {
  EditProductModel({
    this.success,
    this.message,
    this.address,
    this.totalCount,
  });

  String? success;
  String? message;
  Addresss? address;
  int? totalCount;

  factory EditProductModel.fromJson(Map<String, dynamic> json) =>
      EditProductModel(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        address:
            json["address"] == null ? null : Addresss.fromJson(json["address"]),
        totalCount: json["total_count"] == null ? null : json["total_count"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "address": address == null ? null : address?.toJson(),
        "total_count": totalCount == null ? null : totalCount,
      };
}

class Addresss {
  Addresss({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory Addresss.fromJson(Map<String, dynamic> json) => Addresss(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}
