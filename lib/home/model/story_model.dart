import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  late String story;
  late String username;
  late String email;
  late String imgUrl;
  late String imgName;
  late Timestamp uploadTime;

  StoryModel(
      {required this.story,
      required this.username,
      required this.email,
      required this.imgUrl,
      required this.uploadTime,
      required this.imgName});

  StoryModel.fromJson(Map<String, dynamic> json) {
    story = json['story'];
    username = json['username'];
    email = json['email'];
    imgUrl = json['imgUrl'];
    imgName = json['imgName'];
    uploadTime = json['uploadTime'];
  }

  Map<String, Object?> toJson() {
    return {
      "story": story,
      "username": username,
      "email": email,
      "imgUrl": imgUrl,
      "imgName": imgName,
      "uploadTime": uploadTime
    };
  }
}
