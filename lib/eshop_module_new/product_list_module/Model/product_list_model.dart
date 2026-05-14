import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_filter_model.dart';
import 'package:gems_revamp/eshop_module_new/product_detail/model/product_detail_model.dart';

class ProductListModel {
  String? success;
  String? message;
  List<ProductItem>? items;
  String? catImage;
  String? catName;
  dynamic catDescription;
  List<CatChild>? catChild;
  int? totalCount;
  List<Filtercollection>? filtercollection;
  Product? productShippingInformation;
  Product? productReturnStoreCredit;

  ProductListModel({
    this.success,
    this.message,
    this.items,
    this.catImage,
    this.catName,
    this.catDescription,
    this.totalCount,
    this.filtercollection,
    this.catChild,
    this.productShippingInformation,
    this.productReturnStoreCredit,
  });
  factory ProductListModel.fromJson(Map<String, dynamic> json) {
    return ProductListModel(
      success: json['success'] != null ? json['success'] : null,
      totalCount: json['total_count'] != null ? json['total_count'] : 0,
      catImage: json['cat_image'] != null ||
              json['cat_image'] != false ||
              json['cat_image'] != ''
          ? json['cat_image']
          : null,
      catName: json['cat_name'] != null ? json['cat_name'] : null,
      catDescription:
          json['cat_description'] != null ? json['cat_description'] : null,
      message: json['message'] != null ? json['message'] : null,
      items: json['items'] != null || json['items'] != ""
          ? List<ProductItem>.from(
              json["items"].map((x) => ProductItem.fromJson(x)))
          : [],
      filtercollection: json['Filtercollection'] != null
          ? List<Filtercollection>.from(
              json["Filtercollection"].map((x) => Filtercollection.fromJson(x)))
          : null,
      catChild: json['cat_child'] != null
          ? List<CatChild>.from(
              json["cat_child"].map((x) => CatChild.fromJson(x)))
          : null,
      productShippingInformation: json["product_shipping_information"] == null
          ? null
          : Product.fromJson(json["product_shipping_information"]),
      productReturnStoreCredit: json["product_return_store_credit"] == null
          ? null
          : Product.fromJson(json["product_return_store_credit"]),
    );
  }
}

class CatChild {
  String? id;
  String? name;
  bool? status;

  CatChild({this.id, this.name, this.status});

  CatChild.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'] : null;
    name = json['name'] != null ? json['name'] : null;
    status = json['status'] != null ? json['status'] : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}

class ProductItem {
  bool? isSwatchesViewMore;
  bool? dbIsWishList;
  String? id;
  String? name;
  String? sku;
  bool? iswishlist;
  String? attributeSetId;
  String? price;
  String? currencySymbol;
  String? status;
  String? visibility;
  String? type;
  String? position;
  String? createdAt;
  String? updatedAt;
  String? weight;
  String? specialPrice;
  String? specialPriceFromDate;
  String? specialPriceToDate;
  String? imageurl;
  String? tierPrices;
  String? socialShare;
  ExtensionAttributes? extensionAttributes;
  List<MediaGalleryImages>? mediaGalleryImages;
  List<SwatchGalleryImages>? swatchGalleryImages;
  Icon? viewMore;
  Map<String, dynamic>? additionalAttributes;
  List<ColorConfigGalleryImages>? colorConfigGalleryImages;
  CustomAttributes? customAttributes;
  var configurableProductOptions;
  String? earnrate;
  String? burnrate;
  String? minipointrequired;
  var pointEarned;
  bool? edvproduct;
  String? soldby;
  String? stock;
  String? categoryType;
  String? subCategory;

  var configurableProductOptionsNew;

