import 'package:appdiphuot/base/base_controller.dart';
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
  var startLat = 10.8231.obs; //hcmc default
  var startLong = 106.6297.obs; //hcmc default
  var startName = "".obs;

  void clearOnDispose() {
    controllerImagePicker.dispose();
    Get.delete<CreateRouterController>();
  }

  void setStartLat(double value) {
    startLat.value = value;
  }

  void setStartLong(double value) {
    startLong.value = value;
  }

  void setStartName(String value) {
    startName.value = value;
  }

  void createRouter() {
    String sTitle = tecTitle.text.toString().trim();
    String sDescription = tecDescription.text.toString().trim();
    final sImages = controllerImagePicker.images;
    double sStartLat = startLat.value;
    double sStartLong = startLong.value;
    String sStartName = startName.value;

    debugPrint(">>>createRouter sTitle $sTitle");
    debugPrint(">>>createRouter sDescription $sDescription");
    debugPrint(">>>createRouter sImages ${sImages.length}");
    for (var element in sImages) {
      debugPrint(">>>createRouter element ${element.name} ${element.path}");
    }
    debugPrint(">>>createRouter sStartLat $sStartLat");
    debugPrint(">>>createRouter startLong $sStartLong");
    debugPrint(">>>createRouter sStartName $sStartName");
  }
}
