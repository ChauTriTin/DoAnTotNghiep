import 'dart:io';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/common/const/convert_utils.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/db/firebase_helper.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:appdiphuot/model/rate.dart';
import 'package:appdiphuot/model/trip.dart';
import 'package:appdiphuot/util/log_dog_utils.dart';
import 'package:appdiphuot/util/time_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

import '../../../user_singleton_controller.dart';

class CreateRouterController extends BaseController {
  var userData = UserSingletonController.instance.userData;
  final id = DateTime.now().millisecondsSinceEpoch.toString();
  final tecTitle = TextEditingController();
  final tecDescription = TextEditingController();
  final tecRequire = TextEditingController();
  final controllerImagePicker = MultiImagePickerController(
    maxImages: 3,
    withReadStream: true,
    allowedImageTypes: ['png', 'jpg', 'jpeg'],
  );
  var placeStart = Place().obs;
  var placeEnd = Place().obs;
  var listPlaceStop = <Place>[].obs;

  // final dateTimeDefault = DateTime(1111, 1, 11);
  var dateTimeStart = DateTime.now().add(const Duration(days: 7)).obs;
  var dateTimeEnd = DateTime.now().add(const Duration(days: 6)).obs;
  var isPublic = true.obs;

  var isCreateRouteSuccess = false.obs;

  void clearOnDispose() {
    controllerImagePicker.dispose();
    Get.delete<CreateRouterController>();
  }

  void initDefault(
    String title,
    String description,
    Place? placeStart,
    Place? placeEnd,
    List<Place> listPlaceStop,
    DateTime? dateTimeStart,
    DateTime? dateTimeEnd,
    String require,
  ) {
    debugPrint(">>>initDefault $title");
    debugPrint(">>>initDefault $description");
    debugPrint(">>>initDefault ${placeStart?.toJson()}");
    debugPrint(">>>initDefault ${placeEnd?.toJson()}");
    debugPrint(">>>initDefault ${listPlaceStop.toString()}");
    debugPrint(">>>initDefault $dateTimeStart");
    debugPrint(">>>initDefault $dateTimeEnd");
    debugPrint(">>>initDefault $require");
    tecTitle.text = title;
    tecDescription.text = description;
    if (placeStart != null) {
      setPlaceStart(placeStart);
    }
    if (placeEnd != null) {
      setPlaceEnd(placeEnd);
    }
    this.listPlaceStop.addAll(listPlaceStop);
    if (dateTimeStart != null) {
      setDateTimeStart(dateTimeStart);
    }
    if (dateTimeEnd != null) {
      setDateTimeEnd(dateTimeEnd);
    }
    tecRequire.text = require;
  }

  void setPlaceStart(Place place) {
    placeStart.value = place;
  }

  void setPlaceEnd(Place place) {
    placeEnd.value = place;
  }

  bool isValidToAddNewPlaceStop() {
    if (listPlaceStop.length < 5) {
      return true;
    }
    return false;
  }

  void addPlaceStop(Place place) {
    listPlaceStop.add(place);
    listPlaceStop.refresh();
  }

  void editPlaceStop(Place place, int index) {
    listPlaceStop[index] = place;
    listPlaceStop.refresh();
  }

  void deletePlaceStop(int index) {
    listPlaceStop.removeAt(index);
    listPlaceStop.refresh();
  }

  void setDateTimeStart(DateTime? dt) {
    if (dt == null) {
      return;
    }
    debugPrint(">>> dt ${dt.microsecondsSinceEpoch}");
    debugPrint(">>> dateTimeEnd ${dateTimeEnd.value.microsecondsSinceEpoch}");
    var diff =
        dt.microsecondsSinceEpoch > dateTimeEnd.value.microsecondsSinceEpoch;
    debugPrint(">>> diff $diff");
    if (diff) {
      dateTimeStart.value = dt;
    } else {
      showSnackBarFullError(StringConstants.warning,
          "Thời gian khởi hành phải sau thời gian ngừng đăng kí");
    }
  }

  // DateTime getDateTimeStart() {
  //   if (dateTimeStart.value == dateTimeDefault) {
  //     return DateTime.now();
  //   } else {
  //     return dateTimeStart.value;
  //   }
  // }
  //
  // DateTime getDateTimeEnd() {
  //   if (dateTimeEnd.value == dateTimeDefault) {
  //     return DateTime.now();
  //   } else {
  //     return dateTimeEnd.value;
  //   }
  // }

  void setDateTimeEnd(DateTime? dt) {
    if (dt == null) {
      return;
    }
    debugPrint(">>> dt ${dt.microsecondsSinceEpoch}");
    debugPrint(">>> dateTimeEnd ${dateTimeStart.value.microsecondsSinceEpoch}");
    var diff =
        dt.microsecondsSinceEpoch < dateTimeStart.value.microsecondsSinceEpoch;
    debugPrint(">>> diff $diff");
    if (diff) {
      dateTimeEnd.value = dt;
    } else {
      showSnackBarFullError(StringConstants.warning,
          "Thời gian ngừng đăng ký phải trước hơn thời gian khởi hành");
    }
  }

  void setPublic(bool value) {
    isPublic.value = value;
  }

