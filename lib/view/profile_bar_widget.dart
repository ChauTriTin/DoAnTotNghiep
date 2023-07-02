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
    this.onAvatarPress,
  });

  final String name;
  final String state;
  final String linkAvatar;
  final Function? onAvatarPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DimenConstants.marginPaddingSmall),
      color: ColorConstants.appColor,
      child: Row(
        children: [
          const SizedBox(width: 12,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4,),
                Text(
                  state,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 50,
            height: 50,
            child: AvatarGlow(
              glowColor: Colors.white,
              endRadius: 40,
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: const Duration(milliseconds: 100),
              child: InkWell(
                onTap: () {
                  if (onAvatarPress != null) onAvatarPress!();
                },
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(48), // Image radius
                      child: Image.network(
                        fit: BoxFit.cover,
                        linkAvatar,
                        height: 45,
                        width: 45,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 8,),
        ],
      ),
    );
  }
}
