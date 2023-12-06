import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:sheeps_landing/data/models/project.dart';

class ProjectRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _projectCollection = _firestore.collection('Project');

  // documentID 로 프로젝트 데이터 가져오기
  static Future<Project?> getProjectByID(String documentID) async {
    Project? project;

    try {
      DocumentSnapshot documentSnapshot = await _projectCollection.doc(documentID).get();
      project = Project.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return null;
    }

    return project;
  }

  // userID 로 프로젝트 리스트 가져오기
  static Future<List<Project>> getProjectListByUserID(String userDocumentID) async {
    List<Project> projects = [];

    try {
      await _projectCollection.where('userDocumentID', isEqualTo: userDocumentID).orderBy('updatedAt', descending: true).get().then((QuerySnapshot querySnapshot) {
        for (QueryDocumentSnapshot<Object?> doc in querySnapshot.docs) {
          projects.add(Project.fromJson(doc.data() as Map<String, dynamic>));
        }
      });
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }

    return projects;
  }

  // 프로젝트 생성
  static Future<Project?> createProject(Project project) async {
    try {
      final DocumentReference doc = _projectCollection.doc();
      project.documentID = doc.id;

      final DateTime now = DateTime.now();
      project.createdAt = now;
      project.updatedAt = now;

      await doc.set(project.toJson());
      return project;
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return null;
    }
  }

  // 프로젝트 수정
  static Future<Project?> modifyProject(Project project) async {
    try {
      project.updatedAt = DateTime.now();

      await _projectCollection.doc(project.documentID).update(project.toJson());
      return project;
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return null;
    }
  }

  // 조회수 업데이트
  static Future<bool> updateViewCount({required String documentID, int count = 1}) async {
    try {
      await _projectCollection.doc(documentID).update(
        {
          "viewCount": FieldValue.increment(count),
          "updatedAt": FieldValue.serverTimestamp(),
        },
      );
      return true;
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return false;
    }
  }

  // 좋아요 업데이트
  static Future<bool> updateLikeCount({required String documentID, int count = 1}) async {
    try {
      await _projectCollection.doc(documentID).update(
        {
          "likeCount": FieldValue.increment(count),
          "updatedAt": FieldValue.serverTimestamp(),
        },
      );
      return true;
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return false;
    }
  }

  // 프로젝트 삭제
  static Future<bool> deleteProject(Project project) async {
    try {
      // main 이미지 삭제
      await FirebaseStorage.instance.refFromURL(project.imgPath).delete();

      // description 이미지 삭제
      for (Description description in project.descriptions) {
        await FirebaseStorage.instance.refFromURL(description.imgPath).delete();
      }

      // 프로젝트 삭제
      await _projectCollection.doc(project.documentID).delete();

      return true;
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return false;
    }
  }

  static Future<bool> updateOrderID({required String documentID, required String orderID}) async {
    try {
      await _projectCollection.doc(documentID).update(
        {
          "orderID": orderID,
          "orderedAt" : FieldValue.serverTimestamp(),
        },
      );
      return true;
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return false;
    }
  }
}
