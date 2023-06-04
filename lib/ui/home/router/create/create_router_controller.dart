import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:appdiphuot/model/trip.dart';
import 'package:appdiphuot/util/time_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class CreateRouterController extends BaseController {
  final id = DateTime.now().microsecondsSinceEpoch.toString();
  final tecTitle = TextEditingController();
  final tecDescription = TextEditingController();
  final tecRequire = TextEditingController();
  final controllerImagePicker = MultiImagePickerController(
    maxImages: 6,
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
      return;
    }
    debugPrint("sDescription $sDescription");
    if (sDescription.isEmpty) {
      showSnackBarFullError(
          StringConstants.warning, "Vui lòng nhập mô tả chuyến đi");
      return;
    }
    debugPrint("sRequire $sRequire");
    debugPrint("sImages ${sImages.length}");
    if (sImages.isEmpty) {
      showSnackBarFullError(
          StringConstants.warning, "Vui lòng đính kèm hình ảnh");
      return;
    }
    for (var element in sImages) {
      debugPrint("element ${element.name} ${element.path}");
    }
    debugPrint("sPlaceStart $sPlaceStart");
    debugPrint("sPlaceEnd $sPlaceEnd");
    if (sPlaceStart.name == null || sPlaceStart.name?.isEmpty == true) {
      showSnackBarFullError(
          StringConstants.warning, "Vui lòng chọn địa điểm bắt đầu");
      return;
    }
    if (sPlaceEnd.name == null || sPlaceEnd.name?.isEmpty == true) {
      showSnackBarFullError(
          StringConstants.warning, "Vui lòng chọn địa điểm kết thúc");
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
      return;
    }

    var trip = Trip();
    trip.id = id;
    trip.userIdHost = "123"; //TODO
    trip.listIdMember = [];
    trip.title = sTitle;
    trip.des = sDescription;
    trip.listImg = []; //TODO
    trip.placeStart = sPlaceStart;
    trip.placeEnd = sPlaceEnd;
    trip.listPlace = listPlaceStop;
    trip.timeStart = TimeUtils.convert(dateTimeStart.value);
    trip.timeEnd = TimeUtils.convert(dateTimeEnd.value);
    trip.require = sRequire;
    trip.isPublic = isPublic.value;

    debugPrint(">>>trip ${trip.toJson()}");

    // setAppLoading(true, "Loading", TypeApp.createRouter);
    // Future.delayed(const Duration(milliseconds: 2000), () {
    //   isCreateRouteSuccess.value = true;
    //
    //   //TODO delete later
    //   if (kDebugMode) {
    //     isCreateRouteSuccess.value = false;
    //   }
    //
    //   setAppLoading(false, "Loading", TypeApp.createRouter);
    // });

    // try {
    //   var userData = UserData(user.displayName ?? "", user.uid,
    //       user.email ?? "", user.photoURL ?? "");
    //
    //   Dog.d('createRouter: user: ${userData.toJson()}');
    //   FirebaseHelper.collectionReferenceRouter
    //       .doc(user.uid)
    //       .set(userData.toJson())
    //       .then((value) {
    //     Dog.d("saveUserInfoToFirebaseDataStore User Added");
    //   }).catchError((error) {
    //     Dog.d("saveUserInfoToFirebaseDataStore Failed to add user: $error");
    //   });
    // } catch (e) {
    //   Dog.e('createRouter: $e');
    // }
  }
}
