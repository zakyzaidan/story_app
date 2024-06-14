import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_app/assets/database_services.dart';
import 'package:story_app/assets/image_utils.dart';
import 'package:story_app/home/model/story_model.dart';
import 'package:story_app/profile/bloc/profile_bloc.dart';
import 'package:story_app/profile/model/user_model.dart';

class EditStoryScreen extends StatefulWidget {
  final StoryModel storyModel;
  final int index;
  const EditStoryScreen(
      {super.key, required this.storyModel, required this.index});

  @override
  State<EditStoryScreen> createState() => _EditStoryScreenState();
}

class _EditStoryScreenState extends State<EditStoryScreen> {
  final TextEditingController _storyTextController = TextEditingController();
  final DatabaseServices databaseServices = DatabaseServices();
  final ProfileBloc profileBloc = ProfileBloc();
  Uint8List? img;

  @override
  Widget build(BuildContext context) {
    final String imgUrlLama = widget.storyModel.imgUrl;
    final String imgName = widget.storyModel.imgName;
    _storyTextController.text = widget.storyModel.story;
    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      listenWhen: (previous, current) => current is ProfileActionState,
      buildWhen: (previous, current) => current is! ProfileActionState,
      listener: (context, state) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Success Edit Profile"),
          duration: Duration(seconds: 3),
        ));
      },
      builder: (context, state) {
        if (state.runtimeType == TakeImageClickedState) {
          try {
            final successState = state as TakeImageClickedState;
            img = successState.img;
            return Scaffold(
              appBar: AppBar(
                title: const Text("Edit story"),
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
                              profileBloc
                                  .add(TakeImageFromCameraClickedEvent());
                            },
                            child: const Text("Camera"),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              profileBloc
                                  .add(TakeImageFromGaleryClickedEvent());
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
                            String imgUrl =
                                await uploadImageToStorage(imgName, img!);
                            final StoryModel storyModel = StoryModel(
                                imgName: imgName,
                                imgUrl: imgUrl,
                                story: _storyTextController.text,
                                username: user.username,
                                email: user.email,
                                uploadTime: uploadTime);
                            profileBloc.add(EditMyStoryButtonClickedEvent(
                                index: widget.index, storyModel: storyModel));
                          },
                          label: const Text("Edit"))
                    ],
                  ),
                ),
              ),
            );
          } catch (e) {
            profileBloc.add(ProfileInitialEvent());
          }
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("Edit story"),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  imgUrlLama != ""
                      ? SizedBox(
                          height: 250,
                          child: Center(
                              child: CachedNetworkImage(
                            imageUrl: imgUrlLama,
                            fit: BoxFit.contain,
                            progressIndicatorBuilder:
                                (context, url, progress) =>
                                    CircularProgressIndicator(
                              value: progress.progress,
                            ),
                          )),
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
                          profileBloc.add(TakeImageFromCameraClickedEvent());
                        },
                        child: const Text("Camera"),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          profileBloc.add(TakeImageFromGaleryClickedEvent());
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
                        final StoryModel storyModel = StoryModel(
                            imgName: imgName,
                            imgUrl: imgUrlLama,
                            story: _storyTextController.text,
                            username: user.username,
                            email: user.email,
                            uploadTime: uploadTime);
                        profileBloc.add(EditMyStoryButtonClickedEvent(
                            index: widget.index, storyModel: storyModel));
                      },
                      label: const Text("Edit"))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
