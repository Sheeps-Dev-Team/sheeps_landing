import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    this.documentID = '',
    required this.email,
    required this.loginType,
    required this.name,
    this.state = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  String documentID;
  String email;
  int loginType;
  String name;
  int state;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      documentID: json['documentID'] ?? '',
      email: json['email'] ?? '',
      loginType: json['loginType'] ?? 0,
      name: json['name'] ?? '',
      state: json['state'] ?? 0,
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
      "state" : state,
      "createdAt": Timestamp.fromDate(createdAt),
      "updatedAt": Timestamp.fromDate(updatedAt),
    };
  }
}