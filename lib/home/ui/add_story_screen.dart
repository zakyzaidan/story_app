import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_app/assets/database_services.dart';
import 'package:story_app/assets/image_utils.dart';
import 'package:story_app/home/bloc/home_bloc.dart';
import 'package:story_app/home/model/story_model.dart';
import 'package:story_app/profile/model/user_model.dart';
import 'package:uuid/uuid.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final _storyTextController = TextEditingController();
  final DatabaseServices databaseServices = DatabaseServices();
  final HomeBloc homeBloc = HomeBloc();
  Uint8List? img;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Success Upload Story"),
          duration: Duration(seconds: 3),
        ));
      },
      builder: (context, state) {
        if (state.runtimeType == TakeImageFromGaleryClickedState) {
          final successState = state as TakeImageFromGaleryClickedState;
          img = successState.img;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Add story"),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  img != null
                      ? SizedBox(
                          height: 250,
                          child: Center(
                            child: Image.memory(
                              img!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                      : const SizedBox(
                          height: 150,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("take image"),
                              Icon(
                                Icons.image_search_outlined,
                                size: 80,
                              ),
                            ],
                          )),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          homeBloc.add(TakeImageFromCameraClickedEvent());
                        },
                        child: const Text("Camera"),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          homeBloc.add(TakeImageFromGaleryClickedEvent());
                        },
                        child: const Text("Galery"),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 200,
                    child: TextField(
                      controller: _storyTextController,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'Write a message',
                        filled: true,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  FloatingActionButton.extended(
                      onPressed: () async {
                        UserModel user = await databaseServices.getUser();
                        Timestamp uploadTime =
                            Timestamp.fromDate(DateTime.now());
                        if (img == null) {
                          final StoryModel storyModel = StoryModel(
                              imgName: "",
                              imgUrl: "",
                              story: _storyTextController.text,
                              username: user.username,
                              email: user.email,
                              uploadTime: uploadTime);
                          homeBloc.add(
                              UploadButtonClickedEvent(storyModel: storyModel));
                        } else {
                          String uuid = const Uuid().v4();
                          String imgUrl =
                              await uploadImageToStorage(uuid, img!);
                          final StoryModel storyModel = StoryModel(
                              imgName: uuid,
                              imgUrl: imgUrl,
                              story: _storyTextController.text,
                              username: user.username,
                              email: user.email,
                              uploadTime: uploadTime);
                          homeBloc.add(
                              UploadButtonClickedEvent(storyModel: storyModel));
                        }
                      },
                      label: const Text("Upload"))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
