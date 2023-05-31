
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
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
      backgroundColor: ColorConstants.colorWhite,
      body: SafeArea(
          child: Column (
            children: [_buildBackWidget(), _buildRegisterWidget()],
          )
      ),
    );

  }

  Widget _buildBackWidget() {
    return Container(
      // margin: const EdgeInsets.symmetric(
      //     vertical: DimenConstants.marginTopIconBack),
      width: double.infinity,
      height: DimenConstants.circleBackBg,
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Positioned(
            top: -50,
            left: -250,
            right: 0,
            bottom: 0,
            child: Container(
                decoration: BoxDecoration(
                  color: ColorConstants.bgBackCircleColor,
                  shape: BoxShape.circle,
                ),
              child: Center(
                child: Text(
                    "Trở lại",
                  style: TextStyle(color: ColorConstants.colorWhite),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRegisterWidget() {
    return Expanded(
        child: Container(

        )
    );
  }
}
