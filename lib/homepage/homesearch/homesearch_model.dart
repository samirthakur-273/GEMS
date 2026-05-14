import 'dart:convert';

HomeSearchModel homeSearchModelFromJson(String str) =>
    HomeSearchModel.fromJson(json.decode(str));

String homeSearchModelToJson(HomeSearchModel data) =>
    json.encode(data.toJson());

class HomeSearchModel {
  HomeSearchModel({
    this.status,
    this.code,
    this.message,
    this.values,
  });

  bool? status;
  String? code;
  String? message;
  List<Value>? values;

  factory HomeSearchModel.fromJson(Map<String, dynamic> json) =>
      HomeSearchModel(
        status: json["status"] == null ? null : json["status"],
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        values: json["values"] == null
            ? null
            : List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "code": code == null ? null : code,
        "message": message == null ? null : message,
        "values": values == null
            ? null
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class Value {
  Value({
    this.affiliateId,
    this.affiliateName,
  });

  String? affiliateId;
  String? affiliateName;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        affiliateId: json["affiliate_id"],
        affiliateName: json["affiliate_name"],
      );

  Map<String, dynamic> toJson() => {
        "affiliate_id": affiliateId,
        "affiliate_name": affiliateName,
      };
}
