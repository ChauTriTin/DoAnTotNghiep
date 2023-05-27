import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_countdown/slide_countdown.dart';

import 'create_success_controller.dart';

class CreateSuccessScreen extends StatefulWidget {
  const CreateSuccessScreen({
    super.key,
    required this.title,
    required this.dateTimeEnd,
  });

  final String title;
  final DateTime dateTimeEnd;

  @override
  State<CreateSuccessScreen> createState() => _CreateSuccessScreenState();
}

class _CreateSuccessScreenState extends BaseStatefulState<CreateSuccessScreen> {
  final _controller = Get.put(CreateSuccessController());

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
          Obx(() {
            var isDoneCountdown = _controller.isDoneCountdown.value;
            return Padding(
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
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.appColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: DimenConstants.marginPaddingLarge),
                    Container(
                      alignment: Alignment.center,
                      width: Get.width,
                      height: Get.height / 5,
                      decoration: BoxDecoration(
                        color: isDoneCountdown
                            ? Colors.white
                            : ColorConstants.appColor.withOpacity(0.5),
                        border: Border.all(
                          color: isDoneCountdown
                              ? Colors.white
                              : ColorConstants.appColor.withOpacity(0.5),
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(DimenConstants.radiusRound),
                        ),
                      ),
                      padding: const EdgeInsets.all(
                          DimenConstants.marginPaddingMedium),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isDoneCountdown
                                ? "ĐI THÔI"
                                : "Chuyến đi sẽ khởi hành sau",
                            style: TextStyle(
                              fontSize: DimenConstants.txtMedium,
                              fontWeight: FontWeight.bold,
                              color: isDoneCountdown
                                  ? ColorConstants.appColor
                                  : Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (!isDoneCountdown)
                            const SizedBox(
                                height: DimenConstants.marginPaddingMedium),
                          Expanded(
                            child: SlideCountdownSeparated(
                              showZeroValue: true,
                              duration:
                                  widget.dateTimeEnd.difference(DateTime.now()),
                              // separatorType: SeparatorType.title,
                              // slideDirection: SlideDirection.up,
                              onDone: () {
                                _controller.setDoneCountdown(true);
                              },
                              replacement: Image.asset(
                                "assets/images/bike.png",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: DimenConstants.marginPaddingLarge),
                  ],
                ),
              ),
            );
          }),
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