  ProductItem(
      {this.isSwatchesViewMore,
      this.dbIsWishList,
      this.viewMore,
      this.id,
      this.name,
      this.sku,
      this.iswishlist,
      this.attributeSetId,
      this.price,
      this.currencySymbol,
      this.status,
      this.visibility,
      this.type,
      this.position,
      this.createdAt,
      this.updatedAt,
      this.weight,
      this.specialPrice,
      this.edvproduct,
      this.specialPriceFromDate,
      this.specialPriceToDate,
      this.imageurl,
      this.tierPrices,
      this.extensionAttributes,
      this.customAttributes,
      this.socialShare,
      this.configurableProductOptions,
      this.colorConfigGalleryImages,
      this.configurableProductOptionsNew,
      this.mediaGalleryImages,
      this.swatchGalleryImages,
      this.earnrate,
      this.burnrate,
      this.minipointrequired,
      this.pointEarned,
      this.additionalAttributes,
      this.soldby,
      this.stock,
      this.categoryType,
      this.subCategory,});
  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
        dbIsWishList:
            json["dbIsWishList"] == null ? false : json["dbIsWishList"],
        isSwatchesViewMore: false,
        id: json['id'] != null ? json['id'] : null,
        name: json['name'] != null ? json['name'] : null,
        sku: json['sku'] != null ? json['sku'] : null,
        iswishlist: json["iswishlist"] == null ? null : json["iswishlist"],
        attributeSetId:
            json['attribute_set_id'] != null ? json['attribute_set_id'] : null,
        price: json['price'] != null ? json['price'] : null,
        edvproduct: json['edvproduct'] != null ? json['edvproduct'] : null,
        currencySymbol:
            json['currency_symbol'] != null ? json['currency_symbol'] : null,
        status: json['status'] != null ? json['status'] : null,
        visibility: json['visibility'] != null ? json['visibility'] : null,
        type: json['type'] != null ? json['type'] : null,
        position: json['position'] != null ? json['position'] : null,
        createdAt: json['created_at'] != null ? json['created_at'] : null,
        updatedAt: json['updated_at'] != null ? json['updated_at'] : null,
        weight: json['weight'] != null ? json['weight'] : null,
        specialPrice:
            json['special_price'] != null ? json['special_price'] : null,
        specialPriceFromDate: json['special_price_from_date'] != null
            ? json['special_price_from_date']
            : null,
        specialPriceToDate: json['special_price_to_date'] != null
            ? json['special_price_to_date']
            : null,
        imageurl: json['imageurl'] != null ? json['imageurl'] : null,
        tierPrices: json['tier_prices'] != null ? json['tier_prices'] : null,
        customAttributes: json['custom_attributes'] != null
            ? CustomAttributes.fromJson(json['custom_attributes'])
            : null,
        configurableProductOptions: json['configurable_product_options'] != null
            ? json["configurable_product_options"]
            : null,
        colorConfigGalleryImages: json['color_config_gallery_images'] != null
            ? List<ColorConfigGalleryImages>.from(
                json["color_config_gallery_images"]
                    .map((x) => ColorConfigGalleryImages.fromJson(x)))
            : null,
        extensionAttributes: json['extension_attributes'] != null
            ? ExtensionAttributes.fromJson(json['extension_attributes'])
            : null,
        configurableProductOptionsNew:
            json["configurable_product_options_new"] == null
                ? null
                : json["configurable_product_options_new"],
        mediaGalleryImages: json['media_gallery_images'] != null
            ? List<MediaGalleryImages>.from(json["media_gallery_images"]
                .map((x) => MediaGalleryImages.fromJson(x)))
            : null,
        swatchGalleryImages: json['swatch_gallery_images'] != null
            ? List<SwatchGalleryImages>.from(
                json["swatch_gallery_images"].map((x) => SwatchGalleryImages.fromJson(x)))
            : null,
        socialShare: json["social_share"] == null ? null : json["social_share"],
        earnrate: json["earnrate"] == null ? null : json["earnrate"],
        burnrate: json["burnrate"] == null ? null : json["burnrate"],
        minipointrequired: json["minipointrequired"] == null ? null : json["minipointrequired"],
        pointEarned: json["point_earned"] == null ? null : json["point_earned"],
        soldby: json["soldby"] == null ? null : json["soldby"],
        stock: json["Stock"] == null ? null : json["Stock"],
        categoryType: json["category_type"] == null ? null : json["category_type"],
        subCategory: json["sub_category"] == null ? null : json["sub_category"],
        additionalAttributes: json["additional_attributes"] == null ? null : Map.from(json["additional_attributes"]));
  }

  ProductDetails get productData => ProductDetails(
      item: ProductData(
          id: id,
          name: name,
          sku: sku,
          iswishlist: iswishlist,
          attributeSetId: attributeSetId,
          price: price,
          currencySymbol: currencySymbol,
          status: status ?? '',
          type: type,
          edvproduct: edvproduct,
          position: position,
          weight: weight,
          specialPrice: specialPrice,
          imageurl: imageurl,
          mediaGalleryImages: mediaGalleryImages,
          swatchGalleryImages: swatchGalleryImages,
          customAttributes: customAttributes,
          configurableProductOptionsNew: configurableProductOptionsNew,
          colorConfigGalleryImages: colorConfigGalleryImages,
          socialShare: socialShare,
          soldby: soldby,
          stock: stock,
          categoryType: categoryType,
          subCategory: subCategory,
          configurableProductOptions: configurableProductOptions,
          additionalAttributes: additionalAttributes));
}

