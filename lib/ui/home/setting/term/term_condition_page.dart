import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermAndConditionPagge extends StatefulWidget {
  const TermAndConditionPagge({
    super.key,
  });

  @override
  State<TermAndConditionPagge> createState() => _PageSettingScreen();
}

class _PageSettingScreen extends BaseStatefulState<TermAndConditionPagge> {
  @override
  void initState() {
    super.initState();
    _setupListen();
  }

  void _setupListen() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstants.appColor,
          title: const Text(StringConstants.termCondition),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        backgroundColor: ColorConstants.colorWhite,
        body: Obx(() {
          return buildBody();
        }));
  }

  Widget buildBody() {
    return Container(
      margin: const EdgeInsets.all(DimenConstants.marginPaddingLarge),
      child: Column(
        children: [],
      ),
    );
  }
}
