import 'dart:convert';

List<DialogModel> dialogModelFromJson(String str) => List<DialogModel>.from(json.decode(str).map((x) => DialogModel.fromJson(x)));

String dialogModelToJson(List<DialogModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DialogModel {
  DialogModel({
     this.success,
     this.message,
  });

  final String? success;
  final String? message;

  factory DialogModel.fromJson(Map<String, dynamic> json) => DialogModel(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
  };
}
