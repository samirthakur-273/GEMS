// To parse this JSON data, do
//
//     final notificationListModel = notificationListModelFromJson(jsonString);

import 'dart:convert';

NotificationListModel notificationListModelFromJson(String str) =>
    NotificationListModel.fromJson(json.decode(str));

String notificationListModelToJson(NotificationListModel data) =>
    json.encode(data.toJson());

class NotificationListModel {
  NotificationListModel({
    this.status,
    this.message,
    this.code,
    this.values,
    this.meta,
  });

  bool? status;
  String? message;
  String? code;
  List<Value>? values;
  Meta? meta;

  factory NotificationListModel.fromJson(Map<String, dynamic> json) =>
      NotificationListModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        values: json["values"] == null
            ? null
            : List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "values": values == null
            ? null
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "meta": meta == null ? null : meta!.toJson(),
      };
}

class Meta {
  Meta({
    this.countsTotal,
    this.countsTotalRead,
    this.countsTotalUnread,
    this.countsDaterangeTotal,
    this.countsDaterangeRead,
    this.countsDaterangeUnread,
  });

  int? countsTotal;
  int? countsTotalRead;
  int? countsTotalUnread;
  int? countsDaterangeTotal;
  int? countsDaterangeRead;
  int? countsDaterangeUnread;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        countsTotal: json["counts_total"] == null ? null : json["counts_total"],
        countsTotalRead: json["counts_total_read"] == null
            ? null
            : json["counts_total_read"],
        countsTotalUnread: json["counts_total_unread"] == null
            ? null
            : json["counts_total_unread"],
        countsDaterangeTotal: json["counts_daterange_total"] == null
            ? null
            : json["counts_daterange_total"],
        countsDaterangeRead: json["counts_daterange_read"] == null
            ? null
            : json["counts_daterange_read"],
        countsDaterangeUnread: json["counts_daterange_unread"] == null
            ? null
            : json["counts_daterange_unread"],
      );

  Map<String, dynamic> toJson() => {
        "counts_total": countsTotal == null ? null : countsTotal,
        "counts_total_read": countsTotalRead == null ? null : countsTotalRead,
        "counts_total_unread":
            countsTotalUnread == null ? null : countsTotalUnread,
        "counts_daterange_total":
            countsDaterangeTotal == null ? null : countsDaterangeTotal,
        "counts_daterange_read":
            countsDaterangeRead == null ? null : countsDaterangeRead,
        "counts_daterange_unread":
            countsDaterangeUnread == null ? null : countsDaterangeUnread,
      };
}

class Value {
  Value({
    this.id,
    this.createdBy,
    this.cohortId,
    this.internalLink,
    this.selectedCityHotel,
    this.selectedCitySrc,
    this.selectedCityDst,
    this.selectedCitySrcCitynameInapp,
    this.selectedCitySrcCountryNameInapp,
    this.selectedCityDestCitynameInapp,
    this.selectedCityDestCountryNameInapp,
    this.internalModule,
    this.deepLinking,
    this.externalLink,
    this.timestamp,
    this.campaignId,
    this.userId,
    this.campaignFor,
    this.title,
    this.body,
    this.campaignName,
    this.banner,
    this.logo,
    this.status,
    this.membershipNo,
    this.isRead,
  });

  String? id;
  String? createdBy;
  String? cohortId;
  String? internalLink;
  String? selectedCityHotel;
  String? selectedCitySrc;
  String? selectedCityDst;
  String? selectedCitySrcCitynameInapp;
  String? selectedCitySrcCountryNameInapp;
  String? selectedCityDestCitynameInapp;
  String? selectedCityDestCountryNameInapp;
  String? internalModule;
  String? deepLinking;
  String? externalLink;
  String? timestamp;
  String? campaignId;
  String? userId;
  String? campaignFor;
  String? title;
  String? body;
  String? campaignName;
  String? banner;
  String? logo;
  String? status;
  String? membershipNo;
  int? isRead;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        id: json["_id"] == null ? null : json["_id"],
        createdBy: json["created_by"],
        cohortId: json["cohort_id"],
        internalLink:
            json["internal_link"] == null ? null : json["internal_link"],
        selectedCityHotel: json["selected_city_hotel"] == null
            ? null
            : json["selected_city_hotel"],
        selectedCitySrc: json["selected_city_src"] == null
            ? null
            : json["selected_city_src"],
        selectedCityDst: json["selected_city_dst"] == null
            ? null
            : json["selected_city_dst"],
        selectedCitySrcCitynameInapp: json["selected_city_src_cityname_inapp"],
        selectedCitySrcCountryNameInapp:
            json["selected_city_src_country_name_inapp"],
        selectedCityDestCitynameInapp:
            json["selected_city_dest_cityname_inapp"],
        selectedCityDestCountryNameInapp:
            json["selected_city_dest_country_name_inapp"],
        internalModule: json["internal_module"],
        deepLinking: json["deep_linking"],
        externalLink:
            json["external_link"] == null ? null : json["external_link"],
        timestamp: json["timestamp"],
        campaignId: json["campaign_id"] == null ? null : json["campaign_id"],
        userId: json["userId"],
        campaignFor: json["campaign_for"],
        title: json["title"] == null ? null : json["title"],
        body: json["body"] == null ? null : json["body"],
        campaignName:
            json["campaignName"] == null ? null : json["campaignName"],
        banner: json["banner"] == null ? null : json["banner"],
        logo: json["logo"] == null ? null : json["logo"],
        status: json["status"],
        membershipNo:
            json["membership_no"] == null ? null : json["membership_no"],
        isRead: json["isRead"] == null ? null : json["isRead"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "created_by": createdBy == null ? null : createdBy,
        "cohort_id": cohortId ?? "",
        "internal_link": internalLink == null ? "" : internalLink,
        "selected_city_hotel":
            selectedCityHotel == null ? "" : selectedCityHotel,
        "selected_city_src": selectedCitySrc == null ? "" : selectedCitySrc,
        "selected_city_dst": selectedCityDst == null ? null : selectedCityDst,
        "selected_city_src_cityname_inapp": selectedCitySrcCitynameInapp == null
            ? ""
            : selectedCitySrcCitynameInapp,
        "selected_city_src_country_name_inapp":
            selectedCitySrcCountryNameInapp == null
                ? ""
                : selectedCitySrcCountryNameInapp,
        "selected_city_dest_cityname_inapp":
            selectedCityDestCitynameInapp == null
                ? ""
                : selectedCityDestCitynameInapp,
        "selected_city_dest_country_name_inapp":
            selectedCityDestCountryNameInapp == null
                ? ""
                : selectedCityDestCountryNameInapp,
        "internal_module": internalModule == null ? "" : internalModule,
        "deep_linking": deepLinking == null ? "" : deepLinking,
        "external_link": externalLink == null ? "" : externalLink,
        "timestamp": timestamp == null ? "" : timestamp,
        "campaign_id": campaignId == null ? "" : campaignId,
        "userId": userId == null ? "" : userId,
        "campaign_for": campaignFor == null ? "" : campaignFor,
        "title": title == null ? "" : title,
        "body": body == null ? "" : body,
        "campaignName": campaignName == null ? "" : campaignName,
        "banner": banner == null ? "" : banner,
        "logo": logo == null ? "" : logo,
        "status": status == null ? "" : status,
        "membership_no": membershipNo == null ? "" : membershipNo,
        "isRead": isRead == null ? "" : isRead,
      };
}
