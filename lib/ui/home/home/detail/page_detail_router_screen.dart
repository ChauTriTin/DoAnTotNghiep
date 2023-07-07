import 'dart:convert';
import 'dart:developer';

import 'package:appdiphuot/common/const/constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/model/trip.dart';
import 'package:appdiphuot/ui/home/home/detail/page_detail_router_controller.dart';
import 'package:appdiphuot/ui/home/router/join/joine_manager_screen.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:appdiphuot/util/time_utils.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../../base/base_stateful_state.dart';
import '../../../../common/const/color_constants.dart';
import '../../../../common/const/dimen_constants.dart';
import '../../../../model/comment.dart';
import '../../../../model/place.dart';
import '../../../../model/rate.dart';
import '../../../user_singleton_controller.dart';
import '../../router/create/create_router_screen.dart';
import '../../router/create_success/create_success_screen.dart';
import '../../router/create_success/enum_router.dart';
import '../../user/user_preview/page_user_preview_screen.dart';

class DetailRouterScreen extends StatefulWidget {
  const DetailRouterScreen({Key? key}) : super(key: key);

  @override
  State<DetailRouterScreen> createState() => _DetailRouterScreenState();
}

class _DetailRouterScreenState extends BaseStatefulState<DetailRouterScreen> {
  final DetailRouterController _controller = Get.put(DetailRouterController());
  final _commentController = TextEditingController();
  final _codeController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Trip? tripData;

  @override
  void initState() {
    super.initState();
    var data = Get.arguments[0][Constants.detailTrip];
    try {
      _controller.getDetailTrip(Trip.fromJson(jsonDecode(data)).id);
    } catch (e) {
      log("Get trip data ex: $e");
    }
    _setupListen();
    _controller.getAllRouter();
    _controller.getUserInfo(Trip.fromJson(jsonDecode(data)).userIdHost ?? "");
    _controller.getCommentRoute(Trip.fromJson(jsonDecode(data)).id);

    Dog.d(
        "fcmToken detail: ${UserSingletonController.instance.userData.value.fcmToken}");
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

    _controller.isTripDeleted.listen((isDeleted) {
      if (isDeleted) {
        _showWarningDialog();
      }
    });
  }

