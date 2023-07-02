import 'package:appdiphuot/common/const/constants.dart';
import 'package:appdiphuot/ui/home/user/user_preview/page_user_preview_screen.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../../base/base_stateful_state.dart';
import '../../../../common/const/color_constants.dart';
import '../../../../common/const/dimen_constants.dart';
import '../../../../common/const/string_constants.dart';
import '../../../../model/trip.dart';
import '../../../../model/user.dart';
import '../../../../util/ui_utils.dart';
import '../../../../view/profile_bar_widget.dart';
import '../../../user_singleton_controller.dart';
import 'member_controller.dart';

class JoinedManagerScreen extends StatefulWidget {
  const JoinedManagerScreen({super.key, required this.tripdata});

  final Trip tripdata;

  @override
  State<JoinedManagerScreen> createState() => _JoinedManagerScreenState();
}

class _JoinedManagerScreenState extends State<JoinedManagerScreen> {
  final MemberController _controller = Get.put(MemberController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.tripData.value = widget.tripdata;
    _controller.getData();
    _setupListen();
  }

  void _setupListen() {
    _controller.appLoading.listen((appLoading) {
      if (appLoading.isLoading) {
        OverlayLoadingProgress.start(context, barrierDismissible: false);
      } else {
        OverlayLoadingProgress.stop();
      }
    });
    _controller.appError.listen((err) {
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ColorConstants.appColor,
      ),
      backgroundColor: ColorConstants.colorWhite,
      body: Stack(
        children: [
          Obx(() => _getBody()),
          Padding(
            padding: const EdgeInsets.all(
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

  Widget _getBody() {
    return Column(children: [
      const SizedBox(
        height: DimenConstants.marginPaddingXXL,
      ),
      Padding(
        padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
        child: Container(
          alignment: Alignment.center,
          width: Get.width,
          height: Get.height / 7,
          decoration: BoxDecoration(
            color: ColorConstants.colorLanguage.withOpacity(0.5),
            border: Border.all(
              color: ColorConstants.appColor.withOpacity(0.5),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(DimenConstants.radiusRound),
            ),
          ),
          // padding: const EdgeInsets.all(
          //     DimenConstants.marginPaddingMedium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                flex: 2,
                child: Text(
                  'SỐ NGƯỜI THAM GIA',
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: DimenConstants.marginPaddingMedium),
              Expanded(
                flex: 1,
                child: Text(
                  _controller.members.length.toString(),
                  style: TextStyle(
                    fontSize: 80.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                    shadows: <Shadow>[
                      Shadow(
                        offset: const Offset(10.0, 10.0),
                        blurRadius: 3.0,
                        color: ColorConstants.colorPink.withOpacity(0.3),
                      ),
                      Shadow(
                        offset: const Offset(10.0, 10.0),
                        blurRadius: 8.0,
                        color: ColorConstants.colorPink.withOpacity(0.3),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: DimenConstants.marginPaddingMedium),
              Lottie.asset(
                'assets/files/people.json',
                fit: BoxFit.fitWidth,
                width: 105,
                // height: Get.height / 2,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: DimenConstants.marginPaddingMedium),
      getListMembers(),
    ]);
  }

  Widget getListMembers() {
    if (_controller.members.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(
            horizontal: DimenConstants.marginPaddingMedium,
            vertical: DimenConstants.marginPaddingSmall),
        child: Column(
          children: [
            Lottie.asset('assets/files/no_data.json'),
            Text(
              StringConstants.nomember,
              style: UIUtils.getStyleText(),
            )
          ],
        ),
      );
    } else {
      return Expanded(
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 20, right: 20),
          scrollDirection: Axis.vertical,
          itemCount: _controller.members.length,
          itemBuilder: (BuildContext context, int index) {
            return _getItemRow(index);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              color: ColorConstants.dividerColor,
              thickness: DimenConstants.dividerHeight,
            );
          },
        ),
      );
    }
  }

  Widget _getItemRow(int index) {
    var user = _controller.members[index];
    return Padding(
      padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
      child: InkWell(
        onTap: (){
          _openMemberProfile(user);
        },
        child: Row(
          children: [
            Container(
              width: 50, // Kích thước rộng mong muốn
              height: 50,
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.getAvatar()),
              ),
            ),
            Expanded(
                child: Container(
                    margin: const EdgeInsets.only(
                        left: DimenConstants.marginPaddingMedium,
                        right: DimenConstants.marginPaddingMedium),
                    child: Text(user.name ?? ""))),
            getIconUser(user),
          ],
        ),
      ),
    );
  }

  void _openMemberProfile(UserData user) {
    Get.to(() => const PageUserPreviewScreen(), arguments: [
      { Constants.user: user.uid}
    ]);
  }

  Widget getIconUser(UserData user) {
    var currentUid = UserSingletonController.instance.getUid();
    if (_controller.tripData.value.userIdHost == user.uid) {
      return Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Colors.red, // Màu nền đỏ
          shape: BoxShape.circle,
        ),
        // Khoảng cách nội dung trong container
        child: const Icon(
          size: 18,
          Icons.hiking,
          color: Colors.white, // Màu biểu tượng (icon) trắng
        ),
      );
    } else {
      if (currentUid == _controller.tripData.value.userIdHost) {
        return InkWell(
          onTap: () {
            _showDeleteDialog(user);
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.red, // Màu nền đỏ
              shape: BoxShape.circle,
            ),
            // Khoảng cách nội dung trong container
            child: const Icon(
              size: 18,
              Icons.delete,
              color: Colors.white, // Màu biểu tượng (icon) trắng
            ),
          ),
        );
      } else {
        return Container();
      }
    }
  }

  void _showDeleteDialog(UserData user) {
    UIUtils.showAlertDialog(
      context,
      StringConstants.warning,
      "Bạn có chắc muốn remove '${user.name ?? ""}' Không?",
      StringConstants.cancel,
      null,
      StringConstants.delete,
      (){
        _controller.removeMember(user);
      },
    );
  }
}
