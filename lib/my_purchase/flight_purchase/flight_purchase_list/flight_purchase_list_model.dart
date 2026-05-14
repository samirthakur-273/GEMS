// To parse this JSON data, do
//
//     final flightPurchaseListModel = flightPurchaseListModelFromJson(jsonString);

import 'dart:convert';

FlightPurchaseListModel flightPurchaseListModelFromJson(String str) => FlightPurchaseListModel.fromJson(json.decode(str));

String flightPurchaseListModelToJson(FlightPurchaseListModel data) => json.encode(data.toJson());

class FlightPurchaseListModel {
    FlightPurchaseListModel({
        this.message,
        this.code,
        this.status,
        this.values,
    });

    String? message;
    String? code;
    bool? status;
    List<Value>? values;

    factory FlightPurchaseListModel.fromJson(Map<String, dynamic> json) => FlightPurchaseListModel(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        values: json["values"] == null ? null : List<Value>.from(json["values"].map((x) => Value.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "values": values == null ? null : List<dynamic>.from(values!.map((x) => x.toJson())),
    };
}

class Value {
    Value({
        this.fltAnm,
        this.fltPnr,
        this.bnzAccPnts,
        this.fltBbokingDate,
        this.fltBookStatus,
        this.fltBrfNo,
        this.fltCpBrfNo,
        this.fltTotalAmt,
        this.fltPartialAmt,
        this.transactionType,
        this.fltOrigin,
        this.fltDest,
        this.fltOrgin,
        this.fltNo,
        this.fltJtym,
        this.fltClass,
        this.fltOgct,
        this.fltDect,
        this.fltArnImg,
        this.fltPaDt,
        this.fltPbDt,
        this.fltDeptTime,
        this.ftlArrivalTime,
        this.fltStop,
        this.fltTripType,
        this.fltTravelType,
    });

    String? fltAnm;
    String? fltPnr;
    String? bnzAccPnts;
    String? fltBbokingDate;
    int? fltBookStatus;
    int? fltBrfNo;
    String? fltCpBrfNo;
    int? fltTotalAmt;
    int? fltPartialAmt;
    String? transactionType;
    String? fltOrigin;
    String? fltDest;
    String? fltOrgin;
    String? fltNo;
    String? fltJtym;
    String? fltClass;
    String? fltOgct;
    String? fltDect;
    String? fltArnImg;
    String? fltPaDt;
    String? fltPbDt;
    String? fltDeptTime;
    String? ftlArrivalTime;
    int? fltStop;
    String? fltTripType;
    String? fltTravelType;

    factory Value.fromJson(Map<String, dynamic> json) => Value(
        fltAnm: json["flt_anm"] == null ? null : json["flt_anm"],
        fltPnr: json["flt_pnr"] == null ? null : json["flt_pnr"],
        bnzAccPnts: json["bnz_acc_pnts"] == null ? null : json["bnz_acc_pnts"],
        fltBbokingDate: json["flt_bboking_date"] == null ? null : json["flt_bboking_date"],
        fltBookStatus: json["flt_book_status"] == null ? null : json["flt_book_status"],
        fltBrfNo: json["flt_brf_no"] == null ? null : json["flt_brf_no"],
        fltCpBrfNo: json["flt_cp_brf_no"] == null ? null : json["flt_cp_brf_no"],
        fltTotalAmt: json["flt_total_amt"] == null ? null : json["flt_total_amt"],
        fltPartialAmt: json["flt_partial_amt"] == null ? null : json["flt_partial_amt"],
        transactionType: json["transaction_type"] == null ? null : json["transaction_type"],
        fltOrigin: json["flt_origin"] == null ? null : json["flt_origin"],
        fltDest: json["flt_dest"] == null ? null : json["flt_dest"],
        fltOrgin: json["flt_orgin"] == null ? null : json["flt_orgin"],
        fltNo: json["flt_no"] == null ? null : json["flt_no"],
        fltJtym: json["flt_jtym"] == null ? null : json["flt_jtym"],
        fltClass: json["flt_class"] == null ? null : json["flt_class"],
        fltOgct: json["flt_ogct"] == null ? null : json["flt_ogct"],
        fltDect: json["flt_dect"] == null ? null : json["flt_dect"],
        fltArnImg: json["flt_arn_img"] == null ? null : json["flt_arn_img"],
        fltPaDt: json["flt_pa_dt"] == null ? null : json["flt_pa_dt"],
        fltPbDt: json["flt_pb_dt"] == null ? null : json["flt_pb_dt"],
        fltDeptTime: json["flt_dept_time"] == null ? null : json["flt_dept_time"],
        ftlArrivalTime: json["ftl_arrival_time"] == null ? null : json["ftl_arrival_time"],
        fltStop: json["flt_stop"] == null ? null : json["flt_stop"],
        fltTripType: json["flt_trip_type"] == null ? null : json["flt_trip_type"],
        fltTravelType: json["flt_travel_type"] == null ? null : json["flt_travel_type"],
    );

    Map<String, dynamic> toJson() => {
        "flt_anm": fltAnm == null ? null : fltAnm,
        "flt_pnr": fltPnr == null ? null : fltPnr,
        "bnz_acc_pnts": bnzAccPnts == null ? null : bnzAccPnts,
        "flt_bboking_date": fltBbokingDate == null ? null : fltBbokingDate,
        "flt_book_status": fltBookStatus == null ? null : fltBookStatus,
        "flt_brf_no": fltBrfNo == null ? null : fltBrfNo,
        "flt_cp_brf_no": fltCpBrfNo == null ? null : fltCpBrfNo,
        "flt_total_amt": fltTotalAmt == null ? null : fltTotalAmt,
        "flt_partial_amt": fltPartialAmt == null ? null : fltPartialAmt,
        "transaction_type": transactionType == null ? null : transactionType,
        "flt_origin": fltOrigin == null ? null : fltOrigin,
        "flt_dest": fltDest == null ? null : fltDest,
        "flt_orgin": fltOrgin == null ? null : fltOrgin,
        "flt_no": fltNo == null ? null : fltNo,
        "flt_jtym": fltJtym == null ? null : fltJtym,
        "flt_class": fltClass == null ? null : fltClass,
        "flt_ogct": fltOgct == null ? null : fltOgct,
        "flt_dect": fltDect == null ? null : fltDect,
        "flt_arn_img": fltArnImg == null ? null : fltArnImg,
        "flt_pa_dt": fltPaDt == null ? null : fltPaDt,
        "flt_pb_dt": fltPbDt == null ? null : fltPbDt,
        "flt_dept_time": fltDeptTime == null ? null : fltDeptTime,
        "ftl_arrival_time": ftlArrivalTime == null ? null : ftlArrivalTime,
        "flt_stop": fltStop == null ? null : fltStop,
        "flt_trip_type": fltTripType == null ? null : fltTripType,
        "flt_travel_type": fltTravelType == null ? null : fltTravelType,
    };
}
