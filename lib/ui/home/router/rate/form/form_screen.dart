import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/ui/home/router/rate/done_trip/rate_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({
    super.key,
    // required this.id,
  });

  // final String id;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends BaseStatefulState<FormScreen> {
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
      padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
      children: [],
    );
  }
}
