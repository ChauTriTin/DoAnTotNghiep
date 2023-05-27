import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/model/place.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class CreateRouterController extends BaseController {
  final tecTitle = TextEditingController();
  final tecDescription = TextEditingController();
  final controllerImagePicker = MultiImagePickerController(
    maxImages: 6,
    withReadStream: true,
    allowedImageTypes: ['png', 'jpg', 'jpeg'],
  );
  var placeStart = Place().obs;
  var placeEnd = Place().obs;

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

  void createRouter() {
    String sTitle = tecTitle.text.toString().trim();
    String sDescription = tecDescription.text.toString().trim();
    final sImages = controllerImagePicker.images;
    Place sPlaceStart = placeStart.value;
    Place sPlaceEnd = placeEnd.value;

    debugPrint(">>>createRouter sTitle $sTitle");
    debugPrint(">>>createRouter sDescription $sDescription");
    debugPrint(">>>createRouter sImages ${sImages.length}");
    for (var element in sImages) {
      debugPrint(">>>createRouter element ${element.name} ${element.path}");
    }
    debugPrint(">>>createRouter sPlaceStart $sPlaceStart");
    debugPrint(">>>createRouter sPlaceEnd $sPlaceEnd");
  }
}
