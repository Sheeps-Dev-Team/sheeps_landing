
class User{
  User({
    this.documentID = '',
    required this.email,
    required this.loginType,
    required this.name,
    this.createdAt = '',
    this.updatedAt = ''
  });

  String documentID;
  String email;
  int loginType;
  String name;
  String createdAt;
  String updatedAt;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        documentID: json['documentID'] ?? '',
        email: json['email'] ?? '',
        loginType: json['loginType'] ?? 0,
        name: json['name'] ?? '',
        createdAt: json['createdAt'] ?? '',
        updatedAt: json['updatedAt'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "documentID": documentID,
      "email": email,
      "loginType": loginType,
      "name": name,
      "createdAt" : createdAt,
      "updatedAt" : updatedAt
    };
  }
}

class UserCallBack{
    UserCallBack({
      this.projectDocumentID = '',
      required this.ip,
      this.email = '',
      this.phoneNumber = '',
      this.name = '',
      this.createdAt = '',
    });

    String projectDocumentID;
    String ip;
    String email;
    String phoneNumber;
    String name;
    String createdAt;

    factory UserCallBack.fromJson(Map<String, dynamic> json) {
      return UserCallBack(
          projectDocumentID: json['projectDocumentID'] ?? '',
          ip: json['ip'] ?? '',
          email: json['email'] ?? 0,
          phoneNumber: json['phoneNumber'] ?? '',
          name: json['name'] ?? '',
          createdAt: json['createdAt'] ?? ''
      );
    }

    Map<String, dynamic> toJson() {
      return {
        "projectDocumentID": projectDocumentID,
        "ip": ip,
        "email": email,
        "phoneNumber": phoneNumber,
        "name" : name,
        "createdAt" : createdAt
      };
    }
}