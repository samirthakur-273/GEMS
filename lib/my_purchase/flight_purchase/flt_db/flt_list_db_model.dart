class FLTPurchaseListDbModel {
  int? purchaseId;
  dynamic fltpurchaselistdata;

  FLTPurchaseListDbModel(this.purchaseId, this.fltpurchaselistdata);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': purchaseId,
      'fltPurchasetdata': fltpurchaselistdata,
    };
    return map;
  }

  FLTPurchaseListDbModel.fromMap(Map<String, dynamic> map) {
    purchaseId = map['id'];
    fltpurchaselistdata = map['fltPurchasetdata'];
  }
}
