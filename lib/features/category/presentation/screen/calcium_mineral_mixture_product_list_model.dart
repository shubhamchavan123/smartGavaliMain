class CalciumMineralMixtureProductListModel {
  final String id;
  final String catId;
  final String subcatId;
  final String name;
  final String image;
  final String description;
  final String price;
  final String quantity;
  final String expiryDate;
  final String weight;
  final String unit;
  final String isdeleted;
  final String createdAt;

  CalciumMineralMixtureProductListModel({
    required this.id,
    required this.catId,
    required this.subcatId,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.quantity,
    required this.expiryDate,
    required this.weight,
    required this.unit,
    required this.isdeleted,
    required this.createdAt,
  });

  factory CalciumMineralMixtureProductListModel.fromJson(Map<String, dynamic> json) {
    return CalciumMineralMixtureProductListModel(
      id: json['id'],
      catId: json['cat_id'],
      subcatId: json['subcat_id'],
      name: json['name'],
      image: json['image'],
      description: json['description'],
      price: json['price'],
      quantity: json['quantity'],
      expiryDate: json['expiry_date'],
      weight: json['weight'],
      unit: json['unit'],
      isdeleted: json['isdeleted'],
      createdAt: json['created_at'],
    );
  }
}
