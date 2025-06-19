import 'dart:convert';

PostCategoryModel postCategoryModelFromJson(String str) =>
    PostCategoryModel.fromJson(json.decode(str));

String postCategoryModelToJson(PostCategoryModel data) =>
    json.encode(data.toJson());

class PostCategoryModel {
  String status;
  String message;
  List<PostCategoryDetail> details;

  PostCategoryModel({
    required this.status,
    required this.message,
    required this.details,
  });

  factory PostCategoryModel.fromJson(Map<String, dynamic> json) =>
      PostCategoryModel(
        status: json["status"],
        message: json["message"],
        details: List<PostCategoryDetail>.from(
            json["details"].map((x) => PostCategoryDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "details": List<dynamic>.from(details.map((x) => x.toJson())),
  };
}

class PostCategoryDetail {
  String id;
  String category;
  String isAdminProduct;
  String image;
  String isDeleted;
  DateTime createdAt;

  PostCategoryDetail({
    required this.id,
    required this.category,
    required this.isAdminProduct,
    required this.image,
    required this.isDeleted,
    required this.createdAt,
  });

  factory PostCategoryDetail.fromJson(Map<String, dynamic> json) =>
      PostCategoryDetail(
        id: json["id"],
        category: json["category"],
        isAdminProduct: json["is_admin_product"],
        image: json["image"],
        isDeleted: json["isdeleted"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "is_admin_product": isAdminProduct,
    "image": image,
    "isdeleted": isDeleted,
    "created_at": createdAt.toIso8601String(),
  };
}
