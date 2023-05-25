import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../base/base_stateful_state.dart';
import '../common/const/color_constants.dart';
import '../common/const/string_constants.dart';
import '../util/ui_utils.dart';
import 'home_page_controller.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends BaseStatefulState<MyHomePage> {
  final _cHomePage = Get.put(HomePageController());

  @override
  void initState() {
    super.initState();
    _setupListen();
  }

  void _setupListen() {
    _cHomePage.appLoading.listen((appLoading) {});
    _cHomePage.appError.listen((err) {
      showErrorDialog(
          StringConstants.errorMsg, err.messageError, "Retry", () {});
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
      body: Container(),
      // floatingActionButton: const FloatingActionButton(
      //   onPressed: null,
      //   child: Icon(Icons.favorite),
      // ),
    );
  }
}
