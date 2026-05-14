import 'dart:convert';

MakesenseEventModel makesenseEventModalFromMap(String str) =>
    MakesenseEventModel.fromMap(json.decode(str));

String makesenseEventModalToMap(MakesenseEventModel data) =>
    json.encode(data.toMap());

class MakesenseEventModel {
  MakesenseEventModel({
    this.message,
    this.status,
  });

  String? message;
  bool? status;
  factory MakesenseEventModel.fromMap(Map<String, dynamic> json) =>
      MakesenseEventModel(
        message: json["message"] == null ? null : json["message"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toMap() => {
        "message": message == null ? null : message,
        "status": status == null ? null : status,
      };
}
