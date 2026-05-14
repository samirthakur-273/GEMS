class MyWishListDbModel {
  int? id;
  dynamic mywishlistdata;

  MyWishListDbModel(this.id, this.mywishlistdata);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'mywishlistdata': mywishlistdata,
    };
    return map;
  }

  MyWishListDbModel.fromMap(Map<String, dynamic> map) {
     id = map['id'];
    mywishlistdata = map['mywishlistdata'];
  }
}