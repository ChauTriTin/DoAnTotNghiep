import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static String keyRouter = "router";

  static final CollectionReference collectionReferenceRouter =
      FirebaseFirestore.instance.collection(keyRouter);
}
