import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../../base/base_stateful_state.dart';
import '../../../../common/const/color_constants.dart';
import '../../../../view/profile_bar_widget.dart';
import '../../../user_singleton_controller.dart';

class JoinedManagerScreen extends StatefulWidget {
  const JoinedManagerScreen({super.key, required this.id});

  final String id;

  @override
  State<JoinedManagerScreen> createState() => _JoinedManagerScreenState();
}

class _JoinedManagerScreenState extends State<JoinedManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: ColorConstants.appColor,
        ),
        body: Obx(
          () => Container(
            color: ColorConstants.colorWhite,
            child: Column(children: [
              ProfileBarWidget(
                  name: UserSingletonController.instance.userData.value.name ??
                      "",
                  state: "⬤ Online",
                  linkAvatar: UserSingletonController.instance.userData.value
                      .getAvatar()),
            ]),
          ),
        ));
  }
}
