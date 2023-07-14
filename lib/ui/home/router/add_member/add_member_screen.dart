import 'package:appdiphuot/model/user.dart';
import 'package:appdiphuot/ui/home/user/user_preview/page_user_preview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../../common/const/constants.dart';
import '../../../../model/trip.dart';
import '../../../../util/log_dog_utils.dart';
import '../../../../util/ui_utils.dart';
import 'add_member_controller.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({
    super.key,
    required this.trip,
  });

  final Trip trip;

  @override
  State<AddMemberScreen> createState() => _AddMemberScreen();
}

class _AddMemberScreen extends BaseStatefulState<AddMemberScreen> {
  final _controller = Get.put(AddMemberController());
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupListen();
    _controller.getData(widget.trip);
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

    _searchController.addListener(_performSearch);
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
          backgroundColor: ColorConstants.appColor,
          title: const Text(StringConstants.inviteUser),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        backgroundColor: ColorConstants.colorWhite,
        body: buildBody());
  }

  Widget buildBody() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Obx(
          () => Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Tìm kiếm',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(child: getSearchMemberList())
            ],
          ),
        ));
  }

  Widget getSearchMemberList() {
    if (_controller.userSearchResults.value.isEmpty) {
      return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Center(
            child: Text(
              StringConstants.noUser,
              style: UIUtils.getStyleText(),
            ),
          ));
    } else {
      return ListView.separated(
        // padding: const EdgeInsets.only(),
        physics: const BouncingScrollPhysics(),
        itemCount: _controller.userSearchResults.value.length,
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
          return getUserItem(index, _controller.userSearchResults.value[index]);
        },
      );
    }
  }

  Widget getUserItem(int index, UserData user) {
    String avatar = user.avatar.isNullOrBlank == true
        ? StringConstants.avatarImgDefault
        : user.avatar ?? "";
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
                    child: Image.network(
                      avatar,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  user.name ?? "",
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: DimenConstants.txtMedium,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: _controller.tripData.value.listIdMember
                          ?.contains(user.uid) ==
                      true,
                  child: IconButton(
                    onPressed: () {},
                    icon: SizedBox(
                      width: 24,
                      child: Image.asset("assets/images/user_added.png"),
                    ),
                  ),
                ),
              ),
              Obx(() => Visibility(
                    visible: _controller.tripData.value.listIdMember
                            ?.contains(user.uid) ==
                        false,
                    child: IconButton(
                      icon: SizedBox(
                        width: 24,
                        child: Image.asset("assets/images/add_new_user.png"),
                      ),
                      onPressed: () {
                        _controller.addMember(user);
                      },
                    ),
                  ))
            ],
          ),
        ),
        onTap: () {
          Get.to(() => const PageUserPreviewScreen(), arguments: [
            {Constants.user: user.uid ?? ""}
          ]);
        });
  }

  void _performSearch() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      Dog.d("_performSearch: $searchText");
      _controller.stringSearch = searchText;
      _controller.searchUser();
    });
  }
}
