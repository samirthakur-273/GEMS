// To parse this JSON data, do
//
//     final categoryListModel = categoryListModelFromJson(jsonString);

import 'dart:convert';

List<CategoryListModel> categoryListModelFromJson(String str) =>
    List<CategoryListModel>.from(
        json.decode(str).map((x) => CategoryListModel.fromJson(x)));

String categoryListModelToJson(List<CategoryListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryListModel {
  CategoryListModel({
    required this.success,
   required this.updateResponse,
    required this.message,
    this.categories,
  });
  bool updateResponse;
  String success;
  String message;
  List<Category>? categories;

  factory CategoryListModel.fromJson(Map<String, dynamic> json) =>
      CategoryListModel(
        success: json["success"] == null ? null : json["success"],
        updateResponse:
            json['updateResponse'] == null ? false : json['updateResponse'],
        message: json["message"] == null ? null : json["message"],
        categories: json["categories"] == null
            ? null
            : List<Category>.from(
                json["categories"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "categories": categories == null
            ? null
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
      };
}

class Category {
  Category({
   required this.status,
    required this.id,
   required this.name,
   required this.imageurl,
   required this.thumbnail,
   required this.catBanner,
    this.description,
   required this.childs,
  });
  bool status;
  String id;
  String name;
  String imageurl;
  String thumbnail;
  String catBanner;
  dynamic description;
  List<CategoryChild>? childs;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        status: json["status"] == null ? false : json["status"],
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        imageurl: json["imageurl"] == null ? null : json["imageurl"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
        catBanner: json["cat_banner"] == null ? null : json["cat_banner"],
        description: json["description"],
        childs: json["childs"] == null
            ? null
            : List<CategoryChild>.from(
                json["childs"].map((x) => CategoryChild.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "imageurl": imageurl == null ? null : imageurl,
        "thumbnail": thumbnail == null ? null : thumbnail,
        "cat_banner": catBanner == null ? null : catBanner,
        "description": description,
        "childs": childs == null
            ? null
            : List<dynamic>.from(childs!.map((x) => x.toJson())),
      };
}

class CategoryChild {
  CategoryChild({
   required this.id,
   required this.name,
   required this.imageurl,
   required this.thumbnail,
   required this.catBanner,
    this.description,
   required this.childs,
  });

  String id;
  String name;
  String imageurl;
  String thumbnail;
  String catBanner;
  dynamic description;
  List<PurpleChild>? childs;

  factory CategoryChild.fromJson(Map<String, dynamic> json) => CategoryChild(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        imageurl: json["imageurl"] == null ? null : json["imageurl"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
        catBanner: json["cat_banner"] == null ? null : json["cat_banner"],
        description: json["description"],
        childs: json["childs"] == null
            ? null
            : List<PurpleChild>.from(
                json["childs"].map((x) => PurpleChild.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "imageurl": imageurl == null ? null : imageurl,
        "thumbnail": thumbnail == null ? null : thumbnail,
        "cat_banner": catBanner == null ? null : catBanner,
        "description": description,
        "childs": childs == null
            ? null
            : List<dynamic>.from(childs!.map((x) => x.toJson())),
      };
}

class PurpleChild {
  PurpleChild({
    this.id,
     this.name,
    this.thumbnail,
    this.imageurl,
    this.catBanner,
    this.description,
    this.childs,
  });

  String? id;
  String? name;
  String? thumbnail;
  String? imageurl;
  String? catBanner;
  dynamic description;
  List<FluffyChild>? childs;

  factory PurpleChild.fromJson(Map<String, dynamic> json) => PurpleChild(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
        imageurl: json["imageurl"] == null ? null : json["imageurl"],
        catBanner: json["cat_banner"] == null ? null : json["cat_banner"],
        description: json["description"],
        childs: json["childs"] == null
            ? null
            : List<FluffyChild>.from(
                json["childs"].map((x) => FluffyChild.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "thumbnail": thumbnail == null ? null : thumbnail,
        "imageurl": imageurl == null ? null : imageurl,
        "cat_banner": catBanner == null ? null : catBanner,
        "description": description,
        "childs": childs == null
            ? null
            : List<dynamic>.from(childs!.map((x) => x.toJson())),
      };
}

class FluffyChild {
  FluffyChild({
    this.id,
    this.name,
    this.imageurl,
    this.thumbnail,
    this.catBanner,
    this.description,
    this.childs,
  });

  String? id;
  String? name;
  String? imageurl;
  String? thumbnail;
  String? catBanner;
  dynamic description;
  List<dynamic>? childs;

  factory FluffyChild.fromJson(Map<String, dynamic> json) => FluffyChild(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        imageurl: json["imageurl"] == null ? null : json["imageurl"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
        catBanner: json["cat_banner"] == null ? null : json["cat_banner"],
        description: json["description"],
        childs: json["childs"] == null
            ? null
            : List<dynamic>.from(json["childs"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "imageurl": imageurl == null ? null : imageurl,
        "thumbnail": thumbnail == null ? null : thumbnail,
        "cat_banner": catBanner == null ? null : catBanner,
        "description": description,
        "childs":
            childs == null ? null : List<dynamic>.from(childs!.map((x) => x)),
      };
}
