import '../common/const/dimen_constants.dart';
import '../common/const/string_constants.dart';

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

  static bool isValidNameFormat(String format) {
    String pattern = r'^[A-Z][-a-zA-Z]+$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(format);
  }

  static String? validateEmail(String? value) {
    if (value!.isEmpty) return StringConstants.errorEmailEmpty;
    if (!ValidateUtils.isValidEmailFormat(value)) {
      return StringConstants.errorEmailRegex;
    }
    return null;
  }

  static String? validateUserName(String? value) {
    if (value!.isEmpty) return StringConstants.errorNameEmpty;
    if (!ValidateUtils.isValidNameFormat(value)) {
      return StringConstants.errorNameRegex;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value!.isEmpty) return StringConstants.errorPasswordEmpty;
    if (!ValidateUtils.isValidPasswordFormat(value)) {
      return StringConstants.errorPasswordRegex;
    }
    return null;
  }
}
