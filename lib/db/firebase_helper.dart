import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static String keyRouter = "router";
  static String keyUser = "users";
  static String keyChat = "chat";
  static String messages = "messages";
  static String listIdMember = "listIdMember";
  static String isComplete = "isComplete";
  static String userIdHost = "userIdHost";

  static final CollectionReference collectionReferenceRouter =
      FirebaseFirestore.instance.collection(keyRouter);

  static final CollectionReference collectionReferenceUser =
      FirebaseFirestore.instance.collection(keyUser);

  static final CollectionReference collectionReferenceChat =
      FirebaseFirestore.instance.collection(keyChat);
}
