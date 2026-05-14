class MasterListDBModel {
  int? id;
  dynamic masterlistdata;

  MasterListDBModel(this.id, this.masterlistdata);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'masterlistdata': masterlistdata,
    };
    return map;
  }

  MasterListDBModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    masterlistdata = map['masterlistdata'];
  }
}
