import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static String keyRouter = "router";
  static String keyUser = "users";

  static final CollectionReference collectionReferenceRouter =
      FirebaseFirestore.instance.collection(keyRouter);

  static final CollectionReference collectionReferenceUser =
      FirebaseFirestore.instance.collection(keyUser);
}
