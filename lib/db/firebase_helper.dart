import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/user.dart';
import '../util/shared_preferences_util.dart';

class FirebaseHelper {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  Future<void> getUserInfo() async {
    try {
      String uid = await SharedPreferencesUtil.getUIDLogin() ?? "";
      _users.doc(uid).snapshots().listen((value) {
        DocumentSnapshot<Map<String, dynamic>>? userMap =
            value as DocumentSnapshot<Map<String, dynamic>>?;
        if (userMap == null || userMap.data() == null) return;

        var user = UserData.fromJson((userMap).data()!);
      });
    } catch (e) {
      debugPrint(">>>getUserInfo $e");
    }
  }

// void _uploadAvatarToFirebase() async {
//   try {
//     String fileName = userData.value.uid;
//     Reference reference = _firebaseStorage.ref().child("avatars/$fileName");
//     UploadTask uploadTask = reference.putFile(_selectedImage.value!);
//     TaskSnapshot snapshot = await uploadTask;
//
//     if (snapshot.state != TaskState.success) {
//       setAppLoading(false, "Loading", TypeApp.uploadAvatar);
//       UIUtils.showSnackBarError(
//           StringConstants.error, StringConstants.errorUploadAvatar);
//       return;
//     }
//
//     String imageUrl = await snapshot.ref.getDownloadURL();
//     log("uploadAvatarToFirebase success: url: $imageUrl");
//     _users.doc(userData.value.uid).update({"avatar": imageUrl});
//     UIUtils.showSnackBar(
//         StringConstants.warning, StringConstants.successUploadAvatar);
//     setAppLoading(false, "Loading", TypeApp.uploadAvatar);
//   } catch (e) {
//     log("uploadAvatarToFirebase error: $e");
//     setAppLoading(false, "Loading", TypeApp.uploadAvatar);
//   }
// }
}
