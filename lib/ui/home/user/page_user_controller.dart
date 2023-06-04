import 'dart:developer';
import 'dart:io';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../model/place.dart';
import '../../../model/user.dart';
import '../../../util/shared_preferences_util.dart';
import '../../../util/ui_utils.dart';

class PageUserController extends BaseController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  final ImagePicker _imagePicker = ImagePicker();
  final Rx<File?> _selectedImage = Rx<File?>(null);

  File? get selectedImage => _selectedImage.value;

  var tripParticipatedCount = 0.obs;
  var leadTripCount = 0.obs;
  var totalKm = 0.obs;

  var userData = UserData(
    "",
    "",
    "",
    "",
  ).obs;

  var places = <Place>[
    Place(),
    Place(),
    Place(),
    Place(),
    Place(),
    Place(),
    Place(),
    Place(),
    Place(),
  ].obs;

  void clearOnDispose() {
    Get.delete<PageUserController>();
  }

  void signOut() {
    setAppLoading(true, "Loading", TypeApp.logout);
    SharedPreferencesUtil.setUID("");
    auth.signOut();
    setAppLoading(false, "Loading", TypeApp.logout);
  }

  Future<void> getData() async {
    getUserInfo();
    getTotalTripCount();
    getTrip();
    getTotalTripCount();
  }

  Future<void> getUserInfo() async {
    try {
      String uid = await SharedPreferencesUtil.getUIDLogin() ?? "";
      _users.doc(uid).snapshots().listen((value) {
        DocumentSnapshot<Map<String, dynamic>>? userMap =
            value as DocumentSnapshot<Map<String, dynamic>>?;
        if (userMap == null || userMap.data() == null) return;

        var user = UserData.fromJson((userMap).data()!);
        userData.value = user;
        log("getUserInfo success: ${user.toString()}");
      });
    } catch (e) {
      log("getUserInfo get user info fail: $e");
    }
  }

  String getAvatar() {
    String avatarUrl = userData.value.avatar;
    if (avatarUrl.isEmpty) {
      return StringConstants.avatarImgDefault;
    } else {
      return avatarUrl;
    }
  }

  String getName() {
    return userData.value.name;
  }

  Future<void> getTrip() async {
    // List<Place> fakePlace = fakePlace();
    // places.value = fakePlace;
  }

  Future<void> getTotalKm() async {
    // List<Place> fakePlace = fakePlace();
    // places.value = fakePlace;
  }

  Future<void> getTotalTripCount() async {
    // List<Place> fakePlace = fakePlace();
    // places.value = fakePlace;
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

  void clearSelectedImage() {
    _selectedImage.value = null;
  }

  void _uploadAvatarToFirebase() async {
    try {
      String fileName = userData.value.uid;
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
