import 'package:hive/hive.dart';

class HiveStorageRepo {
  bool toBoolean(String str, [strict = false]) {
    if (strict == true) {
      return str == '1' || str == 'true';
    }
    return str != '0' && str != 'false' && str != '';
  }

  static const keyUserName = '';

  /// new keys as per response body
  static const boxKnackbe = 'knackbe_box';
  static const keySuccess = 'success';
  static const keyMessage = 'message';
  static const keyEmployeeCode = 'employeeCode';
  static const keyFirstName = 'firstName';
  static const keyLastName = 'lastName';
  static const keyMobileNo = 'mobileNo';
  static const keyMainCompanyId = 'maincompany_id';
  static const keySubCompanyId = 'sub_company_id';
  static const keyEGroupId = 'egroup_id';
  static const keyEmployeeStatusId = 'employee_status_id';
  static const keyIsLogIn = 'is_log_in';
  static const keyProfilePic = 'profile_pic';


  var hiveBox = Hive.box(boxKnackbe);

  static const keyLocationBox = 'location_box';

  // hiveBox.put(keyToken, 'Aaa');
}

//{