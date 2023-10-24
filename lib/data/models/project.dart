import 'package:cloud_firestore/cloud_firestore.dart';

class Project{

  Project({
    this.documentID = '',
    required this.userDocumentID,
    required this.name,
    required this.title,
    required this.contents,
    this.imgPath = '',
    this.buttonType = 0,
    this.viewCount = 0,
    this.descriptions = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  String documentID;
  String userDocumentID;
  String name;
  String title;
  String contents;
  String imgPath;
  int buttonType;
  int viewCount;
  List<Description> descriptions;
  DateTime createdAt;
  DateTime updatedAt;

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
        documentID: json['documentID'] ?? '',
        userDocumentID: json['userDocumentID'] ?? '',
        name: json['name'] ?? '',
        title: json['title'] ?? '',
        contents: json['contents'] ?? '',
        imgPath: json['imgPath'] ?? '',
        buttonType: json['buttonType'] ?? 0,
        viewCount: json['viewCount'] ?? 0,
        descriptions: json['descriptions'] == null ? [] : (json['descriptions'] as List).map((e) => e.fromJson()).toList().cast<Description>(),
        createdAt: json['createdAt'].toDate(),
        updatedAt: json['updatedAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "documentID" : documentID,
      "userDocumentID" : userDocumentID,
      "name" : name,
      "title" : title,
      "contents" : contents,
      "imgPath" : imgPath,
      "buttonType" : buttonType,
      "viewCount" : viewCount,
      "descriptions" : descriptions.map((e) => e.toJson()).toList(),
      "createdAt": Timestamp.fromDate(createdAt),
      "updatedAt": Timestamp.fromDate(updatedAt),
    };
  }

}

class Description{
  Description({
    required this.title,
    required this.contents,
    required this.imgPath,
  });

  String title;
  String contents;
  String imgPath;

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
        title: json['title'] ?? '',
        contents: json['contents'] ?? '',
        imgPath: json['imgPath'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title" : title,
      "contents" : contents,
      "imgPath" : imgPath,
    };
  }
}