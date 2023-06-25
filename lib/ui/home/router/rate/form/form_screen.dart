import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/ui/home/router/rate/form/form_controller.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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
          _buildList(),
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
        const Text(
          'ĐÁNH GIÁ VỀ CHUYẾN ĐI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: DimenConstants.txtLarge,
          ),
        ),
        const SizedBox(height: DimenConstants.marginPaddingMedium),
        _buildItem(_controller.currentUserData.value.getAvatar() ?? ""),
      ],
    );
  }

  Widget _buildItem(String urlNetwork) {
    return Container(
      child: Row(
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
                  child: Image.network(
                    urlNetwork,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
