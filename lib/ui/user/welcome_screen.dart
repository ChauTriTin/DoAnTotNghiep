import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../base/base_stateful_state.dart';
import '../../common/const/color_constants.dart';
import '../../common/const/string_constants.dart';
import '../../util/ui_utils.dart';
import 'welcome_screen_controller.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends BaseStatefulState<WelcomeScreen> {
  final _cHomePage = Get.put(WelcomeController());

  @override
  void initState() {
    super.initState();
    _setupListen();
  }

  void _setupListen() {
    _cHomePage.appLoading.listen((appLoading) {});
    _cHomePage.appError.listen((err) {
      showErrorDialog(StringConstants.errorMsg, err.messageError, "Retry", () {
        //do sth
      });
    });
  }

  @override
  void dispose() {
    _cHomePage.clearOnDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.appColorBkg,
      appBar: UIUtils.getAppBar(
        StringConstants.appName,
        () {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else {
            exit(0);
          }
        },
        () {},
        iconData: Icons.menu,
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
