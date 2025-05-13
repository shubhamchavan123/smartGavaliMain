// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;
// import 'package:smart_gawali/core/error_handaling/custom_exception.dart';
//
// import 'package:smart_gawali/networking_model/api_base_model/uri_builder.dart';
// import 'package:smart_gawali/networking_model/network_data_source/network_data_source.dart';
//
//
//
//
//
// class NetworkDataRepo implements NetworkDataSource {
//   var uriBuilder = URIBuilder();
//
//   /// Login
//
//   @override
//   Future<http.Response> getLoginSource({required LoginRequestModel requestBody,
//     required http.Client httpClient}) async {
//     try {
//       var uri = uriBuilder.getLoginUrl();
//       var data = '';
//       var header = uriBuilder.getApiEndPointHeaderContentType();
//       data = json.encode(requestBody);
//       var response = await http.post(uri, body: data, headers: header);
//        return response;
//     } on TimeOutException catch (e) {
//        rethrow;
//     } on Exception catch (e) {
//        rethrow;
//     }
//   }
//
//   /// update fcm token
//
//   Future<http.Response> getUpdateFCMSource({required UpdateFCMTokenRequestModel requestBody,
//     required http.Client httpClient}) async {
//     try {
//       var uri = uriBuilder.getUpdateFCMUrl();
//       var data = '';
//       var header = uriBuilder.getApiEndPointHeaderContentType();
//       data = json.encode(requestBody);
//       var response = await http.post(uri, body: data, headers: header);
//       debugPrint('NetworkDataRepo  Update response: ${response.body}');
//       return response;
//     } on TimeOutException catch (e) {
//       debugPrint('Timed out $e');
//       rethrow;
//     } on Exception catch (e) {
//       debugPrint('ExceptionXXX $e');
//       rethrow;
//     }
//   }
//
//
//   /// Profile
//
//   // Future<http.Response> getProfileSource(
//   //     {required BasicInfoRequestModel requestBody,
//   //       required http.Client httpClient}) async {
//   //   try {
//   //     var uri = uriBuilder.getProfileUrl();
//   //     var data = '';
//   //     var header = uriBuilder.getApiEndPointHeaderContentType();
//   //     data = json.encode(requestBody.toJson());
//   //     var response = await httpClient.post(uri, body: data, headers: header);
//   //     debugPrint('NetworkDataRepo  Profile response: ${response.body}');
//   //     return response;
//   //   } on TimeOutException catch (e) {
//   //     debugPrint('Timed out $e');
//   //     rethrow;
//   //   } on Exception catch (e) {
//   //     debugPrint('ExceptionXXX $e');
//   //     rethrow;
//   //   }
//   // }
//   //
//
//
// }
