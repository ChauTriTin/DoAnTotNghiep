import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/home/home/page_home_controller.dart';
import 'package:appdiphuot/view/profile_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateRouterScreen extends StatefulWidget {
  const CreateRouterScreen({
    super.key,
  });

  @override
  State<CreateRouterScreen> createState() => _CreateRouterScreenState();
}

class _CreateRouterScreenState extends BaseStatefulState<CreateRouterScreen> {
  final _controller = Get.put(PageHomeController());
  final _tecTitle = TextEditingController();
  final _tecDescription = TextEditingController();

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
              linkAvatar: StringConstants.linkImgMinaCrying,
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  DimenConstants.marginPaddingMedium,
                  DimenConstants.marginPaddingSmall,
                  DimenConstants.marginPaddingMedium,
                  0,
                ),
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: ColorConstants.appColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        child: const Text(
                          'Tạo chuyến đi',
                          style: TextStyle(
                            fontSize: DimenConstants.txtMedium,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Mã: AB0134NM45',
                          style: TextStyle(
                            fontSize: DimenConstants.txtMedium,
                            color: ColorConstants.appColor,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      const SizedBox(width: DimenConstants.marginPaddingSmall),
                      const Icon(
                        Icons.content_copy,
                        color: ColorConstants.appColor,
                      ),
                    ],
                  ),
                  const Divider(),
                  Text(
                    'Tiêu đề chuyến đi của bạn'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: DimenConstants.txtMedium,
                    ),
                  ),
                  const SizedBox(height: DimenConstants.marginPaddingSmall),
                  TextField(
                    textAlign: TextAlign.start,
                    controller: _tecTitle,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Nhập tiêu đề',
                      hintStyle: const TextStyle(
                        fontSize: DimenConstants.txtMedium,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(DimenConstants.radiusMedium),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      filled: false,
                      contentPadding: const EdgeInsets.all(
                          DimenConstants.marginPaddingMedium),
                      fillColor: ColorConstants.appColor,
                    ),
                  ),
                  const Divider(),
                  Text(
                    'Mô tả chuyến đi'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: DimenConstants.txtMedium,
                    ),
                  ),
                  const SizedBox(height: DimenConstants.marginPaddingSmall),
                  TextField(
                    textAlign: TextAlign.start,
                    controller: _tecDescription,
                    keyboardType: TextInputType.multiline,
                    minLines: 5,
                    maxLines: 10,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'Nhập mô tả',
                      hintStyle: const TextStyle(
                        fontSize: DimenConstants.txtMedium,
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(DimenConstants.radiusMedium),
                        borderSide: const BorderSide(
                          width: 0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      filled: false,
                      contentPadding: const EdgeInsets.all(
                          DimenConstants.marginPaddingMedium),
                      fillColor: ColorConstants.appColor,
                    ),
                  ),
                  const Divider(),
                  Text(
                    'HÌNH ẢNH'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: DimenConstants.txtMedium,
                    ),
                  ),
                  const SizedBox(height: DimenConstants.marginPaddingSmall),
                  const Divider(),
                  Text(
                    'Địa điểm bắt đầu'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: DimenConstants.txtMedium,
                    ),
                  ),
                  const SizedBox(height: DimenConstants.marginPaddingSmall),
                  const Divider(),
                  Text(
                    'Địa điểm kết THúc'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: DimenConstants.txtMedium,
                    ),
                  ),
                  const SizedBox(height: DimenConstants.marginPaddingSmall),
                  const Divider(),
                  Text(
                    'Địa điểm kết THúc'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: DimenConstants.txtMedium,
                    ),
                  ),
                  const SizedBox(height: DimenConstants.marginPaddingSmall),
                  const Divider(),
                  Text(
                    'nơi dùng chân'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: DimenConstants.txtMedium,
                    ),
                  ),
                  const SizedBox(height: DimenConstants.marginPaddingSmall),
                  const Divider(),
                  Text(
                    'thời gian khởi hành'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: DimenConstants.txtMedium,
                    ),
                  ),
                  const SizedBox(height: DimenConstants.marginPaddingSmall),
                  const Divider(),
                  Text(
                    'thời gian NGỪng đăng ký'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: DimenConstants.txtMedium,
                    ),
                  ),
                  const SizedBox(height: DimenConstants.marginPaddingSmall),
                  const Divider(),
                  Text(
                    'thời gian NGỪng đăng ký'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: DimenConstants.txtMedium,
                    ),
                  ),
                  const SizedBox(height: DimenConstants.marginPaddingSmall),
                  const Divider(),
                  Text(
                    'Yêu cầu với người tham gia'.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: DimenConstants.txtMedium,
                    ),
                  ),
                  const SizedBox(height: DimenConstants.marginPaddingSmall),
                  const Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