  void _showWarningDialog() {
    UIUtils.showAlertDialog(context, StringConstants.warning,
        StringConstants.deleteTripError, StringConstants.ok, () {
      Get.back();
    }, null, null);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _commentController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            backgroundColor: ColorConstants.appColor,
            actions: [
              Visibility(
                  visible: !_controller.isTripCompleted() &&
                      _controller.isJoinedCurrentTrip(),
                  child: PopupMenuButton<String>(
                    onSelected: _selectOption,
                    itemBuilder: (BuildContext context) {
                      return [
                        if (_controller.isUserHost())
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Text("Chỉnh sửa chuyến đi"),
                          ),
                        if (_controller.isUserHost())
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Xóa chuyến đi'),
                          ),
                        if (!_controller.isUserHost())
                          const PopupMenuItem<String>(
                            value: 'outTrip',
                            child: Text('Rời khỏi chuyến đi'),
                          )
                      ];
                    },
                  )),
            ],
            // title: Text(_controller.tripData?.title ?? ""),
            title: const Text(
              StringConstants.tripDetail,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          backgroundColor: ColorConstants.colorWhite,
          body: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              _slideShowImage(context),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _controller.detailTrip.value.createdAt ?? "",
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: ColorConstants.textColorDisable,
                    fontSize: DimenConstants.txtSmall,
                  ),
                ),
              ),
              _infoRouter(),
              _copyIdRouter(),
              _listButtonEvent(),
              const SizedBox(height: DimenConstants.marginPaddingMedium),
              Container(
                padding: const EdgeInsets.only(
                    left: DimenConstants.marginPaddingMedium),
                child: Text(
                  "*** Yêu cầu: ${_controller.detailTrip.value.require}",
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              _divider(12),
              _leader(),
              _divider(0),
              if (_controller.detailTrip.value.isComplete == false)
                ...widgetsShowBeforeCompleted(),
              if (_controller.detailTrip.value.isComplete == true)
                ...widgetsShowAfterCompleted()
            ],
          ),
        ));
  }

  void _selectOption(String option) {
    Dog.d("_selectOption: $option");
    if (option == 'edit') {
      Get.to(CreateRouterScreen(
        dfTitle: "",
        dfDescription: "",
        dfPlaceStart: null,
        dfPlaceEnd: null,
        dfListPlaceStop: [],
        dfDateTimeStart: null,
        dfDateTimeEnd: null,
        dfRequire: "",
        dfIsPublic: true,
        dfEditRouterWithTripId: _controller.detailTrip.value.id,
      ));
    } else if (option == 'delete') {
      showDeleteConfirmDialog();
    } else if (option == 'outTrip') {
      showOutTripConfirmDialog();
    }
  }

  void showDeleteConfirmDialog() {
    UIUtils.showAlertDialog(
      context,
      StringConstants.warning,
      StringConstants.deleteWarning,
      StringConstants.cancel,
      null,
      StringConstants.delete,
      _controller.deleteRouter,
    );
  }

  void showOutTripConfirmDialog() {
    UIUtils.showAlertDialog(
      context,
      StringConstants.warning,
      StringConstants.outWarning,
      StringConstants.cancel,
      null,
      StringConstants.outTrip,
      _controller.outTrip,
    );
  }

  List<Widget> listImage() {
    var list = <Widget>[];
    var images = _controller.detailTrip.value.listImg;
    images?.forEach((element) {
      list.add(CachedMemoryImage(
          fit: BoxFit.cover, uniqueKey: element, base64: element));
    });
    return list;
  }

  Widget _slideShowImage(BuildContext context) {
    return ImageSlideshow(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 4,
      initialPage: 0,
      indicatorColor: Colors.redAccent,
      indicatorBackgroundColor: Colors.grey,
      onPageChanged: (value) {},
      autoPlayInterval: 3000,
      isLoop: (_controller.detailTrip.value.listImg?.length ?? 0) > 1
          ? true
          : false,
      children: listImage(),
    );
  }

  Widget _infoRouter() {
    return Container(
        margin: const EdgeInsets.symmetric(
            horizontal: DimenConstants.marginPaddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _controller.detailTrip.value.isPublic == true
                      ? Icons.public
                      : Icons.lock,
                  color: Colors.blue,
                  size: 18,
                ),
                const SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: Text(
                    _controller.detailTrip.value.title ?? "",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _controller.detailTrip.value.des ?? "",
              textAlign: TextAlign.start,
            ),
          ],
        ));
  }

  Widget _listButtonEvent() {
    bool isJoined = _controller.isWidgetJoinedVisible.value;
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (!isJoined && _controller.detailTrip.value.isComplete == false)
            InkWell(
              onTap: () => {
                _controller.detailTrip.value.isPublic == true
                    ? _checkJoinPublicTrip()
                    : _showJoinPrivateRouterDialog()
              },
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Text(
                            "+",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 6),
                      child: const Text("Tham gia",
                          style: TextStyle(fontSize: 12, color: Colors.black))),
                ],
              ),
            ),
          if (isJoined && _controller.detailTrip.value.isComplete == false)
            InkWell(
              onTap: () => {
                Get.to(
                  CreateSuccessScreen(
                      id: _controller.detailTrip.value.id ?? "",
                      state: RouterState.detail),
                )
              },
              child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Image.asset("assets/images/ic_launcher.png")),
            ),
          InkWell(
            onTap: () {
              Dog.d("showMember: ${_controller.detailTrip.value.id}");
              if (_controller.detailTrip.value.id == null) return;
              Get.to(
                  JoinedManagerScreen(tripdata: _controller.detailTrip.value));
            },
            child: Column(children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent,
                ),
                child: Center(
                  child: Text(
                    _controller.detailTrip.value.listIdMember?.length
                            .toString() ??
                        "1",
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 6),
                  child: const Text("Số người tham gia",
                      style: TextStyle(fontSize: 12, color: Colors.black)))
            ]),
          ),
          InkWell(
            onTap: () => {_showCommentDialog()},
            child: Column(
              children: [
                const Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.comment,
                        color: Colors.redAccent,
                        size: 40.0,
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 6),
                    child: const Text("Bình luận",
                        style: TextStyle(fontSize: 12, color: Colors.black)))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _leader() {
    double rate = _controller.userLeaderData.value.getRate();
    int rateCount = _controller.userLeaderData.value.rates?.length ?? 0;
    return Obx(() => InkWell(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 22, right: 22),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.motorcycle,
                            color: Colors.redAccent,
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              child: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: 'Leader',
                                      style: TextStyle(
                                          color: ColorConstants.colorTitleTrip,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          decoration:
                                          TextDecoration.none), // Màu chữ đỏ
                                    ),
                                    TextSpan(
                                        text: ': ${_controller.userLeaderData.value.name}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Colors.black,
                                            decoration: TextDecoration.none)),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 48, right: 24),
                      child: Row(
                        children: [
                          RatingBar.builder(
                            ignoreGestures: true,
                            initialRating: rate,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Expanded(
                            child: Text(
                              "$rateCount đánh giá",
                              style: const TextStyle(
                                  color: ColorConstants.colorGreen,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(right: 24),
                  child: CircleAvatar(
                      backgroundImage: NetworkImage(
                    _controller.getLeaderAvatar(),
                  ))),
            ],
          ),
          onTap: () {
            Get.to(() => const PageUserPreviewScreen(), arguments: [
              {Constants.user: _controller.userLeaderData.value.uid ?? ""}
            ]);
          },
        ));
  }

  Widget _divider(double marginTop) {
    return Container(
        margin: EdgeInsets.only(top: marginTop), child: const Divider());
  }

  Widget _seeMore() {
    return InkWell(
      onTap: () {
        _showDetailRouterDialog();
      },
      child: Expanded(
          child: Container(
        margin: const EdgeInsets.only(top: 14, bottom: 16),
        child: const Center(
          child: Text(
            "Xem chi tiết chuyến đi",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      )),
    );
  }

  Widget getItemRow(Trip trip) {
    if (trip.id == _controller.detailTrip.value.id) {
      return const SizedBox();
    }
    return InkWell(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.white10,
                width: MediaQuery.of(context).size.height * 1 / 7.5,
                height: MediaQuery.of(context).size.height * 1 / 7.5,
                margin: const EdgeInsets.only(right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(48),
                    child: CachedMemoryImage(
                      fit: BoxFit.cover,
                      uniqueKey: trip.listImg?.first ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                      base64: trip.listImg?.first ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.height * 1 / 7.5,
                margin: const EdgeInsets.only(top: 8),
                child: Text(
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    trip.title ?? ""),
              )
            ]),
        onTap: () {
          // Get.to(() => const DetailRouterScreen(), arguments: [
          //   {Constants.detailTrip: jsonEncode(trip)},
          // ]);

          _controller.getDetailTrip(trip.id);
          _controller.getUserInfo(trip.userIdHost ?? "");
          _controller.getCommentRoute(trip.id);
        });
  }

  final List<String> dataList = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  Widget getOtherList(List<Trip> trips) {
    if (_controller.listTrips.isEmpty) {
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
          padding: const EdgeInsets.only(left: DimenConstants.marginPaddingMedium),
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: trips.length,
          itemBuilder: (BuildContext context, int index) {
            var trip = trips[index];
            return getItemRow(trip);
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

  Widget _headerDialog(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
      ),
    );
  }

  void _showDetailRouterDialog() {
    showMaterialModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        context: context,
        builder: (context) => Obx(() => Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: DimenConstants.marginPaddingMedium,
                  right: DimenConstants.marginPaddingMedium,
                  top: DimenConstants.marginPaddingSmall),
              child: SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  padding: const EdgeInsets.all(0),
                  children: [
                    const SizedBox(height: DimenConstants.marginPaddingMedium),
                    _headerDialog(StringConstants.titleDetailDialog),
                    const SizedBox(height: DimenConstants.marginPaddingMedium),
                    ...convertListLocation()
                  ],
                ),
              ),
            )));
  }

  Widget _locationTrip(Place place,
      {bool isSubLocation = false, bool isStart = false}) {
    return Row(
      children: [
        isSubLocation
            ? Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.only(
                    left: DimenConstants.marginPaddingExtraLarge,
                    right: DimenConstants.marginPaddingMedium,
                    bottom: DimenConstants.marginPaddingMedium,
                    top: DimenConstants.marginPaddingMedium),
                child: Image.asset("assets/images/sub_location.png"))
            : Container(
                width: 40,
                height: 40,
                margin:
                    const EdgeInsets.all(DimenConstants.marginPaddingMedium),
                child: Image.asset("assets/images/location.png")),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Wrap(
                children: [
                  Text(
                    place.name ?? "",
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ],
              ),
              if (!isSubLocation)
                Container(
                  padding: const EdgeInsets.only(
                      right: DimenConstants.marginPaddingMedium,
                      top: DimenConstants.marginPaddingMedium),
                  child: Text(
                    isStart
                        ? "Thời gian: ${_controller.detailTrip.value.timeStart}"
                        : "Thời gian: ${_controller.detailTrip.value.timeEnd}",
                    style: const TextStyle(fontSize: 12),
                  ),
                )
            ],
          ),
        )
      ],
    );
  }

  List<Widget> convertListLocation() {
    var list = <Widget>[];

    if (_controller.detailTrip.value.placeStart != null) {
      list.add(_locationTrip(_controller.detailTrip.value.placeStart!,
          isStart: true));
    }
    Dog.d(
        "convertListLocation : ${_controller.detailTrip.value.listPlace?.length}");
    Dog.d(
        "convertListLocation : ${_controller.detailTrip.value.placeStart?.name}");
    Dog.d(
        "convertListLocation : ${_controller.detailTrip.value.placeEnd?.name}");
    _controller.detailTrip.value.listPlace?.forEach((element) {
      list.add(_locationTrip(element, isSubLocation: true));
    });

    if (_controller.detailTrip.value.placeEnd != null) {
      list.add(_locationTrip(_controller.detailTrip.value.placeEnd!));
    }

    return list;
  }

  Widget _buildListComment() {
    if (_controller.commentData.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
        child: Column(
          children: [
            Lottie.asset('assets/files/no_data.json'),
            Text(
              StringConstants.noComment,
              style: UIUtils.getStyleText(),
            )
          ],
        ),
      );
    } else {
      return ListView(
        physics: const BouncingScrollPhysics(),
        children: _renderListComment(),
      );
    }
  }

  List<Widget> _renderListComment() {
    List<Widget> widgetList = [];
    Dog.d("_renderListComment: ${_controller.commentData.length}");
    try {
      if (_controller.commentData.isEmpty) return widgetList;
      for (var element in _controller.commentData) {
        Dog.d("_renderListComment: ${element.content}");
        widgetList.add(_comment(element));
      }
    } catch (ex) {
      Dog.e("_renderListComment: $ex");
    }
    Dog.d("_renderListComment widgetList: ${widgetList.length}");
    return widgetList;
  }

  Widget _comment(Comment comment) {
    return CommentTreeWidget<Comment, Comment>(
      comment,
      comment.replyComment ?? [],
      treeThemeData:
          const TreeThemeData(lineColor: Colors.transparent, lineWidth: 3),
      avatarRoot: (context, data) => PreferredSize(
        preferredSize: const Size.fromRadius(18),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: Colors.grey,
          backgroundImage:
              data.avatarUrl != null ? NetworkImage(data.avatarUrl!) : null,
        ),
      ),
      avatarChild: (context, data) => PreferredSize(
        preferredSize: const Size.fromRadius(12),
        child: CircleAvatar(
          radius: 12,
          backgroundColor: Colors.grey,
          backgroundImage:
              data.avatarUrl != null ? NetworkImage(data.avatarUrl!) : null,
        ),
      ),
      contentChild: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name ?? "",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    data.content ?? "",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w300, color: Colors.black),
                  ),
                ],
              ),
            ),
            DefaultTextStyle(
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.grey[700], fontWeight: FontWeight.bold),
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 8,
                    ),
                    Text(TimeUtils.formatDateTimeFromMilliseconds(data.id as int)),
                  ],
                ),
              ),
            )
          ],
        );
      },
      contentRoot: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name ?? "No name",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 14,
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    data.content ?? "",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 13,
                        fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontSize: 11,
                    color: Colors.grey[500]),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      Text(TimeUtils.formatDateTimeFromMilliseconds(int.parse(data.id ?? "0"))),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _sendBox() {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
                UserSingletonController.instance.userData.value.getAvatar()),
          ),
          const SizedBox(width: DimenConstants.marginPaddingSmall, height: 0),
          Expanded(
            child: TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: 'Nhập bình luận',
              ),
            ),
          ),
          const SizedBox(width: DimenConstants.marginPaddingSmall, height: 0),
          InkWell(
            onTap: () {
              _controller.addCommentRoute(
                  _controller.detailTrip.value.id, _commentController.text);
              _commentController.clear();
            },
            child: const Icon(
              Icons.send,
              color: Colors.blue,
            ),
          )
        ],
      ),
    );
  }

  void _showCommentDialog() {
    showMaterialModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        context: context,
        builder: (context) => Obx(
              () => Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: DimenConstants.marginPaddingMedium,
                    right: DimenConstants.marginPaddingMedium,
                    top: DimenConstants.marginPaddingMedium),
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: double.infinity,
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      _headerDialog(StringConstants.titleCommentDialog),
                      const SizedBox(
                          height: DimenConstants.marginPaddingMedium),
                      Expanded(child: _buildListComment()),
                      _sendBox()
                    ],
                  ),
                ),
              ),
            ));
  }

  void _showJoinPrivateRouterDialog() {
    if (_controller.isUserBlocked()) {
      showUserBlockedDialog();
    } else {
      showMaterialModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        context: context,
        builder: (context) => SingleChildScrollView(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: DimenConstants.marginPaddingMedium),
          controller: ModalScrollController.of(context),
          child: SizedBox(
            height: 220,
            width: double.infinity,
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                _headerDialog(StringConstants.titleJoinPrivateDialog),
                const SizedBox(height: DimenConstants.marginPaddingLarge),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: DimenConstants.marginPaddingExtraLarge),
                  width: double.infinity,
                  child: TextField(
                    controller: _codeController,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        hintText: StringConstants.codeRouter),
                  ),
                ),
                const SizedBox(height: DimenConstants.marginPaddingMedium),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: DimenConstants.marginPaddingExtraLarge),
                  child: UIUtils.getOutlineButton1(StringConstants.confirm, () {
                    _controller.joinedRouter(_codeController.text);
                    Get.back();
                  }, Colors.red, DimenConstants.marginPaddingMedium,
                      Colors.white, Colors.red),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  List<Widget> widgetsShowBeforeCompleted() {
    var list = <Widget>[];
    list.add(_seeMore());
    list.add(const SizedBox(height: DimenConstants.marginPaddingLarge));
    list.add(Container(
        margin: const EdgeInsets.only(right: 24, left: 24),
        child: const Text(
          "Chuyến đi khác",
          style: TextStyle(fontWeight: FontWeight.bold),
        )));
    list.add(const SizedBox(height: DimenConstants.marginPaddingMedium));
    var listNotCompleted = _controller.listTrips.where((p0) => p0.isComplete == false).toList();
    list.add(getOtherList(listNotCompleted));
    return list;
  }

  List<Widget> widgetsShowAfterCompleted() {
    var list = <Widget>[];
    var trip = _controller.detailTrip.value;
    list.add(Container(
      margin: const EdgeInsets.only(
          left: DimenConstants.marginPaddingExtraLarge,
          right: DimenConstants.marginPaddingExtraLarge,
          bottom: DimenConstants.marginPaddingMedium,
          top: DimenConstants.marginPaddingMedium),
      child: ElevatedButton(
          onPressed: () {
            //TODO nguyen map correct values
            Get.to(CreateRouterScreen(
              dfTitle: trip.title ?? "",
              dfDescription: trip.des ?? "",
              dfPlaceStart: Place(
                lat: trip.placeStart?.lat ?? defaultLat,
                long: trip.placeStart?.long ?? defaultLong,
                name: trip.placeStart?.name ?? "",
              ),
              dfPlaceEnd: Place(
                lat: trip.placeEnd?.lat ?? defaultLat,
                long: trip.placeEnd?.long ?? defaultLong,
                name: trip.placeEnd?.name ?? "",
              ),
              dfListPlaceStop: [...trip.listPlace ?? <Place>[]],
              dfDateTimeStart: DateTime.now().add(const Duration(days: 7)),
              //thoi gian bat dau chuyen di
              dfDateTimeEnd: DateTime.now().add(const Duration(days: 3)),
              //thoi gian cuoi cung de dang ky tham gia chuyen di
              //warning: chu y rang thoi gian bat dau chuyen di phai sau thoi gian ket thuc ngay dang ky
              dfRequire: trip.require ?? "",
              dfIsPublic: trip.isPublic ?? true,
              dfEditRouterWithTripId:
                  null, //case clone the router, always pass null
            ));
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.red)))),
          child: const Text("Tạo lại chuyến đi")),
    ));
    list.add(rateTrip());
    return list;
  }

  List<Rate> convertMapToRateList(Map<String, dynamic>? map) {
    if (map == null) return <Rate>[];
    final parsed = map.values.cast<Map<String, dynamic>>();
    return parsed.map<Rate>((json) => Rate.fromJson(json)).toList();
  }

  Widget rateTrip() {
    var ratesMap = convertMapToRateList(_controller.detailTrip.value.rates);
    var totalRate = _controller.detailTrip.value.rates?.length ?? 0;
    double rateLeader = 0;
    double rateStart = 0;
    double rateEnd = 0;
    double rateTrip = 0;
    int rateLeaderCount = 0;
    int rateStartCount = 0;
    int rateEndCount = 0;
    int rateTripCount = 0;

    for (var element in ratesMap) {
      if (element.rateLeader != null) {
        rateLeader += element.rateLeader ?? 0;
        rateLeaderCount++;
      }
      if (element.ratePlaceStart != null) {
        rateStart += element.ratePlaceStart ?? 0;
        rateStartCount++;
      }
      if (element.ratePlaceEnd != null) {
        rateEnd += element.ratePlaceEnd ?? 0;
        rateEndCount++;
      }
      if (element.rateTrip != null) {
        rateTrip += element.rateTrip ?? 0;
        rateTripCount++;
      }
    }

    Dog.d("rateMaps ${ratesMap.length}");
    Dog.d("rateLeader $rateLeader -- $totalRate");
    Dog.d("rate ${rateLeader / ratesMap.length}");

    if (totalRate != 0) {
      rateLeader = rateLeader / totalRate;
      rateStart = rateStart / totalRate;
      rateEnd = rateEnd / totalRate;
      rateTrip = rateTrip / totalRate;
    }

    return Obx(() => Container(
          margin: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Đánh giá",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Leader',
                              style: TextStyle(
                                  color: ColorConstants.colorTitleTrip,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  decoration:
                                      TextDecoration.none), // Màu chữ đỏ
                            ),
                            TextSpan(
                                text: ': ${_controller.getNameLeader()}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Colors.black,
                                    decoration: TextDecoration.none)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        RatingBar.builder(
                          initialRating: rateLeader,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 20.0,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.orange,
                          ),
                          ignoreGestures: true,
                          onRatingUpdate: (double value) {},
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          child: Text(
                            "$rateLeaderCount đánh giá",
                            style: const TextStyle(
                                color: ColorConstants.colorGreen,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              _divider(8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Bắt đầu',
                              style: TextStyle(
                                  color: ColorConstants.colorTitleTrip,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  decoration:
                                  TextDecoration.none), // Màu chữ đỏ
                            ),
                            TextSpan(
                                text: ': ${_controller.detailTrip.value.placeStart?.name}}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Colors.black,
                                    decoration: TextDecoration.none)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        RatingBar.builder(
                          initialRating: rateStart,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 20.0,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.orange,
                          ),
                          ignoreGestures: true,
                          onRatingUpdate: (double value) {},
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          child: Text(
                            "$rateStartCount đánh giá",
                            style: const TextStyle(
                                color: ColorConstants.colorGreen,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              _divider(8),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                              text: 'Kết thúc',
                              style: TextStyle(
                                  color: ColorConstants.colorTitleTrip,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  decoration:
                                  TextDecoration.none), // Màu chữ đỏ
                            ),
                            TextSpan(
                                text: ': ${_controller.detailTrip.value.placeEnd?.name}}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Colors.black,
                                    decoration: TextDecoration.none)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        RatingBar.builder(
                          initialRating: rateEnd,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 20.0,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.orange,
                          ),
                          ignoreGestures: true,
                          onRatingUpdate: (double value) {},
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          child: Text(
                            "$rateEndCount đánh giá",
                            style: const TextStyle(
                                color: ColorConstants.colorGreen,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              _divider(8),
              ...listPlaceRate(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: const Text("Đánh giá của chuyến đi",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16, color: ColorConstants.colorTitleTrip)),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: [
                        RatingBar.builder(
                          initialRating: rateTrip,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 20.0,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.orange,
                          ),
                          ignoreGestures: true,
                          onRatingUpdate: (double value) {},
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          child: Text(
                            "$rateEndCount đánh giá",
                            style: const TextStyle(
                                color: ColorConstants.colorGreen,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }

  List<Widget> listPlaceRate() {
    var list = <Widget>[];
    var ratesMap = convertMapToRateList(_controller.detailTrip.value.rates);
    var listPlaceRate = <double>[];
    var listPlaceRateCount = <int>[];

    var totalRate = _controller.detailTrip.value.rates?.length ?? 0;

    _controller.detailTrip.value.listPlace?.forEach((element) {
      listPlaceRate.add(0);
      listPlaceRateCount.add(0);
    });

    for (var element in ratesMap) {
      element.rateListPlaceStop?.forEach((item) {
        int index = element.rateListPlaceStop?.indexOf(item) ?? -1;
        Dog.d("index: $index , listPlaceRate: ${listPlaceRate.length}");
        if (index != -1) {
          var currentCount = listPlaceRateCount[index];
          listPlaceRateCount[index] = currentCount + 1;
          if (listPlaceRate.isEmpty) {
            listPlaceRate[index] = item;
          } else {
            var currentRate = listPlaceRate[index];
            listPlaceRate[index] = currentRate + item;
          }
        }
      });
    }

    if (listPlaceRate.isEmpty) {
      _controller.detailTrip.value.listPlace?.forEach((element) {
        listPlaceRate.add(0);
      });
    }

    for (var element in _controller.detailTrip.value.listPlace ?? <Place>[]) {
      var listPlace = _controller.detailTrip.value.listPlace;
      int index = -1;

      if (listPlace != null && listPlace.isNotEmpty) {
        index = listPlace.indexOf(element);
      }
      double rate = 0;
      int countRate = 0;
      if (totalRate != 0 && index != -1) {
        rate = listPlaceRate[index] / totalRate;
        countRate = listPlaceRateCount[index];
      }

      if (index != -1) {
        list.add(const SizedBox(height: 12));
        list.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                child:RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      const TextSpan(
                        text: "Điểm dừng chân",
                        style: TextStyle(
                            color: ColorConstants.colorTitleTrip,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            decoration:
                            TextDecoration.none), // Màu chữ đỏ
                      ),
                      TextSpan(
                          text: ': ${element.name}}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black,
                              decoration: TextDecoration.none)),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  RatingBar.builder(
                    initialRating: rate,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 20.0,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.orange,
                    ),
                    ignoreGestures: true,
                    onRatingUpdate: (double value) {},
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Expanded(
                    child: Text(
                      "$countRate đánh giá",
                      style: const TextStyle(
                          color: ColorConstants.colorGreen,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
        list.add(_divider(8));
      }
    }
    return list;
  }

  Widget _copyIdRouter() {
    if (!_controller.isUserHost()) {
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
      child: InkWell(
        onTap: _copyRouterId,
        child: RichText(
          text: TextSpan(
            text: "Mã chuyến đi:  ",
            style: const TextStyle(
              fontSize: 14.0,
              color: ColorConstants.textColor,
            ),
            children: [
              TextSpan(
                text: _controller.detailTrip.value.id ?? "",
                style: const TextStyle(
                  fontSize: 14.0,
                  color: ColorConstants.appColor,
                ),
              ),
              const WidgetSpan(
                child: SizedBox(
                  width: 8,
                ),
              ),
              const WidgetSpan(
                child: Icon(Icons.copy, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _copyRouterId() async {
    await Clipboard.setData(
        ClipboardData(text: _controller.detailTrip.value.id ?? ""));
    Fluttertoast.showToast(
        msg: "Copied",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: ColorConstants.appColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _checkJoinPublicTrip() {
    Dog.d("checkJoinPublicTrip");
    if (_controller.isUserBlocked()) {
      showUserBlockedDialog();
    } else {
      _controller.joinedRouter(_controller.detailTrip.value.id);
    }
  }

  void showUserBlockedDialog() {
    UIUtils.showAlertDialog(
      context,
      StringConstants.warning,
      StringConstants.blockedWarning,
      StringConstants.ok,
      null,
      null,
      null,
    );
  }
}
