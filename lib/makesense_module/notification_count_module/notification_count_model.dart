import 'dart:convert';

NotificationCountModel notificationCountModelFromJson(String str) => NotificationCountModel.fromJson(json.decode(str));

String notificationCountModelToJson(NotificationCountModel data) => json.encode(data.toJson());

class NotificationCountModel {
    bool? status;
    String? message;
    String? code;
    List<dynamic>? values;
    Meta? meta;
    String? requestUid;

    NotificationCountModel({
        this.status,
        this.message,
        this.code,
        this.values,
        this.meta,
        this.requestUid,
    });

    factory NotificationCountModel.fromJson(Map<String, dynamic> json) => NotificationCountModel(
        status: json["status"],
        message: json["message"],
        code: json["code"],
        values: json["values"] == null ? [] : List<dynamic>.from(json["values"]!.map((x) => x)),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        requestUid: json["requestUID"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "code": code,
        "values": values == null ? [] : List<dynamic>.from(values!.map((x) => x)),
        "meta": meta?.toJson(),
        "requestUID": requestUid,
    };
}

class Meta {
    int? countsTotal;
    int? countsTotalRead;
    int? countsTotalUnread;
    int? countsDaterangeTotal;
    int? countsDaterangeRead;
    int? countsDaterangeUnread;

    Meta({
        this.countsTotal,
        this.countsTotalRead,
        this.countsTotalUnread,
        this.countsDaterangeTotal,
        this.countsDaterangeRead,
        this.countsDaterangeUnread,
    });

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        countsTotal: json["counts_total"],
        countsTotalRead: json["counts_total_read"],
        countsTotalUnread: json["counts_total_unread"],
        countsDaterangeTotal: json["counts_daterange_total"],
        countsDaterangeRead: json["counts_daterange_read"],
        countsDaterangeUnread: json["counts_daterange_unread"],
    );

    Map<String, dynamic> toJson() => {
        "counts_total": countsTotal,
        "counts_total_read": countsTotalRead,
        "counts_total_unread": countsTotalUnread,
        "counts_daterange_total": countsDaterangeTotal,
        "counts_daterange_read": countsDaterangeRead,
        "counts_daterange_unread": countsDaterangeUnread,
    };
}
