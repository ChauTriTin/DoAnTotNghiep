import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/ui/home/router/rate/done_trip/rate_controller.dart';
import 'package:appdiphuot/ui/home/router/rate/form/form_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({
    super.key,
    required this.id,
  });

  final String id;

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
          Center(
            child: Lottie.asset(
              'assets/files/fire.json',
              fit: BoxFit.fitHeight,
              width: Get.width,
              height: Get.height / 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Bạn cảm thấy như thế nào\nvề chuyến đi?\nHãy đánh giá ngay nhé!!!",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.textColorDisable,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back(); //close this screen
                      Get.to(FormScreen(
                        id: widget.id,
                      ));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorConstants.colorWhite,
                        border: Border.all(
                          color: ColorConstants.appColor,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(DimenConstants.radiusRound),
                        ),
                      ),
                      padding: const EdgeInsets.all(
                          DimenConstants.marginPaddingMedium),
                      margin: const EdgeInsets.fromLTRB(
                        DimenConstants.marginPaddingExtraLarge,
                        DimenConstants.marginPaddingLarge,
                        DimenConstants.marginPaddingExtraLarge,
                        DimenConstants.marginPaddingLarge,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/ic_launcher_2.png",
                            width: 200,
                          ),
                          const Text(
                            "HOÀN THÀNH",
                            style: TextStyle(
                              fontSize: DimenConstants.txtHeader1,
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
