import 'dart:convert';

DetailsFlightModel detailsFlightModelFromJson(String str) =>
    DetailsFlightModel.fromJson(json.decode(str));

String detailsFlightModelToJson(DetailsFlightModel data) =>
    json.encode(data.toJson());

class DetailsFlightModel {
  DetailsFlightModel({
    this.message,
    this.code,
    this.status,
    this.values,
  });

  String? message;
  String? code;
  bool? status;
  Values? values;

  factory DetailsFlightModel.fromJson(Map<String, dynamic> json) =>
      DetailsFlightModel(
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
    this.flightDetail,
    this.flightDetailReturn,
    this.earnRate,
    this.redeemRate,
    this.pgConFee,
    this.totalAmount,
    this.uid,
  });

  List<FlightDetail>? flightDetail;
  List<dynamic>? flightDetailReturn;
  String? uid;
  double? earnRate;
  int? redeemRate;
  var pgConFee;
  var totalAmount;

  factory Values.fromJson(Map<String, dynamic> json) => Values(
        flightDetail: json["flightDetail"] == null
            ? null
            : List<FlightDetail>.from(
                json["flightDetail"].map((x) => FlightDetail.fromJson(x))),
        flightDetailReturn: json["flightDetail_return"] == null
            ? null
            : List<dynamic>.from(json["flightDetail_return"].map((x) => x)),
        uid: json["uid"] == null ? null : json["uid"],
        earnRate:
            json["earn_rate"] == null ? null : json["earn_rate"].toDouble(),
        redeemRate: json["redeem_rate"] == null ? null : json["redeem_rate"],
        pgConFee:
            json["pg_con_fee"] == null ? null : json["pg_con_fee"],
        totalAmount: json["total_amount"] == null
            ? null
            : json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "flightDetail": flightDetail == null
            ? null
            : List<dynamic>.from(flightDetail!.map((x) => x.toJson())),
        "flightDetail_return": flightDetailReturn == null
            ? null
            : List<dynamic>.from(flightDetailReturn!.map((x) => x)),
        "uid": uid == null ? null : uid,
        "earn_rate": earnRate == null ? null : earnRate,
        "redeem_rate": redeemRate == null ? null : redeemRate,
        "pg_con_fee": pgConFee == null ? null : pgConFee,
        "total_amount": totalAmount == null ? null : totalAmount,
      };
}

class FlightDetail {
  FlightDetail({
    this.uid,
    this.supplier,
    this.hky,
    this.id,
    this.rqid,
    this.sid,
    this.btid,
    this.src,
    this.dest,
    this.bfr,
    this.anm,
    this.stp,
    this.tpt,
    this.flt,
    this.jtym,
    this.org,
    this.paDtym,
    this.ref,
    this.ttx,
    this.ccp,
    this.adults,
    this.childs,
    this.infants,
    this.pbAtym,
    this.pbDtym,
    this.paAtym,
    this.fno,
    this.convFee,
    this.totalPrice,
    this.newamount,
    this.oldamount,
    this.breakup,
    this.bnds,
    this.bnzAccrPnts,
    this.bnzReddemPnts,
    this.convRate,
    this.version,
    this.priceChanged,
    this.ismealObjAvailable,
    this.isseatObjAvailable,
    this.isInsuranceObjAvailable,
    // this.commissionRatio,
    // this.totalPayableAmount,
    // this.pgConvFee,
  });

  String? uid;
  String? supplier;
  String? hky;
  String? id;
  String? rqid;
  String? sid;
  int? btid;
  String? src;
  String? dest;
  int? bfr;
  String? anm;
  int? stp;
  int? tpt;
  String? flt;
  int? jtym;
  String? org;
  int? paDtym;
  String? ref;
  int? ttx;
  int? ccp;
  int? adults;
  int? childs;
  int? infants;
  int? pbAtym;
  int? pbDtym;
  int? paAtym;
  int? fno;
  int? convFee;
  int? totalPrice;
  int? newamount;
  int? oldamount;
  String? breakup;
  List<String>? bnds;
  List<int>? bnzAccrPnts;
  List<int>? bnzReddemPnts;
  String? convRate;
  double? version;
  String? priceChanged;
  bool? ismealObjAvailable;
  bool? isseatObjAvailable;
  bool? isInsuranceObjAvailable;
  // int? commissionRatio;
  // double? totalPayableAmount;
  // double? pgConvFee;

