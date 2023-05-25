import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/ui/base/demo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/base_stateful_state.dart';
import '../../common/const/color_constants.dart';
import '../../common/const/string_constants.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends BaseStatefulState<DemoScreen> {
  final _controllerDemo = Get.put(DemoController());

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
      backgroundColor: ColorConstants.appColorBkg,
      body: Container(
        padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
        child: Obx(() {
          var number = _controllerDemo.number.value;
          var list = _controllerDemo.list.toString();
          return ListView(
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(240, 50),
                ),
                onPressed: () {
                  _controllerDemo.addNumber();
                  _controllerDemo.addString();
                },
                child: const Text(
                  '+',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.red,
                  ),
                ),
              ),
              Text("Number $number"),
              const SizedBox(height: DimenConstants.marginPaddingMedium),
              Text("list $list"),
              const SizedBox(height: DimenConstants.marginPaddingMedium),
            ],
          );
        }),
      ),
    );
  }
}
