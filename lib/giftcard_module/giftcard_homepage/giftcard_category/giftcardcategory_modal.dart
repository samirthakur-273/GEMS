// To parse this JSON data, do
//
//     final giftCategoryModal = giftCategoryModalFromJson(jsonString);

import 'dart:convert';

GiftCategoryModal giftCategoryModalFromJson(String str) => GiftCategoryModal.fromJson(json.decode(str));

String giftCategoryModalToJson(GiftCategoryModal data) => json.encode(data.toJson());

class GiftCategoryModal {
    GiftCategoryModal({
        this.message,
        this.code,
        this.status,
        this.objects,
        this.total,
    });

    String? message;
    String? code;
    bool ?status;
    List<Object>? objects;
    int? total;

    factory GiftCategoryModal.fromJson(Map<String, dynamic> json) => GiftCategoryModal(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        objects: json["objects"] == null ? null : List<Object>.from(json["objects"].map((x) => Object.fromJson(x))),
        total: json["total"] == null ? null : json["total"],
    );

    Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "objects": objects == null ? null : List<dynamic>.from(objects!.map((x) => x.toJson())),
        "total": total == null ? null : total,
    };
}

class Object {
    Object({
        this.categoryName,
        this.categoryCode,
        this.categoryId,
        required this.categoryIcon,
        this.sequence,
        this.count,
    });

    String ?categoryName;
    String ?categoryCode;
    int ?categoryId;
    String categoryIcon;
    String ?sequence;
    int? count;

    factory Object.fromJson(Map<String, dynamic> json) => Object(
        categoryName: json["category_name"] == null ? null : json["category_name"],
        categoryCode: json["category_code"] == null ? null : json["category_code"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
        categoryIcon: json["category_icon"] == null ? null : json["category_icon"],
        sequence: json["sequence"] == null ? null : json["sequence"],
        count: json["count"] == null ? null : json["count"],
    );

    Map<String, dynamic> toJson() => {
        "category_name": categoryName == null ? null : categoryName,
        "category_code": categoryCode == null ? null : categoryCode,
        "category_id": categoryId == null ? null : categoryId,
        "category_icon": categoryIcon == null ? null : categoryIcon,
        "sequence": sequence == null ? null : sequence,
        "count": count == null ? null : count,
    };
}
