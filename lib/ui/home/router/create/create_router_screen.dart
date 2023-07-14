import 'package:appdiphuot/base/base_stateful_state.dart';
import 'package:appdiphuot/common/const/color_constants.dart';
import 'package:appdiphuot/common/const/dimen_constants.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:appdiphuot/ui/home/picker/map_picker/map_picker_screen.dart';
import 'package:appdiphuot/ui/home/router/create_success/create_success_screen.dart';
import 'package:appdiphuot/util/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:forked_slider_button/forked_slider_button.dart';
import 'package:get/get.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

import '../../../../util/log_dog_utils.dart';
import '../../setting/setting_screen.dart';
import '../create_success/enum_router.dart';
import 'create_router_controller.dart';

class CreateRouterScreen extends StatefulWidget {
  const CreateRouterScreen({
    super.key,
    required this.dfTitle,
    required this.dfDescription,
    required this.dfPlaceStart,
    required this.dfPlaceEnd,
    required this.dfListPlaceStop,
    required this.dfDateTimeStart,
    required this.dfDateTimeEnd,
    required this.dfRequire,
    required this.dfIsPublic,
    required this.dfEditRouterWithTripId,
  });

  final String dfTitle;
  final String dfDescription;
  final Place? dfPlaceStart;
  final Place? dfPlaceEnd;
  final List<Place> dfListPlaceStop;
  final DateTime? dfDateTimeStart;
  final DateTime? dfDateTimeEnd;
  final String dfRequire;
  final bool dfIsPublic;
  final String? dfEditRouterWithTripId;

  @override
  State<CreateRouterScreen> createState() => _CreateRouterScreenState();
}

class _CreateRouterScreenState extends BaseStatefulState<CreateRouterScreen> {
  final _controller = Get.put(CreateRouterController());

