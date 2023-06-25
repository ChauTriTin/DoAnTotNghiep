import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
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
  });

  final String id;

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
    );
  }

  Widget _buildList() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        DimenConstants.marginPaddingMedium,
        DimenConstants.marginPadding98,
        DimenConstants.marginPaddingMedium,
        DimenConstants.marginPaddingMedium,
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
          _controller.currentUserData.value.getAvatar(),
          null,
          "Trưởng đoàn",
          _controller.currentUserData.value.name ?? "",
        ),
        const SizedBox(height: DimenConstants.marginPaddingMedium),
        const Divider(),
        const SizedBox(height: DimenConstants.marginPaddingMedium),
        _buildItem(
          null,
          "assets/images/ic_launcher_2.png",
          "Về chuyến đi",
          _controller.trip.value.title ?? "",
        ),
        const SizedBox(height: DimenConstants.marginPaddingMedium),
        const Divider(),
        const SizedBox(height: DimenConstants.marginPaddingMedium),
        _buildItem(
          null,
          "assets/images/ic_marker_start.png",
          "Điểm xuất phát",
          _controller.trip.value.placeStart?.name ?? "",
        ),
        _buildStopView(),
        const SizedBox(height: DimenConstants.marginPaddingMedium),
        const Divider(),
        const SizedBox(height: DimenConstants.marginPaddingMedium),
        _buildItem(
          null,
          "assets/images/ic_marker_end.png",
          "Địa điểm đến",
          _controller.trip.value.placeEnd?.name ?? "",
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
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (context, i) {
        return _buildItem(
          null,
          "assets/images/ic_marker_end.png",
          "Địa điểm đến",
          _controller.trip.value.placeEnd?.name ?? "",
        );
      },
    );
  }

  Widget _buildItem(
    String? urlNetwork,
    String? urlAsset,
    String text1,
    String text2,
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
                style: TextStyle(
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
                initialValue: 3.0,
                readOnly: false,
                onChange: (value) {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
