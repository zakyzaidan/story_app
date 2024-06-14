import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:story_app/home/model/story_model.dart';
import 'package:story_app/profile/model/user_model.dart';

class DatabaseServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserModel> getUser() async {
    final snapshot = await firestore
        .collection('users')
        .where('email', isEqualTo: auth.currentUser!.email)
        .get();
    final userData = snapshot.docs.map((e) => UserModel.fromJson(e)).single;
    return userData;
  }

  uploadStory(StoryModel story) async {
    await firestore.collection("story").add(story.toJson());
  }

  Stream<QuerySnapshot> getAllStory() {
    final snapshot = firestore
        .collection("story")
        .orderBy("uploadTime", descending: true)
        .snapshots();
    return snapshot;
  }

  Stream<QuerySnapshot> getMyStory(String email) {
    final snapshot = firestore
        .collection("story")
        .where("email", isEqualTo: email)
        .orderBy("uploadTime", descending: true);
    final s = snapshot.snapshots();
    return s;
  }

  deleteMyStory(String email, int index) async {
    final myStoryRef = firestore
        .collection("story")
        .where("email", isEqualTo: email)
        .orderBy("uploadTime", descending: true);
    final myStory = await myStoryRef.get();
    final idDeletedstory = myStory.docs[index].id;
    try {
      await firestore.collection("story").doc(idDeletedstory).delete();
    } catch (e) {
      print(e);
    }
  }

  editMyStory(String email, int index, String story, String imgUrl) async {
    final myStoryRef = firestore
        .collection("story")
        .where("email", isEqualTo: email)
        .orderBy("uploadTime", descending: true);
    final myStory = await myStoryRef.get();
    final idEditStory = myStory.docs[index].id;
    try {
      await firestore
          .collection("story")
          .doc(idEditStory)
          .update({"story": story, "imgUrl": imgUrl});
    } catch (e) {
      print(e);
    }
  }

  editProfile(String username, String bio, String email) async {
    await firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .update({"username": username, "bio": bio});

    //ganti semua nama pada story
    final myStory = await firestore
        .collection("story")
        .where("email", isEqualTo: email)
        .get();
    final length = myStory.docs.length;

    for (var i = 0; i < length; i++) {
      final id = myStory.docs[i].id;

      await firestore
          .collection("story")
          .doc(id)
          .update({"username": username});
    }
  }
}
