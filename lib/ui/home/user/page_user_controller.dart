import 'dart:developer';
import 'dart:io';

import 'package:appdiphuot/base/base_controller.dart';
import 'package:appdiphuot/common/const/string_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../db/firebase_helper.dart';
import '../../../model/trip.dart';
import '../../../model/user.dart';
import '../../../util/shared_preferences_util.dart';
import '../../../util/ui_utils.dart';
import '../../user_singleton_controller.dart';

class PageUserController extends BaseController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  final ImagePicker _imagePicker = ImagePicker();
  final Rx<File?> _selectedImage = Rx<File?>(null);

  File? get selectedImage => _selectedImage.value;

  var tripParticipatedCount = 0.obs;
  var totalKm = 0.obs;

  var userData = UserSingletonController.instance.userData;

  var trips = <Trip>[].obs;
  var tripsHost = <Trip>[].obs;

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
    getTrip();
    getTripHost();
    getTotalTripCount();
  }

  Future<void> getTrip() async {
    try {
      String uid = await SharedPreferencesUtil.getUIDLogin() ?? "";
      log("getTrip: userid $uid");
      var routerStream = FirebaseHelper.collectionReferenceRouter
          .where(FirebaseHelper.listIdMember, arrayContainsAny: [uid])
          .snapshots();

      var routerSnapshots =
          routerStream.map((querySnapshot) => querySnapshot.docs);

      routerSnapshots.listen((routerSnapshots) {
        var tempTrips = <Trip>[];

        for (var routerSnapshot in routerSnapshots) {
          log("getTrip: $routerSnapshot");

          DocumentSnapshot<Map<String, dynamic>>? tripMap =
              routerSnapshot as DocumentSnapshot<Map<String, dynamic>>?;

          if (tripMap == null || tripMap.data() == null) return;

          var trip = Trip.fromJson((tripMap).data()!);
          tempTrips.add(trip);
        }

        trips.value = tempTrips;
      });
    } catch (e) {
      log("getTrip: $e");
    }
  }

  Future<void> getTripHost() async {
    try {
      String uid = await SharedPreferencesUtil.getUIDLogin() ?? "";
      log("getTripHost: userid $uid");
      var routerStream = FirebaseHelper.collectionReferenceRouter
          .where(FirebaseHelper.userIdHost, isEqualTo: uid)
          .snapshots();

      var routerSnapshots =
          routerStream.map((querySnapshot) => querySnapshot.docs);

      routerSnapshots.listen((routerSnapshots) {
        var tempTrips = <Trip>[];

        for (var routerSnapshot in routerSnapshots) {
          log("getTripHost: $routerSnapshot");

          DocumentSnapshot<Map<String, dynamic>>? tripMap =
              routerSnapshot as DocumentSnapshot<Map<String, dynamic>>?;

          if (tripMap == null || tripMap.data() == null) return;

          var trip = Trip.fromJson((tripMap).data()!);
          tempTrips.add(trip);
        }

        tripsHost.value = tempTrips;
      });
    } catch (e) {
      log("getTripHost: $e");
    }
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
