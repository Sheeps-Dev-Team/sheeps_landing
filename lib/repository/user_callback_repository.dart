import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sheeps_landing/data/models/user_callback.dart';

class UserCallbackRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _userCallbackCollection = _firestore.collection('UserCallback');

  // 쿨백 생성
  static Future<UserCallback?> createUserCallback(UserCallback userCallback) async {
    try {
      final DocumentReference doc = _userCallbackCollection.doc();
      userCallback.documentID = doc.id;

      final DateTime now = DateTime.now();
      userCallback.createdAt = now;
      userCallback.updatedAt = now;

      await doc.set(userCallback.toJson());
      return userCallback;
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return null;
    }
  }
}