class UserProfileDbModel {
  int? id;
  dynamic userprofiledata;

  UserProfileDbModel(this.id, this.userprofiledata);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'userprofiledata': userprofiledata,
    };
    return map;
  }

  UserProfileDbModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    userprofiledata = map['userprofiledata'];
  }
}
