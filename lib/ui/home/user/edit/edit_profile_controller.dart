


import 'dart:developer';
import 'dart:io';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/db/firebase_helper.dart';
import 'package:appdiphuot/ui/user_singleton_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/const/string_constants.dart';
import '../../../../util/shared_preferences_util.dart';
import '../../../../util/ui_utils.dart';
import '../../../authentication/landing_page/page_authentication_screen.dart';

class EditProfileController extends BaseController{

  final ImagePicker _imagePicker = ImagePicker();
  final Rx<File?> _selectedImage = Rx<File?>(null);
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final _users = FirebaseHelper.collectionReferenceUser;

  var userData = UserSingletonController.instance.userData;

  void clearOnDispose() {
    Get.delete<EditProfileController>();
  }

  void getData() {

  }

  void openCamera() async {
    final image = await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setAppLoading(true, "Loading", TypeApp.uploadAvatar);
      _selectedImage.value = File(image.path);
      _uploadAvatarToFirebase();
    }
  }

  void openGallery() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setAppLoading(true, "Loading", TypeApp.uploadAvatar);
      _selectedImage.value = File(image.path);
      _uploadAvatarToFirebase();
    }
  }

  void _uploadAvatarToFirebase() async {
    try {
      String fileName = userData.value.uid ?? "";
      Reference reference = _firebaseStorage.ref().child("avatars/$fileName");
      UploadTask uploadTask = reference.putFile(_selectedImage.value!);
      TaskSnapshot snapshot = await uploadTask;

      if (snapshot.state != TaskState.success) {
        setAppLoading(false, "Loading", TypeApp.uploadAvatar);
        UIUtils.showSnackBarError(
            StringConstants.error, StringConstants.errorUploadAvatar);
        return;
      }

      String imageUrl = await snapshot.ref.getDownloadURL();
      log("uploadAvatarToFirebase success: url: $imageUrl");
      _users.doc(userData.value.uid).update({"avatar": imageUrl});
      UIUtils.showSnackBar(
          StringConstants.warning, StringConstants.successUploadAvatar);
      setAppLoading(false, "Loading", TypeApp.uploadAvatar);
    } catch (e) {
      log("uploadAvatarToFirebase error: $e");
      setAppLoading(false, "Loading", TypeApp.uploadAvatar);
    }
  }
}