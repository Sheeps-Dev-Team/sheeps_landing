import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sheeps_landing/screens/template/default_template.dart';

class Project {
  Project({
    this.documentID = '',
    required this.userDocumentID,
    required this.name,
    required this.title,
    required this.contents,
    required this.imgPath,
    this.callbackType = '',
    this.keyColor = 4283609155,
    this.viewCount = 0,
    this.templateID = DefaultTemplate.id,
    this.descriptions = const [],
    this.isPosting = true,
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
  int keyColor;
  int viewCount;
  int templateID;
  List<Description> descriptions;
  bool isPosting;
  DateTime createdAt;
  DateTime updatedAt;

  factory Project.fromJson(Map<String, dynamic> json) {

    List<Description> list = [];
    if(json['descriptions'] != null || json['descriptions'].isNotEmpty){
      for(var i = 0 ; i < json['descriptions'].length ; ++i){
        list.add(Description.fromJson(json['descriptions'][i]));
      }
    }

    return Project(
      documentID: json['documentID'] ?? '',
      userDocumentID: json['userDocumentID'] ?? '',
      name: json['name'] ?? '',
      title: json['title'] ?? '',
      contents: json['contents'] ?? '',
      imgPath: json['imgPath'] ?? '',
      callbackType: json['callbackType'] ?? '',
      keyColor: json['keyColor'] ?? 4283609155,
      viewCount: json['viewCount'] ?? 0,
      templateID: json['templateID'] ?? DefaultTemplate.id,
      descriptions: list,
      isPosting: json['isPosting'] ?? true,
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
      "keyColor": keyColor,
      "viewCount": viewCount,
      "templateID": templateID,
      "descriptions": descriptions.map((e) => e.toJson()).toList(),
      "isPosting": isPosting,
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
    int? templateID,
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
      templateID: templateID ?? this.templateID,
      descriptions: descriptions ?? this.descriptions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get getUrl => 'https://sheeps-landing.web.app/project/$documentID';
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
