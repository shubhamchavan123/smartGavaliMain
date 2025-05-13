import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_gawali/features/category/presentation/screen/category_model.dart';
import 'package:smart_gawali/features/category/presentation/screen/subcategory_model.dart';
import 'package:smart_gawali/features/home/data/model/banner_model.dart';

import '../category/presentation/screen/calcium_mineral_mixture_product_list_model.dart';
import '../category/presentation/screen/calcium_mineral_mixture_product_list_screen.dart';

class ApiService {
  static const String _baseUrl = 'https://sks.sitsolutions.co.in';


  // static const String baseUrl = 'https://sks.sitsolutions.co.in';

  // Method to place an order
  Future<String> placeOrder(
      List<CalciumMineralMixtureProductListModel> productList,
      Map<String, int> quantities,
      ) async {
    try {
      // Get SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();

      // Retrieve saved user_id
      final userId = prefs.getString('user_id') ?? '0';
      print("Saved user_id: $userId"); // Debug print to confirm value

      // Prepare product data for API
      List<Map<String, dynamic>> productJson = productList.map((product) {
        return {
          "product_id": product.id,
          "quantity": quantities[product.id] ?? 0,
        };
      }).toList();

      // Make HTTP POST request
      final response = await http.post(
        Uri.parse("$_baseUrl/place_order"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          "product": productJson,
          "user_id": int.parse(userId), // Use retrieved user ID
          "order_type": "Cash On Delivery",
        }),
      );

      // Debug: Print full API response
      print('API Response: ${response.body}');

      // Handle success
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonresponse = jsonDecode(response.body);
        if (jsonresponse['status'] == "success") {
          return jsonresponse["message"];
        }
      }
      // Handle client/server errors
      else if (response.statusCode == 400 || response.statusCode == 401) {
        final jsonresponse = jsonDecode(response.body);
        return jsonresponse['errors'] ?? jsonresponse['message'] ?? "Unknown error";
      }
    } catch (e) {
      print('Exception: $e');
      return "Error occurred while placing the order: $e";
    }

    return "Verification failed";
  }


  // Method to fetch product list
  static Future<List<CalciumMineralMixtureProductListModel>> fetchProducts(String subCatId) async {
    final response = await http.get(Uri.parse('$_baseUrl/product_list'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List products = jsonData["details"];

      return products
          .map((item) => CalciumMineralMixtureProductListModel.fromJson(item))
          .where((p) => p.subcatId == subCatId && p.isdeleted == "0")
          .toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Method to fetch product details
  static Future<ProductDetails> fetchProductDetails(String productId) async {
    final url = Uri.parse('$_baseUrl/product_details');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'product_id': productId}),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ProductDetails.fromJson(jsonData['details']);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  /// Fetch categories
  static Future<List<CategoryDetail>> fetchCategories() async {
    final url = Uri.parse('$_baseUrl/category_list');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final categoryModel = categoryModelFromJson(response.body);
        return categoryModel.details
            .where((cat) => cat.isDeleted == "0")
            .toList(); // Optional: filter active categories only
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  /// Fetch subcategories for a given category ID
  static Future<List<Details>> fetchSubCategories(String categoryId) async {
    final url = Uri.parse('$_baseUrl/subcategory_list');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'cat_id': categoryId}), // confirm it's 'cat_id'
      );

      if (response.statusCode == 200) {
        final subCategoryModel = subcategoryModelFromJson(response.body);
        return subCategoryModel.details
            .where((sub) => sub.isdeleted == "0")
            .toList(); // Optional: filter active subcategories
      } else {
        throw Exception('Failed to fetch subcategories');
      }
    } catch (e) {
      throw Exception('Error fetching subcategories: $e');
    }
  }

  /// Fetch banners or advertisements
  static Future<List<String>> fetchBannerImages(String type) async {
    final url = Uri.parse('$_baseUrl/banner_list');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'type': type}),
      );

      if (response.statusCode == 200) {
        final bannerModel = bannerModelFromJson(response.body);
        return bannerModel.details.map((e) => e.image).toList();
      } else {
        throw Exception('Failed to fetch $type banners');
      }
    } catch (e) {
      throw Exception('Error fetching $type banners: $e');
    }
  }
}
