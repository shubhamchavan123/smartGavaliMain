import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_gawali/features/category/presentation/screen/category_model.dart';
import 'package:smart_gawali/features/category/presentation/screen/subcategory_model.dart';
import 'package:smart_gawali/features/home/data/model/banner_model.dart';

import '../category/presentation/screen/ChildSubcategoryList.dart';
import '../category/presentation/screen/calcium_mineral_mixture_product_list_model.dart';
import '../category/presentation/screen/calcium_mineral_mixture_product_list_screen.dart';
import '../login/presentation/screen/DynamicFormScreen.dart';
import '../login/presentation/screen/ForgotPasswordScreen.dart';

class ApiService {
  static const String _baseUrl = 'https://sks.sitsolutions.co.in';


  // static const String baseUrl = 'https://sks.sitsolutions.co.in';

  static Uri get updateProfileUrl => Uri.parse('$_baseUrl/update_profile');
  static Uri get addPostUrl => Uri.parse('$_baseUrl/add_post');
  static Uri get viewUserPostUrl => Uri.parse('$_baseUrl/view_user_post');
  static Uri get deletePostUrl => Uri.parse('$_baseUrl/delete_post');
  static Uri get unitListUrl => Uri.parse('$_baseUrl/unit_list');
  static Uri get updatePostUrl => Uri.parse('$_baseUrl/update_post');
  static Uri get orderListUrl => Uri.parse('$_baseUrl/order_list');
  static Uri get doLoginUrl => Uri.parse('$_baseUrl/do_login');
  static Uri get doRegisterUrl => Uri.parse('$_baseUrl/do_register');
  static Uri get productListUrl => Uri.parse('$_baseUrl/product_list');



  static Future<ForgotPasswordResponse?> forgotPassword(String mobile) async {
    final url = Uri.parse('https://sks.sitsolutions.co.in/forgot_password');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'mobile': mobile}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ForgotPasswordResponse.fromJson(data);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>> addView({
    required int userId,
    required String postId,
  }) async {
    try {
      debugPrint('Calling add_view API with userId: $userId, postId: $postId');

      final response = await http.post(
        Uri.parse('$_baseUrl/add_view'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'post_id': postId,
        }),
      );

      debugPrint('add_view API response status: ${response.statusCode}');
      debugPrint('add_view API response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        debugPrint('add_view API success: $responseData');
        return responseData;
      } else {
        throw Exception('Failed to add view: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('add_view API error: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchChildSubcategorie(int subcatId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/child_subcat_list'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'subcat_id': subcatId}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final childResponse = ChildSubcategoryResponse.fromJson(data);

        return childResponse.details.map((e) {
          final bool isRequired = e.required.toLowerCase() == 'yes';
          final options = e.dropdownValues.values.toList();
          final optionMap = e.dropdownValues;

          return {
            'type': e.type,
            'label': e.label,
            'name': e.attribute,
            'required': isRequired,
            'options': options,
            'optionMap': optionMap,
          };
        }).toList();
      } else {
        throw Exception('Failed to fetch child subcategories: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error - fetchChildSubcategories: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAttributeFields(String categoryId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/attribute_list'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'cat_id': int.tryParse(categoryId) ?? 1}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final attributeResponse = AttributeResponse.fromJson(data);

        return attributeResponse.details.map((e) {
          final bool isRequired = e.required.toLowerCase() == 'yes';
          List<String>? options;
          Map<String, String>? optionMap;

          if (e.type == 'dropdown') {
            if (e.dropdownList != null) {
              options = e.dropdownList;
            } else if (e.dropdownMap != null) {
              optionMap = e.dropdownMap;
              options = e.dropdownMap!.values.toList();
            } else {
              options = ['होय', 'नाही'];
            }
          }

          return {
            'type': e.type,
            'label': e.label,
            'name': e.attribute,
            'required': isRequired,
            'options': options,
            'optionMap': optionMap,
            'originalData': e,
          };
        }).toList();
      } else {
        throw Exception('Failed to load attributes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchAttributeFields: $e');
      rethrow;
    }
  }
  /// Fetch category posts using only subcategory (without child subcategory)
  static Future<ViewCategoryPostModel> fetchCategoryPostsBySubcategoryOnly(String subcategoryId) async {
    final url = Uri.parse('$_baseUrl/view_category_post');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'subcategory': subcategoryId}),
      );

      if (response.statusCode == 200) {
        return ViewCategoryPostModel.fromJson(jsonDecode(response.body));
      } else {
        throw HttpException('Failed to load posts. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchCategoryPostsBySubcategoryOnly: $e');
      return ViewCategoryPostModel(status: 'error', message: e.toString(), details: []);
    }
  }


  static Future<CalculationData> fetchPostDetails(String postId) async {
    final url = Uri.parse('https://sks.sitsolutions.co.in/post_details');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'post_id': postId}),
      );

      if (response.statusCode == 200) {
        return CalculationData.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load post details. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching post details: $e');
      throw Exception('Failed to load post details: $e');
    }
  }

  static Future<ViewCategoryPostModel> fetchCategoryPosts(
      String subcategoryId, String? childSubcategoryId) async {
    try {
      final url = Uri.parse('https://sks.sitsolutions.co.in/view_category_post');
      final body = {
        'subcategory': subcategoryId,
        if (childSubcategoryId != null) 'child_subcategory': childSubcategoryId,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return ViewCategoryPostModel.fromJson(jsonDecode(response.body));
      }
      throw Exception('Failed with status ${response.statusCode}');
    } catch (e) {
      print('Error fetching posts: $e');
      return ViewCategoryPostModel(
        status: 'error',
        message: e.toString(),
        details: [],
      );
    }
  }


  static Future<List<ChildSubcategoryModel>> fetchChildSubcategories(String subCatId) async {
    try {
      final url = Uri.parse('https://sks.sitsolutions.co.in/child_subcategory_list');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'subcat_id': subCatId}),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Handle empty response or "Not available" case
        if (jsonData['status'] == 'error' && jsonData['message'] == 'Not available.') {
          return [];
        }

        if (jsonData['status'] == 'success' && jsonData['details'] is List) {
          return (jsonData['details'] as List)
              .where((item) => item != null)
              .map((json) => ChildSubcategoryModel.fromJson(json ?? {}))
              .where((item) => item.isdeleted == "0")
              .toList();
        }
        return [];
      }
      throw Exception('Failed with status ${response.statusCode}');
    } catch (e) {
      print('Error fetching child subcategories: $e');
      return [];
    }
  }
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
