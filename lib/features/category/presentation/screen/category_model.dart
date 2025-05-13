import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    required this.details,
    required this.message,
    required this.status,
  });

  List<CategoryDetail> details;
  String message;
  String status;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        details: List<CategoryDetail>.from(
            json["details"].map((x) => CategoryDetail.fromJson(x))),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
        "message": message,
        "status": status,
      };
}

class CategoryDetail {
  CategoryDetail({
    required this.createdAt,
    this.image,
    required this.id,
    required this.category,
    required this.isDeleted,
  });

  DateTime createdAt;
  String? image;
  String id;
  String category;
  String isDeleted;

  factory CategoryDetail.fromJson(Map<String, dynamic> json) => CategoryDetail(
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
        image: json["image"],
        category: json["category"],
        isDeleted: json["isdeleted"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt.toIso8601String(),
        "id": id,
        "image": image,
        "category": category,
        "isdeleted": isDeleted,
      };
}
