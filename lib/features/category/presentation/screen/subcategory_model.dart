/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

// SubcategoryModel subcategoryModelFromJson(String str) => SubcategoryModel.fromJson(json.decode(str));
//
// String subcategoryModelToJson(SubcategoryModel data) => json.encode(data.toJson());
//
// class SubcategoryModel {
//     SubcategoryModel({
//         required this.details,
//         required this.message,
//         required this.status,
//     });
//
//     List<Details> details;
//     String message;
//     String status;
//
//     factory SubcategoryModel.fromJson(Map<dynamic, dynamic> json) => SubcategoryModel(
//         details: List<Details>.from(json["details"].map((x) => Details.fromJson(x))),
//         message: json["message"],
//         status: json["status"],
//     );
//
//     Map<dynamic, dynamic> toJson() => {
//         "details": List<dynamic>.from(details.map((x) => x.toJson())),
//         "message": message,
//         "status": status,
//     };
// }
//
// class Details {
//     Details({
//         this.image, // now nullable
//         required this.catId,
//         required this.createdAt,
//         required this.id,
//         required this.subcategory,
//         required this.isdeleted,
//     });
//
//     String? image; // changed from String to String?
//     String catId;
//     DateTime createdAt;
//     String id;
//     String subcategory;
//     String isdeleted;
//
//     factory Details.fromJson(Map<dynamic, dynamic> json) => Details(
//         image: json["image"],
//         catId: json["cat_id"],
//         createdAt: DateTime.parse(json["created_at"]),
//         id: json["id"],
//         subcategory: json["subcategory"],
//         isdeleted: json["isdeleted"],
//     );
//
//     Map<dynamic, dynamic> toJson() => {
//         "image": image,
//         "cat_id": catId,
//         "created_at": createdAt.toIso8601String(),
//         "id": id,
//         "subcategory": subcategory,
//         "isdeleted": isdeleted,
//     };
// }
import 'dart:convert';

SubcategoryModel subcategoryModelFromJson(String str) =>
    SubcategoryModel.fromJson(json.decode(str));

String subcategoryModelToJson(SubcategoryModel data) =>
    json.encode(data.toJson());

class SubcategoryModel {
    SubcategoryModel({
        required this.details,
        required this.message,
        required this.status,
    });

    List<Details> details;
    String message;
    String status;

    factory SubcategoryModel.fromJson(Map<String, dynamic> json) =>
        SubcategoryModel(
            details: List<Details>.from(
                json["details"].map((x) => Details.fromJson(x))),
            message: json["message"],
            status: json["status"],
        );

    Map<String, dynamic> toJson() => {
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class Details {
    Details({
        this.image,
        required this.catId,
        required this.createdAt,
        required this.id,
        required this.subcategory,
        required this.isdeleted,
        required this.isAdminProduct,
    });

    String? image;
    String catId;
    DateTime createdAt;
    String id;
    String subcategory;
    String isdeleted;
    String isAdminProduct;

    factory Details.fromJson(Map<String, dynamic> json) => Details(
        image: json["image"],
        catId: json["cat_id"],
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
        subcategory: json["subcategory"],
        isdeleted: json["isdeleted"],
        isAdminProduct: json["is_admin_product"],
    );

    Map<String, dynamic> toJson() => {
        "image": image,
        "cat_id": catId,
        "created_at": createdAt.toIso8601String(),
        "id": id,
        "subcategory": subcategory,
        "isdeleted": isdeleted,
        "is_admin_product": isAdminProduct,
    };
}
