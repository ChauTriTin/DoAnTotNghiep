import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
    double rate = UserSingletonController.instance.userData.value.getRate();
    int rateCount =
        UserSingletonController.instance.userData.value.rates?.length ?? 0;
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
                  const SizedBox(height: 8,),
                  // Mail
                  Text(
                    UserSingletonController.instance.getEmail(),
                    style: UIUtils.getStyleTextSmall300(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RatingBar.builder(
                        initialRating: rate,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemSize: 20.0,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.orange,
                        ),
                        ignoreGestures: true,
                        onRatingUpdate: (double value) {},
                      ),
                      const SizedBox(
                        width: DimenConstants.marginPaddingTiny,
                      ),
                      Text(
                        rate.toString(),
                        style: const TextStyle(
                            color: ColorConstants.colorGreen,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(width: 6,),
                      const Text("|", style: TextStyle(color: ColorConstants.textColorDisable)),
                      const SizedBox(width: 6,),

                      Text(
                        "$rateCount đánh giá",
                        style: const TextStyle(
                            color: ColorConstants.colorGreen,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: DimenConstants.marginPaddingLarge,
                  ),
                ],
              ),
            )),

        // Edit profile
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
            )),
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
