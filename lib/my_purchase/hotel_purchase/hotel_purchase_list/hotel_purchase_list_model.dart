// To parse this JSON data, do
//
//     final hotelPurchaseListModel = hotelPurchaseListModelFromJson(jsonString);

import 'dart:convert';

HotelPurchaseListModel hotelPurchaseListModelFromJson(String str) =>
    HotelPurchaseListModel.fromJson(json.decode(str));

String hotelPurchaseListModelToJson(HotelPurchaseListModel data) =>
    json.encode(data.toJson());

class HotelPurchaseListModel {
  HotelPurchaseListModel({
    this.message,
    this.code,
    this.status,
    this.values,
  });

  String? message;
  String? code;
  bool? status;
  List<Value>? values;

  factory HotelPurchaseListModel.fromJson(Map<String, dynamic> json) =>
      HotelPurchaseListModel(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        values: json["values"] == null
            ? null
            : List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "values": values == null
            ? null
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class Value {
  Value({
    this.htlBrfNo,
    this.htlTpcBrfNo,
    this.htlName,
    this.htlDesc,
    this.htlAddres,
    this.htlCheckinTime,
    this.htlCheckoutTime,
    this.htlCheckinDate,
    this.htlCheckoutDate,
    this.htlRoomType,
    this.htlGstCount,
    this.htlBookCurrency,
    this.htlBookMode,
    this.htlCreatedAt,
    this.htlCcod,
    this.htlBookStatus,
    this.bnzAccrPnts,
    this.htlImages,
    this.htlTransactionType,
    this.htlTotalAmt,
    this.htlPartialAmt,
    this.noOfRooms,
    this.noOfNights,
  });

  String? htlBrfNo;
  String? htlTpcBrfNo;
  String? htlName;
  String? htlDesc;
  String? htlAddres;
  String? htlCheckinTime;
  String? htlCheckoutTime;
  String? htlCheckinDate;
  String? htlCheckoutDate;
  String? htlRoomType;
  String? htlGstCount;
  String? htlBookCurrency;
  String? htlBookMode;
  String? htlCreatedAt;
  String? htlCcod;
  int? htlBookStatus;
  String? bnzAccrPnts;
  String? htlImages;
  String? htlTransactionType;
  int? htlTotalAmt;
  int? htlPartialAmt;
  String? noOfRooms;
  String? noOfNights;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        htlBrfNo: json["htl_brf_no"] == null ? null : json["htl_brf_no"],
        htlTpcBrfNo:
            json["htl_tpc_brf_no"] == null ? null : json["htl_tpc_brf_no"],
        htlName: json["htl_name"] == null ? null : json["htl_name"],
        htlDesc: json["htl_desc"] == null ? null : json["htl_desc"],
        htlAddres: json["htl_addres"] == null ? null : json["htl_addres"],
        htlCheckinTime:
            json["htl_checkin_time"] == null ? null : json["htl_checkin_time"],
        htlCheckoutTime: json["htl_checkout_time"] == null
            ? null
            : json["htl_checkout_time"],
        htlCheckinDate:
            json["htl_checkin_date"] == null ? null : json["htl_checkin_date"],
        htlCheckoutDate: json["htl_checkout_date"] == null
            ? null
            : json["htl_checkout_date"],
        htlRoomType:
            json["htl_room_type"] == null ? null : json["htl_room_type"],
        htlGstCount:
            json["htl_gst_count"] == null ? null : json["htl_gst_count"],
        htlBookCurrency: json["htl_book_currency"] == null
            ? null
            : json["htl_book_currency"],
        htlBookMode:
            json["htl_book_mode"] == null ? null : json["htl_book_mode"],
        htlCreatedAt:
            json["htl_created_at"] == null ? null : json["htl_created_at"],
        htlCcod: json["htl_ccod"] == null ? null : json["htl_ccod"],
        htlBookStatus:
            json["htl_book_status"] == null ? null : json["htl_book_status"],
        bnzAccrPnts:
            json["bnz_accr_pnts"] == null ? null : json["bnz_accr_pnts"],
        htlImages: json["htl_images"] == null ? null : json["htl_images"],
        htlTransactionType: json["htl_transaction_type"] == null
            ? null
            : json["htl_transaction_type"],
        htlTotalAmt:
            json["htl_total_amt"] == null ? null : json["htl_total_amt"],
        htlPartialAmt:
            json["htl_partial_amt"] == null ? null : json["htl_partial_amt"],
        noOfRooms: json["no_of_rooms"] == null ? null : json["no_of_rooms"],
        noOfNights: json["no_of_nights"] == null ? null : json["no_of_nights"],
      );

  Map<String, dynamic> toJson() => {
        "htl_brf_no": htlBrfNo == null ? null : htlBrfNo,
        "htl_tpc_brf_no": htlTpcBrfNo == null ? null : htlTpcBrfNo,
        "htl_name": htlName == null ? null : htlName,
        "htl_desc": htlDesc == null ? null : htlDesc,
        "htl_addres": htlAddres == null ? null : htlAddres,
        "htl_checkin_time": htlCheckinTime == null ? null : htlCheckinTime,
        "htl_checkout_time": htlCheckoutTime == null ? null : htlCheckoutTime,
        "htl_checkin_date": htlCheckinDate == null ? null : htlCheckinDate,
        "htl_checkout_date": htlCheckoutDate == null ? null : htlCheckoutDate,
        "htl_room_type": htlRoomType == null ? null : htlRoomType,
        "htl_gst_count": htlGstCount == null ? null : htlGstCount,
        "htl_book_currency": htlBookCurrency == null ? null : htlBookCurrency,
        "htl_book_mode": htlBookMode == null ? null : htlBookMode,
        "htl_created_at": htlCreatedAt == null ? null : htlCreatedAt,
        "htl_ccod": htlCcod == null ? null : htlCcod,
        "htl_book_status": htlBookStatus == null ? null : htlBookStatus,
        "bnz_accr_pnts": bnzAccrPnts == null ? null : bnzAccrPnts,
        "htl_images": htlImages == null ? null : htlImages,
        "htl_transaction_type":
            htlTransactionType == null ? null : htlTransactionType,
        "htl_total_amt": htlTotalAmt == null ? null : htlTotalAmt,
        "htl_partial_amt": htlPartialAmt == null ? null : htlPartialAmt,
        "no_of_rooms": noOfRooms == null ? null : noOfRooms,
        "no_of_nights": noOfNights == null ? null : noOfNights,
      };
}
