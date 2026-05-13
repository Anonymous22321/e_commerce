class UserModel {
  String? userId, username, email, pic;

  UserModel({this.userId, this.username, this.email, this.pic});

  UserModel.fromJson(Map<String, dynamic>? userMap) {
    if (userMap == null) {
      return;
    }
    userId = userMap["userId"];
    username = userMap["username"];
    email = userMap["email"];
    pic = userMap["pic"]??"";
  }

  Map<String, dynamic> toJson() {
    return {"userId": userId, "username": username, "email": email, "pic": pic};
  }
}