  @override
  void initState() {
    super.initState();
    _setupListen();
    _controller.getTripInProgress();
    //setup default value
    if (widget.dfEditRouterWithTripId == null ||
        widget.dfEditRouterWithTripId?.isEmpty == true) {
      _controller.setEditRouterMode(false);
      //create router with some default values
      _controller.initDefault(
        widget.dfTitle,
        widget.dfDescription,
        widget.dfPlaceStart,
        widget.dfPlaceEnd,
        widget.dfListPlaceStop,
        widget.dfDateTimeStart,
        widget.dfDateTimeEnd,
        widget.dfRequire,
        widget.dfIsPublic,
      );
    } else {
      //edit router
      _controller.setEditRouterMode(true);
      _controller.editRouter(widget.dfEditRouterWithTripId);
    }
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
    ever(_controller.isCreateRouteSuccess, (value) {
      if (value == true) {
        Get.back();

        RouterState state;
        if (widget.dfEditRouterWithTripId != null) {
          state = RouterState.editSuccess;
          showSnackBarFull(
              StringConstants.warning, "Chỉnh sửa chuyến đi thành công");
        } else {
          state = RouterState.createSuccess;
          showSnackBarFull(StringConstants.warning, "Tạo chuyến đi thành công");
        }

        Get.to(
          CreateSuccessScreen(id: _controller.id.value, state: state
            // dateTimeEnd: _controller.dateTimeEnd.value,
            // placeStart: _controller.placeStart.value,
            // placeEnd: _controller.placeEnd.value,
            // listPlaceStop: _controller.listPlaceStop,
          ),
        );
      }
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
        title: Text(
          _controller.getTextMode(),
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        backgroundColor: ColorConstants.appColor,
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
      backgroundColor: ColorConstants.appColorBkg,
      body: FocusDetector(
        child: Container(
          color: ColorConstants.colorWhite,
          child: Column(
            children: [
              Expanded(child: Obx(() {
                return _buildBodyView();
              })),
            ],
          ),
        ),
        onFocusLost: () {
          debugPrint("onFocusLost");
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  void _navigateToSettingScreen() {
    Get.to(const PageSettingScreen());
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
        const SizedBox(
          height: 12,
        ),
        InkWell(
          onTap: _controller.copyRouterId,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Mã: ${_controller.id.value}',
                style: const TextStyle(
                  fontSize: DimenConstants.txtMedium,
                  color: ColorConstants.appColor,
                ),
                textAlign: TextAlign.end,
              ),
              const SizedBox(width: DimenConstants.marginPaddingSmall),
              const Icon(
                Icons.content_copy,
                color: ColorConstants.appColor,
              ),
            ],
          ),
        ),
        const Divider(),
        //tieu de chuyen di
        Text(
          'Tiêu đề chuyến đi của bạn'.toUpperCase(),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
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
            fillColor: Colors.black12,
          ),
        ),
        const Divider(),
        //mo ta chuyen di
        Text(
          'Mô tả chuyến đi'.toUpperCase(),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
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
            fillColor: Colors.black12,
          ),
        ),
        const Divider(),
        //hinh anh
        Text(
          'HÌNH ẢNH'.toUpperCase(),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
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
            color: Colors.black87,
            fontWeight: FontWeight.w500,
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
                color: Colors.black12,
                borderRadius: const BorderRadius.all(
                    Radius.circular(DimenConstants.radiusMedium))),
            child: Text(
              _controller.placeStart.value.name ?? "Chọn địa điểm",
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
            color: Colors.black87,
            fontWeight: FontWeight.w500,
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
                color: Colors.black12,
                borderRadius: const BorderRadius.all(
                    Radius.circular(DimenConstants.radiusMedium))),
            child: Text(
              _controller.placeEnd.value.name ?? "Chọn địa điểm",
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
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,

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
            color: Colors.black87,
            fontWeight: FontWeight.w500,
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
                color: Colors.black12,
                borderRadius: const BorderRadius.all(
                    Radius.circular(DimenConstants.radiusMedium))),
            child: Text(
              TimeUtils.convert(_controller.dateTimeStart.value),
              style: const TextStyle(
                color: Colors.black,
                fontSize: DimenConstants.txtMedium,
              ),
            ),
          ),
          onTap: () {
            _pickTimeStart();
          },
        ),
        const Divider(),
        //thoi gian ngung dang ky
        Text(
          'thời gian NGỪng đăng ký'.toUpperCase(),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
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
                color: Colors.black12,
                borderRadius: const BorderRadius.all(
                    Radius.circular(DimenConstants.radiusMedium))),
            child: Text(
              TimeUtils.convert(_controller.dateTimeEnd.value),
              style: const TextStyle(
                color: Colors.black,
                fontSize: DimenConstants.txtMedium,
              ),
            ),
          ),
          onTap: () {
            _pickTimeEnd();
          },
        ),
        const Divider(),
        //yeu cau voi nguoi tham gia
        Text(
          'Yêu cầu với người tham gia'.toUpperCase(),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: DimenConstants.txtMedium,
          ),
        ),
        const SizedBox(height: DimenConstants.marginPaddingSmall),
        TextField(
          textAlign: TextAlign.start,
          controller: _controller.tecRequire,
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: 10,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: 'Nhập yêu cầu',
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
            fillColor: Colors.black12,
          ),
        ),
        const Divider(),
        Text(
          'TRẠNG THÁI CHUYẾN ĐI'.toUpperCase(),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: DimenConstants.txtMedium,
          ),
        ),
        const SizedBox(height: DimenConstants.marginPaddingSmall),
        Container(
          alignment: Alignment.center,
          child: LiteRollingSwitch(
            width: 160,
            value: _controller.isPublic.value,
            textOn: 'công khai'.toUpperCase(),
            textOff: 'Cá NHân'.toUpperCase(),
            colorOn: ColorConstants.appColor,
            colorOff: ColorConstants.appColor,
            iconOn: Icons.language,
            iconOff: Icons.lock,
            textSize: DimenConstants.txtMedium,
            onChanged: (bool state) {
              _controller.setPublic(state);
            },
            onTap: () {},
            onDoubleTap: () {},
            onSwipe: () {},
          ),
        ),
        const SizedBox(height: DimenConstants.marginPaddingLarge),
        Center(
          child: SliderButton(
            dismissible: false,
            backgroundColor: Colors.red.withOpacity(0.25),
            action: () {
              if (checkCanJoinTrip()) {
                FocusScope.of(context).unfocus();
                _controller.createRouter();
              } else {
                showErrorDialog("Không thể tham gia",
                    "Bạn có chuyến đi bắt đầu vào ngày này", "OK", () {});
              }
            },
            label: Text(
              _controller.getTextMode(),
              style: const TextStyle(
                  color: Color(0xff4a4a4a),
                  fontWeight: FontWeight.bold,
                  fontSize: DimenConstants.txtMedium),
            ),
            icon: Image.asset(
              "assets/images/ic_launcher.png",
              width: 40,
              height: 40,
            ),
          ),
        ),
        const SizedBox(height: DimenConstants.marginPadding98),
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
              place.name ?? "",
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
      defaultPlace: Place(),
      callback: (newPlace) {
        _controller.addPlaceStop(newPlace);
      },
    ));
  }

  void _pickTimeStart() async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: _controller.dateTimeStart.value,
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      selectableDayPredicate: (dateTime) {
        // Disable 25th Feb 2023
        // if (dateTime == DateTime(2023, 2, 25)) {
        //   return false;
        // } else {
        //   return true;
        // }
        return true;
      },
    );
    _controller.setDateTimeStart(dateTime);
  }

  void _pickTimeEnd() async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: _controller.dateTimeEnd.value,
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      selectableDayPredicate: (dateTime) {
        // Disable 25th Feb 2023
        // if (dateTime == DateTime(2023, 2, 25)) {
        //   return false;
        // } else {
        //   return true;
        // }
        return true;
      },
    );
    _controller.setDateTimeEnd(dateTime);
  }

  bool checkCanJoinTrip() {
    var listJoined = _controller.tripsInProgress.value;
    Dog.d("tripsInProgress: ${listJoined.length}");
    if (listJoined.isNotEmpty) {
      var listStartTimeOfTripsParticipated = <String>[];
      try {
        listJoined.forEach((element) {
          // NẾU đang edit chuyến đi, sẽ loại trừ chuyến đi hiện tại và k cần check time của chuyến đi này
          if (element.id != _controller.tripData.value.id) {
            String timeStart = element.timeStart!.split(" ").first;
            listStartTimeOfTripsParticipated.add(timeStart);
          }
        });

        var timeOfCurrentTrip = TimeUtils
            .convert(_controller.dateTimeStart.value)
            .split(" ")
            .first;

        // Thời gian của chuyến đi hiện tại đã đụng với chuyến đi khác
        if (listStartTimeOfTripsParticipated.contains(timeOfCurrentTrip)) {
          return false;
        } else {
          return true;
        }
      } catch (e, s) {
        print("checkCanJoinTrip eror: $s");
      }
    }
    return false;
  }
}
