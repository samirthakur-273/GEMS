import 'dart:convert';

RegisterDeviceModel registerDeviceModelFromJson(String str) => RegisterDeviceModel.fromJson(json.decode(str));

String registerDeviceModelToJson(RegisterDeviceModel data) => json.encode(data.toJson());

class RegisterDeviceModel {
    RegisterDeviceModel({
        this.status,
        this.messagse,
        this.code,
        this.values,
    });

    bool? status;
    String? messagse;
    String? code;
    Values? values;

    factory RegisterDeviceModel.fromJson(Map<String, dynamic> json) => RegisterDeviceModel(
        status: json["status"] == null ? null : json["status"],
        messagse: json["messagse"] == null ? null : json["messagse"],
        code: json["code"] == null ? null : json["code"],
        values: json["values"] == null ? null : Values.fromJson(json["values"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "messagse": messagse == null ? null : messagse,
        "code": code == null ? null : code,
        "values": values == null ? null : values!.toJson(),
    };
}

class Values {
    Values({
        this.deviceId,
        this.timestamp,
    });

    String? deviceId;
    DateTime? timestamp;

    factory Values.fromJson(Map<String, dynamic> json) => Values(
        deviceId: json["device_id"] == null ? null : json["device_id"],
        timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    );

    Map<String, dynamic> toJson() => {
        "device_id": deviceId == null ? null : deviceId,
        "timestamp": timestamp == null ? null : timestamp!.toIso8601String(),
    };
}
