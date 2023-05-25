import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/ui/base/demo_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/base_stateful_state.dart';
import '../../common/const/color_constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends BaseStatefulState<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.appColorBkg,
      body: Container(
        padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                "assets/images/ic_launcher.png",
                height: 200,
              ),
            ),
            const Text("ABC"),
            const SizedBox(height: DimenConstants.marginPaddingMedium),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(240, 50),
              ),
              onPressed: () {},
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: DimenConstants.marginPaddingMedium),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(240, 50),
              ),
              onPressed: () {},
              child: const Text(
                'Signup',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: DimenConstants.marginPaddingMedium),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(240, 50),
              ),
              onPressed: () {
                Get.to(const DemoScreen(title: "my title"));
              },
              child: const Text(
                'Demo',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
