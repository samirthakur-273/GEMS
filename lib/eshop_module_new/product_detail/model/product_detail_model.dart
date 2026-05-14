import 'dart:convert';

import 'package:gems_revamp/eshop_module_new/product_list_module/Model/product_list_model.dart';

List<ProductDetails> productDetailsFromJson(String str) =>
    List<ProductDetails>.from(
        json.decode(str).map((x) => ProductDetails.fromJson(x)));

String productDetailsToJson(List<ProductDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductDetails {
  ProductDetails({
    this.success,
    this.message,
    this.item,
  });

  String? success;
  String? message;
  ProductData? item;

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        item: json["item"] == null ? null : ProductData.fromJson(json["item"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "item": item == null ? null : item!.toJson(),
      };
}

class ProductData {
  ProductData({
    required this.id,
    required this.name,
    required this.sku,
    required this.iswishlist,
    this.attributeSetId,
    required this.price,
    required this.currencySymbol,
    required this.status,
    this.deliveryStatus,
    this.deliveryMessage,
    this.visibility,
    this.type,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.metaTitle,
    this.metaKeyword,
    this.metaDescription,
    this.weight,
    this.specialPrice,
    this.specialPriceFromDate,
    this.specialPriceToDate,
    this.imageurl,
    this.tierPrices,
    this.extensionAttributes,
    this.options,
    this.relatedProducts,
    this.recommendedTitle,
    this.recommendedProducts,
    this.mediaGalleryImages,
    this.swatchGalleryImages,
    this.colorConfigGalleryImages,
    this.customAttributes,
    this.additionalAttributes,
    this.configurableProductOptions,
    this.customerServiceBlock,
    this.productShippingInformation,
    this.productReturnStoreCredit,
    this.socialShare,
    this.earnrate,
    this.burnrate,
    this.minipointrequired,
    this.pointEarned,
    this.edvproduct,
    this.soldby,
    this.configurableProductOptionsNew,
    this.categoryType,
    this.subCategory,
    this.stock,
  });

  String? id;
  String? name;
  String? sku;
  bool? iswishlist;
  String? attributeSetId;
  String? price;
  String? currencySymbol;
  String status;
  String? deliveryStatus;
  String? deliveryMessage;
  String? visibility;
  String? type;
  dynamic position;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic metaTitle;
  dynamic metaKeyword;
  dynamic metaDescription;
  String? weight;
  String? specialPrice;
  dynamic specialPriceFromDate;
  dynamic specialPriceToDate;
  String? imageurl;
  dynamic tierPrices;
  ExtensionAttributes? extensionAttributes;
  List<dynamic>? options;
  dynamic relatedProducts;
  String? recommendedTitle;
  List<RecommendedProduct>? recommendedProducts;
  List<MediaGalleryImages>? mediaGalleryImages;
  List<SwatchGalleryImages>? swatchGalleryImages;
  List<ColorConfigGalleryImages>? colorConfigGalleryImages;
  CustomAttributes? customAttributes;
  Map<String, dynamic>? additionalAttributes;
  var configurableProductOptions;
  Product? customerServiceBlock;
  Product? productShippingInformation;
  Product? productReturnStoreCredit;
  String? socialShare;
  String? earnrate;
  String? burnrate;
  String? minipointrequired;
  String? pointEarned;
  bool? edvproduct;
  String? soldby;
  var configurableProductOptionsNew;
  String? categoryType;
  String? subCategory; 
  String? stock;

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        sku: json["sku"] == null ? null : json["sku"],
        edvproduct: json['edvproduct'] == null ? null : json['edvproduct'],
        iswishlist: json["iswishlist"] == null ? null : json["iswishlist"],
        attributeSetId:
            json["attribute_set_id"] == null ? null : json["attribute_set_id"],
        price: json["price"] == null ? null : json["price"],
        currencySymbol:
            json["currency_symbol"] == null ? null : json["currency_symbol"],
        status: json["status"] == null ? null : json["status"],
        deliveryStatus:
            json["delivery_status"] == null ? null : json["delivery_status"],
        deliveryMessage:
            json["delivery_message"] == null ? null : json["delivery_message"],
        visibility: json["visibility"] == null ? null : json["visibility"],
        type: json["type"] == null ? null : json["type"],
        position: json["position"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        metaTitle: json["meta_title"],
        metaKeyword: json["meta_keyword"],
        metaDescription: json["meta_description"],
        weight: json["weight"] == null ? null : json["weight"],
        specialPrice:
            json["special_price"] == null ? null : json["special_price"],
        specialPriceFromDate: json["special_price_from_date"] == null
            ? null
            : json["special_price_from_date"],
        specialPriceToDate: json["special_price_to_date"] == null
            ? null
            : json["special_price_to_date"],
        imageurl: json["imageurl"] == null ? null : json["imageurl"],
        tierPrices: json["tier_prices"],
        extensionAttributes: json["extension_attributes"] == null
            ? null
            : ExtensionAttributes.fromJson(json["extension_attributes"]),
        options: json["options"] == null
            ? null
            : List<dynamic>.from(json["options"].map((x) => x)),
        relatedProducts: json["related_products"],
        recommendedTitle: json["recommended_title"] == null
            ? null
            : json["recommended_title"],
        recommendedProducts: json["recommended_products"] == null
            ? null
            : List<RecommendedProduct>.from(json["recommended_products"]
                .map((x) => RecommendedProduct.fromJson(x))),
        mediaGalleryImages: json["media_gallery_images"] == null
            ? null
            : List<MediaGalleryImages>.from(json["media_gallery_images"]
                .map((x) => MediaGalleryImages.fromJson(x))),
        swatchGalleryImages: json["swatch_gallery_images"] == null
            ? null
            : List<SwatchGalleryImages>.from(json["swatch_gallery_images"]
                .map((x) => SwatchGalleryImages.fromJson(x))),
        colorConfigGalleryImages: json["color_config_gallery_images"] == null
            ? null
            : List<ColorConfigGalleryImages>.from(
                json["color_config_gallery_images"]
                    .map((x) => ColorConfigGalleryImages.fromJson(x))),
        customAttributes: json["custom_attributes"] == null
            ? null
            : CustomAttributes.fromJson(json["custom_attributes"]),
        additionalAttributes: json["additional_attributes"] == null
            ? null
            : Map.from(json["additional_attributes"]),
        configurableProductOptions: json["configurable_product_options"] == null
            ? null
            : json["configurable_product_options"],
        customerServiceBlock: json["customer_service_block"] == null
            ? null
            : Product.fromJson(json["customer_service_block"]),
        productShippingInformation: json["product_shipping_information"] == null
            ? null
            : Product.fromJson(json["product_shipping_information"]),
        productReturnStoreCredit: json["product_return_store_credit"] == null
            ? null
            : Product.fromJson(json["product_return_store_credit"]),
        socialShare: json["social_share"] == null ? null : json["social_share"],
        earnrate: json["earnrate"] == null ? null : json["earnrate"],
        burnrate: json["burnrate"] == null ? null : json["burnrate"],
        minipointrequired: json["minipointrequired"] == null
            ? null
            : json["minipointrequired"],
        pointEarned: json["point_earned"] == null ? null : json["point_earned"],
        stock: json["Stock"] == null ? null : json["Stock"],
        soldby: json["soldby"] == null ? null : json["soldby"],
        configurableProductOptionsNew:
            json["configurable_product_options_new"] == null
                ? null
                : json["configurable_product_options_new"],
        categoryType: json["category_type"] == null ? null : json["category_type"],
        subCategory: json["sub_category"] == null ? null : json["sub_category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "sku": sku == null ? null : sku,
        "iswishlist": iswishlist == null ? null : iswishlist,
        "attribute_set_id": attributeSetId == null ? null : attributeSetId,
        "price": price == null ? null : price,
        "currency_symbol": currencySymbol == null ? null : currencySymbol,
        "status": status == null ? null : status,
        "delivery_status": deliveryStatus == null ? null : deliveryStatus,
        "delivery_message": deliveryMessage == null ? null : deliveryMessage,
        "visibility": visibility == null ? null : visibility,
        "type": type == null ? null : type,
        "position": position,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "meta_title": metaTitle,
        "meta_keyword": metaKeyword,
        "edvproduct": edvproduct == null ? null : edvproduct,
        "meta_description": metaDescription,
        "weight": weight == null ? null : weight,
        "special_price": specialPrice == null ? null : specialPrice,
        "special_price_from_date": specialPriceFromDate,
        "special_price_to_date": specialPriceToDate,
        "imageurl": imageurl == null ? null : imageurl,
        "tier_prices": tierPrices,
        "extension_attributes":
            extensionAttributes == null ? null : extensionAttributes!.toJson(),
        "options":
            options == null ? null : List<dynamic>.from(options!.map((x) => x)),
        "related_products": relatedProducts,
        "recommended_title": recommendedTitle == null ? null : recommendedTitle,
        "recommended_products": recommendedProducts == null
            ? null
            : List<dynamic>.from(recommendedProducts!.map((x) => x.toJson())),
        "media_gallery_images": mediaGalleryImages == null
            ? null
            : List<dynamic>.from(mediaGalleryImages!.map((x) => x.toJson())),
        "swatch_gallery_images": swatchGalleryImages == null
            ? null
            : List<dynamic>.from(swatchGalleryImages!.map((x) => x.toJson())),
        "color_config_gallery_images": colorConfigGalleryImages == null
            ? null
            : List<dynamic>.from(
                colorConfigGalleryImages!.map((x) => x.toJson())),
        "custom_attributes": customAttributes == null ? null : customAttributes,
        "additional_attributes":
            additionalAttributes == null ? null : additionalAttributes,
        "configurable_product_options": configurableProductOptions == null
            ? null
            : configurableProductOptions!.toJson(),
        "customer_service_block": customerServiceBlock == null
            ? null
            : customerServiceBlock!.toJson(),
        "product_shipping_information": productShippingInformation == null
            ? null
            : productShippingInformation!.toJson(),
        "product_return_store_credit": productReturnStoreCredit == null
            ? null
            : productReturnStoreCredit!.toJson(),
        "social_share": socialShare == null ? null : socialShare,
        "earnrate": earnrate == null ? null : earnrate,
        "burnrate": burnrate == null ? null : burnrate,
        "minipointrequired":
            minipointrequired == null ? null : minipointrequired,
        "Stock": stock == null ? null : stock,
        "point_earned": pointEarned == null ? null : pointEarned,
        "soldby": soldby == null ? null : soldby,
        "configurable_product_options_new":
            configurableProductOptionsNew == null
                ? null
                : configurableProductOptionsNew,
        "category_type": categoryType == null ? null : categoryType,
        "sub_category": subCategory == null ? null : subCategory,
      };
}

class AdditionalAttributes {
  AdditionalAttributes({
    this.brand,
    this.gender,
    this.colorConfig,
    this.sizeGuide,
  });

  String? brand;
  String? gender;
  String? colorConfig;
  String? sizeGuide;

  factory AdditionalAttributes.fromJson(Map<String, dynamic> json) =>
      AdditionalAttributes(
        brand: json["Brand"] == null ? null : json["Brand"],
        gender: json["Gender"] == null ? null : json["Gender"],
        colorConfig: json["Color Config"] == null ? null : json["Color Config"],
        sizeGuide: json["Size Guide"] == null ? null : json["Size Guide"],
      );

  Map<String, dynamic> toJson() => {
        "Brand": brand == null ? null : brand,
        "Gender": gender == null ? null : gender,
        "Color Config": colorConfig == null ? null : colorConfig,
        "Size Guide": sizeGuide == null ? null : sizeGuide,
      };
}

class GalleryImage {
  GalleryImage({
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

  String? valueId;
  String? mediaType;
  dynamic entityId;
  String? position;
  String? label;
  dynamic videoUrl;
  dynamic videoTitle;
  String? url;
  String? productId;
  String? sku;

  factory GalleryImage.fromJson(Map<String, dynamic> json) => GalleryImage(
        valueId: json["value_id"] == null ? null : json["value_id"],
        mediaType: json["media_type"] == null ? null : json["media_type"],
        entityId: json["entity_id"],
        position: json["position"] == null ? null : json["position"],
        label: json["label"] == null ? null : json["label"],
        videoUrl: json["video_url"],
        videoTitle: json["video_title"],
        url: json["url"] == null ? null : json["url"],
        productId: json["product_id"] == null ? null : json["product_id"],
        sku: json["sku"] == null ? null : json["sku"],
      );

  Map<String, dynamic> toJson() => {
        "value_id": valueId == null ? null : valueId,
        "media_type": mediaType == null ? null : mediaType,
        "entity_id": entityId,
        "position": position == null ? null : position,
        "label": label == null ? null : label,
        "video_url": videoUrl,
        "video_title": videoTitle,
        "url": url == null ? null : url,
        "product_id": productId == null ? null : productId,
        "sku": sku == null ? null : sku,
      };
}

class ExtensionAttributes {
  ExtensionAttributes({
    this.websiteIds,
    this.stockItem,
  });

  List<String>? websiteIds;
  StockItem? stockItem;

  factory ExtensionAttributes.fromJson(Map<String, dynamic> json) =>
      ExtensionAttributes(
        websiteIds: json["website_ids"] == null
            ? null
            : List<String>.from(json["website_ids"].map((x) => x)),
        stockItem: json["stock_item"] == null
            ? null
            : StockItem.fromJson(json["stock_item"]),
      );

  Map<String, dynamic> toJson() => {
        "website_ids": websiteIds == null
            ? null
            : List<dynamic>.from(websiteIds!.map((x) => x)),
        "stock_item": stockItem == null ? null : stockItem!.toJson(),
      };
}

class StockItem {
  StockItem({
    this.itemId,
    this.productId,
    this.stockId,
    this.qty,
    required this.isInStock,
    this.minQty,
    this.minSaleQty,
    this.maxSaleQty,
  });

  String? itemId;
  String? productId;
  int? stockId;
  int? qty;
  bool isInStock;
  int? minQty;
  int? minSaleQty;
  int? maxSaleQty;

  factory StockItem.fromJson(Map<String, dynamic> json) => StockItem(
        itemId: json["item_id"] == null ? null : json["item_id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        stockId: json["stock_id"] == null ? null : json["stock_id"],
        qty: json["qty"] == null ? null : json["qty"],
        isInStock: json["is_in_stock"] == null ? null : json["is_in_stock"],
        minQty: json["min_qty"] == null ? null : json["min_qty"],
        minSaleQty: json["min_sale_qty"] == null ? null : json["min_sale_qty"],
        maxSaleQty: json["max_sale_qty"] == null ? null : json["max_sale_qty"],
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId == null ? null : itemId,
        "product_id": productId == null ? null : productId,
        "stock_id": stockId == null ? null : stockId,
        "qty": qty == null ? null : qty,
        "is_in_stock": isInStock,
        "min_qty": minQty == null ? null : minQty,
        "min_sale_qty": minSaleQty == null ? null : minSaleQty,
        "max_sale_qty": maxSaleQty == null ? null : maxSaleQty,
      };
}

class RecommendedProduct {
  RecommendedProduct({
    required this.id,
    required this.name,
    required this.sku,
    this.status,
    this.type,
    this.weight,
    this.currencySymbol,
    this.price,
    this.specialPrice,
    this.specialPriceFromDate,
    this.specialPriceToDate,
    this.visibility,
    this.imageurl,
  });

  String id;
  String name;
  String sku;
  String? status;
  String? type;
  String? weight;
  String? currencySymbol;
  String? price;
  String? specialPrice;
  dynamic specialPriceFromDate;
  dynamic specialPriceToDate;
  String? visibility;
  String? imageurl;

  factory RecommendedProduct.fromJson(Map<String, dynamic> json) =>
      RecommendedProduct(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        sku: json["sku"] == null ? null : json["sku"],
        status: json["status"] == null ? null : json["status"],
        type: json["type"] == null ? null : json["type"],
        weight: json["weight"] == null ? null : json["weight"],
        currencySymbol:
            json["currency_symbol"] == null ? null : json["currency_symbol"],
        price: json["price"] == null ? null : json["price"],
        specialPrice:
            json["special_price"] == null ? null : json["special_price"],
        specialPriceFromDate: json["special_price_from_date"],
        specialPriceToDate: json["special_price_to_date"],
        visibility: json["visibility"] == null ? null : json["visibility"],
        imageurl: json["imageurl"] == null ? null : json["imageurl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "sku": sku == null ? null : sku,
        "status": status == null ? null : status,
        "type": type == null ? null : type,
        "weight": weight == null ? null : weight,
        "currency_symbol": currencySymbol == null ? null : currencySymbol,
        "price": price == null ? null : price,
        "special_price": specialPrice == null ? null : specialPrice,
        "special_price_from_date": specialPriceFromDate,
        "special_price_to_date": specialPriceToDate,
        "visibility": visibility == null ? null : visibility,
        "imageurl": imageurl == null ? null : imageurl,
      };
}

class SocialShare {
  SocialShare({
    this.whatsapp,
    this.facebook,
    this.twitter,
    this.pinterest,
    this.google,
  });

  String? whatsapp;
  String? facebook;
  String? twitter;
  String? pinterest;
  String? google;

  factory SocialShare.fromJson(Map<String, dynamic> json) => SocialShare(
        whatsapp: json["whatsapp"] == null ? null : json["whatsapp"],
        facebook: json["facebook"] == null ? null : json["facebook"],
        twitter: json["twitter"] == null ? null : json["twitter"],
        pinterest: json["pinterest"] == null ? null : json["pinterest"],
        google: json["google"] == null ? null : json["google"],
      );

  Map<String, dynamic> toJson() => {
        "whatsapp": whatsapp == null ? null : whatsapp,
        "facebook": facebook == null ? null : facebook,
        "twitter": twitter == null ? null : twitter,
        "pinterest": pinterest == null ? null : pinterest,
        "google": google == null ? null : google,
      };
}

class SwatchGalleryImage {
  SwatchGalleryImage({
    this.entityId,
    this.sku,
    this.swatchurl,
  });

  String? entityId;
  String? sku;
  String? swatchurl;

  factory SwatchGalleryImage.fromJson(Map<String, dynamic> json) =>
      SwatchGalleryImage(
        entityId: json["entity_id"] == null ? null : json["entity_id"],
        sku: json["sku"] == null ? null : json["sku"],
        swatchurl: json["swatchurl"] == null ? null : json["swatchurl"],
      );

  Map<String, dynamic> toJson() => {
        "entity_id": entityId == null ? null : entityId,
        "sku": sku == null ? null : sku,
        "swatchurl": swatchurl == null ? null : swatchurl,
      };
}

List<WishList> wishListFromJson(String str) =>
    List<WishList>.from(json.decode(str).map((x) => WishList.fromJson(x)));

String wishListToJson(List<WishList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WishList {
  WishList({
    this.success,
    this.message,
  });

  String? success;
  String? message;

  factory WishList.fromJson(Map<String, dynamic> json) => WishList(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
      };
}

List<YouMaLikeModel> youMaLikeModelFromJson(String str) =>
    List<YouMaLikeModel>.from(
        json.decode(str).map((x) => YouMaLikeModel.fromJson(x)));

String youMaLikeModelToJson(List<YouMaLikeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class YouMaLikeModel {
  YouMaLikeModel({
    this.success,
    this.message,
    this.item,
  });

  String? success;
  String? message;
  Item? item;

  factory YouMaLikeModel.fromJson(Map<String, dynamic> json) => YouMaLikeModel(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        item: json["item"] == null ? null : Item.fromJson(json["item"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "item": item == null ? null : item!.toJson(),
      };
}

class Item {
  Item({
    this.recommendedTitle,
    this.recommendedProductss,
  });

  String? recommendedTitle;
  List<RecommendedProduct>? recommendedProductss;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        recommendedTitle: json["recommended_title"] == null
            ? null
            : json["recommended_title"],
        recommendedProductss: json["recommended_products"] == null
            ? null
            : List<RecommendedProduct>.from(json["recommended_products"]
                .map((x) => RecommendedProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "recommended_title": recommendedTitle == null ? null : recommendedTitle,
        "recommended_products": recommendedProductss == null
            ? null
            : List<dynamic>.from(recommendedProductss!.map((x) => x.toJson())),
      };
}
