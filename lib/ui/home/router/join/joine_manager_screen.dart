import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../../base/base_stateful_state.dart';
import '../../../../common/const/color_constants.dart';
import '../../../../common/const/dimen_constants.dart';
import '../../../../model/user.dart';
import '../../../../view/profile_bar_widget.dart';
import '../../../user_singleton_controller.dart';

class JoinedManagerScreen extends StatefulWidget {
  const JoinedManagerScreen({super.key, required this.id});

  final String id;

  @override
  State<JoinedManagerScreen> createState() => _JoinedManagerScreenState();
}

class _JoinedManagerScreenState extends State<JoinedManagerScreen> {
  var dataMemberFake = <UserData>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dataMemberFake.add(UserData(name: "Nguyen", uid: "123131"));
    dataMemberFake.add(UserData(name: "Nguyen", uid: "123131"));
    dataMemberFake.add(UserData(name: "Nguyen", uid: "123131"));
    dataMemberFake.add(
        UserData(name: "Nguyen NguyenNguyen  Nguyen Nguyen", uid: "123131"));
    dataMemberFake.add(UserData(name: "Nguyen", uid: "123131"));
    dataMemberFake.add(UserData(name: "Nguyen", uid: "123131"));
    dataMemberFake.add(UserData(name: "Nguyen", uid: "123131"));
    dataMemberFake.add(UserData(name: "Nguyen", uid: "123131"));
    super.initState();
    dataMemberFake.add(UserData(name: "Nguyen", uid: "123131"));
    dataMemberFake.add(UserData(name: "Nguyen", uid: "123131"));
    dataMemberFake.add(UserData(name: "Nguyen", uid: "123131"));
    dataMemberFake.add(UserData(name: "Nguyen", uid: "123131"));

    dataMemberFake.removeWhere(
        (e) => e.uid == UserSingletonController.instance.userData.value.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: ColorConstants.appColor,
        ),
        body: Obx(
          () => Container(
            color: ColorConstants.colorWhite,
            child: Column(children: [
              ProfileBarWidget(
                  name: UserSingletonController.instance.userData.value.name ??
                      "",
                  state: "⬤ Online",
                  linkAvatar: UserSingletonController.instance.userData.value
                      .getAvatar()),
              Padding(
                padding:
                    const EdgeInsets.all(DimenConstants.marginPaddingMedium),
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
                          "1",
                          style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontStyle: FontStyle.italic,
                            shadows: <Shadow>[
                              Shadow(
                                offset: const Offset(10.0, 10.0),
                                blurRadius: 3.0,
                                color:
                                    ColorConstants.colorPink.withOpacity(0.3),
                              ),
                              Shadow(
                                offset: const Offset(10.0, 10.0),
                                blurRadius: 8.0,
                                color:
                                    ColorConstants.colorPink.withOpacity(0.3),
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
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  scrollDirection: Axis.vertical,
                  itemCount: dataMemberFake.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _getItemRow(index);
                  },
                ),
              )
            ]),
          ),
        ));
  }

  Widget _getItemRow(int index) {
    var user = dataMemberFake[index];
    return Padding(
      padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
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
          InkWell(
            onTap: () {},
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.red, // Màu nền đỏ
                shape: BoxShape.circle,
              ),
              // Khoảng cách nội dung trong container
              child: const Icon(
                size: 10,
                Icons.close,
                color: Colors.white, // Màu biểu tượng (icon) trắng
              ),
            ),
          )
        ],
      ),
    );
  }
}
