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
import 'custom_radio.dart';
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
            _buildAvatar(),
            _changeAvatar(),
            const SizedBox(
              height: DimenConstants.marginPaddingMedium,
            ),

            // Name
            UIUtils.getTitleTextEditProfile(StringConstants.name),
            const SizedBox(height: DimenConstants.marginPaddingSmall),
            TextInputField(
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
              textColor: ColorConstants.textEditBgColor,
              initalText: _controller.email.value,
              backgroundColor: ColorConstants.colorBgEditTextField,
              onChange: (String? value) {
                _controller.email.value = value ?? "";
              },
            ),

            const SizedBox(
              height: DimenConstants.marginPaddingMedium,
            ),

            // SDT
            UIUtils.getTitleTextEditProfile(StringConstants.phone),
            const SizedBox(height: DimenConstants.marginPaddingSmall),
            TextInputField(
              initalText: _controller.phone.value,
              backgroundColor: ColorConstants.colorBgEditTextField,
              validator: ValidateUtils.validateText,
              keyboardType: TextInputType.phone,
              onChange: (String? value) {
                _controller.phone.value = value ?? "";
              },
            ),

            const SizedBox(
              height: DimenConstants.marginPaddingMedium,
            ),

            // Address
            UIUtils.getTitleTextEditProfile(StringConstants.address),
            const SizedBox(height: DimenConstants.marginPaddingSmall),
            TextInputField(
              initalText: _controller.address.value,
              backgroundColor: ColorConstants.colorBgEditTextField,
              validator: ValidateUtils.validateText,
              keyboardType: TextInputType.text,
              onChange: (String? value) {
                _controller.address.value = value ?? "";
              },
            ),

            const SizedBox(
              height: DimenConstants.marginPaddingMedium,
            ),

            // Birthday
            UIUtils.getTitleTextEditProfile(StringConstants.birthday),
            const SizedBox(height: DimenConstants.marginPaddingSmall),
            TextInputField(
              onTap: () {
                _pickTimeBirthday();
              },
              controller: _birthdayController,
              backgroundColor: ColorConstants.colorBgEditTextField,
              validator: ValidateUtils.validateText,
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

            // Gender
            UIUtils.getTitleTextEditProfile(StringConstants.gender),
            const SizedBox(height: DimenConstants.marginPaddingSmall),
            _buildGender(),

            const SizedBox(
              height: DimenConstants.marginPaddingMedium,
            ),

            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: DimenConstants.marginPaddingExtraLarge),
                child: UIUtils.getOutlineButton(
                    StringConstants.update, _saveUserInfo)),

            const SizedBox(
              height: DimenConstants.marginPaddingLarge,
            ),
          ])),
    );
  }

  void _saveUserInfo() {

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

  Widget _buildAvatar() {
    return IconButton(
      iconSize: DimenConstants.avatarProfile2,
      icon: CircleAvatar(
        backgroundColor: ColorConstants.borderTextInputColor,
        radius: DimenConstants.avatarProfile2 / 2,
        child: CircleAvatar(
          radius: DimenConstants.avatarProfile2 / 2 - DimenConstants.logoStroke,
          backgroundImage:
              NetworkImage(UserSingletonController.instance.getAvatar()),
        ),
      ),
      onPressed: () {},
    );
  }

  Widget _changeAvatar() {
    return InkWell(
        onTap: () {
          _openSelectImageBottomSheet(context);
        },
        child: Container(
          margin: const EdgeInsets.only(top: 14, bottom: 16),
          child: const Center(
            child: Text(
              StringConstants.updateAvatar,
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ));
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
                  for (var gender in _controller.genders) {
                    gender.isSelected = false;
                  }
                  gender.isSelected = true;
                });
              },
              child: CustomRadio(gender),
            );
          }),
    );
  }
}
