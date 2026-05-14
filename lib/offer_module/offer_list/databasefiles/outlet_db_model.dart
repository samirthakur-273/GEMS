class OutletDBModel {
  int? id;
  dynamic outletlistdata;

  OutletDBModel(this.id, this.outletlistdata);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'outletlistdata': outletlistdata,
    };
    return map;
  }

  OutletDBModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    outletlistdata = map['outletlistdata'];
  }
}
