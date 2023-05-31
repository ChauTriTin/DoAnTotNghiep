import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

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

  final Widget _infoRouter = Container(
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
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const ProfileBarWidget(
              name: "Nguyen Hoang Giang",
              state: "⬤ Online",
              linkAvatar: "https://www.w3schools.com/howto/img_avatar.png",
            ),
            _slideShowImage(context),
            _infoRouter,
            _listButtonEvent()
          ],
        ),
      ),
    );
  }
}
