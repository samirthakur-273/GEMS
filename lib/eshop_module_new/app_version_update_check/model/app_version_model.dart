import 'dart:convert';

List<AppVersionModel> welcomeFromJson(String str) => List<AppVersionModel>.from(json.decode(str).map((x) => AppVersionModel.fromJson(x)));

String welcomeToJson(List<AppVersionModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AppVersionModel {
  AppVersionModel({
    this.success,
    this.message,
    this.androidOld,
    this.androidForceUpdateVer,
    this.iosOld,
    this.iosForceUpdateVer,
  });

  String? success;
  String? message;
  String? androidOld;
  String? androidForceUpdateVer;
  String? iosOld;
  String? iosForceUpdateVer;

  factory AppVersionModel.fromJson(Map<String, dynamic> json) => AppVersionModel(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    androidOld: json["android_old"] == null ? null : json["android_old"],
    androidForceUpdateVer: json["Android_force_update_ver"] == null ? null : json["Android_force_update_ver"],
    iosOld: json["ios_old"] == null ? null : json["ios_old"],
    iosForceUpdateVer: json["Ios_force_update_ver"] == null ? null : json["Ios_force_update_ver"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "android_old": androidOld == null ? null : androidOld,
    "Android_force_update_ver": androidForceUpdateVer == null ? null : androidForceUpdateVer,
    "ios_old": iosOld == null ? null : iosOld,
    "Ios_force_update_ver": iosForceUpdateVer == null ? null : iosForceUpdateVer,
  };
}