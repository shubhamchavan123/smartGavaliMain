// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:smart_gawali/core/local_storage/hive_storage/hive_storage_repo.dart';
// import 'package:smart_gawali/features/login/data/model/login_response.dart';
// import 'package:smart_gawali/features/login/domain/login_use_case.dart';
//
// import 'data/model/login_request.dart';
//
// class Utils {
//   static Future<bool> checkInternetConnectivity() async {
//     /// First, check if the device is connected to a network
//     final List<ConnectivityResult> connectivityResult =
//         await Connectivity().checkConnectivity();
//
//     if (connectivityResult[connectivityResult.length - 1] ==
//         ConnectivityResult.none) {
//       /// No network connection
//       return false;
//     }
//
//     /// If connected to a network, check if the internet is actually accessible
//     try {
//       final response = await http
//           .get(Uri.parse('https://www.google.com'))
//           .timeout(Duration(seconds: 5));
//       if (response.statusCode == 200) {
//         /// Connected to the internet
//         return true;
//       } else {
//         /// Not connected to the internet
//         return false;
//       }
//     } catch (e) {
//       /// Error in the request, likely not connected to the internet
//       return false;
//     }
//   }
// }
//
// class LoginController with ChangeNotifier {
//   final BuildContext context;
//
//   LoginController(this.context);
//
//   bool isValidUser = false;
//   var errorMessage = '';
//   bool _isLoading = false;
//
//   bool get isLoading => _isLoading;
//
//   set isLoading(bool val) {
//     _isLoading = val;
//     notifyListeners();
//   }
//
//   bool _showError = false;
//
//   bool get showError => _showError;
//
//   TextEditingController mobilenumberController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//
//   final LoginPageUseCase _loginPageUseCase = LoginPageUseCase();
//
//   // Private variable
//   String _fcmToken = '';
//
//   // Getter for _fcmToken
//   String get fcmToken => _fcmToken;
//
//   // Setter for _fcmToken
//   set fcmToken(String token) {
//     _fcmToken = token;
//   }
//
//   Future<void> onLoginSuccess(BuildContext context) async {
//     isLoading = true;
//     isValidUser = false;
//     notifyListeners();
//
//     if (await Utils.checkInternetConnectivity()) {
//       String mobilenumber = mobilenumberController!.text;
//       String password = passwordController!.text;
//       debugPrint(mobilenumber);
//
//       LoginRequestModel loginReqInput = LoginRequestModel(
//         mobileNo: mobilenumber,
//         password: password,
//       );
//       debugPrint(loginReqInput.toJson().toString());
//       var client = http.Client();
//
//       var loginApiResponse = await _loginPageUseCase.getLoginNotifier(
//         client: client,
//         requestBody: loginReqInput,
//       );
//
//       client.close();
//
//       loginApiResponse.fold((error) {
//         _showError = true;
//         errorMessage = error.errorDisplayingMessage;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(errorMessage)),
//         );
//         notifyListeners();
//       }, (response) async {
//         if (response.success == 1 && response.employeeData?.mobileNo != null) {
//           await _handleSuccessfulLogin(response);
//         } else if (response.success == 2) {
//           _handleInvalidLogin();
//         } else if (response.success == 1 &&
//             response.employeeData?.mobileNo == null) {
//           _handleSuccessfulLoginForNullEmp(response);
//         } else {
//           _handleUnexpectedResponse();
//         }
//
//         mobilenumberController.text = '';
//         passwordController.text = '';
//         notifyListeners();
//       });
//     } else {
//       _handleNoInternetConnection();
//     }
//
//     isLoading = false;
//     notifyListeners();
//   }
//
//
//   Future<void> _handleSuccessfulLoginForNullEmp(
//       LoginResponseModel response) async {
//     isValidUser = true;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Login successful but User Data is NULL!')),
//     );
//   }
//
//   Future<void> _handleSuccessfulLogin(LoginResponseModel response) async {
//     isValidUser = true;
//     await onLoginSuccessHive(response);
//
//     // Navigator.pushAndRemoveUntil(
//     //   context,
//     //   MaterialPageRoute(builder: (context) => KenNewHomeScreen()),
//     //   (route) => false, // Remove all previous routes
//     // );
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Login successful!')),
//     );
//   }
//
//   void _handleInvalidLogin() {
//     _showError = true;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(' Employee Not Found.')),
//     );
//   }
//
//   void _handleUnexpectedResponse() {
//     _showError = true;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Unexpected response from server.')),
//     );
//   }
//
//   void _handleNoInternetConnection() {
//     _showError = true;
//     errorMessage = 'Internet Disconnected';
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Internet Disconnected')),
//     );
//   }
//
//   Future<void> onLoginSuccessHive(LoginResponseModel results) async {
//     await Hive.initFlutter();
//     var kbBox = await Hive.openBox(HiveStorageRepo.boxKnackbe);
//
//     kbBox.put(HiveStorageRepo.keySuccess, results.success);
//     kbBox.put(HiveStorageRepo.keyMessage, results.message);
//     kbBox.put(HiveStorageRepo.keyEmployeeCode, results.employeeData!.employeeCode);
//     kbBox.put(HiveStorageRepo.keyFirstName, results.employeeData!.firstName);
//     kbBox.put(HiveStorageRepo.keyLastName, results.employeeData!.lastName);
//     kbBox.put(HiveStorageRepo.keyMobileNo, results.employeeData!.mobileNo);
//     kbBox.put(HiveStorageRepo.keyMainCompanyId, results.employeeData!.maincompanyId);
//     kbBox.put(HiveStorageRepo.keySubCompanyId, results.employeeData!.subCompanyId);
//     kbBox.put(HiveStorageRepo.keyEGroupId, results.employeeData!.egroupId);
//     kbBox.put(HiveStorageRepo.keyEmployeeStatusId, results.employeeData!.employeeStatusId);
//     kbBox.put(HiveStorageRepo.keyIsLogIn, true);
//     kbBox.put(HiveStorageRepo.keyProfilePic, results.employeeData!.userProfile);
//
//     debugPrint('User data stored in Hive');
//     debugPrint('User data : ${kbBox.get(HiveStorageRepo.keyMainCompanyId)}');
//     debugPrint('User data : ${kbBox.get(HiveStorageRepo.keySubCompanyId)}');
//     //debugPrint('User data : ${results.employeeData!.subCompanyId}');
//   }
// }
