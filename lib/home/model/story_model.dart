import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  late String story;
  late String username;
  late String email;
  late Timestamp uploadTime;

  StoryModel(
      {required this.story,
      required this.username,
      required this.email,
      required this.uploadTime});

  StoryModel.fromJson(Map<String, dynamic> json) {
    story = json['story'];
    username = json['username'];
    email = json['email'];
    uploadTime = json['uploadTime'];
  }

  Map<String, Object?> toJson() {
    return {
      "story": story,
      "username": username,
      "email": email,
      "uploadTime": uploadTime
    };
  }
}
