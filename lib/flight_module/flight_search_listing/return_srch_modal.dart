// To parse this JSON data, do
//
//     final returnSearchListModal = returnSearchListModalFromJson(jsonString);

import 'dart:convert';

ReturnSearchListModal returnSearchListModalFromJson(String str) =>
    ReturnSearchListModal.fromJson(json.decode(str));

String returnSearchListModalToJson(ReturnSearchListModal data) =>
    json.encode(data.toJson());

class ReturnSearchListModal {
  ReturnSearchListModal({
    this.message,
    this.code,
    this.status,
    this.values,
  });

  String? message;
  String? code;
  bool? status;
  Values? values;

  factory ReturnSearchListModal.fromJson(Map<String, dynamic> json) =>
      ReturnSearchListModal(
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
    this.flightsData,
    this.flightsMenu,
    this.type,
  });

  List<FlightsDatum>? flightsData;
  FlightsMenu? flightsMenu;
  int? type;

  factory Values.fromJson(Map<String, dynamic> json) => Values(
        flightsData: json["flightsData"] == null
            ? null
            : List<FlightsDatum>.from(
                json["flightsData"].map((x) => FlightsDatum.fromJson(x))),
        flightsMenu: json["flightsMenu"] == null
            ? null
            : FlightsMenu.fromJson(json["flightsMenu"]),
        type: json["type"] == null ? null : json["type"],
      );

  Map<String, dynamic> toJson() => {
        "flightsData": flightsData == null
            ? null
            : List<dynamic>.from(flightsData!.map((x) => x.toJson())),
        "flightsMenu": flightsMenu == null ? null : flightsMenu!.toJson(),
        "type": type == null ? null : type,
      };
}

