
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../common/const/color_constants.dart';
import '../../../common/const/dimen_constants.dart';
import '../../../util/ui_utils.dart';

Widget buildItemSetting(
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


void showDialogMsg(String title, String body, BuildContext context) {
  showMaterialModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      context: context,
      builder: (context) => _buildBodyDialog(title, body, context));
}

Widget _buildBodyDialog(String title, String body, BuildContext context) {
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
              child: SingleChildScrollView(
                child: Text(
                  body,
                  style: UIUtils.getStyleText(),
                ),
              )),
          const SizedBox(height: DimenConstants.marginPaddingLarge),
        ],
      ),
    ),
  );
}


