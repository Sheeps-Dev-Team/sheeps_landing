import 'package:cloud_firestore/cloud_firestore.dart';
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
      if(kDebugMode) print(e.toString());
      return null;
    }

    return project;
  }

  // userID 로 프로젝트 리스트 가져오기
  static Future<List<Project>> getProjectListByUserID(String userDocumentID) async {
    List<Project> projects = [];

    try {
      await _projectCollection.where('userDocumentID', isEqualTo: userDocumentID).get().then((QuerySnapshot querySnapshot) {
        for(QueryDocumentSnapshot<Object?> doc in querySnapshot.docs) {
          projects.add(Project.fromJson(doc.data() as Map<String, dynamic>));
        }
      });
    } catch (e) {
      if(kDebugMode) print(e.toString());
    }

    return projects;
  }

  // 프로젝트 생성
  static Future<Project?> createProject(Project project) async {
    try {
      final DocumentReference doc = _projectCollection.doc();
      project.documentID = doc.id;
      await doc.set(project.toJson());
      return project;
    } catch (e) {
      if(kDebugMode) print(e.toString());
      return null;
    }
  }
}