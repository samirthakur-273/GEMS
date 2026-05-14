import 'dart:convert';

List<AddToCartModel> addToCartModelFromJson(String str) {
  final resp = json.decode(str);
  final _data = resp is Map ? [resp] : resp;
  return List<AddToCartModel>.from(
      _data.map((x) => AddToCartModel.fromJson(x)));
}

String addToCartModelToJson(List<AddToCartModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddToCartModel {
  AddToCartModel({
    this.success,
    this.message,
    this.quoteId,
  });

  String ?success;
  String ?message;
  String ?quoteId;

  factory AddToCartModel.fromJson(Map<String, dynamic> json) => AddToCartModel(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        quoteId: json["quoteId"] == null ? null : json["quoteId"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "quoteId": quoteId == null ? null : quoteId,
      };
}
