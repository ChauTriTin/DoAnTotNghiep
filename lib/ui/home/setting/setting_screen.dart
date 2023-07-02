import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/home/setting/setting_controller.dart';
import 'package:appdiphuot/ui/home/setting/setting_ui_util.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../generated/l10n.dart';
import '../../../util/theme_util.dart';
import '../../../view/profile_bar_widget.dart';
import '../../user_singleton_controller.dart';

class PageSettingScreen extends StatefulWidget {
  const PageSettingScreen({
    super.key,
  });

  @override
  State<PageSettingScreen> createState() => _PageSettingScreen();
}

class _PageSettingScreen extends BaseStatefulState<PageSettingScreen> {
  final _controller = Get.put(SettingController());

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
          toolbarHeight: 0,
          backgroundColor: ColorConstants.appColor,
        ),
        backgroundColor: ColorConstants.colorWhite,
        body: Obx(() {
          return Stack(
            children: [
              buildBody(context),
              Padding(
                padding: const EdgeInsets.all(
                  DimenConstants.marginPaddingMedium,
                ),
                child: FloatingActionButton(
                  mini: true,
                  elevation: DimenConstants.elevationMedium,
                  backgroundColor: ColorConstants.appColor,
                  onPressed: () {
                    Get.back();
                  },
                  child: const Icon(Icons.clear),
                ),
              ),
            ],
          );
        }));
  }

  Widget buildBody(BuildContext context) {
    return Container(
        width: double.infinity,
        color: ColorConstants.colorWhite,
        margin: const EdgeInsets.symmetric(
            horizontal: DimenConstants.marginPaddingMedium),
        child: ListView(physics: const BouncingScrollPhysics(), children: [
          const SizedBox(
            height: DimenConstants.marginPaddingXXL,
          ),
          _buildAvatar(),
          const SizedBox(
            height: DimenConstants.marginPaddingTiny,
          ),
          Text(
            UserSingletonController.instance.getName(),
            style: UIUtils.getStyleTextMedium600(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: DimenConstants.marginPaddingTiny,
          ),

          // Mail
          Text(
            UserSingletonController.instance.getEmail(),
            style: UIUtils.getStyleTextSmall300(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: DimenConstants.marginPaddingMedium,
          ),

          // Setting
          Padding(
            padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
            child: Text(
              StringConstants.generalSetting,
              style: UIUtils.getStyleTextLarge500(),
            ),
          ),
          getDarkMode(),
          getDivider(),

          // Language
          _buildLanguageItem(),
          const SizedBox(
            height: DimenConstants.marginPaddingSmall,
          ),
          getDivider(),
          buildItemSetting(ColorConstants.colorAbout, StringConstants.about,
              () {
            showDialogMsg(
                StringConstants.about, StringConstants.aboutDetail, context);
          }),

          // Term & condition
          getDivider(),
          buildItemSetting(
              ColorConstants.colorTermCondition, StringConstants.termCondition,
              () {
            showDialogMsg(StringConstants.termCondition,
                StringConstants.termConditionDetail, context);
          }),

          // Policy
          getDivider(),
          buildItemSetting(ColorConstants.colorPolicy, StringConstants.policy,
              () {
            showDialogMsg(
                StringConstants.policy, StringConstants.policyDetail, context);
          }),

          // Rating
          getDivider(),
          buildItemSetting(ColorConstants.colorRateApp, StringConstants.rate,
              _showRatingApp),

          getDivider(),
          const SizedBox(
            height: DimenConstants.marginPaddingMedium,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: DimenConstants.marginPaddingExtraLarge),
              child: UIUtils.getOutlineButton(
                StringConstants.signOut,
                () {
                  UIUtils.showAlertDialog(
                    context,
                    StringConstants.warning,
                    StringConstants.signOutWarning,
                    StringConstants.cancel,
                    null,
                    StringConstants.signOut,
                    _controller.signOut,
                  );
                },
              )),

          const SizedBox(
            height: DimenConstants.marginPaddingMedium,
          ),
        ]));
  }

  void _showDialogSelectLanguage() {
    showMaterialModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        context: context,
        builder: (context) => _buildListItemDialog(
            context, _controller.languages, StringConstants.selectLanguage));
  }

  Widget _buildListItemDialog(
    BuildContext context,
    Map<String, String> items,
    String title,
  ) {
    var languageCodes = items.keys.toList();
    var languages = items.values.toList();
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: DimenConstants.marginPaddingMedium,
          right: DimenConstants.marginPaddingMedium,
          top: DimenConstants.marginPaddingMedium),
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        width: double.infinity,
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            const SizedBox(height: DimenConstants.marginPaddingMedium),
            UIUtils.headerDialog(title),
            const SizedBox(height: DimenConstants.marginPaddingMedium),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  var languageCode = languageCodes[index];
                  var language = languages[index];
                  return buildStringItem(languageCode, language);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return getDivider();
                },
              ),
            ),
            const SizedBox(height: DimenConstants.marginPaddingLarge),
          ],
        ),
      ),
    );
  }

  Widget buildStringItem(String langCode, String language) {
    return InkWell(
        onTap: () {
          Get.back();
          _controller.updateLanguage(langCode, language);
        },
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
              vertical: DimenConstants.marginPaddingMedium),
          child: Text(
            language,
            textAlign: TextAlign.center,
            style: UIUtils.getStyleText500(),
          ),
        ));
  }

  Widget _buildLanguageItem() {
    return InkWell(
      onTap: _showDialogSelectLanguage,
      child: Row(
        children: [
          const SizedBox(
            width: DimenConstants.marginPaddingMedium,
          ),
          Container(
            width: DimenConstants.circleShape,
            height: DimenConstants.circleShape,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ColorConstants.colorLanguage,
            ),
          ),
          const SizedBox(
            width: DimenConstants.marginPaddingMedium,
          ),
          Expanded(
              child: Text(
            StringConstants.language,
            style: UIUtils.getStyleTextSmall400(),
          )),
          const SizedBox(
            width: DimenConstants.marginPaddingMedium,
          ),
          Text(
            _controller.selectedLanguage.value,
            style: const TextStyle(
                color: ColorConstants.colorTermCondition,
                fontSize: DimenConstants.textSmall1,
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            width: DimenConstants.marginPaddingSmall,
          ),
          const Icon(
            Icons.keyboard_arrow_right,
            color: ColorConstants.iconColor,
            size: DimenConstants.iconSizeSmall,
          ),
          const SizedBox(
            width: DimenConstants.marginPaddingMedium,
          ),
        ],
      ),
    );
  }

  void _showRatingApp() async {
    const String packageName =
        'com.booking'; // Replace with your app's package name on the Play Store
    const String url = 'market://details?id=$packageName';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Dog.d('_showRatingApp Could not launch $url');
    }
  }

  Widget getDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: DimenConstants.marginPaddingMLarge),
      child: const Divider(
        color: ColorConstants.dividerColor,
        thickness: DimenConstants.dividerHeight,
      ),
    );
  }

  Widget getDarkMode() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          const SizedBox(
            width: DimenConstants.marginPaddingMedium,
          ),
          Container(
            width: DimenConstants.circleShape,
            height: DimenConstants.circleShape,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: ColorConstants.colorMode,
            ),
          ),
          const SizedBox(
            width: DimenConstants.marginPaddingMedium,
          ),
          Expanded(
              child: Text(
            StringConstants.mode,
            style: UIUtils.getStyleTextSmall400(),
          )),
          const SizedBox(
            width: DimenConstants.marginPaddingMedium,
          ),
          Switch(
              value: _controller.isDarkMode.value,
              onChanged: (value) {
                _controller.updateDarkModeStatus(value);
                ThemeModeNotifier.instance.toggleTheme(value);
              }),
          const SizedBox(
            width: DimenConstants.marginPaddingMedium,
          ),
        ],
      ),
    );
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
}
