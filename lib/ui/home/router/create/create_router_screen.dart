import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/ui/home/picker/map_picker/map_picker_screen.dart';
import 'package:appdiphuot/view/profile_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

import 'create_router_controller.dart';

class CreateRouterScreen extends StatefulWidget {
  const CreateRouterScreen({
    super.key,
  });

  @override
  State<CreateRouterScreen> createState() => _CreateRouterScreenState();
}

class _CreateRouterScreenState extends BaseStatefulState<CreateRouterScreen> {
  final _controller = Get.put(CreateRouterController());

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
    // _controller.tecTitle.addListener(() {
    //   _controller.setTitle(_controller.tecTitle.text.toString().trim());
    // });
    // _controller.tecDescription.addListener(() {
    //   _controller.setDescription(_controller.tecDescription.text.toString().trim());
    // });
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
            const SizedBox(height: DimenConstants.marginPaddingTiny),
            Expanded(child: Obx(() {
              return _buildBodyView();
            })),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyView() {
    return ListView(
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
              onPressed: () {
                _controller.createRouter();
              },
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
        //tieu de chuyen di
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
          controller: _controller.tecTitle,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Nhập tiêu đề',
            hintStyle: const TextStyle(
              fontSize: DimenConstants.txtMedium,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(DimenConstants.radiusMedium),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.solid,
              ),
            ),
            filled: true,
            contentPadding:
                const EdgeInsets.all(DimenConstants.marginPaddingMedium),
            fillColor: Colors.white,
          ),
        ),
        const Divider(),
        //mo ta chuyen di
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
          controller: _controller.tecDescription,
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
              borderRadius: BorderRadius.circular(DimenConstants.radiusMedium),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.solid,
              ),
            ),
            filled: true,
            contentPadding:
                const EdgeInsets.all(DimenConstants.marginPaddingMedium),
            fillColor: Colors.white,
          ),
        ),
        const Divider(),
        //hinh anh
        Text(
          'HÌNH ẢNH'.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: DimenConstants.txtMedium,
          ),
        ),
        const SizedBox(height: DimenConstants.marginPaddingSmall),
        MultiImagePickerView(
          onChange: (list) {
            debugPrint("MultiImagePickerView $list");
          },
          controller: _controller.controllerImagePicker,
          padding: const EdgeInsets.all(0),
          initialContainerBuilder: (context, pickerCallback) {
            return SizedBox(
              height: 70,
              width: 70,
              child: Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: ColorConstants.appColor,
                    shape: const CircleBorder(),
                    elevation: DimenConstants.radiusMedium,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(DimenConstants.marginPaddingMedium),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  onPressed: () {
                    pickerCallback();
                  },
                ),
              ),
            );
          },
          addMoreBuilder: (context, pickerCallback) {
            return SizedBox(
              height: 70,
              width: 0,
              child: Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: ColorConstants.appColor,
                    shape: const CircleBorder(),
                    elevation: DimenConstants.radiusMedium,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(DimenConstants.marginPaddingMedium),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  onPressed: () {
                    pickerCallback();
                  },
                ),
              ),
            );
          },
        ),
        const SizedBox(height: DimenConstants.marginPaddingSmall),
        const Divider(),
        //dia diem bat dau
        Text(
          'Địa điểm bắt đầu'.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: DimenConstants.txtMedium,
          ),
        ),
        const SizedBox(height: DimenConstants.marginPaddingSmall),
        InkWell(
          child: Container(
            padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: Colors.black,
                ),
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                    Radius.circular(DimenConstants.radiusMedium))),
            child: Text(
              _controller.placeStart.value.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: DimenConstants.txtMedium,
              ),
            ),
          ),
          onTap: () {
            Get.to(MapPickerScreen(
              defaultPlace: _controller.placeStart.value,
              callback: (newPlace) {
                _controller.setPlaceStart(newPlace);
              },
            ));
          },
        ),
        const SizedBox(height: DimenConstants.marginPaddingSmall),
        const Divider(),
        //dia diem ket thuc
        Text(
          'Địa điểm kết THúc'.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: DimenConstants.txtMedium,
          ),
        ),
        const SizedBox(height: DimenConstants.marginPaddingSmall),
        InkWell(
          child: Container(
            padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: Colors.black,
                ),
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                    Radius.circular(DimenConstants.radiusMedium))),
            child: Text(
              _controller.placeEnd.value.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: DimenConstants.txtMedium,
              ),
            ),
          ),
          onTap: () {
            Get.to(MapPickerScreen(
              defaultPlace: _controller.placeEnd.value,
              callback: (newPlace) {
                _controller.setPlaceEnd(newPlace);
              },
            ));
          },
        ),
        const SizedBox(height: DimenConstants.marginPaddingSmall),
        const Divider(),
        //noi dung chan
        Row(
          children: [
            Expanded(
              child: Text(
                'nơi dừng chân'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: DimenConstants.txtMedium,
                ),
              ),
            ),
            FloatingActionButton(
              mini: true,
              elevation: DimenConstants.elevationMedium,
              backgroundColor: ColorConstants.appColor,
              onPressed: () {
                _addNewStopPlace();
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: DimenConstants.marginPaddingSmall),
        _buildStopView(),
        const Divider(),
        //thoi gian khoi hanh
        Text(
          'thời gian khởi hành'.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: DimenConstants.txtMedium,
          ),
        ),
        const SizedBox(height: DimenConstants.marginPaddingSmall),
        const Divider(),
        //thoi gian ngung dang ky
        Text(
          'thời gian NGỪng đăng ký'.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: DimenConstants.txtMedium,
          ),
        ),
        const SizedBox(height: DimenConstants.marginPaddingSmall),
        const Divider(),
        //yeu cau voi nguoi tham gia
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
    );
  }

  Widget _buildStopView() {
    var list = _controller.listPlaceStop;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, i) {
        var place = list[i];
        return InkWell(
          child: Container(
            padding: const EdgeInsets.all(DimenConstants.marginPaddingMedium),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: Colors.black,
                ),
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                    Radius.circular(DimenConstants.radiusMedium))),
            child: Text(
              place.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: DimenConstants.txtMedium,
              ),
            ),
          ),
          onTap: () {
            Get.to(MapPickerScreen(
              defaultPlace: place,
              callback: (newPlace) {
                _controller.editPlaceStop(newPlace, i);
              },
            ));
          },
          onLongPress: () {
            _controller.deletePlaceStop(i);
            showSnackBarFull(
                StringConstants.warning, "Xoá điểm dừng chân thành công");
          },
        );
      },
    );
  }

  void _addNewStopPlace() {
    if (!_controller.isValidToAddNewPlaceStop()) {
      showSnackBarFullError(StringConstants.warning,
          "Bạn chỉ có thể thêm tối đa 5 điểm dừng chân");
      return;
    }
    Get.to(MapPickerScreen(
      defaultPlace: null,
      callback: (newPlace) {
        _controller.addPlaceStop(newPlace);
      },
    ));
  }
}
