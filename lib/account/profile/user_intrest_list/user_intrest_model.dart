// To parse this JSON data, do
//
//     final userIntrestModel = userIntrestModelFromJson(jsonString);

import 'dart:convert';

UserIntrestModel userIntrestModelFromJson(String str) =>
    UserIntrestModel.fromJson(json.decode(str));

String userIntrestModelToJson(UserIntrestModel data) =>
    json.encode(data.toJson());

class UserIntrestModel {
  UserIntrestModel({
    this.message,
    this.code,
    this.status,
    this.values,
  });

  String? message;
  String? code;
  bool? status;
  List<Value>? values;

  factory UserIntrestModel.fromJson(Map<String, dynamic> json) =>
      UserIntrestModel(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        values: json["values"] == null
            ? null
            : List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "values": values == null
            ? null
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class Value {
  Value({
    this.interestId,
    this.name,
    this.image,
    this.unselectedImage,
    this.sequence,
  });

   int? interestId;
  String? name;
  String? image;
  String? unselectedImage;
  int? sequence;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        interestId: json["interest_id"] == null ? null : json["interest_id"],
        name: json["name"] == null ? null : json["name"],
        image: json["image"] == null ? null : json["image"],
        unselectedImage:
            json["unselected_image"] == null ? null : json["unselected_image"],
        sequence: json["sequence"] == null ? null : json["sequence"],
      );

  Map<String, dynamic> toJson() => {
        "interest_id": interestId == null ? null : interestId,
        "name": name == null ? null : name,
        "image": image == null ? null : image,
        "unselected_image": unselectedImage == null ? null : unselectedImage,
        "sequence": sequence == null ? null : sequence,
      };
}
