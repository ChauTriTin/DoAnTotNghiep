
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../base/base_stateful_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreen();
  }
}

class _RegisterScreen extends BaseStatefulState<RegisterScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Register"),
      ),
    );

  }
}
