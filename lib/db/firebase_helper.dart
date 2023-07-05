import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static String keyRouter = "router";
  static String keyLoc = "location";
  static String keyUser = "users";
  static String keyChat = "chat";
  static String messages = "messages";
  static String rates = "rates";
  static String listIdMember = "listIdMember";
  static String listIdMemberBlocked = "listIdMemberBlocked";
  static String isComplete = "isComplete";
  static String userIdHost = "userIdHost";

  static final CollectionReference collectionReferenceRouter =
      FirebaseFirestore.instance.collection(keyRouter);

  static final CollectionReference collectionReferenceUser =
      FirebaseFirestore.instance.collection(keyUser);

  static final CollectionReference collectionReferenceChat =
      FirebaseFirestore.instance.collection(keyChat);

  static final CollectionReference collectionReferenceLoc =
      FirebaseFirestore.instance.collection(keyLoc);
}
