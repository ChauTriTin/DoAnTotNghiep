import 'dart:convert';
import 'dart:developer';
import 'package:appdiphuot/common/const/constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/model/trip.dart';
import 'package:appdiphuot/ui/home/home/detail/page_detail_router_controller.dart';
import 'package:appdiphuot/util/ui_utils.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../common/const/color_constants.dart';
import '../../../../common/const/dimen_constants.dart';
import '../../../../model/comment.dart';
import '../../../user_singleton_controller.dart';
import '../../../../view/profile_bar_widget.dart';
import '../../setting/setting_screen.dart';

class DetailRouterScreen extends StatefulWidget {
  const DetailRouterScreen({Key? key}) : super(key: key);

  @override
  State<DetailRouterScreen> createState() => _DetailRouterScreenState();
}

class _DetailRouterScreenState extends State<DetailRouterScreen> {
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
      // tripData = Trip.fromJson(jsonDecode(data ?? ""));
      _controller.getDetailTrip(Trip.fromJson(jsonDecode(data)).id);
    } catch (e) {
      log("Get trip data ex: $e");
    }

    _controller.getUserInfo(Trip.fromJson(jsonDecode(data)).userIdHost ?? "");
    _controller.getCommentRoute(Trip.fromJson(jsonDecode(data)).id);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _commentController.dispose();
    _controller.dispose();
    super.dispose();
  }

  List<Widget> listImage() {
    var list = <Widget>[];
    var images = _controller.detailTrip.value?.listImg;
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
        margin: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Text(
                    _controller.detailTrip.value.title ?? "",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(
                  _controller.detailTrip.value.isPublic == true
                      ? Icons.public
                      : Icons.lock,
                  color: Colors.blue,
                )
              ],
            ),
            Container(
                margin: const EdgeInsets.only(top: 12),
                child: Text(_controller.detailTrip.value.des ?? ""))
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
          if (!isJoined)
            InkWell(
              onTap: () => {
                _controller.detailTrip.value.isPublic == true
                    ? _controller.joinedRouter(_controller.detailTrip.value.id)
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
          Column(
            children: [
              const Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      color: Colors.redAccent,
                      size: 40.0,
                    ),
                    Text(
                      "1.7k",
                      style: TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 6),
                  child: const Text("Theo dõi",
                      style: TextStyle(fontSize: 12, color: Colors.black)))
            ],
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
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: Text(
                        "Leader: ${_controller.userLeaderData.value.name}",
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 54, right: 24),
                child: RatingBar.builder(
                  ignoreGestures: true,
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 20,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.red,
                  ),
                  onRatingUpdate: (rating) {},
                ),
              ),
            ],
          ),
        ),
        Container(
            margin: const EdgeInsets.only(right: 24),
            child: Center(
                child: Image.network(
              _controller.getLeaderAvatar(),
              height: 50,
              width: 50,
            ))),
      ],
    );
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

  Widget getItemRow(int i) {
    return InkWell(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            color: Colors.white10,
            width: MediaQuery.of(context).size.height * 1 / 7.5,
            height: MediaQuery.of(context).size.height * 1 / 7.5,
            margin: const EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox.fromSize(
                  size: const Size.fromRadius(48),
                  child: Image.network(StringConstants.linkImg,
                      fit: BoxFit.cover)),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: const Text("Du lich"),
          )
        ]),
        onTap: () {
          Get.to(const DetailRouterScreen());
          setState(
            () {
              // widgets.add(getRow(widgets.length + 1));
            },
          );
        });
  }

  final List<String> dataList = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  Widget _otherRouter() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 1 / 5.5,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 20, right: 20),
        scrollDirection: Axis.horizontal,
        itemCount: dataList.length,
        itemBuilder: (BuildContext context, int index) {
          return getItemRow(index);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            width: DimenConstants.marginPaddingMedium,
          );
        },
      ),
    );
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
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: DimenConstants.marginPaddingMedium),
        controller: ModalScrollController.of(context),
        child: Container(
          height: 300,
          width: double.infinity,
          color: ColorConstants.colorGrey,
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              const SizedBox(height: DimenConstants.marginPaddingMedium),
              _headerDialog(StringConstants.titleDetailDialog),
              const SizedBox(height: DimenConstants.marginPaddingMedium),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _renderListComment() {
    List<Widget> widgetList = [];
    if (_controller.commentData.isEmpty) return widgetList;
    _controller.commentData.map((element) => widgetList.add(_comment(element)));
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
              child: const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Text('Like'),
                    SizedBox(
                      width: 24,
                    ),
                    Text('Reply'),
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
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'dangerous',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    data.content ?? "",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w300, color: Colors.black),
                  ),
                ],
              ),
            ),
            DefaultTextStyle(
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.grey[700], fontWeight: FontWeight.bold),
              child: const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    Text('Like'),
                    SizedBox(
                      width: 24,
                    ),
                    Text('Reply'),
                  ],
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
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(_controller.getLeaderAvatar()),
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
      builder: (context) => Container(
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
              const SizedBox(height: DimenConstants.marginPaddingMedium),
              Expanded(
                  child: ListView(
                children: _renderListComment(),
              )),
              _sendBox()
            ],
          ),
        ),
      ),
    );
  }

  void _showJoinPrivateRouterDialog() {
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
                }, Colors.red, DimenConstants.marginPaddingMedium, Colors.white,
                    Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ColorConstants.appColor,
      ),
      backgroundColor: ColorConstants.appColorBkg,
      body: Obx(() {
        return Container(
          color: ColorConstants.appColorBkg,
          child: Column(
            children: [
              ProfileBarWidget(
                  name: UserSingletonController.instance.userData.value.name ??
                      "",
                  state: "⬤ Online",
                  linkAvatar: UserSingletonController.instance.userData.value
                      .getAvatar()),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _slideShowImage(context),
                    _infoRouter(),
                    _listButtonEvent(),
                    _divider(12),
                    _leader(),
                    _divider(0),
                    _seeMore(),
                    const SizedBox(height: DimenConstants.marginPaddingLarge),
                    Container(
                        margin: const EdgeInsets.only(right: 24, left: 24),
                        child: const Text(
                          "Chuyến đi khác",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(height: DimenConstants.marginPaddingMedium),
                    _otherRouter()
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _navigateToSettingScreen() {
    Get.to(const PageSettingScreen());
  }
}
