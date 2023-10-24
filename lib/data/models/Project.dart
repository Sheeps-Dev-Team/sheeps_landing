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
    this.createdAt = '',
    this.updatedAt = '',
    this.descriptionList = const []
  });

  String documentID;
  String userDocumentID;
  String name;
  String title;
  String contents;
  String imgPath;
  int buttonType;
  int viewCount;
  String createdAt;
  String updatedAt;
  List<Description?> descriptionList;

  factory Project.fromJson(Map<String, dynamic> json) {

    List<Description?> list = [];
    if(json['Description'] != null && json['Description'].isNotEmpty){
      for(var i = 0 ; i < json['Description'].length ; ++i){
        list.add(Description.fromJson(json['Description'][i]));
      }
    }

    return Project(
        documentID: json['documentID'] ?? '',
        userDocumentID: json['userDocumentID'] ?? '',
        name: json['name'] ?? '',
        title: json['title'] ?? '',
        contents: json['contents'] ?? '',
        imgPath: json['imgPath'] ?? '',
        buttonType: json['buttonType'] ?? 0,
        viewCount: json['viewCount'] ?? 0,
        createdAt: json['createdAt'] ?? '',
        updatedAt: json['updatedAt'] ?? '',
        descriptionList: list
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
      "createdAt" : createdAt,
      "updatedAt" : updatedAt
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