class FlightsDatum {
  FlightsDatum({
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
    this.ssDetails,
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
    this.breakup,
    this.bnds,
    this.convRate,
    this.bnzAccrPnts,
    this.bnzReddemPnts,
    this.version,
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
  String? ssDetails;
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
  String? breakup;
  List<String>? bnds;
  String? convRate;
  List<int>? bnzAccrPnts;
  List<int>? bnzReddemPnts;
  double? version;

  factory FlightsDatum.fromJson(Map<String, dynamic> json) => FlightsDatum(
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
        ssDetails: json["SSDetails"] == null ? null : json["SSDetails"],
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
        totalPrice: json["totalPrice"] == null ? null : json["totalPrice"],
        breakup: json["breakup"] == null ? null : json["breakup"],
        bnds: json["bnds"] == null
            ? null
            : List<String>.from(json["bnds"].map((x) => x)),
        convRate: json["convRate"] == null ? null : json["convRate"],
        bnzAccrPnts: json["bnz_accr_pnts"] == null
            ? null
            : List<int>.from(json["bnz_accr_pnts"].map((x) => x)),
        bnzReddemPnts: json["bnz_reddem_pnts"] == null
            ? null
            : List<int>.from(json["bnz_reddem_pnts"].map((x) => x)),
        version:
            json["_version_"] == null ? null : json["_version_"].toDouble(),
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
        "SSDetails": ssDetails == null ? null : ssDetails,
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
        "totalPrice": totalPrice == null ? null : totalPrice,
        "breakup": breakup == null ? null : breakup,
        "bnds": bnds == null ? null : List<dynamic>.from(bnds!.map((x) => x)),
        "convRate": convRate == null ? null : convRate,
        "bnz_accr_pnts": bnzAccrPnts == null
            ? null
            : List<dynamic>.from(bnzAccrPnts!.map((x) => x)),
        "bnz_reddem_pnts": bnzReddemPnts == null
            ? null
            : List<dynamic>.from(bnzReddemPnts!.map((x) => x)),
        "_version_": version == null ? null : version,
      };
}

class FlightsMenu {
  FlightsMenu({
    this.normal,
    this.domReturn,
    this.searchCode,
  });

  DomReturn? normal;
  DomReturn? domReturn;
  String? searchCode;

  factory FlightsMenu.fromJson(Map<String, dynamic> json) => FlightsMenu(
        normal:
            json["normal"] == null ? null : DomReturn.fromJson(json["normal"]),
        domReturn: json["dom_return"] == null
            ? null
            : DomReturn.fromJson(json["dom_return"]),
        searchCode: json["search_code"] == null ? null : json["search_code"],
      );

  Map<String, dynamic> toJson() => {
        "normal": normal == null ? null : normal!.toJson(),
        "dom_return": domReturn == null ? null : domReturn!.toJson(),
        "search_code": searchCode == null ? null : searchCode,
      };
}

class DomReturn {
  DomReturn({
    this.pivot,
    this.stats,
  });

  Pivot? pivot;
  DomReturnStats? stats;

  factory DomReturn.fromJson(Map<String, dynamic> json) => DomReturn(
        pivot: json["pivot"] == null ? null : Pivot.fromJson(json["pivot"]),
        stats: json["stats"] == null
            ? null
            : DomReturnStats.fromJson(json["stats"]),
      );

  Map<String, dynamic> toJson() => {
        "pivot": pivot == null ? null : pivot!.toJson(),
        "stats": stats == null ? null : stats!.toJson(),
      };
}

class Pivot {
  Pivot({
    this.anm,
    this.stp,
    this.org,
    this.btid,
  });

  List<Anm>? anm;
  List<Btid>? stp;
  List<Anm>? org;
  List<Btid>? btid;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        anm: json["anm"] == null
            ? null
            : List<Anm>.from(json["anm"].map((x) => Anm.fromJson(x))),
        stp: json["stp"] == null
            ? null
            : List<Btid>.from(json["stp"].map((x) => Btid.fromJson(x))),
        org: json["org"] == null
            ? null
            : List<Anm>.from(json["org"].map((x) => Anm.fromJson(x))),
        btid: json["btid"] == null
            ? null
            : List<Btid>.from(json["btid"].map((x) => Btid.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "anm": anm == null
            ? null
            : List<dynamic>.from(anm!.map((x) => x.toJson())),
        "stp": stp == null
            ? null
            : List<dynamic>.from(stp!.map((x) => x.toJson())),
        "org": org == null
            ? null
            : List<dynamic>.from(org!.map((x) => x.toJson())),
        "btid": btid == null
            ? null
            : List<dynamic>.from(btid!.map((x) => x.toJson())),
      };
}

class Anm {
  Anm({
    this.field,
    this.value,
    this.count,
    this.stats,
  });

  String? field;
  String? value;
  int? count;
  AnmStats? stats;

  factory Anm.fromJson(Map<String, dynamic> json) => Anm(
        field: json["field"] == null ? null : json["field"],
        value: json["value"] == null ? null : json["value"],
        count: json["count"] == null ? null : json["count"],
        stats: json["stats"] == null ? null : AnmStats.fromJson(json["stats"]),
      );

  Map<String, dynamic> toJson() => {
        "field": field == null ? null : field,
        "value": value == null ? null : value,
        "count": count == null ? null : count,
        "stats": stats == null ? null : stats!.toJson(),
      };
}

class AnmStats {
  AnmStats({
    this.statsFields,
  });

  StatsFields? statsFields;

  factory AnmStats.fromJson(Map<String, dynamic> json) => AnmStats(
        statsFields: json["stats_fields"] == null
            ? null
            : StatsFields.fromJson(json["stats_fields"]),
      );

  Map<String, dynamic> toJson() => {
        "stats_fields": statsFields == null ? null : statsFields!.toJson(),
      };
}

class StatsFields {
  StatsFields({
    this.bfr,
    this.totalPrice,
  });

  Bfr? bfr;
  Bfr? totalPrice;

  factory StatsFields.fromJson(Map<String, dynamic> json) => StatsFields(
        bfr: json["bfr"] == null ? null : Bfr.fromJson(json["bfr"]),
        totalPrice: json["totalPrice"] == null
            ? null
            : Bfr.fromJson(json["totalPrice"]),
      );

  Map<String, dynamic> toJson() => {
        "bfr": bfr == null ? null : bfr!.toJson(),
        "totalPrice": totalPrice == null ? null : totalPrice!.toJson(),
      };
}

class Bfr {
  Bfr({
    this.min,
    this.max,
  });

  int? min;
  int? max;

  factory Bfr.fromJson(Map<String, dynamic> json) => Bfr(
        min: json["min"] == null ? null : json["min"],
        max: json["max"] == null ? null : json["max"],
      );

  Map<String, dynamic> toJson() => {
        "min": min == null ? null : min,
        "max": max == null ? null : max,
      };
}

class Btid {
  Btid({
    this.field,
    this.value,
    this.count,
  });

  String? field;
  int? value;
  int? count;

  factory Btid.fromJson(Map<String, dynamic> json) => Btid(
        field: json["field"] == null ? null : json["field"],
        value: json["value"] == null ? null : json["value"],
        count: json["count"] == null ? null : json["count"],
      );

  Map<String, dynamic> toJson() => {
        "field": field == null ? null : field,
        "value": value == null ? null : value,
        "count": count == null ? null : count,
      };
}

class DomReturnStats {
  DomReturnStats({
    this.bfr,
    this.totalPrice,
    this.jtym,
  });

  Bfr? bfr;
  Bfr? totalPrice;
  Jtym? jtym;

  factory DomReturnStats.fromJson(Map<String, dynamic> json) => DomReturnStats(
        bfr: json["bfr"] == null ? null : Bfr.fromJson(json["bfr"]),
        totalPrice: json["totalPrice"] == null
            ? null
            : Bfr.fromJson(json["totalPrice"]),
        jtym: json["jtym"] == null ? null : Jtym.fromJson(json["jtym"]),
      );

  Map<String, dynamic> toJson() => {
        "bfr": bfr == null ? null : bfr!.toJson(),
        "totalPrice": totalPrice == null ? null : totalPrice!.toJson(),
        "jtym": jtym == null ? null : jtym!.toJson(),
      };
}

class Jtym {
  Jtym({
    this.min,
    this.max,
    this.count,
    this.missing,
    this.sum,
    this.sumOfSquares,
    this.mean,
    this.stddev,
  });

  int? min;
  int? max;
  int? count;
  int? missing;
  int? sum;
  int? sumOfSquares;
  double? mean;
  double? stddev;

  factory Jtym.fromJson(Map<String, dynamic> json) => Jtym(
        min: json["min"] == null ? null : json["min"],
        max: json["max"] == null ? null : json["max"],
        count: json["count"] == null ? null : json["count"],
        missing: json["missing"] == null ? null : json["missing"],
        sum: json["sum"] == null ? null : json["sum"],
        sumOfSquares:
            json["sumOfSquares"] == null ? null : json["sumOfSquares"],
        mean: json["mean"] == null ? null : json["mean"].toDouble(),
        stddev: json["stddev"] == null ? null : json["stddev"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "min": min == null ? null : min,
        "max": max == null ? null : max,
        "count": count == null ? null : count,
        "missing": missing == null ? null : missing,
        "sum": sum == null ? null : sum,
        "sumOfSquares": sumOfSquares == null ? null : sumOfSquares,
        "mean": mean == null ? null : mean,
        "stddev": stddev == null ? null : stddev,
      };
}
