import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
}

Future<Uint8List?> selectedImageFromGalery() async {
  Uint8List? img = await pickImage(ImageSource.gallery);
  return img;
}

Future<Uint8List?> selectedImageFromCamera() async {
  Uint8List? img = await pickImage(ImageSource.camera);
  return img;
}

Future<String> uploadImageToStorage(String nameImage, Uint8List file) async {
  final FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = storage.ref("StoryImage").child(nameImage);
  UploadTask uploadTask = ref.putData(file);
  TaskSnapshot snapshot = await uploadTask;
  String downloadUrl = await snapshot.ref.getDownloadURL();
  return downloadUrl;
}

void deleteImageFromStorage(String nameImage) async {
  final FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = storage.ref("StoryImage").child(nameImage);
  await ref.delete();
}
