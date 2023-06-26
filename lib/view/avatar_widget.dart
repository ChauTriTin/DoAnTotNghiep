import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/const/color_constants.dart';
import '../common/const/string_constants.dart';
import '../ui/home/user/edit/edit_profile_page.dart';
import '../ui/user_singleton_controller.dart';
import '../util/ui_utils.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
            shape: UIUtils.getCardCorner(),
            margin: const EdgeInsets.all(DimenConstants.marginPaddingSmall),
            color: ColorConstants.cardBg,
            shadowColor: Colors.grey,
            elevation: DimenConstants.cardElevation,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                  horizontal: DimenConstants.marginPaddingMedium),
              child: Column(
                children: [
                  const SizedBox(
                    height: DimenConstants.marginPaddingMedium,
                  ),
                  IconButton(
                    iconSize: DimenConstants.avatarProfile2,
                    icon: CircleAvatar(
                      backgroundColor: ColorConstants.borderTextInputColor,
                      radius: DimenConstants.avatarProfile2 / 2,
                      child: CircleAvatar(
                        radius: DimenConstants.avatarProfile2 / 2 -
                            DimenConstants.logoStroke,
                        backgroundImage: NetworkImage(
                            UserSingletonController.instance.getAvatar()),
                      ),
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(
                    height: DimenConstants.marginPaddingTiny,
                  ),
                  Text(
                    UserSingletonController.instance.getName(),
                    style: UIUtils.getStyleTextMedium600(),
                    textAlign: TextAlign.center,
                  ),

                  // Mail
                  Text(
                    UserSingletonController.instance.getEmail(),
                    style: UIUtils.getStyleTextSmall300(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: DimenConstants.marginPaddingLarge,
                  ),
                ],
              ),
            )),
        Card(
            shape: UIUtils.getCardCorner(),
            margin: const EdgeInsets.all(DimenConstants.marginPaddingSmall),
            color: ColorConstants.cardBg,
            shadowColor: Colors.grey,
            elevation: DimenConstants.cardElevation,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: DimenConstants.marginMMedium),
              child: getText(
                  ColorConstants.colorProfile, StringConstants.editProfile, () {
                Get.to(const PageEditProfile());
              }),
            ))
        // Edit profile
        ,
      ],
    );
  }

  Widget getText(
    Color? color,
    String msg,
    GestureTapCallback? onItemPress,
  ) {
    return InkWell(
      onTap: onItemPress,
      child: Row(
        children: [
          const SizedBox(
            width: DimenConstants.marginPaddingMedium,
          ),
          Container(
            width: DimenConstants.circleShape,
            height: DimenConstants.circleShape,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color ?? ColorConstants.appColor,
            ),
          ),
          const SizedBox(
            width: DimenConstants.marginPaddingMedium,
          ),
          Expanded(
              child: Text(
            msg,
            style: UIUtils.getStyleTextSmall400(),
          )),
          const SizedBox(
            width: DimenConstants.marginPaddingMedium,
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
}
