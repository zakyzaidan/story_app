import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String username;
  String email;
  String bio;

  UserModel({required this.bio, required this.email, required this.username});

  factory UserModel.fromJson(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        email: data['email'], bio: data['bio'], username: data['username']);
  }

  Map<String, Object?> toJson() =>
      {'email': email, 'bio': bio, 'username': username};
}
