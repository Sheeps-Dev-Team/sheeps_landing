import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  Project({
    this.documentID = '',
    required this.userDocumentID,
    required this.name,
    required this.title,
    required this.contents,
    required this.imgPath,
    this.callbackType = '',
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
  String callbackType;
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
      callbackType: json['callbackType'] ?? '',
      viewCount: json['viewCount'] ?? 0,
      descriptions: json['descriptions'] == null ? [] : (json['descriptions'] as List).map((e) => e.fromJson()).toList().cast<Description>(),
      createdAt: json['createdAt'].toDate(),
      updatedAt: json['updatedAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "documentID": documentID,
      "userDocumentID": userDocumentID,
      "name": name,
      "title": title,
      "contents": contents,
      "imgPath": imgPath,
      "callbackType": callbackType,
      "viewCount": viewCount,
      "descriptions": descriptions.map((e) => e.toJson()).toList(),
      "createdAt": Timestamp.fromDate(createdAt),
      "updatedAt": Timestamp.fromDate(updatedAt),
    };
  }

  static final Project nullProject = Project(
    userDocumentID: '',
    name: '',
    title: '',
    contents: '',
    imgPath: '',
    descriptions: [Description.nullDescription.copyWith()],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  Project copyWith({
    String? documentID,
    String? userDocumentID,
    String? name,
    String? title,
    String? contents,
    String? imgPath,
    String? callbackType,
    int? viewCount,
    List<Description>? descriptions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Project(
      documentID: documentID ?? this.documentID,
      userDocumentID: userDocumentID ?? this.userDocumentID,
      name: name ?? this.name,
      title: title ?? this.title,
      contents: contents ?? this.contents,
      imgPath: imgPath ?? this.imgPath,
      callbackType: callbackType ?? this.callbackType,
      viewCount: viewCount ?? this.viewCount,
      descriptions: descriptions ?? this.descriptions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Description {
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
      "title": title,
      "contents": contents,
      "imgPath": imgPath,
    };
  }

  static final Description nullDescription = Description(title: '', contents: '', imgPath: '');

  Description copyWith({
    String? title,
    String? contents,
    String? imgPath,
  }) {
    return Description(
      title: title ?? this.title,
      contents: contents ?? this.contents,
      imgPath: imgPath ?? this.imgPath,
    );
  }
}
