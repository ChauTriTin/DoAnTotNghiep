import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/home/noti/page_noti_controller.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageNotiScreen extends StatefulWidget {
  const PageNotiScreen({
    super.key,
  });

  @override
  State<PageNotiScreen> createState() => _PageNotiScreenState();
}

class _PageNotiScreenState extends BaseStatefulState<PageNotiScreen> {
  final _controller = Get.put(PageNotiController());

  @override
  void initState() {
    super.initState();
    _setupListen();
    _controller.getListNotification();
  }

  void _setupListen() {
    _controller.appLoading.listen((appLoading) {});
    _controller.appError.listen((err) {
      showErrorDialog(StringConstants.errorMsg, err.messageError, "Retry", () {
        //do sth
      });
    });
  }

  @override
  void dispose() {
    _controller.clearOnDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.appColorBkg,
      body: Container(
        padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
        child: _buildList(),
      ),
    );
  }

  Widget _buildList() {
    return Obx(() {
      var list = _controller.listNotification;
      Dog.e(">>>_buildList list $list");
      if (list.isEmpty) {
        return Center(
          child: UIUtils.getText("No data"),
        );
      } else {
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            return Container(
              padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
              child: Column(
                children: [
                  UIUtils.getText(list[i].title ?? ""),
                  UIUtils.getText(list[i].body ?? ""),
                ],
              ),
            );
          },
        );
      }
    });
  }
}
