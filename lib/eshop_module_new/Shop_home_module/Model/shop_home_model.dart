import 'dart:convert';

import 'package:gems_revamp/eshop_module_new/product_detail/model/product_detail_model.dart';
import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_list_model.dart';

ShopHomeModel shopHomePageModelFromJson(String str) =>
    ShopHomeModel.fromJson(json.decode(str));

String shopHomePageModelToJson(ShopHomeModel data) =>
    json.encode(data.toJson());

class ShopHomeModel {
  String? success;
  String? message;
  bool? updateResponse;
  List<HomeCategory>? homeCategories;
  List<HomeBannerElement>? homeBanners;
  dynamic featuredProduct;
  HomeBanner1Class? homeBanner1;
  dynamic homeBanner2;
  Bestseller? bestseller;
  HomeBanner1Class? homeBanner3;
  HomeBanner1Class? homeBanner4;
  HomeBanner1Class? homeBanner5;

  ShopHomeModel({
    this.updateResponse,
    this.success,
    this.message,
    this.homeCategories,
    this.homeBanners,
    this.featuredProduct,
    this.homeBanner1,
    this.homeBanner2,
    this.bestseller,
    this.homeBanner3,
    this.homeBanner4,
    this.homeBanner5,
  });
  factory ShopHomeModel.fromJson(Map<String, dynamic> json) => ShopHomeModel(
        updateResponse:
            json["updateResponse"] == null ? null : json["updateResponse"],
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        homeCategories: json["home_categories"] != null
            ? List<HomeCategory>.from(
                json["home_categories"].map((x) => HomeCategory.fromJson(x)))
            : null,
        bestseller: json["bestseller"] == null
            ? null
            : Bestseller.fromJson(json["bestseller"]),
        featuredProduct:
            json["featured_product"] == null ? null : json["featured_product"],
        homeBanner1: json["home_banner1"] == null
            ? null
            : HomeBanner1Class.fromJson(json["home_banner1"]),
        homeBanner2: json["home_banner2"] == null
            ? null
            : HomeBanner1Class.fromJson(json["home_banner2"]),
        homeBanner3: json["home_banner3"] == null
            ? null
            : HomeBanner1Class.fromJson(json["home_banner3"]),
        homeBanner4: json["home_banner4"] == null
            ? null
            : HomeBanner1Class.fromJson(json["home_banner4"]),
        homeBanner5: json["home_banner5"] == null
            ? null
            : HomeBanner1Class.fromJson(json["home_banner5"]),
        homeBanners: json["home_banners"] != null
            ? List<HomeBannerElement>.from(
                json["home_banners"].map((x) => HomeBannerElement.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "updateResponse": updateResponse == null ? null : updateResponse,
        "success": success,
        "message": message,
        "home_categories": this.homeCategories?.map((v) => v.toJson()).toList(),
        "home_banners": this.homeBanners?.map((v) => v.toJson()).toList(),
        "home_banner1": homeBanner1?.toJson(),
        "home_banner2": homeBanner2,
        "bestseller": bestseller?.toJson(),
        "home_banner3": homeBanner3?.toJson(),
        "home_banner4": homeBanner4?.toJson(),
        "home_banner5": homeBanner5?.toJson(),
      };
}

class Bestseller {
  String? id;
  String? title;
  List<Item>? items;

  Bestseller({
    this.id,
    this.title,
    this.items,
  });
  factory Bestseller.fromJson(Map<String, dynamic> json) => Bestseller(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        items: json["items"] == null || (json["items"] as List).isEmpty
            ? null
            : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "items": List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Item {
  bool? dbIsWishList;
  String? id;
  String? name;
  String? sku;
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
  dynamic specialPriceToDate;
  dynamic imageurl;
  dynamic tierPrices;
  ExtensionAttributes? extensionAttributes;
  List<dynamic>? options;
  CustomAttributes? customAttributes;
  var configurableProductOptions;
  List<MediaGalleryImages>? mediaGalleryImages;
  Map<String, dynamic>? additionalAttributes;
  String? earnrate;
  String? burnrate;
  String? minipointrequired;
  String? pointEarned;
  bool? edvproduct;
  String? stock;
  String? soldby;
  String? categoryType;
  String? subCategory;

  // List<ConfigurableProductOption> configurableProductOptions;

  Item(
      {this.id,
      this.dbIsWishList,
      this.name,
      this.sku,
      this.attributeSetId,
      this.price,
      this.currencySymbol,
      this.status,
      this.visibility,
      this.type,
      this.position,
      this.createdAt,
      this.earnrate,
      this.burnrate,
      this.minipointrequired,
      this.pointEarned,
      this.updatedAt,
      this.weight,
      this.specialPrice,
      this.specialPriceFromDate,
      this.specialPriceToDate,
      this.imageurl,
      this.tierPrices,
      this.extensionAttributes,
      this.options,
      this.customAttributes,
      this.configurableProductOptions,
      this.mediaGalleryImages,
      this.additionalAttributes,
      this.edvproduct,
      this.stock,
      this.soldby,
      this.categoryType,
      this.subCategory,});
  factory Item.fromJson(Map<String, dynamic> json) => Item(
      id: json["id"] == null ? null : json["id"],
      dbIsWishList: false,
      name: json["name"] == null ? null : json['name'],
      sku: json["sku"] == null ? null : json['sku'],
      edvproduct: json["edvproduct"] == null ? null : json['edvproduct'],
      attributeSetId:
          json["attribute_set_id"] == null ? null : json['attribute_set_id'],
      price: json["price"] == null ? null : json['price'],
      currencySymbol:
          json["currency_symbol"] == null ? null : json['currency_symbol'],
      status: json["status"] == null ? null : json['status'],
      visibility: json["visibility"] == null ? null : json['visibility'],
      type: json["type"] == null ? null : json['type'],
      position: json["position"] == null ? null : json['position'],
      createdAt: json["created_at"] == null ? null : json['created_at'],
      updatedAt: json["updated_at"] == null ? null : json['updated_at'],
      weight: json["weight"] == null ? null : json['weight'],
      specialPrice:
          json["special_price"] == null ? null : json['special_price'],
      specialPriceFromDate: json["special_price_from_date"] == null
          ? null
          : json['special_price_from_date'],
      specialPriceToDate: json["special_price_to_date"] == null
          ? null
          : json['special_price_to_date'],
      imageurl: json["imageurl"] == null || json["imageurl"] == false
          ? null
          : json['imageurl'],
      tierPrices: json["tier_prices"] == null ? null : json['tier_prices'],
      extensionAttributes: json['extension_attributes'] != null
          ? ExtensionAttributes.fromJson(json['extension_attributes'])
          : null,
      customAttributes: json['custom_attributes'] != null
          ? CustomAttributes.fromJson(json['custom_attributes'])
          : null,
      configurableProductOptions: json['configurable_product_options'] != null
          ? json['configurable_product_options']
          : null,
      options: json['options'] != null ? json['options'].cast<String>() : null,
      mediaGalleryImages: json["media_gallery_images"] == null
          ? null
          : List<MediaGalleryImages>.from(json["media_gallery_images"]
              .map((x) => MediaGalleryImages.fromJson(x))),
      earnrate: json["earnrate"] == null ? null : json["earnrate"],
      burnrate: json["burnrate"] == null ? null : json["burnrate"],
      minipointrequired:
          json["minipointrequired"] == null ? null : json["minipointrequired"],
      pointEarned: json["point_earned"] == null ? null : json["point_earned"],
      stock: json["Stock"] == null ? null : json["Stock"],
      soldby: json["soldby"] == null ? null : json["soldby"],
      categoryType: json["category_type"] == null ? null : json["category_type"],
      subCategory: json["sub_category"] == null ? null : json["sub_category"],
      additionalAttributes: json["additional_attributes"] == null
          ? null
          : Map.from(json["additional_attributes"]));
  Map<String, dynamic> toJson() => {
        "id": id,
        "dbIsWishList": dbIsWishList,
        "name": name,
        "sku": sku,
        "type": type,
        "attribute_set_id": attributeSetId,
        "price": price,
        "currency_symbol": currencySymbol,
        "status": status,
        "visibility": visibility,
        "edvproduct": edvproduct,
        "position": position,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "weight": weight,
        "special_price": specialPrice,
        "special_price_from_date": specialPriceFromDate,
        "special_price_to_date": specialPriceToDate,
        "imageurl": imageurl,
        "tier_prices": tierPrices,
        "extension_attributes": extensionAttributes?.toJson(),
        "options": List<dynamic>.from(options!.map((x) => x)),
        "media_gallery_images":
            List<dynamic>.from(mediaGalleryImages!.map((x) => x.toJson())),
        "custom_attributes": customAttributes!.toJson(),
        "additional_attributes": additionalAttributes,
        "earnrate": earnrate == null ? null : earnrate,
        "burnrate": burnrate == null ? null : burnrate,
        "minipointrequired":
            minipointrequired == null ? null : minipointrequired,
        "point_earned": pointEarned == null ? null : pointEarned,
        "Stock": stock == null ? null : stock,
        "soldby": soldby == null ? null : soldby,
        "category_type": categoryType == null ? null : categoryType,
        "sub_category": subCategory == null ? null : subCategory,
        "configurable_product_options": configurableProductOptions,
      };
  ProductDetails get productData => ProductDetails(
      item: ProductData(
          id: id,
          name: name,
          sku: sku,
          iswishlist: dbIsWishList,
          attributeSetId: attributeSetId,
          price: price,
          currencySymbol: currencySymbol,
          status: status ?? '',
          edvproduct: edvproduct,
          type: type,
          position: position,
          weight: weight,
          specialPrice: specialPrice,
          imageurl: imageurl,
          mediaGalleryImages: mediaGalleryImages,
          // swatchGalleryImages: swatchGalleryImages,
          customAttributes: customAttributes,
          // colorConfigGalleryImages: colorConfigGalleryImages,
          // socialShare: socialShare,
          soldby: soldby,
          stock: stock,
          additionalAttributes: additionalAttributes,
          configurableProductOptions: configurableProductOptions,
          categoryType: categoryType,
          subCategory: subCategory
          ));
}

// class MediaGalleryImage {
//   MediaGalleryImage({
//     this.valueId,
//     this.mediaType,
//     this.entityId,
//     this.position,
//     this.label,
//     this.videoUrl,
//     this.videoTitle,
//     this.url,
//   });

//   String valueId;
//   String mediaType;
//   String entityId;
//   String position;
//   String label;
//   dynamic videoUrl;
//   dynamic videoTitle;
//   String url;

//   factory MediaGalleryImage.fromJson(Map<String, dynamic> json) =>
//       MediaGalleryImage(
//         valueId: json["value_id"],
//         mediaType: json["media_type"],
//         entityId: json["entity_id"],
//         position: json["position"],
//         label: json["label"],
//         videoUrl: json["video_url"],
//         videoTitle: json["video_title"],
//         url: json["url"],
//       );

//   Map<String, dynamic> toJson() => {
//         "value_id": valueId,
//         "media_type": mediaType,
//         "entity_id": entityId,
//         "position": position,
//         "label": label,
//         "video_url": videoUrl,
//         "video_title": videoTitle,
//         "url": url,
//       };
// }

class ConfigurableProductOption {
  ConfigurableProductOption({
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

  factory ConfigurableProductOption.fromJson(Map<String, dynamic> json) =>
      ConfigurableProductOption(
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

// class CustomAttributes {
//   String description;
//   String shortDescription;
//   List<String> categoryIds;

//   CustomAttributes({
//     this.description,
//     this.shortDescription,
//     this.categoryIds,
//   });
//   factory CustomAttributes.fromJson(Map<String, dynamic> json) =>
//       CustomAttributes(
//         description: json["description"] == null ? null : json["description"],
//         shortDescription: json["short_description"] == null
//             ? null
//             : json["short_description"],
//         categoryIds: json["category_ids"] == null
//             ? null
//             : json['category_ids'].cast<String>(),
//       );
//   Map<String, dynamic> toJson() => {
//         "description": description,
//         "short_description": shortDescription,
//         "category_ids": List<dynamic>.from(categoryIds.map((x) => x)),
//       };
// }

class ExtensionAttributes {
  List<String>? websiteIds;

  ExtensionAttributes({
    this.websiteIds,
  });
  factory ExtensionAttributes.fromJson(Map<String, dynamic> json) =>
      ExtensionAttributes(
        websiteIds: json["website_ids"] == null
            ? null
            : json['website_ids'].cast<String>(),
      );
  Map<String, dynamic> toJson() => {
        "website_ids": List<dynamic>.from(websiteIds!.map((x) => x)),
      };
}

class HomeBanner1Class {
  String? id;
  String? title;
  String? image;

  HomeBanner1Class({
    this.id,
    this.title,
    this.image,
  });
  factory HomeBanner1Class.fromJson(Map<String, dynamic> json) =>
      HomeBanner1Class(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        image: json["image"] == null ? null : json["image"],
      );
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
      };
}

class HomeBannerElement {
  String? name;
  String? image;
  String? type;
  String? typeid;
  String? position;

  HomeBannerElement({
    this.name,
    this.image,
    this.type,
    this.typeid,
    this.position,
  });
  factory HomeBannerElement.fromJson(Map<String, dynamic> json) =>
      HomeBannerElement(
        name: json["name"] == null ? null : json["name"],
        image: json["image"] == null ? null : json["image"],
        type: json["type"] == null ? null : json["type"],
        typeid: json["typeid"] == null ? null : json["typeid"],
        position: json["position"] == null ? null : json["position"],
      );
  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "type": type,
        "typeid": typeid,
        "position": position,
      };
}

class HomeCategory {
  String? id;
  String? name;
  dynamic imageurl;
  String? thumbnail;
  // dynamic description;
  String? position;

  HomeCategory({
    this.id,
    this.name,
    this.imageurl,
    this.thumbnail,
    // this.description,
    this.position,
  });
  factory HomeCategory.fromJson(Map<String, dynamic> json) => HomeCategory(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        imageurl: json["imageurl"] == null || json["imageurl"] == false
            ? null
            : json["imageurl"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
        // description: json["description"] == null ? null : json["description"],
        position: json["position"] == null ? null : json["position"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageurl": imageurl,
        "thumbnail": thumbnail,
        // "description": description,
        "position": position,
      };
}

class ConfigurableProductOptions {
  ConfigurableProductOptions({
    this.configDataList,
    this.configOptions,
  });

  List<ConfigData>? configDataList;
  List<int>? configOptions;

  factory ConfigurableProductOptions.fromJson(Map<String, dynamic> json) {
    return ConfigurableProductOptions(
      configDataList: json["config_options"] == null ||
              (json["config_options"] as List).isEmpty
          ? null
          : List<ConfigData>.from(json[json["config_options"][0].toString()]
              .map((x) => ConfigData.fromJson(x))),
      configOptions: json["config_options"] == null
          ? null
          : List<int>.from(json["config_options"].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        if ((configOptions ?? []).isNotEmpty)
          configOptions![0].toString(): configDataList == null
              ? null
              : List<dynamic>.from(configDataList!.map((x) => x.toJson())),
        "config_options": configOptions == null
            ? null
            : List<dynamic>.from(configOptions!.map((x) => x)),
      };
}

class ConfigData {
  ConfigData({
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

  factory ConfigData.fromJson(Map<String, dynamic> json) => ConfigData(
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
