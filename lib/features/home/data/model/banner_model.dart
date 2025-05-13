/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

BannerModel bannerModelFromJson(String str) => BannerModel.fromJson(json.decode(str));

String bannerModelToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
    BannerModel({
        required this.details,
        required this.message,
        required this.status,
    });

    List<Detail> details;
    String message;
    String status;

    factory BannerModel.fromJson(Map<dynamic, dynamic> json) => BannerModel(
        details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<dynamic, dynamic> toJson() => {
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class Detail {
    Detail({
        required this.image,
        required this.name,
        required this.createdAt,
        required this.id,
        required this.type,
        required this.isdeleted,
    });

    String image;
    String name;
    DateTime createdAt;
    String id;
    String type;
    String isdeleted;

    factory Detail.fromJson(Map<dynamic, dynamic> json) => Detail(
        image: json["image"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
        type: json["type"],
        isdeleted: json["isdeleted"],
    );

    Map<dynamic, dynamic> toJson() => {
        "image": image,
        "name": name,
        "created_at": createdAt.toIso8601String(),
        "id": id,
        "type": type,
        "isdeleted": isdeleted,
    };
}