class ConfigurableProductOptions {
  ConfigurableProductOptions({
    this.attributeId,
    this.optionlabel,
    this.label,
    this.optionvalue,
    this.productId,
  });

  int? attributeId;
  String? optionlabel;
  String? label;
  String? optionvalue;
  String? productId;

  factory ConfigurableProductOptions.fromJson(Map<String, dynamic> json) =>
      ConfigurableProductOptions(
        attributeId: json["attribute_id"] == null ? null : json["attribute_id"],
        optionlabel: json["optionlabel"] == null ? null : json["optionlabel"],
        label: json["label"] == null ? null : json["label"],
        optionvalue: json["optionvalue"] == null ? null : json["optionvalue"],
        productId: json["product_id"] == null ? null : json["product_id"],
      );

  Map<String, dynamic> toJson() => {
        "attribute_id": attributeId == null ? null : attributeId,
        "optionlabel": optionlabel == null ? null : optionlabel,
        "label": label == null ? null : label,
        "optionvalue": optionvalue == null ? null : optionvalue,
        "product_id": productId == null ? null : productId,
      };
}

class Product {
  Product({
    this.title,
    this.content,
  });

  String? title;
  String? content;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        title: json["title"] == null ? null : json["title"],
        content: json["content"] == null ? null : json["content"],
      );

  Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "content": content == null ? null : content,
      };
}

// class ConfigurableProductOptionsNew {
//   ConfigurableProductOptionsNew({
//     this.configDataList,
//     this.configOptions,
//   });

//   List<CongifData>? configDataList;
//   List<int>? configOptions;

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
//           configOptions![0].toString(): configDataList == null
//               ? null
//               : List<dynamic>.from(configDataList!.map((x) => x.toJson())),
//         "config_options": configOptions == null
//             ? null
//             : List<dynamic>.from(configOptions!.map((x) => x)),
//       };
// }

