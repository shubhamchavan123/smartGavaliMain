/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    LoginModel({
         this.details,
         this.message,
         this.status,
    });

    Details? details;
    String ?message;
    String ?status;

    factory LoginModel.fromJson(Map<dynamic, dynamic> json) => LoginModel(
        details: Details.fromJson(json["details"]),
        message: json["message"],
        status: json["status"],
    );

    Map<dynamic, dynamic> toJson() => {
        "details": details?.toJson(),
        "message": message,
        "status": status,
    };
}

class Details {
    Details({
         this.password,
         this.userType,
         this.name,
         this.mobile,
         this.createdAt,
         this.id,
         this.isdeleted,
         this.username,
    });

    String? password;
    String ?userType;
    String ?name;
    String ?mobile;
    DateTime? createdAt;
    String ?id;
    String ?isdeleted;
    String ?username;

    factory Details.fromJson(Map<dynamic, dynamic> json) => Details(
        password: json["password"],
        userType: json["user_type"],
        name: json["name"],
        mobile: json["mobile"],
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
        isdeleted: json["isdeleted"],
        username: json["username"],
    );

    Map<dynamic, dynamic> toJson() => {
        "password": password,
        "user_type": userType,
        "name": name,
        "mobile": mobile,
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "isdeleted": isdeleted,
        "username": username,
    };
}
