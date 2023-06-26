import 'dart:async';

import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/model/bus/event_bus.dart';
import 'package:appdiphuot/ui/home/router/map/map_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_countdown/slide_countdown.dart';

import 'create_success_controller.dart';

class CreateSuccessScreen extends StatefulWidget {
  const CreateSuccessScreen({
    super.key,
    required this.id,
    // required this.dateTimeEnd,
    // required this.placeStart,
    // required this.placeEnd,
    // required this.listPlaceStop,
  });

  final String id;

  // final DateTime dateTimeEnd;
  // final Place placeStart;
  // final Place placeEnd;
  // final List<Place> listPlaceStop;

  @override
  State<CreateSuccessScreen> createState() => _CreateSuccessScreenState();
}

class _CreateSuccessScreenState extends BaseStatefulState<CreateSuccessScreen> {
  final _controller = Get.put(CreateSuccessController());
  StreamSubscription? eventBusOnBackPress;

  @override
  void initState() {
    super.initState();
    _listenBus();
    _controller.getRouter(widget.id);
  }

  void _listenBus() {
    eventBusOnBackPress = eventBus.on<OnBackPress>().listen((event) {
      if (event.className == mapScreen) {
        Get.back();
      }
    });
  }

  @override
  void dispose() {
    _controller.clearOnDispose();
    eventBusOnBackPress?.cancel();
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
                    Text(
                      "TẠO THÀNH CÔNG",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.appColor,
                        shadows: <Shadow>[
                          Shadow(
                            offset: const Offset(3.0, 3.0),
                            blurRadius: 3.0,
                            color: ColorConstants.errorBorderTextInputColor
                                .withOpacity(0.5),
                          ),
                          Shadow(
                            offset: const Offset(3.0, 3.0),
                            blurRadius: 8.0,
                            color: ColorConstants.errorBorderTextInputColor
                                .withOpacity(0.5),
                          ),
                        ],
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
                      widget.id,
                      style: const TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.appColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: DimenConstants.marginPaddingLarge),
                    InkWell(
                      onTap: () {
                        _tapGoNow();
                      },
                      child: Container(
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
                                duration: _controller
                                    .getDateTimeEnd()
                                    .difference(DateTime.now()),
                                // separatorType: SeparatorType.title,
                                // slideDirection: SlideDirection.up,
                                onDone: () {
                                  _controller.setDoneCountdown(true);
                                },
                                replacement: Image.asset(
                                  "assets/images/ic_launcher.png",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: (DimenConstants.marginPaddingMedium) * 5),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        alignment: Alignment.center,
                        width: Get.width,
                        height: Get.height / 10,
                        decoration: BoxDecoration(
                          color: isDoneCountdown
                              ? Colors.white
                              : ColorConstants.colorLanguage.withOpacity(0.5),
                          border: Border.all(
                            color: isDoneCountdown
                                ? Colors.white
                                : ColorConstants.appColor.withOpacity(0.5),
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(DimenConstants.radiusRound),
                          ),
                        ),
                        // padding: const EdgeInsets.all(
                        //     DimenConstants.marginPaddingMedium),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Text(
                                'SỐ NGƯỜI THAM GIA',
                                style: TextStyle(
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const SizedBox(
                                width: DimenConstants.marginPaddingMedium),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "${_controller.trip.value.listIdMember?.length ?? 0}",
                                style: TextStyle(
                                  fontSize: 80.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontStyle: FontStyle.italic,
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: const Offset(10.0, 10.0),
                                      blurRadius: 3.0,
                                      color: ColorConstants.colorPink
                                          .withOpacity(0.3),
                                    ),
                                    Shadow(
                                      offset: const Offset(10.0, 10.0),
                                      blurRadius: 8.0,
                                      color: ColorConstants.colorPink
                                          .withOpacity(0.3),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                                width: DimenConstants.marginPaddingMedium),
                            Expanded(
                              flex: 2,
                              child: Lottie.asset(
                                'assets/files/people.json',
                                fit: BoxFit.fitWidth,
                                width: Get.width,
                                // height: Get.height,
                              ),
                            ),
                          ],
                        ),
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

  void _tapGoNow() {
    void go() {
      // Get.back(); //warning don't use go back
      Navigator.pop(context);
      var id = widget.id;
      Get.to(MapScreen(
        id: id,
      ));
    }

    if (kDebugMode == true) {
      showSnackBarFull(
          StringConstants.warning, "Debug mode: forced go to map screen");
      go();
    }
    if (!_controller.isDoneCountdown.value) {
      return;
    }
    go();
  }
}
