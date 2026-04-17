import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.userId,
    this.roleId,
    this.userName,
    this.userEmail,
    this.userMob,
    this.userPermission,
    this.userPswd,
  });

  String? userId;
  String? roleId;
  String? userName;
  String? userEmail;
  String? userMob;
  String? userPermission;
  String? userPswd;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        roleId: json["role_id"],
        userName: json["user_name"],
        userEmail: json["user_email"],
        userMob: json["user_mob"],
        userPermission: json["user_permission"],
        userPswd: json["user_pswd"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "role_id": roleId,
        "user_name": userName,
        "user_email": userEmail,
        "user_mob": userMob,
        "user_permission": userPermission,
        "user_pswd": userPswd,
      };
}
