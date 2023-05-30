import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/base_stateful_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends BaseStatefulState<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.colorWhite,
        body: SafeArea(
          child: Container(
              alignment: Alignment.topLeft,
              child: Column(
                children: [_buildBackWidget(), _buildLoginWidget()],
              )),
        ));
  }

  Widget _buildBackWidget() {
    return Container(
      alignment: Alignment.topLeft,
      // margin: const EdgeInsets.symmetric(
      //     vertical: DimenConstants.marginTopIconBack),
      width: DimenConstants.circleBackBg,
      height: DimenConstants.circleBackBg,
      decoration: BoxDecoration(
        color: ColorConstants.bgBackCircleColor,
        shape: BoxShape.circle,
      ),
    );

    // Container(
    //     width: double.infinity,
    //     height: double.infinity,
    //     child: CustomPaint(
    //       painter: CirclePainter(),
    //     ));
    //     Container(
    //   width: MediaQuery.of(context).size.width,
    //   height: 250,
    //   child: Stack(
    //     children: <Widget>[
    //       Positioned(
    //         top: 150,
    //         right: MediaQuery.of(context).size.width - 200,
    //         child: Container(
    //           width: 200,
    //           height: 200,
    //           decoration: BoxDecoration(
    //             color: ColorConstants.bgBackCircle50Color,
    //             borderRadius: BorderRadius.all(
    //               Radius.circular(200),
    //             ),
    //           ),
    //           child: Center(
    //             child: Container(
    //               width: 150,
    //               height: 150,
    //               decoration: BoxDecoration(
    //                 color: ColorConstants.bgBackCircleColor,
    //                 borderRadius: BorderRadius.all(
    //                   Radius.circular(150),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //       Positioned(
    //         bottom: 30,
    //         left: 30,
    //         child: Text(
    //           'Write now',
    //           style: TextStyle(
    //             color: Colors.white,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _buildLoginWidget() {
    return Expanded(
        child: Container(
      decoration: UIUtils.getBoxDecorationLoginBg(),
      width: double.infinity,
      alignment: Alignment.center,
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UIUtils.getTextAuthTitle(StringConstants.signin),
              const SizedBox(width: DimenConstants.marginPaddingMedium),
              UIUtils.getTextInputLogin(StringConstants.email),
              const SizedBox(width: DimenConstants.marginPaddingSmall),
              UIUtils.getTextInputLogin(StringConstants.password),
            ],
          )
        ],
      ),
    ));
  }
}
