import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/home/home/page_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      backgroundColor: ColorConstants.appColorBkg,
      body: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
        child: Obx(() {
          var number = _controllerDemo.number.value;
          var list = _controllerDemo.list.toString();
          return ListView(
            children: [
              const Text(
                "This is Home Page",
                style: TextStyle(
                  fontSize: DimenConstants.txtLarge,
                  color: Colors.red,
                ),
              ),
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
