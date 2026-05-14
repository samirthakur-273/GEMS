
import 'dart:convert';

EmirateModal emirateModalFromJson(String str) => EmirateModal.fromJson(json.decode(str));

String emirateModalToJson(EmirateModal data) => json.encode(data.toJson());

class EmirateModal {
    bool? status;
    String? statusCode;
    String? message;
    List<Value>? values;

    EmirateModal({
        this.status,
        this.statusCode,
        this.message,
        this.values,
    });

    factory EmirateModal.fromJson(Map<String, dynamic> json) => EmirateModal(
        status: json["status"],
        statusCode: json["status_code"],
        message: json["message"],
        values: json["values"] == null ? [] : List<Value>.from(json["values"]!.map((x) => Value.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "message": message,
        "values": values == null ? [] : List<dynamic>.from(values!.map((x) => x.toJson())),
    };
}

class Value {
    int? id;
    String? name;
    String? code;

    Value({
        this.id,
        this.name,
        this.code,
    });

    factory Value.fromJson(Map<String, dynamic> json) => Value(
        id: json["id"],
        name: json["name"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
    };
}
