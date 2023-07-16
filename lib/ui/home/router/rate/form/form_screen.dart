import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/home/router/rate/form/form_controller.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:rate/rate.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({
    super.key,
    required this.id,
    required this.onRateSuccess,
  });

  final String id;
  final VoidCallback onRateSuccess;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends BaseStatefulState<FormScreen> {
  final _controller = Get.put(FormController());

  @override
  void initState() {
    super.initState();
    _controller.getRouter(widget.id);
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
            return _buildList();
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
      floatingActionButton: FloatingActionButton(
        elevation: DimenConstants.elevationMedium,
        backgroundColor: ColorConstants.colorWhite,
        onPressed: () {
          _controller.rate(() {
            showDialogRateSuccess();
          });
        },
        child: const Icon(
          Icons.check,
          color: ColorConstants.appColor,
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        DimenConstants.marginPaddingMedium,
        DimenConstants.marginPadding98,
        DimenConstants.marginPaddingMedium,
        DimenConstants.splashIconSize,
      ),
      children: [
        const Center(
          child: Text(
            'ĐÁNH GIÁ VỀ CHUYẾN ĐI',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: DimenConstants.txtLarge,
            ),
          ),
        ),
        const SizedBox(height: DimenConstants.marginPaddingMedium),
        _buildItem(
          _controller.getLeaderInfor()?.getAvatar(),
          null,
          "Trưởng đoàn",
          _controller.getLeaderInfor()?.name ?? "",
          (rate) {
            _controller.setRateLeader(rate);
          },
        ),
        const SizedBox(height: DimenConstants.marginPaddingMedium),
        const Divider(),
        const SizedBox(height: DimenConstants.marginPaddingMedium),
        _buildItem(
          null,
          "assets/images/ic_launcher_2.png",
          "Về chuyến đi",
          _controller.trip.value.title ?? "",
          (rate) {
            _controller.setRateTrip(rate);
          },
        ),
        const SizedBox(height: DimenConstants.marginPaddingMedium),
        const Divider(),
        const SizedBox(height: DimenConstants.marginPaddingMedium),
        _buildItem(
          null,
          "assets/images/ic_marker_start.png",
          "Điểm xuất phát",
          _controller.trip.value.placeStart?.fullAddress ?? "",
          (rate) {
            _controller.setPlaceStart(rate);
          },
        ),
        _buildStopView(),
        const SizedBox(height: DimenConstants.marginPaddingMedium),
        const Divider(),
        const SizedBox(height: DimenConstants.marginPaddingMedium),
        _buildItem(
          null,
          "assets/images/ic_marker_end.png",
          "Địa điểm đến",
          _controller.trip.value.placeEnd?.fullAddress ?? "",
          (rate) {
            _controller.setPlaceEnd(rate);
          },
        ),
      ],
    );
  }

  Widget _buildStopView() {
    var list = _controller.trip.value.listPlace ?? List.empty();
    if (list.isEmpty) {
      return Container();
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, i) {
        return Column(
          children: [
            if (i != 0)
              const SizedBox(height: DimenConstants.marginPaddingMedium),
            if (i != 0) const Divider(),
            if (i != 0)
              const SizedBox(height: DimenConstants.marginPaddingMedium),
            _buildItem(
              null,
              "assets/images/ic_marker_end.png",
              "Địa điểm dừng chân ${i + 1}",
              list[i].fullAddress ?? "",
              (rate) {
                _controller.setPlaceStopWithIndex(rate, i);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildItem(
    String? urlNetwork,
    String? urlAsset,
    String text1,
    String text2,
    Function(double value)? onChange,
  ) {
    Widget buildImg() {
      if (urlNetwork == null || urlNetwork.isEmpty) {
        return Image.asset(
          urlAsset ?? "",
          height: 50,
          width: 50,
          fit: BoxFit.scaleDown,
        );
      } else {
        return Image.network(
          urlNetwork,
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        );
      }
    }

    return Row(
      children: [
        AvatarGlow(
          glowColor: Colors.red,
          endRadius: 50,
          duration: const Duration(milliseconds: 2000),
          repeat: true,
          showTwoGlows: true,
          repeatPauseDuration: const Duration(milliseconds: 100),
          child: SizedBox(
            width: 50,
            height: 50,
            child: ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(48), // Image radius
                child: buildImg(),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.textColorDisable,
                  fontSize: DimenConstants.txtMedium,
                ),
              ),
              Text(
                text2,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.appColor,
                  fontSize: DimenConstants.txtMedium,
                ),
              ),
              Rate(
                iconSize: 40,
                color: Colors.orange,
                allowHalf: false,
                allowClear: true,
                initialValue: 0.0,
                readOnly: false,
                onChange: onChange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showDialogRateSuccess() {
    Get.dialog(
      Container(
        alignment: Alignment.center,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            width: Get.width * 80 / 100,
            // height: Get.height / 2,
            // padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
            decoration: BoxDecoration(
              color: ColorConstants.appColor,
              border: Border.all(
                color: ColorConstants.appColor,
              ),
              borderRadius: const BorderRadius.all(
                  Radius.circular(DimenConstants.radiusMedium)),
            ),
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    DimenConstants.marginPaddingSmall,
                    DimenConstants.marginPaddingMedium,
                    DimenConstants.marginPaddingMedium,
                    DimenConstants.marginPaddingSmall,
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: Get.width,
                  margin: const EdgeInsets.fromLTRB(
                    DimenConstants.marginPaddingSmall,
                    DimenConstants.marginPaddingMedium,
                    DimenConstants.marginPaddingSmall,
                    DimenConstants.marginPaddingSmall,
                  ),
                  padding: const EdgeInsets.fromLTRB(
                    DimenConstants.marginPaddingMedium,
                    DimenConstants.marginPaddingMedium,
                    DimenConstants.marginPaddingMedium,
                    DimenConstants.marginPaddingMedium,
                  ),
                  decoration: BoxDecoration(
                    color: ColorConstants.textColorForgotPassword,
                    border: Border.all(
                      color: ColorConstants.textColorForgotPassword,
                    ),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(DimenConstants.radiusMedium)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "CẢM ƠN BẠN VÌ NHỮNG ĐÁNH GIÁ NÀY NHÉ!",
                        style: TextStyle(
                          fontSize: DimenConstants.txtLarge,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                          height: DimenConstants.marginPaddingMedium),
                      ElevatedButton(
                        onPressed: () {
                          //TODO loitp revert
                          // Get.back(); //close this popup
                          // Get.back(); //close this screen
                          widget.onRateSuccess.call();
                          showSnackBarFull(
                              StringConstants.warning, "Đánh giá thành công");
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          '          OK          ',
                          //warning do not remove space letter
                          style: TextStyle(fontSize: DimenConstants.txtLarge),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
