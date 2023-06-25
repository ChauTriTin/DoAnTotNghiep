import 'dart:convert';
import 'dart:developer';

import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/model/user.dart';
import 'package:appdiphuot/ui/authentication/login/google/loggin_google_controller.dart';
import 'package:appdiphuot/ui/authentication/login/page_login_controller.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:appdiphuot/util/validate_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../../base/base_stateful_state.dart';
import '../../../../common/const/constants.dart';
import '../../../../util/PasswordField.dart';
import '../../../../util/TextInputField.dart';
import '../../../../util/log_dog_utils.dart';
import '../../../../util/time_utils.dart';
import '../../../home/user/edit/custom_radio.dart';

class LoginGoogleScreen extends StatefulWidget {
  const LoginGoogleScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginGoogleScreen();
  }
}

class _LoginGoogleScreen extends BaseStatefulState<LoginGoogleScreen> {
  final _formLoginKey = GlobalKey<FormState>();
  final LoginGoogleController _controller = Get.put(LoginGoogleController());
  late final TextEditingController _birthdayController =
      TextEditingController(text: _controller.userData.value.birthday);

  @override
  void initState() {
    super.initState();
    _setupListen();
    var data = Get.arguments[0][Constants.user];
    log("Get userData: $data");
    try {
      // tripData = Trip.fromJson(jsonDecode(data ?? ""));
      _controller.userData.value = UserData.fromJson(jsonDecode(data));
      _controller.getData();
      log("Get userData: ${_controller.userData.value.toString()}");
    } catch (e) {
      log("Get userData ex: $e");
    }
  }

  void _setupListen() {
    _controller.appLoading.listen((appLoading) {
      if (appLoading.isLoading) {
        OverlayLoadingProgress.start(context, barrierDismissible: false);
      } else {
        OverlayLoadingProgress.stop();
      }
    });
    _controller.appError.listen((err) {
      showErrorDialog(StringConstants.errorMsg, err.messageError, "Retry", () {
        //do sth
      });
    });
  }

