import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class CreateRouterController extends BaseController {
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
  final dateTimeDefault = DateTime(1111, 1, 11);
  var dateTimeStart = DateTime(1111, 1, 11).obs;
  var dateTimeEnd = DateTime(1111, 1, 11).obs;
  var isPublic = true.obs;

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
    dateTimeStart.value = dt;
  }

  DateTime getDateTimeStart() {
    if (dateTimeStart.value == dateTimeDefault) {
      return DateTime.now();
    } else {
      return dateTimeStart.value;
    }
  }

  DateTime getDateTimeEnd() {
    if (dateTimeEnd.value == dateTimeDefault) {
      return DateTime.now();
    } else {
      return dateTimeEnd.value;
    }
  }

  void setDateTimeEnd(DateTime? dt) {
    if (dt == null) {
      return;
    }
    dateTimeEnd.value = dt;
  }

  void setPublic(bool value) {
    isPublic.value = value;
  }

  void createRouter() {
    String sTitle = tecTitle.text.toString().trim();
    String sDescription = tecDescription.text.toString().trim();
    String sRequire = tecRequire.text.toString().trim();
    final sImages = controllerImagePicker.images;
    Place sPlaceStart = placeStart.value;
    Place sPlaceEnd = placeEnd.value;
    var sListPlaceStop = listPlaceStop;
    var sDateTimeStart = dateTimeStart;
    var sDateTimeEnd = dateTimeEnd;

    debugPrint(">>>>>>>>>>>>>>>createRouter");
    debugPrint("sTitle $sTitle");
    debugPrint("sDescription $sDescription");
    debugPrint("sRequire $sRequire");
    debugPrint("sImages ${sImages.length}");
    for (var element in sImages) {
      debugPrint("element ${element.name} ${element.path}");
    }
    debugPrint("sPlaceStart $sPlaceStart");
    debugPrint("sPlaceEnd $sPlaceEnd");
    debugPrint("sListPlaceStop ${sListPlaceStop.length}");
    for (var element in sListPlaceStop) {
      debugPrint("element ${element.name}");
    }
    debugPrint("sDateTimeStart $sDateTimeStart");
    debugPrint("sDateTimeEnd $sDateTimeEnd");
  }
}
