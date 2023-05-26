import 'package:appdiphuot/ui/login/register/page_register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/base_stateful_state.dart';
import '../../../common/const/string_constants.dart';
import '../login/page_login_screen.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthenticationScreen();
  }
}

class _AuthenticationScreen extends BaseStatefulState<AuthenticationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Expanded(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Get.to(const LoginScreen());
              },
              child: const Text(StringConstants.signin),
            ),
            TextButton(
              onPressed: () {
                Get.to(const RegisterScreen());
              },
              child: const Text(StringConstants.register),
            )
          ],
        ),
      )),
    );
  }
}
