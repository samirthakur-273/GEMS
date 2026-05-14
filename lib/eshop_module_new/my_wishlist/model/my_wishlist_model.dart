// To parse this JSON data, do
//
//     final myWishlistModel = myWishlistModelFromJson(jsonString);

import 'dart:convert';

List<MyWishlistModel> myWishlistModelFromJson(String str) =>
    List<MyWishlistModel>.from(
        json.decode(str).map((x) => MyWishlistModel.fromJson(x)));

String myWishlistModelToJson(List<MyWishlistModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyWishlistModel {
  MyWishlistModel({
    this.updateResponse,
    this.success,
    this.message,
    this.viewWishlist,
    this.totalCount,
    this.totalValue,
    
  });
  bool? updateResponse;
  String? success;
  String? message;
  List<ViewWishlist>? viewWishlist;
  int? totalCount;
  String? totalValue;

  factory MyWishlistModel.fromJson(Map<String, dynamic> json) =>
      MyWishlistModel(
        updateResponse:
            json['updateResponse'] == null ? null : json['updateResponse'],
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        viewWishlist: json["View wishlist"] == null
            ? null
            : List<ViewWishlist>.from(
                json["View wishlist"].map((x) => ViewWishlist.fromJson(x))),
        totalCount: json["total_count"] == null ? null : json["total_count"],
        totalValue: json["total_value"] == null ? null : json["total_value"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "View wishlist": viewWishlist == null
            ? null
            : List<dynamic>.from(viewWishlist!.map((x) => x.toJson())),
        "total_count": totalCount == null ? null : totalCount,
        "total_value": totalValue == null ? null : totalValue,
      };
}

class ViewWishlist {
  ViewWishlist({
    this.wishlistId,
    this.productid,
    this.sku,
    this.qty,
    this.productName,
    this.shortDescription,
    this.price,
    this.specialPrice,
    this.specialPriceFromDate,
    this.specialPriceToDate,
    this.productImage,
    this.configurableProductOptions,
    this.earnrate,
    this.burnrate,
    this.stock,
    this.pointEarned,
    this.brandName,
    this.categoryType,
    this.subCategory,
  });

  String? wishlistId;
  String? productid;
  String? sku;
  var qty;
  String? productName;
  dynamic shortDescription;
  String? price;
  String? specialPrice;
  dynamic specialPriceFromDate;
  dynamic specialPriceToDate;
  String? productImage;
  var configurableProductOptions;
  dynamic earnrate;
  dynamic burnrate;
  String? stock;
  String? pointEarned;
  String? brandName;
  String? categoryType;
  String? subCategory;

  factory ViewWishlist.fromJson(Map<String, dynamic> json) => ViewWishlist(
        wishlistId: json["Wishlist_id"] == null ? null : json["Wishlist_id"],
        productid: json["productid"] == null ? null : json["productid"],
        sku: json["sku"] == null ? null : json["sku"],
        qty: json["Qty"] == null ? null : json["Qty"],
        productName: json["Product-name"] == null ? null : json["Product-name"],
        shortDescription: json["Short Description"],
        price: json["Price"] == null ? null : json["Price"],
        specialPrice:
            json["Special Price"] == null ? null : json["Special Price"],
        specialPriceFromDate: json["special_price_from_date"],
        specialPriceToDate: json["special_price_to_date"],
        productImage:
            json["Product image"] == null ? null : json["Product image"],
        configurableProductOptions: json["configurable_product_options"] == null
            ? null
            : json["configurable_product_options"],
        earnrate: json["earnrate"]==null?null:json["earnrate"],
        burnrate: json["burnrate"]==null?null:json["burnrate"],
        stock: json["Stock"] == null ? null : json["Stock"],
        pointEarned: json["point_earned"] == null ? null : json["point_earned"],
        brandName: json["brand_name"] == null ? null : json["brand_name"],
        categoryType: json["category_type"] == null ? null : json["category_type"],
        subCategory: json["sub_category"] == null ? null : json["sub_category"],  
      );

  Map<String, dynamic> toJson() => {
        "Wishlist_id": wishlistId == null ? null : wishlistId,
        "productid": productid == null ? null : productid,
        "sku": sku == null ? null : sku,
        "Qty": qty == null ? null : qty,
        "Product-name": productName == null ? null : productName,
        "Short Description": shortDescription,
        "Price": price == null ? null : price,
        "Special Price": specialPrice == null ? null : specialPrice,
        "special_price_from_date": specialPriceFromDate,
        "special_price_to_date": specialPriceToDate,
        "Product image": productImage == null ? null : productImage,
        "configurable_product_options": configurableProductOptions == null
            ? null
            : configurableProductOptions,
        "earnrate": earnrate==null?null:earnrate,
        "burnrate": burnrate==null?null:burnrate,
        "Stock": stock == null ? null : stock,
        "point_earned": pointEarned == null ? null : pointEarned,   
        "brand_name": brandName == null ? null : brandName,
        "category_type": categoryType == null ? null : categoryType,
        "sub_category": subCategory == null ? null : subCategory, 
      };
}

// class ConfigurableProductOptionsNew {
//   ConfigurableProductOptionsNew({
//     this.configDataList,
//     this.configOptions,
//   });

//   List<CongifData> configDataList;
//   List<int> configOptions;

//   factory ConfigurableProductOptionsNew.fromJson(Map<String, dynamic> json) {
//     return ConfigurableProductOptionsNew(
//       configDataList: json["config_options"] == null ||
//               (json["config_options"] as List).isEmpty
//           ? null
//           : List<CongifData>.from(json[json["config_options"][0].toString()]
//               .map((x) => CongifData.fromJson(x))),
//       configOptions: json["config_options"] == null
//           ? null
//           : List<int>.from(json["config_options"].map((x) => x)),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         if ((configOptions ?? []).isNotEmpty)
//           configOptions[0].toString(): configDataList == null
//               ? null
//               : List<dynamic>.from(configDataList.map((x) => x.toJson())),
//         "config_options": configOptions == null
//             ? null
//             : List<dynamic>.from(configOptions.map((x) => x)),
//       };
// }

// class The160 {
//   The160({
//     this.childId,
//     this.productId,
//     this.price,
//     this.specialPrice,
//     this.optionValue,
//     this.label,
//     this.specialPriceFromDate,
//     this.specialPriceToDate,
//     this.optionLabel,
//   });

//   String childId;
//   String productId;
//   String price;
//   String specialPrice;
//   String optionValue;
//   String label;
//   dynamic specialPriceFromDate;
//   dynamic specialPriceToDate;
//   String optionLabel;

//   factory The160.fromJson(Map<String, dynamic> json) => The160(
//         childId: json["child_id"] == null ? null : json["child_id"],
//         productId: json["product_id"] == null ? null : json["product_id"],
//         price: json["price"] == null ? null : json["price"],
//         specialPrice:
//             json["special_price"] == null ? null : json["special_price"],
//         optionValue: json["option_value"] == null ? null : json["option_value"],
//         label: json["label"] == null ? null : json["label"],
//         specialPriceFromDate: json["special_price_from_date"],
//         specialPriceToDate: json["special_price_to_date"],
//         optionLabel: json["option_label"] == null ? null : json["option_label"],
//       );

//   Map<String, dynamic> toJson() => {
//         "child_id": childId == null ? null : childId,
//         "product_id": productId == null ? null : productId,
//         "price": price == null ? null : price,
//         "special_price": specialPrice == null ? null : specialPrice,
//         "option_value": optionValue == null ? null : optionValue,
//         "label": label == null ? null : label,
//         "special_price_from_date": specialPriceFromDate,
//         "special_price_to_date": specialPriceToDate,
//         "option_label": optionLabel == null ? null : optionLabel,
//       };
// }
