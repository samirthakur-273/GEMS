// To parse this JSON data, do
//
//     final flightPurchaseOrderModel = flightPurchaseOrderModelFromJson(jsonString);

import 'dart:convert';

FlightPurchaseOrderModel flightPurchaseOrderModelFromJson(String str) => FlightPurchaseOrderModel.fromJson(json.decode(str));

String flightPurchaseOrderModelToJson(FlightPurchaseOrderModel data) => json.encode(data.toJson());

class FlightPurchaseOrderModel {
    FlightPurchaseOrderModel({
        this.message,
        this.code,
        this.status,
        this.values,
    });

    String? message;
    String? code;
    bool? status;
    Values? values;

    factory FlightPurchaseOrderModel.fromJson(Map<String, dynamic> json) => FlightPurchaseOrderModel(
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
        status: json["status"] == null ? null : json["status"],
        values: json["values"] == null ? null : Values.fromJson(json["values"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message == null ? null : message,
        "code": code == null ? null : code,
        "status": status == null ? null : status,
        "values": values == null ? null : values!.toJson(),
    };
}

class Values {
    Values({
        this.status,
        this.bookSid,
        this.bookSidReturn,
        this.fltInfo,
        this.earnBnzPnts,
        this.saveAsPdf,
    });

    String? status;
    BookSid? bookSid;
    BookSidReturn? bookSidReturn;
    FltInfo? fltInfo;
    String? earnBnzPnts;
    String? saveAsPdf;

    factory Values.fromJson(Map<String, dynamic> json) => Values(
        status: json["status"] == null ? null : json["status"],
        bookSid: json["book_sid"] == null ? null : BookSid.fromJson(json["book_sid"]),
        bookSidReturn: json["book_sid_return"] == null ? null : BookSidReturn.fromJson(json["book_sid_return"]),
        fltInfo: json["flt_info"] == null ? null : FltInfo.fromJson(json["flt_info"]),
        earnBnzPnts: json["earn_bnz_pnts"] == null ? null : json["earn_bnz_pnts"],
        saveAsPdf: json["save_as_pdf"] == null ? null : json["save_as_pdf"],
    );

    Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "book_sid": bookSid == null ? null : bookSid!.toJson(),
        "book_sid_return": bookSidReturn == null ? null : bookSidReturn!.toJson(),
        "flt_info": fltInfo == null ? null : fltInfo!.toJson(),
        "earn_bnz_pnts": earnBnzPnts == null ? null : earnBnzPnts,
        "save_as_pdf": saveAsPdf == null ? null : saveAsPdf,
    };
}

class BookSid {
    BookSid({
        this.result,
    });

    BookSidResult? result;

    factory BookSid.fromJson(Map<String, dynamic> json) => BookSid(
        result: json["result"] == null ? null : BookSidResult.fromJson(json["result"]),
    );

    Map<String, dynamic> toJson() => {
        "result": result == null ? null : result!.toJson(),
    };
}

class BookSidResult {
    BookSidResult({
        this.bookData,
    });

    BookData? bookData;

    factory BookSidResult.fromJson(Map<String, dynamic> json) => BookSidResult(
        bookData: json["bookData"] == null ? null : BookData.fromJson(json["bookData"]),
    );

    Map<String, dynamic> toJson() => {
        "bookData": bookData == null ? null : bookData!.toJson(),
    };
}

class BookData {
    BookData({
        this.result,
        this.transactionId,
        this.suppliertransid,
    });

    BookDataResult? result;
    String? transactionId;
    String? suppliertransid;

    factory BookData.fromJson(Map<String, dynamic> json) => BookData(
        result: json["result"] == null ? null : BookDataResult.fromJson(json["result"]),
        transactionId: json["transactionId"] == null ? null : json["transactionId"],
        suppliertransid: json["suppliertransid"] == null ? null : json["suppliertransid"],
    );

