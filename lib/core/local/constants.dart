import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter/material.dart';
import 'package:smart_gawali/core/local_storage/hive_storage/hive_storage_repo.dart';
import 'package:smart_gawali/core/theme_style/theme_generator.dart';

class Constants {
  static var mAppBar = AppBar(
    backgroundColor: ThemeGenerator1.primaryColor,
    toolbarHeight: 0,
    elevation: 0,
  );

  static Color themeAccentColor = const Color(0xff0095ff);
  static Color themePrimaryColor = const Color(0xff1077b1);

  static var loginBackgroundShape = const BoxDecoration(
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(50),
      bottomRight: Radius.circular(50),
    ),
    color: Color(0XFF4DBDDA),
    // color: themeAccentColor,
    boxShadow: [
      BoxShadow(
        offset: Offset(0.05, 0.05),
        color: Colors.grey,
        blurRadius: 2,
        spreadRadius: 0.001,
      ),
    ],
  );

  var radius = 12;

  static var loginBox = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(12)),

/*      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
      bottomLeft: Radius.circular(12),
      bottomRight: Radius.circular(12),
    ),*/
    color: Color(0XFFffffff),
    // color: themeAccentColor,
    boxShadow: [
      BoxShadow(
        offset: Offset(0.05, 0.05),
        color: Colors.grey,
        blurRadius: 2,
        spreadRadius: 0.001,
      ),
    ],
  );

  static Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return ThemeGenerator1.primaryColor;
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        timeInSecForIosWeb: 1,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 13.0);
  }

  static bool validateStructure(String value) {
    String passwordPattern =
        // r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
        r'^(?=.*?[a-z])(?=.*?[0-9]).{6,}$';
    RegExp regExp = RegExp(passwordPattern);
    return regExp.hasMatch(value);
  }

  static int pageNo = 1;
  static int pageSize = 10;
}

class StatusCode {
  static const int success = 200;
  static const int failed = 201;
  static const int emptyList = 204;
  static const int unauthorizedUser = 401;
  static const int badRequest = 400;
  static const int forbidden = 403;
  static const int internalError = 500;
}

ClearHiveData() async {
  // var kbBox = Hive.box(HiveStorageRepo.boxKnackbe);
  var kbBox = await Hive.openBox(HiveStorageRepo.boxKnackbe);

  kbBox.put(HiveStorageRepo.keySuccess, null);
  kbBox.put(HiveStorageRepo.keyMessage, null);
  kbBox.put(HiveStorageRepo.keyEmployeeCode, null);
  kbBox.put(HiveStorageRepo.keyFirstName, null);
  kbBox.put(HiveStorageRepo.keyLastName, null);
  kbBox.put(HiveStorageRepo.keyMobileNo, null);
  kbBox.put(HiveStorageRepo.keyMainCompanyId, null);
  kbBox.put(HiveStorageRepo.keySubCompanyId, null);
  kbBox.put(HiveStorageRepo.keyEGroupId, null);
  kbBox.put(HiveStorageRepo.keyEmployeeStatusId, null);
}

onLogoutOperation(BuildContext context) async {
  // var kbBox = Hive.box(HiveStorageRepo.boxKnackbe);
  var kbBox = await Hive.openBox(HiveStorageRepo.boxKnackbe);

  kbBox.put(HiveStorageRepo.keySuccess, null);
  kbBox.put(HiveStorageRepo.keyMessage, null);
  kbBox.put(HiveStorageRepo.keyEmployeeCode, null);
  kbBox.put(HiveStorageRepo.keyFirstName, null);
  kbBox.put(HiveStorageRepo.keyLastName, null);
  kbBox.put(HiveStorageRepo.keyMobileNo, null);
  kbBox.put(HiveStorageRepo.keyMainCompanyId, null);
  kbBox.put(HiveStorageRepo.keySubCompanyId, null);
  kbBox.put(HiveStorageRepo.keyEGroupId, null);
  kbBox.put(HiveStorageRepo.keyEmployeeStatusId, null);

  kbBox.close();

  // Navigator.pushReplacement(
  //   context,
  //   MaterialPageRoute(builder: (context) =>  LoginPage()),
  // );

  // Navigator.pushAndRemoveUntil(
  //   context,
  //   MaterialPageRoute(
  //     builder: (context) => LoginKenPage(),
  //   ),
  //   ModalRoute.withName(routeLoginPage),
  // );


}
