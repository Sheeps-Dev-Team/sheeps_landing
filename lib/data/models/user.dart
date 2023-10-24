import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    this.documentID = '',
    required this.email,
    required this.loginType,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  String documentID;
  String email;
  int loginType;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      documentID: json['documentID'] ?? '',
      email: json['email'] ?? '',
      loginType: json['loginType'] ?? 0,
      name: json['name'] ?? '',
      createdAt: json['createdAt'].toDate(),
      updatedAt: json['updatedAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "documentID": documentID,
      "email": email,
      "loginType": loginType,
      "name": name,
      "createdAt": Timestamp.fromDate(createdAt),
      "updatedAt": Timestamp.fromDate(updatedAt),
    };
  }
}

class UserCallBack {
  UserCallBack({
    this.projectDocumentID = '',
    required this.ip,
    this.email = '',
    this.phoneNumber = '',
    this.name = '',
    required this.createdAt,
  });

  String projectDocumentID;
  String ip;
  String email;
  String phoneNumber;
  String name;
  DateTime createdAt;

  factory UserCallBack.fromJson(Map<String, dynamic> json) {
    return UserCallBack(
      projectDocumentID: json['projectDocumentID'] ?? '',
      ip: json['ip'] ?? '',
      email: json['email'] ?? 0,
      phoneNumber: json['phoneNumber'] ?? '',
      name: json['name'] ?? '',
      createdAt: json['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "projectDocumentID": projectDocumentID,
      "ip": ip,
      "email": email,
      "phoneNumber": phoneNumber,
      "name": name,
      "createdAt": Timestamp.fromDate(createdAt),
    };
  }
}