    Map<String, dynamic> toJson() => {
        "result": result == null ? null : result!.toJson(),
        "transactionId": transactionId == null ? null : transactionId,
        "suppliertransid": suppliertransid == null ? null : suppliertransid,
    };
}

class BookDataResult {
    BookDataResult({
        this.responseCode,
        this.status,
        this.message,
        // this.pnr,
        this.hasInsurance,
        this.finalSsrStatus,
        this.cancellationModes,
    });

    int? responseCode;
    String? status;
    String? message;
    // Pnr? pnr;
    String? hasInsurance;
    String? finalSsrStatus;
    String? cancellationModes;

    factory BookDataResult.fromJson(Map<String, dynamic> json) => BookDataResult(
        responseCode: json["response_code"] == null ? null : json["response_code"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        // pnr: json["pnr"] == null ? null : Pnr.fromJson(json["pnr"]),
        hasInsurance: json["has_insurance"] == null ? null : json["has_insurance"],
        finalSsrStatus: json["final_ssr_status"] == null ? null : json["final_ssr_status"],
        cancellationModes: json["cancellation_modes"] == null ? null : json["cancellation_modes"],
    );

    Map<String, dynamic> toJson() => {
        "response_code": responseCode == null ? null : responseCode,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        // "pnr": pnr == null ? null : pnr!.toJson(),
        "has_insurance": hasInsurance == null ? null : hasInsurance,
        "final_ssr_status": finalSsrStatus == null ? null : finalSsrStatus,
        "cancellation_modes": cancellationModes == null ? null : cancellationModes,
    };
}

// class Pnr {
//     Pnr({
//         this.inbound,
//         this.outbound,
//     });

//     String? inbound;
//     String? outbound;

//     factory Pnr.fromJson(Map<String, dynamic> json) => Pnr(
//         inbound: json["inbound"] == null ? null : json["inbound"],
//         outbound: json["outbound"] == null ? null : json["outbound"],
//     );

//     Map<String, dynamic> toJson() => {
//         "inbound": inbound == null ? null : inbound,
//         "outbound": outbound == null ? null : outbound,
//     };
// }

class BookSidReturn {
    BookSidReturn();

    factory BookSidReturn.fromJson(Map<String, dynamic> json) => BookSidReturn(
    );

    Map<String, dynamic> toJson() => {
    };
}

class FltInfo {
    FltInfo({
        this.segments,
        this.guest,
        this.totalAmt,
        this.fltImage,
        this.transactionType,
        this.redeemPnts,
        this.partialAmt,
        this.bfr,
        this.ttx,
        this.convFees,
    });

    List<Segment>? segments;
    List<Guest>? guest;
    int? totalAmt;
    String? fltImage;
    String? transactionType;
    int? redeemPnts;
    int? partialAmt;
    int? bfr;
    int? ttx;
    int? convFees;

    factory FltInfo.fromJson(Map<String, dynamic> json) => FltInfo(
        segments: json["segments"] == null ? null : List<Segment>.from(json["segments"].map((x) => Segment.fromJson(x))),
        guest: json["guest"] == null ? null : List<Guest>.from(json["guest"].map((x) => Guest.fromJson(x))),
        totalAmt: json["total_amt"] == null ? null : json["total_amt"],
        fltImage: json["flt_image"] == null ? null : json["flt_image"],
        transactionType: json["transaction_type"] == null ? null : json["transaction_type"],
        redeemPnts: json["redeem_pnts"] == null ? null : json["redeem_pnts"],
        partialAmt: json["partial_amt"] == null ? null : json["partial_amt"],
        bfr: json["bfr"] == null ? null : json["bfr"],
        ttx: json["ttx"] == null ? null : json["ttx"],
        convFees: json["conv_fees"] == null ? null : json["conv_fees"],
    );

