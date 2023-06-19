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
    String pattern = r'^(?=.*[0-9a-zA-Z]).{6,}';
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
    String pattern = r'^[a-zA-Z0-9]+(([,. -][a-zA-Z ])?[a-zA-Z]*)*$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(format);
  }

  static bool isValidPhoneFormat(String format) {
    String pattern = r'^(84|0[3|5|7|8|9])+([0-9]{8})\b$';
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
    // if (!ValidateUtils.isValidNameFormat(value)) {
    //   return StringConstants.errorNameRegex;
    // }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value!.isEmpty) return StringConstants.errorPhoneEmpty;
    if (!ValidateUtils.isValidPhoneFormat(value)) {
      return StringConstants.errorPhoneRegex;
    }
    return null;
  }

  static String? validateBienSoXe(String? value) {
    if (value!.isEmpty) return StringConstants.errorBSXEmpty;
    return null;
  }

  static String? validateBirthday(String? value) {
    if (value!.isEmpty) return StringConstants.errorBirthdayEmpty;
    return null;
  }

  static String? validateAddress(String? value) {
    if (value!.isEmpty) return StringConstants.errorAddressEmpty;
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