  factory FlightDetail.fromJson(Map<String, dynamic> json) => FlightDetail(
        uid: json["uid"] == null ? null : json["uid"],
        supplier: json["supplier"] == null ? null : json["supplier"],
        hky: json["hky"] == null ? null : json["hky"],
        id: json["id"] == null ? null : json["id"],
        rqid: json["rqid"] == null ? null : json["rqid"],
        sid: json["sid"] == null ? null : json["sid"],
        btid: json["btid"] == null ? null : json["btid"],
        src: json["src"] == null ? null : json["src"],
        dest: json["dest"] == null ? null : json["dest"],
        bfr: json["bfr"] == null ? null : json["bfr"],
        anm: json["anm"] == null ? null : json["anm"],
        stp: json["stp"] == null ? null : json["stp"],
        tpt: json["tpt"] == null ? null : json["tpt"],
        flt: json["flt"] == null ? null : json["flt"],
        jtym: json["jtym"] == null ? null : json["jtym"],
        org: json["org"] == null ? null : json["org"],
        paDtym: json["pa_dtym"] == null ? null : json["pa_dtym"],
        ref: json["ref"] == null ? null : json["ref"],
        ttx: json["ttx"] == null ? null : json["ttx"],
        ccp: json["ccp"] == null ? null : json["ccp"],
        adults: json["adults"] == null ? null : json["adults"],
        childs: json["childs"] == null ? null : json["childs"],
        infants: json["infants"] == null ? null : json["infants"],
        pbAtym: json["pb_atym"] == null ? null : json["pb_atym"],
        pbDtym: json["pb_dtym"] == null ? null : json["pb_dtym"],
        paAtym: json["pa_atym"] == null ? null : json["pa_atym"],
        fno: json["fno"] == null ? null : json["fno"],
        convFee: json["conv_fee"] == null ? null : json["conv_fee"],
        newamount: json["newamount"] == null ? null : json["newamount"],
        oldamount: json["oldamount"] == null ? null : json["oldamount"],
        totalPrice: json["totalPrice"] == null ? null : json["totalPrice"],
        breakup: json["breakup"] == null ? null : json["breakup"],
        bnds: json["bnds"] == null
            ? null
            : List<String>.from(json["bnds"].map((x) => x)),
        bnzAccrPnts: json["bnz_accr_pnts"] == null
            ? null
            : List<int>.from(json["bnz_accr_pnts"].map((x) => x)),
        bnzReddemPnts: json["bnz_reddem_pnts"] == null
            ? null
            : List<int>.from(json["bnz_reddem_pnts"].map((x) => x)),
        convRate: json["convRate"] == null ? null : json["convRate"],
        version:
            json["_version_"] == null ? null : json["_version_"].toDouble(),
        priceChanged:
            json["price_changed"] == null ? null : json["price_changed"],
        ismealObjAvailable: json["ismealObjAvailable"] == null
            ? null
            : json["ismealObjAvailable"],
        isseatObjAvailable: json["isseatObjAvailable"] == null
            ? null
            : json["isseatObjAvailable"],
        isInsuranceObjAvailable: json["isInsuranceObjAvailable"] == null
            ? null
            : json["isInsuranceObjAvailable"],
        // commissionRatio:
        //     json["commission_ratio"] == null ? null : json["commission_ratio"],
        // totalPayableAmount: json["total_payable_amount"] == null
        //     ? null
        //     : json["total_payable_amount"].toDouble(),
        // pgConvFee:
        //     json["pg_conv_fee"] == null ? null : json["pg_conv_fee"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid == null ? null : uid,
        "supplier": supplier == null ? null : supplier,
        "hky": hky == null ? null : hky,
        "id": id == null ? null : id,
        "rqid": rqid == null ? null : rqid,
        "sid": sid == null ? null : sid,
        "btid": btid == null ? null : btid,
        "src": src == null ? null : src,
        "dest": dest == null ? null : dest,
        "bfr": bfr == null ? null : bfr,
        "anm": anm == null ? null : anm,
        "stp": stp == null ? null : stp,
        "tpt": tpt == null ? null : tpt,
        "flt": flt == null ? null : flt,
        "jtym": jtym == null ? null : jtym,
        "org": org == null ? null : org,
        "pa_dtym": paDtym == null ? null : paDtym,
        "ref": ref == null ? null : ref,
        "ttx": ttx == null ? null : ttx,
        "ccp": ccp == null ? null : ccp,
        "adults": adults == null ? null : adults,
        "childs": childs == null ? null : childs,
        "infants": infants == null ? null : infants,
        "pb_atym": pbAtym == null ? null : pbAtym,
        "pb_dtym": pbDtym == null ? null : pbDtym,
        "pa_atym": paAtym == null ? null : paAtym,
        "fno": fno == null ? null : fno,
        "conv_fee": convFee == null ? null : convFee,
        "newamount": newamount == null ? null : newamount,
        "oldamount": oldamount == null ? null : oldamount,
        "totalPrice": totalPrice == null ? null : totalPrice,
        "breakup": breakup == null ? null : breakup,
        "bnds": bnds == null ? null : List<dynamic>.from(bnds!.map((x) => x)),
        "bnz_accr_pnts": bnzAccrPnts == null
            ? null
            : List<dynamic>.from(bnzAccrPnts!.map((x) => x)),
        "bnz_reddem_pnts": bnzReddemPnts == null
            ? null
            : List<dynamic>.from(bnzReddemPnts!.map((x) => x)),
        "convRate": convRate == null ? null : convRate,
        "_version_": version == null ? null : version,
        "price_changed": priceChanged == null ? null : priceChanged,
        "ismealObjAvailable":
            ismealObjAvailable == null ? null : ismealObjAvailable,
        "isseatObjAvailable":
            isseatObjAvailable == null ? null : isseatObjAvailable,
        "isInsuranceObjAvailable":
            isInsuranceObjAvailable == null ? null : isInsuranceObjAvailable,
        // "commission_ratio": commissionRatio == null ? null : commissionRatio,
        // "total_payable_amount":
        //     totalPayableAmount == null ? null : totalPayableAmount,
        // "pg_conv_fee": pgConvFee == null ? null : pgConvFee,
      };
}