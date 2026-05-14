// To parse this JSON data, do
//
//     final policyModel = policyModelFromJson(jsonString);

import 'dart:convert';

List<PolicyModel> policyModelFromJson(String str) => List<PolicyModel>.from(
    json.decode(str).map((x) => PolicyModel.fromJson(x)));

String policyModelToJson(List<PolicyModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PolicyModel {
  PolicyModel({
    this.success,
    this.message,
    this.cmscontent,
    this.imgmediasrc,
  });

  String ?success;
  String ?message;
  String ?cmscontent;
  String ?imgmediasrc;

  factory PolicyModel.fromJson(Map<String, dynamic> json) => PolicyModel(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        cmscontent: json["cmscontent"] == null ? null : json["cmscontent"],
        imgmediasrc: json["imgmediasrc"] == null ? null : json["imgmediasrc"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "cmscontent": cmscontent == null ? null : cmscontent,
        "imgmediasrc": imgmediasrc == null ? null : imgmediasrc,
      };
}
