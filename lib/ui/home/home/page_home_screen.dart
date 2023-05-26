import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/home/home/page_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../view/profile_bar_widget.dart';

class PageHomeScreen extends StatefulWidget {
  const PageHomeScreen({
    super.key,
  });

  @override
  State<PageHomeScreen> createState() => _PageHomeScreenState();
}

class _PageHomeScreenState extends BaseStatefulState<PageHomeScreen> {
  final _controllerDemo = Get.put(PageHomeController());

  @override
  void initState() {
    super.initState();
    _setupListen();
  }

  void _setupListen() {
    _controllerDemo.appLoading.listen((appLoading) {});
    _controllerDemo.appError.listen((err) {
      showErrorDialog(StringConstants.errorMsg, err.messageError, "Retry", () {
        //do sth
      });
    });
  }

  @override
  void dispose() {
    _controllerDemo.clearOnDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ColorConstants.appColor,
      ),
      backgroundColor: ColorConstants.appColorBkg,
      body: Container(
        color: ColorConstants.appColorBkg,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const ProfileBarWidget(
              name: "Nguyen Hoang Giang",
              state: "⬤ Online",
              linkAvatar: StringConstants.linkImgMinaCrying,
            ),
            Row(
              children: [
                const SizedBox(width: DimenConstants.marginPaddingMedium),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: ColorConstants.appColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: const Text(
                    'Tạo chuyến đi',
                    style: TextStyle(
                      fontSize: DimenConstants.txtMedium,
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Mã: AB0134NM45',
                    style: TextStyle(
                      fontSize: DimenConstants.txtMedium,
                      color: ColorConstants.appColor,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
                const SizedBox(width: DimenConstants.marginPaddingSmall),
                const Icon(
                  Icons.content_copy,
                  color: ColorConstants.appColor,
                ),
                const SizedBox(width: DimenConstants.marginPaddingMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
