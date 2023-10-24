import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:sheeps_landing/data/models/user.dart';

class UserRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _userCollection = _firestore.collection('Users');

  // documentID 로 유저 데이터 가져오기
  static Future<User?> getUserByID(String documentID) async {
    User? user;

    try {
      DocumentSnapshot documentSnapshot = await _userCollection.doc(documentID).get();
      user = User.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    } catch (e) {
      if(kDebugMode) print(e.toString());
    }

    return user;
  }

  // 유저 생성
  static Future<User?> createUser(User user) async {
    try {
      final DocumentReference doc = _userCollection.doc();
      user.documentID = doc.id;
      await doc.set(user.toJson());
      return user;
    } catch (e) {
      if(kDebugMode) print(e.toString());
      return null;
    }
  }
}