    Map<String, dynamic> toJson() => {
        "segments": segments == null ? null : List<dynamic>.from(segments!.map((x) => x.toJson())),
        "guest": guest == null ? null : List<dynamic>.from(guest!.map((x) => x.toJson())),
        "total_amt": totalAmt == null ? null : totalAmt,
        "flt_image": fltImage == null ? null : fltImage,
        "transaction_type": transactionType == null ? null : transactionType,
        "redeem_pnts": redeemPnts == null ? null : redeemPnts,
        "partial_amt": partialAmt == null ? null : partialAmt,
        "bfr": bfr == null ? null : bfr,
        "ttx": ttx == null ? null : ttx,
        "conv_fees": convFees == null ? null : convFees,
    };
}

class Guest {
    Guest({
        this.name,
        this.phone,
        this.email,
    });

    String? name;
    String? phone;
    String? email;

    factory Guest.fromJson(Map<String, dynamic> json) => Guest(
        name: json["name"] == null ? null : json["name"],
        phone: json["phone"] == null ? null : json["phone"],
        email: json["email"] == null ? null : json["email"],
    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "phone": phone == null ? null : phone,
        "email": email == null ? null : email,
    };
}

class Segment {
    Segment({
        this.anm,
        this.origin,
        this.dept,
        this.ogct,
        this.dpct,
        this.arvltm,
        this.dptim,
        this.arrvldt,
        this.dptdt,
        this.arrvlterminal,
        this.deptteminal,
        this.jtym,
        this.segmentNo,
        this.fltImage,
        this.fno,
        this.acd,
        this.legOrder,
    });

    String? anm;
    String? origin;
    String? dept;
    String? ogct;
    String? dpct;
    String? arvltm;
    String? dptim;
    String? arrvldt;
    String? dptdt;
    String? arrvlterminal;
    String? deptteminal;
    String? jtym;
    int? segmentNo;
    String? fltImage;
    String? fno;
    String? acd;
    int? legOrder;

    factory Segment.fromJson(Map<String, dynamic> json) => Segment(
        anm: json["anm"] == null ? null : json["anm"],
        origin: json["origin"] == null ? null : json["origin"],
        dept: json["dept"] == null ? null : json["dept"],
        ogct: json["ogct"] == null ? null : json["ogct"],
        dpct: json["dpct"] == null ? null : json["dpct"],
        arvltm: json["arvltm"] == null ? null : json["arvltm"],
        dptim: json["dptim"] == null ? null : json["dptim"],
        arrvldt: json["arrvldt"] == null ? null : json["arrvldt"],
        dptdt: json["dptdt"] == null ? null : json["dptdt"],
        arrvlterminal: json["arrvlterminal"] == null ? null : json["arrvlterminal"],
        deptteminal: json["deptteminal"] == null ? null : json["deptteminal"],
        jtym: json["jtym"] == null ? null : json["jtym"],
        segmentNo: json["segmentNo"] == null ? null : json["segmentNo"],
        fltImage: json["fltImage"] == null ? null : json["fltImage"],
        fno: json["fno"] == null ? null : json["fno"],
        acd: json["acd"] == null ? null : json["acd"],
        legOrder: json["legOrder"] == null ? null : json["legOrder"],
    );

    Map<String, dynamic> toJson() => {
        "anm": anm == null ? null : anm,
        "origin": origin == null ? null : origin,
        "dept": dept == null ? null : dept,
        "ogct": ogct == null ? null : ogct,
        "dpct": dpct == null ? null : dpct,
        "arvltm": arvltm == null ? null : arvltm,
        "dptim": dptim == null ? null : dptim,
        "arrvldt": arrvldt == null ? null : arrvldt,
        "dptdt": dptdt == null ? null : dptdt,
        "arrvlterminal": arrvlterminal == null ? null : arrvlterminal,
        "deptteminal": deptteminal == null ? null : deptteminal,
        "jtym": jtym == null ? null : jtym,
        "segmentNo": segmentNo == null ? null : segmentNo,
        "fltImage": fltImage == null ? null : fltImage,
        "fno": fno == null ? null : fno,
        "acd": acd == null ? null : acd,
        "legOrder": legOrder == null ? null : legOrder,
    };
}
