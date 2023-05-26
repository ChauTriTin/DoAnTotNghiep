import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import '../common/const/color_constants.dart';
import '../common/const/string_constants.dart';

class ProfileBarWidget extends StatelessWidget {
  const ProfileBarWidget({
    super.key,
    required this.name,
    required this.state,
    required this.linkAvatar,
  });

  final String name;
  final String state;
  final String linkAvatar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
      color: ColorConstants.appColor,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: DimenConstants.txtLarge,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  state,
                  style: const TextStyle(
                    fontSize: DimenConstants.txtMedium,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 70,
            height: 70,
            child: AvatarGlow(
              glowColor: Colors.white,
              endRadius: 60,
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: const Duration(milliseconds: 100),
              child: SizedBox(
                width: 50,
                height: 50,
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(48), // Image radius
                    child: Image.network(
                      linkAvatar,
                      height: 45,
                      width: 45,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