  Future<void> createRouter() async {
    setAppLoading(true, "Loading", TypeApp.createRouter);

    String sTitle = tecTitle.text.toString().trim();
    String sDescription = tecDescription.text.toString().trim();
    String sRequire = tecRequire.text.toString().trim();
    final sImages = controllerImagePicker.images;
    Place sPlaceStart = placeStart.value;
    Place sPlaceEnd = placeEnd.value;
    var sListPlaceStop = listPlaceStop;
    var sDateTimeStart = dateTimeStart.value;
    var sDateTimeEnd = dateTimeEnd.value;
    var sIsPublic = isPublic.value;

    // if (kDebugMode) {
    //   showSnackBarFull(
    //       StringConstants.warning, "Debug mode: Force createRouter");
    //   isCreateRouteSuccess.value = true;
    //   setAppLoading(false, "Loading", TypeApp.createRouter);
    //   return;
    // }

    debugPrint(">>>>>>>>>>>>>>>createRouter");
    debugPrint("sTitle $sTitle");
    if (sTitle.isEmpty) {
      showSnackBarFullError(
          StringConstants.warning, "Vui lòng nhập tiêu đề chuyến đi của bạn");
      setAppLoading(false, "", TypeApp.createRouter);
      return;
    }
    debugPrint("sDescription $sDescription");
    if (sDescription.isEmpty) {
      showSnackBarFullError(
          StringConstants.warning, "Vui lòng nhập mô tả chuyến đi");
      setAppLoading(false, "", TypeApp.createRouter);
      return;
    }
    debugPrint("sRequire $sRequire");
    debugPrint("sImages ${sImages.length}");
    if (sImages.isEmpty) {
      showSnackBarFullError(
          StringConstants.warning, "Vui lòng đính kèm hình ảnh");
      setAppLoading(false, "", TypeApp.createRouter);
      return;
    }
    // for (var element in sImages) {
    //   debugPrint("element ${element.name} ${element.path}");
    // }
    debugPrint("sPlaceStart $sPlaceStart");
    debugPrint("sPlaceEnd $sPlaceEnd");
    if (sPlaceStart.name == null || sPlaceStart.name?.isEmpty == true) {
      showSnackBarFullError(
          StringConstants.warning, "Vui lòng chọn địa điểm bắt đầu");
      setAppLoading(false, "", TypeApp.createRouter);
      return;
    }
    if (sPlaceEnd.name == null || sPlaceEnd.name?.isEmpty == true) {
      showSnackBarFullError(
          StringConstants.warning, "Vui lòng chọn địa điểm kết thúc");
      setAppLoading(false, "", TypeApp.createRouter);
      return;
    }
    debugPrint("sListPlaceStop ${sListPlaceStop.length}");
    // if (sListPlaceStop.isEmpty) {
    //   showSnackBarFullError(
    //       StringConstants.warning, "Vui lòng chọn điểm dừng chân");
    //   return;
    // }
    // for (var element in sListPlaceStop) {
    //   debugPrint("element ${element.name}");
    // }
    debugPrint("sDateTimeStart $sDateTimeStart");
    // if (sDateTimeStart == dateTimeDefault) {
    //   showSnackBarFullError(
    //       StringConstants.warning, "Vui lòng chọn thời gian khởi hành");
    //   return;
    // }
    debugPrint("sDateTimeEnd $sDateTimeEnd");
    // if (sDateTimeEnd == dateTimeDefault) {
    //   showSnackBarFullError(
    //       StringConstants.warning, "Vui lòng chọn thời gian ngừng đăng kí");
    //   return;
    // }
    debugPrint("sIsPublic $sIsPublic");
    if (sRequire.isEmpty) {
      showSnackBarFullError(
          StringConstants.warning, "Vui lòng nhập yêu cầu với người tham gia");
      setAppLoading(false, "", TypeApp.createRouter);
      return;
    }
    var trip = Trip();
    trip.id = id;
    trip.userIdHost = userData.value.uid;
    trip.userHostName = userData.value.name;
    trip.listIdMember = <String>[];
    if (userData.value.uid?.isNotEmpty == true) {
      trip.listIdMember?.add(userData.value.uid ?? "");
    }
    trip.title = sTitle;
    trip.des = sDescription;
    trip.listImg = <String>[];

    // for (var element in sImages) {
    //   // debugPrint("element ${element.name} ${element.path}");
    //   if (element.path != null) {
    //     var file = File(element.path!);
    //     if (await file.exists()) {
    //       var base64 = imageToBase64(file);
    //       debugPrint("element ${element.name} ${element.path} base64 $base64");
    //       trip.listImg?.add(base64);
    //     }
    //   }
    // }
    await Future.wait(
      sImages.map(
        (element) async {
          // var body = (await api.get(item.url)).bodyBytes;
          // await file.writeAsBytes(body);

          var file = File(element.path!);
          var base64 = imageToBase64(file);
          debugPrint("element ${element.name} ${element.path} base64 $base64");
          trip.listImg?.add(base64);
        },
      ),
    );

    trip.placeStart = sPlaceStart;
    trip.placeEnd = sPlaceEnd;
    trip.listPlace = listPlaceStop;
    trip.timeStart = TimeUtils.convert(dateTimeStart.value);
    trip.timeEnd = TimeUtils.convert(dateTimeEnd.value);
    trip.require = sRequire;
    trip.isPublic = isPublic.value;
    trip.isComplete = false;
    // trip.rates = List.empty();

    debugPrint(">>>trip ${trip.toJson()}");

    Future.delayed(const Duration(milliseconds: 500), () {
      isCreateRouteSuccess.value = true;

      try {
        FirebaseHelper.collectionReferenceRouter
            .doc(trip.id)
            .set(trip.toJson())
            .then((value) {
          Dog.d("createRouter trip Added");
          isCreateRouteSuccess.value = false;
        }).catchError((error) {
          Dog.d("createRouter Failed to add trip: $error");
        });
      } catch (e) {
        Dog.e('createRouter: $e');
      }

      setAppLoading(false, "Loading", TypeApp.createRouter);
    });
  }
}
