class HomePageDbModel {
  int? id;
  dynamic homepagedata;

  HomePageDbModel(this.id, this.homepagedata);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'homepagedata': homepagedata,
    };
    return map;
  }

  HomePageDbModel.fromMap(Map<String, dynamic> map) {
     id = map['id'];
    homepagedata = map['homepagedata'];
  }
}