import 'dart:async';

import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/model/bus/event_bus.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:appdiphuot/ui/home/router/map/map_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_countdown/slide_countdown.dart';

import 'rate_controller.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({
    super.key,
    // required this.id,
  });

  // final String id;

  @override
  State<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends BaseStatefulState<RateScreen> {
  final _controller = Get.put(RateController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.clearOnDispose();
    super.dispose();
  }

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
          Padding(
            padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "TẠO THÀNH CÔNG",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.appColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: DimenConstants.marginPaddingSmall),
                  const Text(
                    "Chuyến đi của bạn đã được tạo với mã",
                    style: TextStyle(
                      fontSize: DimenConstants.txtMedium,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: DimenConstants.marginPaddingMedium),
                  const Text(
                    "111",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.appColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: DimenConstants.marginPaddingLarge),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      width: Get.width,
                      height: Get.height / 5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(DimenConstants.radiusRound),
                        ),
                      ),
                      padding: const EdgeInsets.all(
                          DimenConstants.marginPaddingMedium),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ĐI THÔI",
                            style: TextStyle(
                              fontSize: DimenConstants.txtMedium,
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.appColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: DimenConstants.marginPaddingLarge),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              DimenConstants.marginPaddingMedium,
              DimenConstants.marginPaddingLarge,
              DimenConstants.marginPaddingMedium,
              DimenConstants.marginPaddingMedium,
            ),
            child: FloatingActionButton(
              mini: true,
              elevation: DimenConstants.elevationMedium,
              backgroundColor: ColorConstants.appColor,
              onPressed: () {
                Get.back();
              },
              child: const Icon(Icons.clear),
            ),
          ),
        ],
      ),
    );
  }
}
