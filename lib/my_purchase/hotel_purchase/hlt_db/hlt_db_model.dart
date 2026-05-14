class HotelPurchaseListDbModel {
  int? purchaseId;
  dynamic hotelspurchaselistdata;

  HotelPurchaseListDbModel(this.purchaseId, this.hotelspurchaselistdata);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': purchaseId,
      'hotelPurchasetdata': hotelspurchaselistdata,
    };
    return map;
  }

  HotelPurchaseListDbModel.fromMap(Map<String, dynamic> map) {
    purchaseId = map['id'];
    hotelspurchaselistdata = map['hotelPurchasetdata'];
  }
}
