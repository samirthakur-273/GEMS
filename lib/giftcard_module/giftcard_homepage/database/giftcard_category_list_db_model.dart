class GiftCardCategoryListDbModel {
  int? id;
  dynamic giftcategorylistdata;

  GiftCardCategoryListDbModel(this.id, this.giftcategorylistdata);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'giftcategorylistdata': giftcategorylistdata,
    };
    return map;
  }

  GiftCardCategoryListDbModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    giftcategorylistdata = map['giftcategorylistdata'];
  }
}
