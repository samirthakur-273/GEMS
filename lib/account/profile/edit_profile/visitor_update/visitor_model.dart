import 'dart:convert';

VisitorUpdateModal visitorUpdateModalFromJson(String str) => VisitorUpdateModal.fromJson(json.decode(str));

String visitorUpdateModalToJson(VisitorUpdateModal data) => json.encode(data.toJson());

class VisitorUpdateModal {
    bool? status;
    String? requestUid;

    VisitorUpdateModal({
        this.status,
        this.requestUid,
    });

    factory VisitorUpdateModal.fromJson(Map<String, dynamic> json) => VisitorUpdateModal(
        status: json["status"],
        requestUid: json["requestUID"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "requestUID": requestUid,
    };
}
