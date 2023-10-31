class UserCallback {
  static const String typeNone = '선택 안함';
  static const String typeForm = '폼';
  static const String typeLink = '링크';

  static const String formTypeName = '이름';
  static const String formTypeEmail = '이메일';
  static const String formTypePhoneNumber = '전화번호';

  UserCallback({
    required this.documentID,
    required this.projectID,
    required this.ip,
    this.name,
    this.email,
    this.phoneNumber,
  });

  final String documentID;
  final String projectID;
  final String ip;
  final String? name;
  final String? email;
  final String? phoneNumber;

  factory UserCallback.fromJson(Map<String, dynamic> map) {
    return UserCallback(
      documentID: map['documentID'],
      projectID: map['projectID'],
      ip: map['ip'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
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
    };
  }

  List<String> get getRows => [typeNone, formTypeName, formTypeEmail, formTypePhoneNumber, ip];
}
