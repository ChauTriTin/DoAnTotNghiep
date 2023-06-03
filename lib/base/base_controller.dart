import 'package:appdiphuot/util/ui_utils.dart';
import 'package:get/get.dart';

class BaseController extends GetxController {
  var appLoading = AppLoading(
    false,
    "",
    null,
    DateTime.now().millisecondsSinceEpoch,
  ).obs;

  var appError = AppError(
    "",
    null,
    DateTime.now().millisecondsSinceEpoch,
  ).obs;

  void setAppLoading(
    bool isLoading,
    String messageLoading,
    TypeApp typeApp,
  ) {
    AppLoading loading = AppLoading(
      isLoading,
      messageLoading,
      typeApp,
      DateTime.now().millisecondsSinceEpoch,
    );
    appLoading.value = loading;
  }

  void setAppError(
    String messageError,
    TypeApp typeApp,
  ) {
    AppError appError = AppError(
      messageError,
      typeApp,
      DateTime.now().millisecondsSinceEpoch,
    );
    this.appError.value = appError;
  }

  void showSnackBarFull(
    String title,
    String message,
  ) {
    UIUtils.showFullWidthSnackBar(title, message);
  }

  void showSnackBarFullError(
    String title,
    String message,
  ) {
    UIUtils.showFullWidthSnackBarError(title, message);
  }
}

class AppLoading {
  AppLoading(
    this.isLoading,
    this.messageLoading,
    this.typeApp,
    this.millisecondsSinceEpoch,
  );

  bool isLoading;
  String messageLoading;
  TypeApp? typeApp;
  int millisecondsSinceEpoch;
}

class AppError {
  AppError(this.messageError, this.typeApp, this.millisecondsSinceEpoch);

  String messageError;
  TypeApp? typeApp;
  int millisecondsSinceEpoch;
}

enum TypeApp {
  createRouter,
  forgotPassword,
  login,
  register,
  logout,
  uploadAvatar,
}
