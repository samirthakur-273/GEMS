// To parse this JSON data, do
//
//     final getWplModel = getWplModelFromJson(jsonString);

import 'dart:convert';

GetWplModel getWplModelFromJson(String str) => GetWplModel.fromJson(json.decode(str));

String getWplModelToJson(GetWplModel data) => json.encode(data.toJson());

class GetWplModel {
    bool? status;
    String? message;
    String? statusCode;
    Values? values;

    GetWplModel({
        this.status,
        this.message,
        this.statusCode,
        this.values,
    });

    factory GetWplModel.fromJson(Map<String, dynamic> json) => GetWplModel(
        status: json["status"],
        message: json["message"],
        statusCode: json["status_code"],
        values: Values.fromJson(json["values"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "status_code": statusCode,
        "values": values!.toJson(),
    };
}

class Values {
    bool? wplTicketStatus;
    dynamic wplDate;
    dynamic showWplDate;
    bool? limitReached;
    String? memberType;
    int? totalLimit;
    String? firstName;
    String? lastName;
    String? email;
    List<SlotArray>? slotArray;

    Values({
        this.wplTicketStatus,
        this.wplDate,
        this.showWplDate,
        this.limitReached,
        this.memberType,
        this.totalLimit,
        this.firstName,
        this.lastName,
        this.email,
        this.slotArray,
    });

    factory Values.fromJson(Map<String, dynamic> json) => Values(
        wplTicketStatus: json["wpl_ticket_status"],
        wplDate: json["wpl_date"],
        showWplDate: json["show_wpl_date"],
        limitReached: json["limit_reached"],
        memberType: json["member_type"],
        totalLimit: json["total_limit"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        slotArray: List<SlotArray>.from(json["slot_array"].map((x) => SlotArray.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "wpl_ticket_status": wplTicketStatus,
        "wpl_date": wplDate,
        "show_wpl_date": showWplDate,
        "limit_reached": limitReached,
        "member_type": memberType,
        "total_limit": totalLimit,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "slot_array": List<dynamic>.from(slotArray!.map((x) => x.toJson())),
    };
}

class SlotArray {
    String? memberType;
    int? memberTypeId;
    int? limit;
    String? showSlotDate;
    DateTime? slotDate;
    String? slotTime;
    String? slotName;
    String? description;
    String? imgUrl;

    SlotArray({
        this.memberType,
        this.memberTypeId,
        this.limit,
        this.showSlotDate,
        this.slotDate,
        this.slotTime,
        this.slotName,
        this.description,
        this.imgUrl,
    });

    factory SlotArray.fromJson(Map<String, dynamic> json) => SlotArray(
        memberType: json["member_type"],
        memberTypeId: json["member_type_id"],
        limit: json["limit"],
        showSlotDate: json["show_slot_date"],
        slotDate: DateTime.parse(json["slot_date"]),
        slotTime: json["slot_time"],
        slotName: json["slot_name"],
        description: json["description"],
        imgUrl: json["img_url"],
    );

    Map<String, dynamic> toJson() => {
        "member_type": memberType,
        "member_type_id": memberTypeId,
        "limit": limit,
        "show_slot_date": showSlotDate,
        "slot_date": "${slotDate!.year.toString().padLeft(4, '0')}-${slotDate!.month.toString().padLeft(2, '0')}-${slotDate!.day.toString().padLeft(2, '0')}",
        "slot_time": slotTime,
        "slot_name": slotName,
        "description": description,
        "img_url": imgUrl,
    };
}
