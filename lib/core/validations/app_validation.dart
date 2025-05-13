
class AppValidation {

  static bool validateMobileNumber(String? username) {
    if (username!.isNotEmpty && username.length < 10) {
      return false;
    }
    return true;
  }

  static bool validateEmail(String? username) {
    RegExp emailPattern = RegExp('[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+');
    if (username!.isNotEmpty && emailPattern.hasMatch(username)) {
      return false;
    }
    return true;
  }

}