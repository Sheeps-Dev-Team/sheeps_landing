import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserCallback {
  static const String typeNone = '선택 안함';
  static const String typeForm = '폼';
  static const String typeLink = '링크';

  static const String formTypeName = '이름';
  static const String formTypeEmail = '이메일';
  static const String formTypePhoneNumber = '전화번호';

  UserCallback({
    this.documentID = '',
    required this.projectID,
    required this.ip,
    this.name,
    this.email,
    this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  String documentID;
  final String projectID;
  final String ip;
  final String? name;
  final String? email;
  final String? phoneNumber;
  DateTime createdAt;
  DateTime updatedAt;

  factory UserCallback.fromJson(Map<String, dynamic> json) {
    return UserCallback(
      documentID: json['documentID'] ?? '',
      projectID: json['projectID'],
      ip: json['ip'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      createdAt: json['createdAt'].toDate(),
      updatedAt: json['updatedAt'].toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentID': documentID,
      'projectID': projectID,
      'ip': ip,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      "createdAt": Timestamp.fromDate(createdAt),
      "updatedAt": Timestamp.fromDate(updatedAt),
    };
  }

  List<String> get getRows => [name ?? '', email ?? '', phoneNumber ?? '', DateFormat('yyyy.MM.dd HH:mm').format(createdAt)];
}