class CongifData {
  CongifData({
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
  DateTime? specialPriceFromDate;
  dynamic specialPriceToDate;
  String? optionLabel;

  factory CongifData.fromJson(Map<String, dynamic> json) => CongifData(
        childId: json["child_id"] == null ? null : json["child_id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        price: json["price"] == null ? null : json["price"],
        specialPrice:
            json["special_price"] == null ? null : json["special_price"],
        optionValue: json["option_value"] == null ? null : json["option_value"],
        label: json["label"] == null ? null : json["label"],
        specialPriceFromDate: json["special_price_from_date"] == null
            ? null
            : DateTime.parse(json["special_price_from_date"]),
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
        "special_price_from_date": specialPriceFromDate == null
            ? null
            : specialPriceFromDate?.toIso8601String(),
        "special_price_to_date": specialPriceToDate,
        "option_label": optionLabel == null ? null : optionLabel,
      };
}

class CustomAttributes {
  String? description;
  dynamic shortDescription;
  List<String>? categoryIds;

  CustomAttributes({
    this.description,
    this.shortDescription,
    this.categoryIds,
  });
  factory CustomAttributes.fromJson(Map<String, dynamic> json) {
    return CustomAttributes(
        description: json['description'] != null ? json['description'] : null,
        shortDescription: json['short_description'] != null
            ? json['short_description']
            : null,
        categoryIds: json['category_ids'].cast<String>());
  }
  Map<String, dynamic> toJson() => {
        "description": description == null ? null : description,
        "short_description": shortDescription,
        "category_ids": categoryIds == null
            ? null
            : List<dynamic>.from(categoryIds!.map((x) => x)),
      };
}

class ExtensionAttributes {
  List<String>? websiteIds;

  ExtensionAttributes({
    this.websiteIds,
  });
  factory ExtensionAttributes.fromJson(Map<String, dynamic> json) {
    return ExtensionAttributes(websiteIds: json['website_ids'].cast<String>());
  }
}

class MediaGalleryImages {
  String? valueId;
  String? mediaType;
  String? entityId;
  String? position;
  String? label;
  String? videoUrl;
  String? videoTitle;
  String? url;
  String? colorimageUrls;

  MediaGalleryImages(
      {this.valueId,
      this.mediaType,
      this.entityId,
      this.position,
      this.label,
      this.videoUrl,
      this.videoTitle,
      this.url,
      this.colorimageUrls});

  MediaGalleryImages.fromJson(Map<String, dynamic> json) {
    valueId = json['value_id'] != null ? json['value_id'] : null;
    mediaType = json['media_type'] != null ? json['media_type'] : null;
    entityId = json['entity_id'] != null ? json['entity_id'] : null;
    position = json['position'] != null ? json['position'] : null;
    label = json['label'] != null ? json['label'] : null;
    videoUrl = json['video_url'] != null ? json['video_url'] : null;
    videoTitle = json['video_title'] != null ? json['video_title'] : null;
    url = json['url'] != null ? json['url'] : null;
    colorimageUrls = "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value_id'] = this.valueId;
    data['media_type'] = this.mediaType;
    data['entity_id'] = this.entityId;
    data['position'] = this.position;
    data['label'] = this.label;
    data['video_url'] = this.videoUrl;
    data['video_title'] = this.videoTitle;
    data['url'] = this.url;
    return data;
  }
}

class SwatchGalleryImages {
  bool? isSelected;
  String? entityId;
  String? sku;
  String? swatchurl;

  SwatchGalleryImages(
      {this.isSelected, this.entityId, this.sku, this.swatchurl});

  SwatchGalleryImages.fromJson(Map<String, dynamic> json) {
    isSelected = false;
    entityId = json['entity_id'] != null ? json['entity_id'] : null;
    sku = json['sku'] != null ? json['sku'] : null;
    swatchurl = json['swatchurl'] != null ? json['swatchurl'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entity_id'] = this.entityId;
    data['sku'] = this.sku;
    data['swatchurl'] = this.swatchurl;
    return data;
  }
}

class ColorConfigGalleryImages {
  String? valueId;
  String? mediaType;
  String? entityId;
  String? position;
  String? label;
  String? videoUrl;
  String? videoTitle;
  String? url;
  String? productId;
  String? sku;

  ColorConfigGalleryImages({
    this.valueId,
    this.mediaType,
    this.entityId,
    this.position,
    this.label,
    this.videoUrl,
    this.videoTitle,
    this.url,
    this.productId,
    this.sku,
  });

  ColorConfigGalleryImages.fromJson(Map<String, dynamic> json) {
    valueId = json['value_id'] != null ? json['value_id'] : null;
    mediaType = json['media_type'] != null ? json['media_type'] : null;
    entityId = json['entity_id'] != null ? json['entity_id'] : null;
    position = json['position'] != null ? json['position'] : null;
    label = json['label'] != null ? json['label'] : null;
    videoUrl = json['video_url'] != null ? json['video_url'] : null;
    videoTitle = json['video_title'] != null ? json['video_title'] : null;
    url = json['url'] != null ? json['url'] : null;
    sku = json['sku'] != null ? json['sku'] : null;
    productId = json['product_id'] != null ? json['product_id'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value_id'] = this.valueId;
    data['media_type'] = this.mediaType;
    data['entity_id'] = this.entityId;
    data['position'] = this.position;
    data['label'] = this.label;
    data['video_url'] = this.videoUrl;
    data['video_title'] = this.videoTitle;
    data['url'] = this.url;
    data['product_id'] = this.productId;
    data['sku'] = this.sku;
    return data;
  }
}

class ConfigImages {
  var productId;
  var colorImageUrl;
  ConfigImages({this.productId, this.colorImageUrl});
}

/* Add to WishList Model */
class AddToWishListModel {
  bool? updateResponse;
  String? success;
  String? message;

  AddToWishListModel({
    this.updateResponse,
    this.success,
    this.message,
  });
  factory AddToWishListModel.fromJson(Map<String, dynamic> json) {
    return AddToWishListModel(
      updateResponse:
          json['updateResponse'] != null ? json['updateResponse'] : null,
      success: json['success'] != null ? json['success'] : null,
      message:
          json['message'] != null ? json['message'] : "Something went Wrong",
    );
  }
}

List<AutoSuggestModel> autoSuggestModelFromJson(String str) =>
    List<AutoSuggestModel>.from(
        json.decode(str).map((x) => AutoSuggestModel.fromJson(x)));

String autoSuggestModelToJson(List<AutoSuggestModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AutoSuggestModel {
  AutoSuggestModel({
    this.success,
    this.message,
    this.items,
  });

  String? success;
  String? message;
  List<Itemsss>? items;
  

  factory AutoSuggestModel.fromJson(Map<String, dynamic> json) =>
      AutoSuggestModel(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        items: json["items"] == null || json["status"] == false
            ? null
            : List<Itemsss>.from(json["items"].map((x) => Itemsss.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "items": items == null
            ? null
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Itemsss {
  Itemsss({
    this.title,
    this.count,
  });

  String? title;
  int? count;

  factory Itemsss.fromJson(Map<String, dynamic> json) => Itemsss(
        title: json["title"] == null ? null : json["title"],
        count: json["count"] == null ? null : json["count"],
      );

  Map<String, dynamic> toJson() => {
        "title": title == null ? null : title,
        "count": count == null ? null : count,
      };
}
