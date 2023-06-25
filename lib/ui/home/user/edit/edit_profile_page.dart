import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../../util/TextInputField.dart';
import '../../../../util/time_utils.dart';
import '../../../../util/validate_utils.dart';
import '../../../user_singleton_controller.dart';
import '../../../../view/custom_radio.dart';
import 'edit_profile_controller.dart';

class PageEditProfile extends StatefulWidget {
  const PageEditProfile({
    super.key,
  });

  @override
  State<PageEditProfile> createState() => _PageEditProfile();
}

class _PageEditProfile extends BaseStatefulState<PageEditProfile> {
  final _controller = Get.put(EditProfileController());
  final _form = GlobalKey<FormState>();
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
        appBar: AppBar(
          backgroundColor: ColorConstants.appColor,
          title: const Text(StringConstants.editProfile),
        ),
        backgroundColor: ColorConstants.colorWhite,
        body: Obx(() {
          return buildBody();
        }));
  }

  Widget buildBody() {
    return Form(
      key: _form,
      child: Container(
          width: MediaQuery.of(context).size.width,
          color: ColorConstants.colorWhite,
          margin: const EdgeInsets.symmetric(
              horizontal: DimenConstants.marginPaddingExtraLarge),
          child: ListView(physics: const BouncingScrollPhysics(), children: [
            const SizedBox(
              height: DimenConstants.marginPaddingMedium,
            ),
            _changeAvatar(),
            const SizedBox(
              height: DimenConstants.marginPaddingTiny,
            ),

            // Name
            UIUtils.getTitleTextEditProfile(StringConstants.name),
            const SizedBox(height: DimenConstants.marginPaddingSmall),
            TextInputField(
              textColor: ColorConstants.textColor,
              initalText: _controller.name.value,
              backgroundColor: ColorConstants.colorBgEditTextField,
              validator: ValidateUtils.validateUserName,
              keyboardType: TextInputType.text,
              onChange: (String? value) {
                _controller.name.value = value ?? "";
              },
            ),

            const SizedBox(
              height: DimenConstants.marginPaddingMedium,
            ),

            // Email
            UIUtils.getTitleTextEditProfile(StringConstants.email),
            const SizedBox(height: DimenConstants.marginPaddingSmall),
            TextInputField(
              isDisable: true,
              textColor: ColorConstants.textColorDisable,
              initalText: _controller.email.value,
              backgroundColor: ColorConstants.colorBgEditTextField,
              validator: ValidateUtils.validateEmail,
              onChange: (String? value) {
                _controller.email.value = value ?? "";
              },
            ),

            const SizedBox(
              height: DimenConstants.marginPaddingMedium,
            ),

            // Birthday
            UIUtils.getTitleTextEditProfile(StringConstants.birthday),
            const SizedBox(height: DimenConstants.marginPaddingSmall),
            TextInputField(
              textColor: ColorConstants.textColor,
              onTap: () {
                _pickTimeBirthday();
              },
              controller: _birthdayController,
              backgroundColor: ColorConstants.colorBgEditTextField,
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
            UIUtils.getTitleTextEditProfile(StringConstants.address),
            const SizedBox(height: DimenConstants.marginPaddingSmall),
            TextInputField(
              textColor: ColorConstants.textColor,
              initalText: _controller.address.value,
              backgroundColor: ColorConstants.colorBgEditTextField,
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
            UIUtils.getTitleTextEditProfile(StringConstants.phone),
            const SizedBox(height: DimenConstants.marginPaddingSmall),
            TextInputField(
              textColor: ColorConstants.textColor,
              initalText: _controller.phone.value,
              backgroundColor: ColorConstants.colorBgEditTextField,
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
            UIUtils.getTitleTextEditProfile(StringConstants.bsx),
            const SizedBox(height: DimenConstants.marginPaddingSmall),
            TextInputField(
              textColor: ColorConstants.textColor,
              initalText: _controller.bsx.value,
              backgroundColor: ColorConstants.colorBgEditTextField,
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
            UIUtils.getTitleTextEditProfile(StringConstants.gender),
            const SizedBox(height: DimenConstants.marginPaddingSmall),
            _buildGender(),

            const SizedBox(
              height: DimenConstants.marginPaddingMedium,
            ),

            UIUtils.getButtonFill(StringConstants.update, _saveUserInfo),
            const SizedBox(
              height: DimenConstants.marginPaddingLarge,
            ),
          ])),
    );
  }

  void _saveUserInfo() {
    _form.currentState!.save();
    if (_form.currentState!.validate()) {
      if (_controller.gender.value == 0) {
        UIUtils.showSnackBar(
            StringConstants.error, StringConstants.errorGenderEmpty);
        return;
      }
      _controller.saveUserInfo();
    }
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

  Widget _changeAvatar() {
    return SizedBox(
      height: DimenConstants.avatarProfile,
      width: DimenConstants.avatarProfile,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          IconButton(
            iconSize: DimenConstants.avatarProfile,
            icon: CircleAvatar(
              backgroundColor: ColorConstants.borderTextInputColor,
              radius: DimenConstants.avatarProfile / 2,
              child: CircleAvatar(
                radius: DimenConstants.avatarProfile / 2 - DimenConstants.logoStroke,
                backgroundImage:
                NetworkImage(UserSingletonController.instance.getAvatar()),
              ),
            ),
            onPressed: () {

            },
          ),
          Positioned(
              bottom: 0,
              right: 0,
              left: 100 ,
              child: RawMaterialButton(
                onPressed: () {
                  _openSelectImageBottomSheet(context);
                },
                elevation: 3,
                fillColor: ColorConstants.colorWhite,
                padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
                shape: const CircleBorder(),
                child: const Icon(Icons.camera_alt_outlined, color: Colors.blue,),
              )),
        ],
      ),
    );
  }

  void _openSelectImageBottomSheet(BuildContext context) {
    Get.bottomSheet(Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(DimenConstants.borderBottomAuth),
            topRight: Radius.circular(DimenConstants.borderBottomAuth),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _controller.openGallery();
                  Get.back();
                },
                child: const ListTile(
                  leading: Icon(Icons.photo),
                  title: Text(StringConstants.openGallery),
                ),
              )),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _controller.openCamera();
                Get.back();
              },
              child: const ListTile(
                leading: Icon(Icons.camera),
                title: Text(StringConstants.openCamera),
              ),
            ),
          )
        ],
      ),
    ));
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
