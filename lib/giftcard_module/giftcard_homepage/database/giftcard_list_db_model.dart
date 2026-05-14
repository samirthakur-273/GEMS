class GiftCardListDbModel {
  int? id;
  dynamic giftlistdata;

  GiftCardListDbModel(this.id, this.giftlistdata);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'giftlistdata': giftlistdata,
    };
    return map;
  }

  GiftCardListDbModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    giftlistdata = map['giftlistdata'];
  }
}
