class MyProfileDataModel {
  int? id;
  dynamic profiledata;

  MyProfileDataModel(this.id, this.profiledata);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'profiledata': profiledata,
    };
    return map;
  }

  MyProfileDataModel.fromMap(Map<dynamic, dynamic> map) {
     id = map['id'];
    profiledata = map['profiledata'];
  }
}