import 'dart:convert';

import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/home/chat/detail/page_detail_chat_screen.dart';
import 'package:appdiphuot/ui/home/chat/page_chat_controller.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../common/const/constants.dart';
import '../../../model/trip.dart';
import '../router/join/joine_manager_screen.dart';

class PageChatScreen extends StatefulWidget {
  const PageChatScreen({
    super.key,
  });

  @override
  State<PageChatScreen> createState() => _PageChatScreenState();
}

class _PageChatScreenState extends BaseStatefulState<PageChatScreen> {
  final _controller = Get.put(PageChatController());

  @override
  void initState() {
    super.initState();
    _setupListen();
  }

  void _setupListen() {
    _controller.appLoading.listen((appLoading) {});
    _controller.appError.listen((err) {
      showErrorDialog(StringConstants.errorMsg, err.messageError, "Retry", () {
        //do sth
      });
    });
  }

  @override
  void dispose() {
    _controller.clearOnDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.colorWhite,
      body: Obx(() {
        if (_controller.trips.isEmpty) {
          return Container(
            margin: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
            child: Column(
              children: [
                Lottie.asset('assets/files/no_data.json'),
                Text(
                  StringConstants.noMessage,
                  style: UIUtils.getStyleText(),
                )
              ],
            ),
          );
        } else {
          return ListView.separated(
            // padding: const EdgeInsets.only(),
            physics: const BouncingScrollPhysics(),
            itemCount: _controller.trips.length,
            separatorBuilder: (BuildContext context, int index) {
              // return const SizedBox(height: DimenConstants.marginPaddingSmall);
              return const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: DimenConstants.marginPaddingMedium),
                child: Divider(
                  height: DimenConstants.marginPaddingSmall,
                  color: ColorConstants.dividerGreyColor,
                ),
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return _getRowConversation(index, _controller.trips[index]);
            },
          );
        }
      }),
    );
  }

  Widget _getRowConversation(int index, Trip trip) {
    return InkWell(
        child: Padding(
          padding: const EdgeInsets.only(
              left: DimenConstants.marginPaddingMedium,
              right: DimenConstants.marginPaddingMedium),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(24),
                    child: CachedMemoryImage(
                      fit: BoxFit.cover,
                      uniqueKey: trip.getFirstImageUrl(),
                      base64: trip.getFirstImageUrl(),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  trip.title ?? "",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: DimenConstants.txtMedium,
                      fontWeight: FontWeight.w400),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.to(JoinedManagerScreen(tripdata: trip));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.supervised_user_circle_rounded,
                      size: 24,
                      color: ColorConstants.appColor1,
                    ),
                    const SizedBox(
                      width: 1,
                    ),
                    Text(
                      "${trip.listIdMember?.length.toString()}",
                      //   style: GoogleFonts.roboto(
                      //   fontSize: 18.0,
                      //   fontWeight: FontWeight.bold,
                      //   // other properties...
                      // ),
                      // style: const TextStyle(
                      //     color: Colors.black,
                      //     fontFamily: 'cafe',
                      //     fontSize: DimenConstants.txtMedium,
                      //     fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        onTap: () {
          Get.to(() => PageDetailChatScreen(
                tripID: trip.id ?? "",
              ));
        });
  }
}
