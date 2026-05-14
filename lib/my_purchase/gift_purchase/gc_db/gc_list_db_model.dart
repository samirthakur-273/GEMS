class GiftCardPurchaseListDbModel {
  int? purchaseId;
  dynamic giftcardpurchaselistdata;

  GiftCardPurchaseListDbModel(this.purchaseId, this.giftcardpurchaselistdata);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': purchaseId,
      'giftPurchasetdata': giftcardpurchaselistdata,
    };
    return map;
  }

  GiftCardPurchaseListDbModel.fromMap(Map<String, dynamic> map) {
    purchaseId = map['id'];
    giftcardpurchaselistdata = map['giftPurchasetdata'];
  }
}