  @override
  void dispose() {
    _controller.clearOnDispose();
    OverlayLoadingProgress.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.colorWhite, body: _buildBody());
  }

  Widget _buildBody() {
    return SafeArea(
      child: Container(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              UIUtils.getBackWidget(() {
                Get.back();
              }),
              const SizedBox(height: DimenConstants.marginPaddingLarge),
              _buildLoginWidget()
            ],
          )),
    );
  }

  Widget _buildLoginWidget() {
    return Expanded(
        flex: 5,
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: DimenConstants.marginPaddingLarge),
          decoration: UIUtils.getBoxDecorationLoginBg(),
          width: double.infinity,
          child: SingleChildScrollView(
              child: Form(
                  key: _formLoginKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title: Update info
                      const SizedBox(height: DimenConstants.marginPaddingLarge),
                      UIUtils.getTextHeaderAuth(StringConstants.updateInfo,
                          ColorConstants.colorWhite),
                      const SizedBox(height: DimenConstants.marginPaddingLarge),

                      // Name
                      UIUtils.getTitleTextInputAuth(StringConstants.name),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      TextInputField(
                        initalText: _controller.userData.value.name,
                        validator: ValidateUtils.validateUserName,
                        keyboardType: TextInputType.text,
                        onChange: (String? value) {
                          _controller.userData.value.name = value ?? "";
                        },
                      ),
                      const SizedBox(
                          height: DimenConstants.marginPaddingMedium),

                      //Email
                      UIUtils.getTitleTextInputAuth(StringConstants.email),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      TextInputField(
                        isDisable: true,
                        onTap: onTabEmail,
                        textColor: ColorConstants.textColorDisable1,
                        initalText: _controller.userData.value.email,
                        validator: ValidateUtils.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        onChange: (String? value) {
                          _controller.userData.value.email = value ?? "";
                        },
                      ),
                      const SizedBox(
                          height: DimenConstants.marginPaddingMedium),

                      // Birthday
                      UIUtils.getTitleTextInputAuth(StringConstants.birthday),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      TextInputField(
                        onTap: () {
                          _pickTimeBirthday();
                        },
                        controller: _birthdayController,
                        validator: ValidateUtils.validateBirthday,
                        keyboardType: TextInputType.text,
                        isDisable: true,
                        onChange: (String? value) {
                          Dog.d("birthDayChanged: $value");
                          _controller.userData.value.birthday = value ?? "";
                        },
                      ),

                      const SizedBox(
                        height: DimenConstants.marginPaddingMedium,
                      ),

                      // Address
                      UIUtils.getTitleTextInputAuth(StringConstants.address),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      TextInputField(
                        initalText: _controller.userData.value.address,
                        validator: ValidateUtils.validateAddress,
                        keyboardType: TextInputType.text,
                        onChange: (String? value) {
                          _controller.userData.value.address = value ?? "";
                        },
                      ),

                      const SizedBox(
                        height: DimenConstants.marginPaddingMedium,
                      ),

                      // SDT
                      UIUtils.getTitleTextInputAuth(StringConstants.phone),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      TextInputField(
                        initalText: _controller.userData.value.phone,
                        validator: ValidateUtils.validatePhone,
                        keyboardType: TextInputType.phone,
                        onChange: (String? value) {
                          _controller.userData.value.phone = value ?? "";
                        },
                      ),

                      const SizedBox(
                        height: DimenConstants.marginPaddingMedium,
                      ),

                      // Bsx
                      UIUtils.getTitleTextInputAuth(StringConstants.bsx),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      TextInputField(
                        initalText: _controller.userData.value.bsx,
                        validator: ValidateUtils.validateBienSoXe,
                        keyboardType: TextInputType.streetAddress,
                        onChange: (String? value) {
                          _controller.userData.value.bsx = value ?? "";
                        },
                      ),

                      const SizedBox(
                        height: DimenConstants.marginPaddingMedium,
                      ),

                      // Gender
                      UIUtils.getTitleTextInputAuth(StringConstants.gender),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      _buildGender(),

                      const SizedBox(
                        height: DimenConstants.marginPaddingMedium,
                      ),

                      // Register btn
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      UIUtils.getLoginOutlineButton(
                        StringConstants.update,
                        _doUpdateInfo,
                      ),

                      const SizedBox(
                          height: DimenConstants.marginPaddingExtraLarge),
                    ],
                  ))),
        ));
  }

  void _doUpdateInfo() {
    _formLoginKey.currentState!.save();
    if (_formLoginKey.currentState!.validate()) {
      _controller.saveUserToFirebase();
    }
  }

  void _pickTimeBirthday() async {
    DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate:
          TimeUtils.stringToDateTime(_controller.userData.value.birthday) ??
              DateTime.now(),
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      selectableDayPredicate: (dateTime) {
        return true;
      },
    );
    if (dateTime == null) return;

    _controller.userData.value.birthday = TimeUtils.dateTimeToString(dateTime);

    setState(() {
      _birthdayController.text = _controller.userData.value.birthday ?? "";
    });
    Dog.d("datetime_birthday: ${_controller.userData.value.birthday}");
  }

  Widget _buildGender() {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 3 -
          DimenConstants.marginPaddingMedium * 2,
      child: ListView.builder(
          key: UniqueKey(),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: _controller.genders.length,
          itemBuilder: (context, index) {
            var gender = _controller.genders[index];
            return InkWell(
              splashColor: Colors.pinkAccent,
              onTap: () {
                setState(() {
                  _controller.updateGender(index);
                });
              },
              child: CustomRadio(gender),
            );
          }),
    );
  }

  SnackbarController? snackbar;

  void onTabEmail() {
    if (snackbar != null) {
      snackbar?.close();
    }
    snackbar = UIUtils.showSnackBar(
        StringConstants.notification, StringConstants.messageEditEmail);
  }
}
