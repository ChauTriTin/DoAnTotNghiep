import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../common/const/color_constants.dart';
import '../../../../view/profile_bar_widget.dart';

class DetailRouterScreen extends StatefulWidget {
  const DetailRouterScreen({Key? key}) : super(key: key);

  @override
  State<DetailRouterScreen> createState() => _DetailRouterScreenState();
}

class _DetailRouterScreenState extends State<DetailRouterScreen> {
  Widget _slideShowImage(BuildContext context) {
    return ImageSlideshow(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 4,
      initialPage: 0,
      indicatorColor: Colors.redAccent,
      indicatorBackgroundColor: Colors.grey,
      onPageChanged: (value) {
        print('Page changed: $value');
      },
      autoPlayInterval: 3000,
      isLoop: true,
      children: [
        Image.network(
          "https://www.w3schools.com/howto/img_avatar.png",
          fit: BoxFit.cover,
        ),
        Image.network(
          "https://www.w3schools.com/howto/img_avatar.png",
          fit: BoxFit.cover,
        ),
        Image.network(
          "https://www.w3schools.com/howto/img_avatar.png",
          fit: BoxFit.cover,
        ),
      ],
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
                  child: const Text(
                    "Vinh Ha Long 3N3D",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const Icon(
                  Icons.public,
                  color: Colors.blue,
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 12),
              child: const Text(
                  "Chuyến đi Hạ Long trong 3 ngày khởi hành từ tp.HCM ngày 15/5 Chuyến đi Hạ Long trong 3 ngày khởi hành từ tp.HCM ngày 15/5"),
            )
          ],
        ));
  }

  Widget _listButtonEvent() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
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
                      style: TextStyle(fontSize: 12, color: Colors.black)))
            ],
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
          Column(
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
                margin: const EdgeInsets.only(left: 24, right: 24, top: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.sports_motorsports_outlined,
                      color: Colors.blue,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: const Text(
                        "Leader: Huynh Quoc Nguyen",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 54, right: 24, top: 6),
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
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
            margin: const EdgeInsets.only(right: 24, top: 6),
            child: Center(
                child: Image.network(
              "https://www.w3schools.com/howto/img_avatar.png",
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
        padding: const EdgeInsets.only(top: 6, bottom: 6),
        child: const Center(
          child: Text(
            "Xem chi tiết chuyến đi",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      )),
    );
  }

  void _showDetailRouterDialog() {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
          height: 300,
          width: double.infinity,
          color: ColorConstants.colorGrey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: ColorConstants.appColor,
      ),
      backgroundColor: ColorConstants.appColorBkg,
      body: Container(
        color: ColorConstants.appColorBkg,
        child: Column(
          children: [
            const ProfileBarWidget(
              name: "Nguyen Hoang Giang",
              state: "⬤ Online",
              linkAvatar: "https://www.w3schools.com/howto/img_avatar.png",
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  _slideShowImage(context),
                  _infoRouter(),
                  _listButtonEvent(),
                  _divider(12),
                  _leader(),
                  _divider(12),
                  _seeMore()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
