import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/ui/authentication/register/page_register_controller.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../base/base_stateful_state.dart';
import '../../../common/const/string_constants.dart';
import '../../../util/PasswordField.dart';
import '../../../util/TextInputField.dart';
import '../../../util/time_utils.dart';
import '../../../util/ui_utils.dart';
import '../../../util/validate_utils.dart';
import '../../home/user/edit/custom_radio.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreen();
  }
}

class _RegisterScreen extends BaseStatefulState<RegisterScreen> {
  final _formLoginKey = GlobalKey<FormState>();
  final RegisterController _controller = Get.put(RegisterController());
  late final TextEditingController _birthdayController =
      TextEditingController(text: _controller.birthday.value);

  @override
  void initState() {
    super.initState();
    _controller.getData();
    _setupListen();
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
              const SizedBox(height: DimenConstants.marginPaddingMedium),
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
                      // Title: Register
                      const SizedBox(height: DimenConstants.marginPaddingLarge),
                      UIUtils.getTextHeaderAuth(StringConstants.registerTitle,
                          ColorConstants.colorWhite),
                      const SizedBox(height: DimenConstants.marginPaddingLarge),

                      // Name
                      UIUtils.getTitleTextInputAuth(StringConstants.name),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      _getTextInputWidget(false),
                      const SizedBox(
                          height: DimenConstants.marginPaddingMedium),

                      //Email
                      UIUtils.getTitleTextInputAuth(StringConstants.email),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      _getTextInputWidget(true),
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
                          _controller.birthday.value = value ?? "";
                        },
                      ),

                      const SizedBox(
                        height: DimenConstants.marginPaddingMedium,
                      ),

                      // Address
                      UIUtils.getTitleTextInputAuth(StringConstants.address),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      TextInputField(
                        initalText: _controller.address.value,
                        validator: ValidateUtils.validateAddress,
                        keyboardType: TextInputType.emailAddress,
                        onChange: (String? value) {
                          _controller.address.value = value ?? "";
                        },
                      ),

                      const SizedBox(
                        height: DimenConstants.marginPaddingMedium,
                      ),

                      // SDT
                      UIUtils.getTitleTextInputAuth(StringConstants.phone),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      TextInputField(
                        initalText: _controller.phone.value,
                        validator: ValidateUtils.validatePhone,
                        keyboardType: TextInputType.phone,
                        onChange: (String? value) {
                          _controller.phone.value = value ?? "";
                        },
                      ),

                      const SizedBox(
                        height: DimenConstants.marginPaddingMedium,
                      ),

                      // Bsx
                      UIUtils.getTitleTextInputAuth(StringConstants.bsx),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      TextInputField(
                        initalText: _controller.bsx.value,
                        validator: ValidateUtils.validateBienSoXe,
                        keyboardType: TextInputType.streetAddress,
                        onChange: (String? value) {
                          _controller.bsx.value = value ?? "";
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

                      // Password
                      UIUtils.getTitleTextInputAuth(StringConstants.password),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      _getPasswordWidget(false),
                      const SizedBox(
                          height: DimenConstants.marginPaddingMedium),

                      // Confirm password
                      UIUtils.getTitleTextInputAuth(
                          StringConstants.passwordConfirm),
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      _getPasswordWidget(true),
                      const SizedBox(
                          height: DimenConstants.marginPaddingMedium),

                      // Register btn
                      const SizedBox(height: DimenConstants.marginPaddingSmall),
                      UIUtils.getLoginOutlineButton(
                        StringConstants.register,
                        _doRegister,
                      ),

                      const SizedBox(
                          height: DimenConstants.marginPaddingExtraLarge),
                    ],
                  ))),
        ));
  }

  void _doRegister() {
    _formLoginKey.currentState!.save();
    if (_formLoginKey.currentState!.validate()) {
      _controller.doRegister();
    }
  }

  Widget _getPasswordWidget(bool isConfirmPassword) {
    return PasswordField(
      validator: isConfirmPassword
          ? validatePasswordConfirm
          : ValidateUtils.validatePassword,
      onChange: (String? value) {
        if (isConfirmPassword) {
          _controller.confirmPassword.value = value ?? "";
        } else {
          _controller.password.value = value ?? "";
        }
      },
    );
  }

  String? validatePasswordConfirm(String? confirmPw) {
    if (confirmPw!.isEmpty) {
      return StringConstants.errorPasswordEmpty;
    }

    String? pw = _controller.password.value;

    Dog.d("pw: $pw, confirmPw: $confirmPw");
    if (!ValidateUtils.isValidPasswordRetype(pw, confirmPw)) {
      return StringConstants.errorPasswordNotMatch;
    }
    return null;
  }

  Widget _getTextInputWidget(bool isEmail) {
    return TextInputField(
      validator: isEmail
          ? ValidateUtils.validateEmail
          : ValidateUtils.validateUserName,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      onChange: (String? value) {
        if (isEmail) {
          _controller.email.value = value ?? "";
        } else {
          _controller.name.value = value ?? "";
        }
      },
    );
  }

  void _pickTimeBirthday() async {
    DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: TimeUtils.stringToDateTime(_controller.birthday.value) ??
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

    _controller.birthday.value = TimeUtils.dateTimeToString(dateTime);

    setState(() {
      _birthdayController.text = _controller.birthday.value;
    });
    Dog.d("datetime_birthday: ${_controller.birthday.value}");
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
}
