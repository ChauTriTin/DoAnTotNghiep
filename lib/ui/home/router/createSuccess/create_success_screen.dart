import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/ui/base/demo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CreateSuccessScreen extends StatefulWidget {
  const CreateSuccessScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<CreateSuccessScreen> createState() => _CreateSuccessScreenState();
}

class _CreateSuccessScreenState extends BaseStatefulState<CreateSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Lottie.asset('assets/files/wave.json'),
          Align(
            alignment: Alignment.bottomCenter,
            child: Lottie.asset(
              'assets/files/wave_1.json',
              fit: BoxFit.fitWidth,
              width: Get.width,
            ),
          ),
          const Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "TẠO THÀNH CÔNG",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.appColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
