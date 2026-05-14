import 'dart:convert';

MaintenceModel maintenceModelFromJson(String str) =>
    MaintenceModel.fromJson(json.decode(str));

String maintenceModelToJson(MaintenceModel data) => json.encode(data.toJson());

class MaintenceModel {
  MaintenceModel({
    this.status,
    this.message,
  });

  bool? status;
  String? message;

  factory MaintenceModel.fromJson(Map<String, dynamic> json) => MaintenceModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message
      };
}