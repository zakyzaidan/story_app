class StoryModel {
  late String story;
  late String username;
  late String email;

  StoryModel(
      {required this.story, required this.username, required this.email});

  StoryModel.fromJson(Map<String, dynamic> json) {
    story = json['story'];
    username = json['username'];
    email = json['email'];
  }

  Map<String, Object?> toJson() {
    return {
      "story": story,
      "username": username,
      "email": email,
    };
  }
}
