import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/authentication/landing_page/page_authentication_screen.dart';
import 'package:appdiphuot/ui/home/user/page_user_controller.dart';
import 'package:appdiphuot/ui/home/user/place_detail/page_detail_trip_screen.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../common/extension/build_context_extension.dart';
import '../../../model/place.dart';
import '../../../model/trip.dart';
import '../../user_singleton_controller.dart';
import '../home/detail/page_detail_router_screen.dart';

class PageUserScreen extends StatefulWidget {
  const PageUserScreen({
    super.key,
  });

  @override
  State<PageUserScreen> createState() => _PageUserScreenState();
}

class _PageUserScreenState extends BaseStatefulState<PageUserScreen> {
  final _controller = Get.put(PageUserController());

  @override
  void initState() {
    super.initState();
    _setupListen();
    _controller.getData();
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
      showErrorDialog(StringConstants.errorMsg, err.messageError, "Retry", () {
        //do sth
      });
    });
  }

  @override
  void dispose() {
    _controller.clearOnDispose();
    OverlayLoadingProgress.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: ColorConstants.appColor,
        ),
        backgroundColor: ColorConstants.screenBg,
        body: Obx(() {
          return buildBody();
        }));
  }

  Widget buildBody() {
    return Container(
        width: double.infinity,
        child: ListView(physics: const BouncingScrollPhysics(), children: [
          Card(
            margin: const EdgeInsets.all(DimenConstants.marginPaddingSmall),
            color: ColorConstants.cardBg,
            shadowColor: Colors.grey,
            elevation: DimenConstants.cardElevation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: DimenConstants.marginPaddingMedium,
                ),
                // Chuyến đi đã tham gia
                Padding(
                  padding: const EdgeInsets.only(
                      left: DimenConstants.marginPaddingMedium),
                  child: Text(
                    StringConstants.tripParticipated,
                    style: UIUtils.getStyleTextLarge500(),
                  ),
                ),

                const SizedBox(
                  height: DimenConstants.marginPaddingMedium,
                ),
                _listTrips(_controller.trips),
                const SizedBox(
                  height: DimenConstants.marginPaddingMedium,
                ),
              ],
            ),
          ),
          Card(
              margin: const EdgeInsets.all(DimenConstants.marginPaddingSmall),
              color: ColorConstants.cardBg,
              shadowColor: Colors.grey,
              elevation: DimenConstants.cardElevation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: DimenConstants.marginPaddingMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: DimenConstants.marginPaddingMedium),
                    child: Text(
                      StringConstants.tripHost,
                      style: UIUtils.getStyleText500(),
                    ),
                  ),
                  const SizedBox(
                    height: DimenConstants.marginPaddingMedium,
                  ),
                  _listTrips(_controller.tripsHost),

                ],
              )),

          Card(
              margin: const EdgeInsets.all(DimenConstants.marginPaddingSmall),
              color: ColorConstants.cardBg,
              shadowColor: Colors.grey,
              elevation: DimenConstants.cardElevation,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                _buildTripInfo(),
              ])),
        ]));
  }

  Widget _listTrips(RxList<Trip> trips) {
    if (trips.value.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
        child: Column(
          children: [
            Lottie.asset('assets/files/no_data.json'),
            Text(
              StringConstants.noTrip,
              style: UIUtils.getStyleText(),
            )
          ],
        ),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 1 / 5.5,
        child: ListView.separated(
          padding: const EdgeInsets.only(left: 20, right: 20),
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: trips.length,
          itemBuilder: (BuildContext context, int index) {
            var trip = trips[index];
            return getTripRowItem(index, trip);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              width: DimenConstants.marginPaddingMedium,
            );
          },
        ),
      );
    }
  }

  Widget getTripRowItem(int index, Trip trip) {
    var itemSize = MediaQuery.of(context).size.height * 1 / 7.5;
    return InkWell(
        child: Container(
          constraints: BoxConstraints(maxWidth: itemSize),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              color: Colors.white10,
              width: itemSize,
              height: itemSize,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(48),
                  child: CachedMemoryImage(
                      fit: BoxFit.cover,
                      width: itemSize,
                      height: itemSize,
                      uniqueKey: trip.getFirstImageUrl(),
                      base64: trip.getFirstImageUrl()),
                ),
              ),
            ),
            const SizedBox(
              height: DimenConstants.marginPaddingSmall,
            ),
            Text(
              "${trip.title}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: UIUtils.getStyleText(),
            )
          ]),
        ),
        onTap: () {
          _onPressTripItem(trip);
        });
  }

  void _onPressTripItem(Trip trip) {
    Get.to(PageDetailTrip(tripData: trip));
  }

  Widget _buildAvatar() {
    return IconButton(
        iconSize: DimenConstants.avatarProfile,
        onPressed: () {},
        icon: CircleAvatar(
          backgroundColor: ColorConstants.borderTextInputColor,
          radius: DimenConstants.avatarProfile / 2,
          child: CircleAvatar(
            radius:
                DimenConstants.avatarProfile / 2 - DimenConstants.logoStroke,
            backgroundImage:
                NetworkImage(UserSingletonController.instance.getAvatar()),
          ),
        ));
  }

  Widget _buildTripInfo() {
    return Padding(
        padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: DimenConstants.marginPaddingMedium,
            ),
            UIUtils.getTextSpanCount(StringConstants.tripParticipatedCount,
                _controller.trips.length),
            UIUtils.getTextSpanCount(
                StringConstants.leadTripCount, _controller.tripsHost.length),
            UIUtils.getTextSpanCount(
                StringConstants.totalKm, _controller.totalKm.value),
            const SizedBox(
              height: DimenConstants.marginPaddingMedium,
            ),
          ],
        ));
  }
}
