import '../common/const/dimen_constants.dart';

class ValidateUtils {
  static bool isValidPassword(String pw) {
    return pw.length >= DimenConstants.minLengthPassword &&
        isValidPasswordFormat(pw);
  }

  static bool isValidPasswordRetype(String pw, String pwRetype) {
    return pw == pwRetype;
  }

  static bool isValidPasswordFormat(String format) {
    // r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    String pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{4,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(format);
  }

  static bool isValidEmailFormat(String format) {
    // r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';// Simple email
    // Complex email
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(format);
  }
}
