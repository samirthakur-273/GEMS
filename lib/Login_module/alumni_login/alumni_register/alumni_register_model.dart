import 'dart:convert';

AlumniRegisterModel alumniRegisterModelFromJson(String str) => AlumniRegisterModel.fromJson(json.decode(str));

String alumniRegisterModelToJson(AlumniRegisterModel data) => json.encode(data.toJson());

class AlumniRegisterModel {
    AlumniRegisterModel({
        this.message,
        this.code,
        this.status,
        this.values,
    });

    var message;
    String? code;
    bool? status;
    Values? values;

    factory AlumniRegisterModel.fromJson(Map<String, dynamic> json) => AlumniRegisterModel(
        message: json["message"],
        code: json["code"],
        status: json["status"],
        // values: Values.fromJson(json["values"]),
        values: json["values"] == null || json["status"] == false
            ? null
            : Values.fromJson(json["values"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
        "status": status,
        "values": values?.toJson(),
    };
}

class Values {
    Values();

    factory Values.fromJson(Map<String, dynamic> json) => Values(
    );

    Map<String, dynamic> toJson() => {
    };
}
